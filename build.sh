#!/bin/bash

rm -rf main.o
rm -rf main
nasm -f elf32 -o main.o main.asm
ld -m elf_i386 -o main main.o
