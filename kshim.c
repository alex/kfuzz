#include <stdarg.h>
#include <stdlib.h>
#include <string.h>


typedef enum {
    GFP_KERNEL,
    GFP_ATOMIC,
    __GFP_HIGHMEM,
    __GFP_HIGH
} gfp_t;

void *__kmalloc(size_t size, gfp_t flags) {
    return malloc(size);
}

void kfree(void *p) {
    free(p);
}

void kzfree(void *p) {
    free(p);
}

void *__memcpy(void *dest, const void *src, size_t n) {
    return memcpy(dest, src, n);
}

void *__memset(void *s, int c, size_t n) {
    return memset(s, c, n);
}

int printk(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int res = vprintf(fmt, ap);
    va_end(ap);
    return res;
}
