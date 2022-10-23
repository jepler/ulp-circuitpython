# This is a demonstration prototype for CircuitPython "coproc" on esp32s2/s3

Coproc is a new feature in CircuitPython 8 for using the riscv "ultra low power"
coprocessor on esp32s2 and esp32s3 microcontrollers.

Two difficulties presented themselves to me so far:
 * Building a program
 * Accessing program variables from Python without manually transcribing hex addresses

The code here builds towards addressing these problems.

## Building 
```
.../esp-idf/install.sh
. .../esp-idf/export.sh
make
```

This builds `a.out-stripped`, which contains enough information for minidump.

## Running Minidump

```
$ py/minidump.py 
@0000: Load 2906 bytes starting at 4096
shared_mem @ 0x0b7c 0x0400 bytes
```

This shows the amount of code (& initialized data) to be loaded from a.out-stripped, and at what offset within a.out-stripped that data comes.

Then, it shows the size and offset in ULP memory of the symbol `shared_mem`.

## Using
In principle, you now use a wrapper around `minielf` to (A) load the Coproc
binary and (B) to find symbols within the CoprocMemory.
