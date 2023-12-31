#!/bin/bash

# gcc -c -ggdb -fno-builtin -nostdlib -fno-stack-protector ./src/entry.c ./src/malloc.c ./src/stdio.c ./src/string.c ./src/printf.c
# ar -rs rcrt.a malloc.o printf.o stdio.o string.o
# gcc -c -ggdb -fno-builtin -nostdlib -fno-stack-protector ./tests/test.c
# ld -static -e rcrt_entry entry.o test.o rcrt.a -o test
# ls -l test

gcc -c -ggdb -fno-builtin -nostdlib -fno-stack-protector -Wno-pointer-to-int-cast -Wno-int-to-pointer-cast ./src/entry.c ./src/malloc.c ./src/stdio.c ./src/string.c ./src/printf.c ./src/atexit.c

g++ -c -ggdb -nostdinc++ -fno-rtti -fno-exceptions -fno-builtin -nostdlib -fno-stack-protector ./src/crtbegin.cpp ./src/crtend.cpp ./src/ctors.cpp ./src/new_delete.cpp ./src/iostream.cpp ./src/sysdep.cpp

ar -rs rcrt.a malloc.o printf.o stdio.o string.o ctors.o atexit.o iostream.o new_delete.o sysdep.o

g++ -c -ggdb -nostdinc++ -fno-rtti -fno-exceptions -fno-builtin -nostdlib -fno-stack-protector ./tests/test.cpp

if [ ! -d lib ]; then
    mkdir lib
fi

if [ ! -d bin ]; then
    mkdir bin
fi

mv *.o *.a ./lib/

ld -static -e rcrt_entry ./lib/entry.o ./lib/crtbegin.o ./lib/test.o ./lib/rcrt.a ./lib/crtend.o -o ./bin/testcpp
# ld -static -e rcrt_entry entry.o crtbegin.o malloc.o printf.o stdio.o string.o ctors.o atexit.o iostream.o new_delete.o sysdep.o test.o crtend.o -o test

ls -l ./bin/testcpp

./bin/testcpp

