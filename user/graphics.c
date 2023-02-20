#include <inc/lib.h>
#define IMG_WIDTH (int)500
#define IMG_HEIGHT  (int)500
#define IMG_SIZE IMG_WIDTH * IMG_HEIGHT


int DISPLAY_WIDTH = 0;
int DISPLAY_HEIGHT = 0;

void draw_pixel(char *buf, int x, int y, int color) {
   buf[y * DISPLAY_WIDTH + x] = color;  
}

void draw_line(char* buf, int x0, int y0, int x1, int y1, int color)
{
    int dx, dy, p, x, y;
 
	dx = x1 - x0;
	dy = y1 - y0;
 
	x = x0;
	y = y0;
 
	p = 2 * dy - dx;
 
	while(x < x1)
	{
		if(p >= 0)
		{
			draw_pixel(buf, x, y, color);
			y = y + 1;
			p= p + 2 * dy - 2 * dx;
		}
		else
		{
			draw_pixel(buf, x, y, color);
			p = p + 2 * dy;
		}
		x = x + 1;
	}
}


//position of upper left corner x, y
void draw_rectangle(char *buf, int x, int y, int width, int height, int color) {
    if (x + width > DISPLAY_WIDTH || y + height > DISPLAY_HEIGHT)
        return;
    for (int i = 0; i < height; ++i) {
        draw_line(buf, x, y, x + width, y, color);
        ++y;
    }
        
        
}

void umain(int argc, char **argv) {
   
    binaryname = "graphics";
    FRAMEBUFFER_CONTEXT context;
    int res = FramebufferInit(&context);
    if (res < 0) {
        cprintf("error %i\n", res);
        exit();
    }
    DISPLAY_WIDTH = context.width;
    DISPLAY_HEIGHT = context.height;
    cprintf("width: %d, height: %d, bpp: %d framebuffer_size: %d\n", context.width, 
                                                                    context.height, 
                                                                    context.bits_per_pixel,
                                                                    context.size);
    cprintf("front: %p, back: %p\n", context.front, context.back);
    memset(context.back, 255, context.size);
  	unsigned error;
  	uint8_t * image;
  	unsigned width, height;
  	const char* filename =  "spaceship.png";
  	error = lodepng_decode32_file(&image, &width, &height, filename);
  	if(error) cprintf("decoder error %u: %s\n", error, lodepng_error_text(error));
  	/* use image here */
	cprintf("width: %u, height: %u\n", width, height);
	
    uint8_t *buf = context.back;
    for (int i = 0; i  < height; ++i) {
        for (int j = 0 ; j < width * 4; ++j) {
            buf[i * 4 *  context.width + j] = image[width * 4 * i + j];
        }
    }
    FramebufferFlip(&context);
}
