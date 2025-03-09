# Linux Cat Clone in Assembly

this is a simple clone from the linux cat command written with x86_32 assembly.

NOTE: the project is just for fun and is not production ready

### Get Started
- first you need to install nasm
- then you need to download a linker in my case i am using the ld linker as you can find in the build.sh file

`./build.sh && ./main`

### Features
- read long files
- takes file names from command line args
- if no file name is specified it reads from stdin
- handles open files errors
