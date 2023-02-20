#include <inc/framebuffer.h>
#include <inc/vsyscall.h>
#include <inc/syscall.h>
#include <inc/lib.h>


//returns 0 on success

int FramebufferInit(FRAMEBUFFER_CONTEXT *context) {
   context->width = vsys_getframebuffer_width();
   context->height = vsys_getframebuffer_height();
   context->bits_per_pixel = vsys_getframebuffer_bpp();
   context->size = context->width * context->height * (context->bits_per_pixel / 8);
   //graphics convention
   context->front = UTEMP - context->size;
   int res = sys_alloc_region(thisenv->env_id, UTEMP, context->size, PROT_R | PROT_W);
   if (res < 0)
       return res;
   context->back = UTEMP;
   return 0;
}


void FramebufferFlip(FRAMEBUFFER_CONTEXT *context) {
    memcpy(context->front, context->back, context->size);
}
