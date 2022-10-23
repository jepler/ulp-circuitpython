import time
import struct
from coproc import *
from coproc_manager import Program


program = Program("/a.out-stripped")
shared_mem = program.get_symbol('shared_mem').entry.st_value
print(f"{shared_mem=}")
cm = CoprocMemory(0x50000000, 8176)
c = Coproc(program.code)
print(f"{shared_mem=}")


try:
    run(c)

    while True:
        cm[shared_mem] = 10
        time.sleep(2)
        cm[shared_mem] = 20
        time.sleep(2)
finally:
    print("about to halt")
    time.sleep(.2)
    halt(c)
    print("returned from halt")
    time.sleep(.2)
