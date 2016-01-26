#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


extern struct x509_certificate *x509_cert_parse(const void *, size_t);
extern void x509_free_certificate(struct x509_certificate *);


int main() {
    uint8_t buf[8192];
    ssize_t length = read(0, buf, 8192);
    if (length == -1) {
        perror("read()");
        exit(1);
    }

    struct x509_certificate *c = x509_cert_parse(buf, length);
    x509_free_certificate(c);
    return 0;
}
