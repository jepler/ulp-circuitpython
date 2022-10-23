import time
import struct
from coproc import *
from minidump import e, h, en

def storele32(cm, off, x):
    print(off, ":=", x)
    cm[off:off+4] = struct.pack("<l", x)
def storele16(cm, off, x):
    print(off, ":=", x)
    cm[off:off+2] = struct.pack("<h", x)
binary = e._readat(h.p_offset, h.p_filesz)
cm = CoprocMemory(0x50000000, 8176)
off = en.st_value
print(f"value at {off}, adjusted offset is {off}")
c = Coproc(binary)
try:
    run(c)

    while True:
        cm[off] = 10
        time.sleep(2)
        cm[off] = 20
        time.sleep(2)
finally:
    halt(c)
