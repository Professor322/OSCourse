#include <kern/pci.h>
#include <inc/stdio.h>
#include <inc/x86.h>
#include <inc/string.h>
#include <kern/pmap.h>
#include <kern/vga.h>

// PCI devices.
pci_device_t *PciDevices = NULL;
pci_device_t *PciDevicesArr = NULL;
static int cur_pci_idx = 0;

char* pci_class_descriptions[256] = {
    [PCI_CLASS_NONE] = "Unclassified device",
    [PCI_CLASS_MASS_STORAGE] = "Mass storage controller",
    [PCI_CLASS_NETWORK] = "Network controller",
    [PCI_CLASS_DISPLAY] = "Display controller",
    [PCI_CLASS_MULTIMEDIA] = "Multimedia controller",
    [PCI_CLASS_MEMORY] = "Memory controller",
    [PCI_CLASS_BRIDGE] = "Bridge",
    [PCI_CLASS_SIMPLE_COMM] = "Communication controller",
    [PCI_CLASS_BASE_SYSTEM] = "Generic system peripheral",
    [PCI_CLASS_INPUT] = "Input device controller",
    [PCI_CLASS_DOCKING] = "Docking station",
    [PCI_CLASS_PROCESSOR] = "Processor",
    [PCI_CLASS_SERIAL_BUS] = "Serial bus controller",
    [PCI_CLASS_WIRELESS] = "Wireless controller",
    [PCI_CLASS_INTELLIGENT_IO] = "Intelligent controller",
    [PCI_CLASS_SATELLITE_COMM] = "Satellite communications controller",
    [PCI_CLASS_ENCRYPTION] = "Encryption controller",
    [PCI_CLASS_DATA_ACQUISITION] = "Signal processing controller",
    [PCI_CLASS_UNKNOWN] = "Unassigned class"


};

uint32_t pci_config_read_dword(pci_device_t *pciDevice, uint8_t reg) {
    // Build address.
    uint32_t address = PCI_PORT_ENABLE_BIT | ((uint32_t)pciDevice->Bus << 16)
        | ((uint32_t)pciDevice->Device << 11) | ((uint32_t)pciDevice->Function << 8) | (reg & 0xFC);

    // Send address to PCI system.
    outl(PCI_PORT_ADDRESS, address);

    // Read 32-bit data value from PCI system.
    return inl(PCI_PORT_DATA);
}

uint16_t pci_config_read_word(pci_device_t *pciDevice, uint8_t reg) {
    // Read 16-bit value.
    return (uint16_t)(pci_config_read_dword(pciDevice, reg) >> ((reg & 0x2) * 8) & 0xFFFF);
}

uint8_t pci_config_read_byte(pci_device_t *pciDevice, uint8_t reg) {
    // Read 8-bit value.
    return (uint8_t)(pci_config_read_dword(pciDevice, reg) >> ((reg & 0x3) * 8) & 0xFF);
}

void pci_config_write_dword(pci_device_t *pciDevice, uint8_t reg, uint32_t value) {
    // Build address.
    uint32_t address = PCI_PORT_ENABLE_BIT | ((uint32_t)pciDevice->Bus << 16)
        | ((uint32_t)pciDevice->Device << 11) | ((uint32_t)pciDevice->Function << 8) | (reg & 0xFC);

    // Send address to PCI system.
    outl(PCI_PORT_ADDRESS, address);

    // Write 32-bit value to PCI system.
    outl(PCI_PORT_DATA, value);
}

void pci_config_write_word(pci_device_t *pciDevice, uint8_t reg, uint16_t value) {
    // Get current 32-bit value.
    uint32_t currentValue = pci_config_read_dword(pciDevice, reg);

    // Replace portion of the 32-bit value with the new 16-bit value.
    uint32_t newValue = ((uint32_t)value << ((reg & 0x2) * 8)) | (currentValue & (0xFFFF0000 >> (reg & 0x2) * 8));

    // Write the resulting 32-bit value.
    pci_config_write_dword(pciDevice, reg, newValue);
}

void pci_config_write_byte(pci_device_t *pciDevice, uint8_t reg, uint8_t value) {
    // Get current 16-bit value.
    uint16_t currentValue = pci_config_read_word(pciDevice, reg);

    // Replace portion of 16-bit value with the new 8-bit value.
    uint16_t newValue = ((uint16_t)value << ((reg & 0x1) * 8)) | (currentValue & (0xFF00 >> (reg & 0x1) * 8));

    // Write the resulting 16-bit value.
    pci_config_write_word(pciDevice, reg, newValue);
}

void pci_enable_busmaster(pci_device_t *pciDevice) {
    // Set busmaster bit.
    pci_config_write_word(pciDevice, PCI_REG_COMMAND, pci_config_read_word(pciDevice, PCI_REG_COMMAND) | PCI_CMD_BUSMASTER);
}

/**
 * Print the description for a PCI device
 * @param dev PCIDevice struct with PCI device info
 */
