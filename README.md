# ARMv8-graphics
A collection of ARMv8 assembly programs for animations

## How to run it
### Install (on Ubuntu)
- Setting up aarch64 toolchain:
```sh
$ sudo apt install gcc-aarch64-linux-gnu
```  

- Setting up QEMU ARM:
```sh
$ sudo apt install qemu-system-arm
```  

### Debugging
- Fetch and build aarch64 GDB:
```sh
$ sudo apt install gdb-multiarch
```  

- Setting up GDB:
```sh
$ wget -P ~ git.io/.gdbinit
```

### Run
- Compile and run (on each directory):
```sh
$ make run
```

## Preview
### Atomic
![atomic](atomic.gif)

### Ant
![ant](ant.gif)

### Life
![life](life.gif)
