import minielf

class Program:
    def __init__(self, filename):
        self.elf = minielf.ELFFile(open(filename, "rb"))
        code_header = self.elf.get_header_by_type(minielf.PT_LOAD)
        self.code = bytes(self.elf.pread(code_header.p_offset, code_header.p_filesz))
        self.symtab = self.elf.get_section_by_name('.symtab')

    def get_code(self):
        return 

    def get_symbol(self, name):
        r = self.symtab.get_first_symbol_by_name(name)
        if r is None:
            raise ValueError(f"{repr(name)} not found")
        return r
