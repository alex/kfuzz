#!/bin/bash

set -e
set -x

KFUZZ_LOCATION=/vagrant/kfuzz
LINUX_LOCATION=/vagrant/linux

cd $LINUX_LOCATION
make defconfig
echo "CONFIG_ASN1=y" >> .config
echo "CONFIG_ASYMMETRIC_KEY_TYPE=y" >> .config
echo "CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y" >> .config
echo "CONFIG_PUBLIC_KEY_ALGO_RSA=y" >> .config
echo "CONFIG_X509_CERTIFICATE_PARSER=y" >> .config
echo "CONFIG_PKCS7_MESSAGE_PARSER=n" >> .config
make silentoldconfig

export MAKE_JOBS=3
make SUBDIRS=scripts/
make SUBDIRS=crypto/
make SUBDIRS=lib/

cd $KFUZZ_LOCATION
gcc parse.c kshim.c \
    $LINUX_LOCATION/crypto/memneq.o \
    $LINUX_LOCATION/crypto/asymmetric_keys/{asymmetric_type,public_key,rsa,x509_cert_parser,x509-asn1,x509_akid-asn1,x509_rsakey-asn1}.o \
    $LINUX_LOCATION/lib/{asn1_decoder,hexdump}.o \
    $LINUX_LOCATION/lib/mpi/{mpi-bit,mpi-cmp,mpi-pow,mpicoder,mpiutil,mpih-cmp,mpih-div,mpih-mul,generic_mpih-add1,generic_mpih-lshift,generic_mpih-mul1,generic_mpih-mul2,generic_mpih-mul3,generic_mpih-rshift,generic_mpih-sub1}.o \
    2>&1 | grep "undefined reference"  | grep -E -o "\`([a-zA-Z0-9_]*)'" | sort | uniq -c | sort -rn

# gcc parse.c kshim.c /vagrant/linux/crypto/memneq.o /vagrant/linux/crypto/asymmetric_keys/{asymmetric_type,public_key,rsa,x509_cert_parser,x509-asn1,x509_akid-asn1,x509_rsakey-asn1}.o /vagrant/linux/lib/asn1_decoder.o  /vagrant/linux/lib/mpi/{mpi-bit,mpi-cmp,mpi-pow,mpicoder,mpiutil,mpih-cmp,mpih-div,mpih-mul,generic_mpih-add1,generic_mpih-lshift,generic_mpih-mul1,generic_mpih-mul2,generic_mpih-mul3,generic_mpih-sub1,generic_mpih-rshift}.o