void pci_print_info(pci_device_t *pciDevice) {
    // Print base info
    cprintf("\e[94mPCI device: %4X:%4X (%4X:%4X) | Class %X Sub %X | Bus %d Device %d Function %d\n", 
        pciDevice->VendorId, pciDevice->DeviceId, pciDevice->SubVendorId, pciDevice->SubDeviceId, pciDevice->Class, pciDevice->Subclass, pciDevice->Bus, 
        pciDevice->Device, pciDevice->Function);
    
    // Print class info and base addresses
    cprintf("\e[96m  - %s\n", pci_class_descriptions[pciDevice->Class]);

    // Print base addresses.
    for (uint8_t i = 0; i < PCI_BAR_COUNT; i++) {
        if (pciDevice->BaseAddresses[i].BaseAddress)
            cprintf("  - BAR%u: 0x%X Size: %ld (%s)\n", i, pciDevice->BaseAddresses[i].BaseAddress, pciDevice->BaseAddresses[i].Size, pciDevice->BaseAddresses[i].PortMapped ? "port-mapped" : "memory-mapped");
	}
    // Interrupt info
    if(pciDevice->InterruptNo != 0) { 
        cprintf("  - Interrupt %u (Pin %u Line %u\e[0m\n", pciDevice->InterruptNo, pciDevice->InterruptPin, pciDevice->InterruptLine);
    }

}



void pci_enable_palette_snoop(pci_device_t *pciDevice) {
    // Set palette snoop bit.
    if (pci_config_read_word(pciDevice, PCI_REG_COMMAND) & PCI_CMD_PALETTE_SNOOP)
        cprintf("{{{already enable}d}}}\n");
    pci_config_write_word(pciDevice, PCI_REG_COMMAND, pci_config_read_word(pciDevice, PCI_REG_COMMAND) | PCI_CMD_PALETTE_SNOOP);
}


/**
 * Check and get various info about a PCI card
 * @param  bus      PCI bus to read from
 * @param  device   PCI slot to read from
 * @param  function PCI card function to read from
 * @return          A PCIDevice struct with the info filled
 */
pci_device_t *pci_get_device(uint8_t bus, uint8_t device, uint8_t function/*, ACPI_BUFFER *routingBuffer*/) {
    // Create temporary PCI device object.
    pci_device_t pciDeviceTemp = { };

    // Set device address.
    pciDeviceTemp.Bus = bus;
    pciDeviceTemp.Device = device;
    pciDeviceTemp.Function = function;

    // Get device vendor. If vendor is 0xFFFF, the device doesn't exist.
    pciDeviceTemp.VendorId = pci_config_read_word(&pciDeviceTemp, PCI_REG_VENDOR_ID);
    if (pciDeviceTemp.VendorId == PCI_DEVICE_VENDOR_NONE)
        return NULL;

    // Create PCI device object
	if (PciDevicesArr == NULL) 
		PciDevicesArr = kzalloc_region(sizeof(pci_device_t) * PCI_NUM_DEVICES);
	
    if (cur_pci_idx >= PCI_NUM_DEVICES)
		panic("Not enough space for PCI DEVICES");

    pci_device_t *pciDevice = &PciDevicesArr[cur_pci_idx++];
    
	// Set device address.
    pciDevice->Bus = bus;
    pciDevice->Device = device;
    pciDevice->Function = function;

    // Get PCI identification variables.
    pciDevice->VendorId = pci_config_read_word(pciDevice, PCI_REG_VENDOR_ID);
    pciDevice->DeviceId = pci_config_read_word(pciDevice, PCI_REG_DEVICE_ID);
    pciDevice->SubVendorId = pci_config_read_word(pciDevice, PCI_REG_SUB_VENDOR_ID);
    pciDevice->SubDeviceId = pci_config_read_word(pciDevice, PCI_REG_SUB_DEVICE_ID);
    pciDevice->RevisionId = pci_config_read_byte(pciDevice, PCI_REG_REVISION_ID);
    pciDevice->Class = pci_config_read_byte(pciDevice, PCI_REG_CLASS);
    pciDevice->Subclass = pci_config_read_byte(pciDevice, PCI_REG_SUBCLASS);
    pciDevice->Interface = pci_config_read_byte(pciDevice, PCI_REG_PROG_IF);
    pciDevice->HeaderType = pci_config_read_byte(pciDevice, PCI_REG_HEADER_TYPE);

    // Get interrupt info.
    pciDevice->InterruptPin = pci_config_read_byte(pciDevice, PCI_REG_INTERRUPT_PIN);
    pciDevice->InterruptLine = pci_config_read_byte(pciDevice, PCI_REG_INTERRUPT_LINE);

    // Get base address registers.
    for (uint8_t i = 0; i < PCI_BAR_COUNT; i++) {
        // Get BAR.
        uint8_t CurrentBarAddress = PCI_REG_BAR0 + (i * sizeof(uint32_t));

        uint32_t bar = pci_config_read_dword(pciDevice, CurrentBarAddress);
 
        pci_config_write_dword(pciDevice, CurrentBarAddress, 0xffffffff);
        uint32_t bar_value = pci_config_read_dword(pciDevice, CurrentBarAddress);
        
        // Fill in info.
        pciDevice->BaseAddresses[i].PortMapped = (bar & PCI_BAR_TYPE_PORT) != 0;
        if (pciDevice->BaseAddresses[i].PortMapped) {
            // Port I/O bar.
            pciDevice->BaseAddresses[i].BaseAddress = bar & PCI_BAR_PORT_MASK;
        }
        else {
            pciDevice->BaseAddresses[i].BaseAddress = bar & PCI_BAR_MEMORY_MASK;
            pciDevice->BaseAddresses[i].Size = PCI_MAPREG_MEM_SIZE(bar_value);
            pciDevice->BaseAddresses[i].AddressIs64bits = (bar & PCI_BAR_BITS64) != 0;
            pciDevice->BaseAddresses[i].Prefetchable = (bar & PCI_BAR_PREFETCHABLE) != 0;
        }
        pci_config_write_dword(pciDevice, CurrentBarAddress, bar);

    }
    // Return the device.
    return pciDevice;
}

