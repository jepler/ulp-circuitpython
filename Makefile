ifeq ($(origin IDF_PATH),undefined)
$(error You must "source esp-idf/export.sh" before building)
endif

COPROC_RESERVE_MEM ?= 8176
SOC := esp32s3
CROSS := riscv32-esp-elf-
CC := $(CROSS)gcc
STRIP := $(CROSS)strip
CFLAGS := -g -Os -march=rv32imc -mdiv -fdata-sections -ffunction-sections
#CFLAGS += -fvisibility=hidden
CFLAGS += -isystem $(IDF_PATH)/components/ulp/ulp_riscv/include/
CFLAGS += -isystem $(IDF_PATH)/components/soc/$(SOC)/include
CFLAGS += -isystem $(IDF_PATH)/components/esp_common/include
CFLAGS += -DCOPROC_RESERVE_MEM=$(COPROC_RESERVE_MEM)
ifeq ($(SOC),esp32s3)
CFLAGS += -DCONFIG_IDF_TARGET_ESP32S3
endif
ifeq ($(SOC),esp32s2)
CFLAGS += -DCONFIG_IDF_TARGET_ESP32S2
endif
ifeq ($(origin USER_CFLAGS),undefined)
CFLAGS += $(USER_CFLAGS)
endif
LDFLAGS := -Wl,-A,elf32-esp32s2ulp -nostdlib --specs=nano.specs --specs=nosys.specs -Wl,--gc-sections

SRCS ?= ulp.c
SRCS += $(IDF_PATH)/components/ulp/ulp_riscv/ulp_riscv_utils.c
SRCS += $(IDF_PATH)/components/ulp/ulp_riscv/start.S
LDFLAGS += -Wl,-T,link.ld


.PHONY: default
default: a.out-stripped
	py/minidump.py

a.out-stripped: a.out
	$(STRIP) -g -o $@ $<

a.out: $(SRCS) link.ld Makefile
	$(CC) $(CFLAGS) $(SRCS) -o $@ $(LDFLAGS)

.PHONY: clean
clean:
	rm -f a.out* link.ld

link.ld: ulp.riscv.ld Makefile
	$(CC) -E -P -xc $(CFLAGS) -o $@ $<
