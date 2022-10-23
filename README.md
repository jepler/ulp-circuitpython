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

## Running Minidump

```
py/minidump.py
```

## Using
In principle, you now use a wrapper around `minielf` to (A) load the Coproc
binary and (B) to find symbols within the CoprocMemory.
