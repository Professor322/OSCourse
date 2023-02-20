#include <kern/pci.h>
#include <kern/vga.h>
#include <kern/pmap.h>
#include <kern/env.h>
#include <kern/vsyscall.h>

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/uefi.h>
#include <inc/error.h>
#include <inc/framebuffer.h>


static void *display_addr = NULL;
bool display_is_initialized = false;
FRAMEBUFFER_CONTEXT context;

void BgaWriteRegister(uint16_t IndexValue, uint16_t DataValue) {
    outw(VBE_DISPI_IOPORT_INDEX, IndexValue);
    outw(VBE_DISPI_IOPORT_DATA, DataValue);
}
 
void BgaSetVideoMode(unsigned int Width, unsigned int Height, unsigned int BitDepth, int UseLinearFrameBuffer, int ClearVideoMemory) {
    BgaWriteRegister(VBE_DISPI_INDEX_ENABLE, VBE_DISPI_DISABLED);
    BgaWriteRegister(VBE_DISPI_INDEX_XRES, Width);
    BgaWriteRegister(VBE_DISPI_INDEX_YRES, Height);
    BgaWriteRegister(VBE_DISPI_INDEX_BPP, BitDepth);
    BgaWriteRegister(VBE_DISPI_INDEX_ENABLE, VBE_DISPI_ENABLED |
        (UseLinearFrameBuffer ? VBE_DISPI_LFB_ENABLED : 0) |
        (ClearVideoMemory ? 0 : VBE_DISPI_NOCLEARMEM));
}
 

/* 
 * this function initializes pci vga display
 * maps 16mb of display to kernel space
 * sets up vsyscall for display paremetres
 *
 * maps size of 2 displays to user space (for double buffering)
 */
bool vga_init(pci_device_t *pciDevice) {
    if (pciDevice->Class != PCI_CLASS_DISPLAY || pciDevice->Subclass != PCI_SUBCLASS_DISPLAY_VGA)
        return false;
    cprintf("Initializing VGA...\n");
    //configure color scheme
    pci_enable_palette_snoop(pciDevice);
    //map display memory to kernel
    if (!display_addr) {
        //mmio needs kernel address space
        display_addr = mmio_map_region(pciDevice->BaseAddresses[0].BaseAddress, pciDevice->BaseAddresses[0].Size);
    }
    cprintf("Display addr: %p\n", display_addr); 

    context.width = uefi_lp->HorizontalResolution;
    context.height = uefi_lp->VerticalResolution;
    context.bits_per_pixel = 32;
    context.size = context.width * context.height * (context.bits_per_pixel / 8);
    
    context.front = display_addr;
    context.back = context.front + context.size;
    
    //setup vga device
    BgaSetVideoMode(context.width, context.height, context.bits_per_pixel, 1, 1); 
    
    display_is_initialized = true;
	cprintf("VGA Initialized\n"); 
    return display_is_initialized;
}
