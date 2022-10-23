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

The demo is designed for the ESP32-S3-EYE board, which has an LED on GPIO3. You
can potentially use a different LED location by editing `ulp.c` and changing
the line `#define GPIO (GPIO_NUM_3)`.

After you `make`, copy `a.out-stripped` and all the Python files in `py` to
CIRCUITPY.  At the repl, `import do_coproc`. (by not saving this file as
`code.py`, it is not automatically run at startup, which helps when dealing
with hardfaults)

The LED will blink at two alternating rates, "around 5Hz" and "around 2.5Hz".

Note that as of 8.0.0-beta.3-31-gedce717cfc, hitting ctrl-c to interrupt the
program & halt the coproc frequently causes the device to freeze, disconnect,
or restart in safe mode.
