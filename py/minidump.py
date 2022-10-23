#!/usr/bin/env python3

from minielf import ELFFile, PT_LOAD

a_out = open("a.out-stripped", "rb")
e = ELFFile(a_out)
s = e.get_section(1)
s = e.get_section_by_name('.symtab')
print(s)
sy = s.get_first_symbol_by_name('shared_mem')
en = sy.entry
for h in e.iter_headers():
    if h.p_type == PT_LOAD:
        print(f"@{h.p_vaddr:04x}: Load {h.p_filesz} bytes starting at {h.p_offset}")
        content = e.pread(h.p_offset, 16)
        print(" ".join(f"{b:02x}" for b in content))

print(f"shared_mem @ 0x{en.st_value:04x} 0x{en.st_size:04x} bytes")
