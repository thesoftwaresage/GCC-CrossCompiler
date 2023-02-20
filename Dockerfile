FROM alpine:latest

RUN apk add --no-cache build-base gcc g++ make flex bison mpc1-dev gmp-dev mpfr-dev texinfo libstdc++ linux-headers git nasm dhclient


WORKDIR /usr/src

RUN git clone --depth 1 git://sourceware.org/git/binutils-gdb.git && \
    cd /usr && \
    mkdir build && \
    cd /usr/build && \
    mkdir build-binutils && \
    cd build-binutils && \
    ./../../src/binutils-gdb/configure --target=i686-elf --prefix=/usr/local/cross --with-sysroot --disable-nls --disable-werror && \
    make -j $(nproc) && \
    make install

RUN git clone --depth 1 git://gcc.gnu.org/git/gcc.git && \
    cd gcc && \
    contrib/download_prerequisites && \
    cd /usr/build && \
    mkdir build-gcc && \
    cd build-gcc && \
    ../../src/gcc/configure --target=i686-elf --prefix=/usr/local/cross --disable-nls --disable-libssp --enable-languages=c,c++ --without-headers && \
    make all-gcc -j $(nproc) && \
    make all-target-libgcc -j $(nproc) && \
    make install-gcc && \
    make install-target-libgcc

WORKDIR /usr/src

WORKDIR /usr/src/gcc-build

ENV PATH="/usr/local/bin:${PATH}"