static void pci_add_device(pci_device_t *pciDevice, pci_device_t *parentPciDevice) {
    pciDevice->Parent = parentPciDevice;
    if (PciDevices != NULL) {
        pci_device_t *lastDevice = PciDevices;
        while (lastDevice->Next != NULL)
            lastDevice = lastDevice->Next;
        lastDevice->Next = pciDevice;
    }
    else
        PciDevices = pciDevice;
}

/**
 * Check a bus for PCI devices
 * @param bus The bus number to scan
 */
static void pci_check_busses(uint8_t bus, pci_device_t *parentPciDevice) {
    uint8_t parentDevice = 0;
    if (parentPciDevice != NULL)
        parentDevice = parentPciDevice->Device;
    cprintf("Getting _PRT for bus %u on device %u...\n", bus, parentDevice);
    // Check each device on bus
    cprintf("PCI: Enumerating devices on bus %u...\n", bus);
    for (uint8_t device = 0; device < PCI_NUM_DEVICES; device++) {
        // Get info on the device and print info
        pci_device_t *pciDevice = pci_get_device(bus, device, 0/*, &buffer*/);
        if (pciDevice == NULL)
            continue;

        // Add device.
        pci_print_info(pciDevice);
        pci_add_device(pciDevice, parentPciDevice);

        // If the card reports more than one function, let's scan those too.
        if ((pciDevice->HeaderType & PCI_HEADER_TYPE_MULTIFUNC) != 0) {
            cprintf("\e[32m  - Scanning other functions on multifunction device!\e[0m\n");
            // Check each function on the device
            for (uint8_t func = 1; func < PCI_NUM_FUNCTIONS; func++) {
                pci_device_t *funcDevice = pci_get_device(bus, device, func/*, &buffer*/);
                if (funcDevice == NULL)
                    continue;

                // Add device.
                pci_print_info(funcDevice);
                pci_add_device(funcDevice, parentPciDevice);
            }
        }

        // Is the device a bridge?
        if (pciDevice->Class == PCI_CLASS_BRIDGE && pciDevice->Subclass == PCI_SUBCLASS_BRIDGE_PCI) {
            uint16_t secondaryBus = pci_config_read_word(pciDevice, PCI_REG_BAR2);
            uint16_t primaryBus = (secondaryBus & ~0xFF00);
            secondaryBus = (secondaryBus & ~0x00FF) >> 8;
            cprintf("\e[32m  - PCI bridge, Primary %X Secondary %X, scanning now.\e[0m\n", primaryBus, secondaryBus);
            pci_check_busses(secondaryBus, pciDevice);

        // If device is a different kind of bridge
        } else if (pciDevice->Class == PCI_CLASS_BRIDGE) {
            cprintf("\e[91m  - Ignoring non-PCI bridge\e[0m\n");
        }
    }
}

const pci_driver_t PciDrivers[] = {
    {"Display", &vga_init},
    {NULL, NULL}
};

static void pci_load_drivers(void) {
    // Run through devices and load drivers.
    cprintf("PCI: Loading drivers for devices...\n");
    pci_device_t *pciDevice = PciDevices;
    while (pciDevice != NULL) {
        pci_print_info(pciDevice);

        // Attempt to find driver.
        uint16_t driverIndex = 0;
        while (PciDrivers[driverIndex].Initialize != NULL) {
            if (PciDrivers[driverIndex].Initialize(pciDevice))
                break;
            driverIndex++;
        }

        // Move to next device.
        pciDevice = pciDevice->Next;
    }
}

pci_device_t *pci_device_lookup(uint8_t Class) {
    pci_device_t *pciDevice = PciDevices;

    while (pciDevice != NULL) {
        if (pciDevice->Class == Class)
            return pciDevice;
        pciDevice = pciDevice->Next;
    }
    
    return NULL;
}

void pci_init(void) {
	pci_check_busses(0, NULL);
    pci_load_drivers();
	//resetting color scheme
	cprintf("\e[37m");
}
