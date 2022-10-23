ifeq ($(origin IDF_PATH),undefined)
$(error You must "source esp-idf/export.sh" before building)
endif

COPROC_RESERVE_MEM ?= 8176
SOC := esp32s3
CROSS := riscv32-esp-elf-
CC := $(CROSS)gcc
STRIP := $(CROSS)strip
CFLAGS := -Os -march=rv32imc -mdiv -fdata-sections -ffunction-sections
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
LDFLAGS := -march=rv32imc --specs=nano.specs --specs=nosys.specs

SRCS ?= ulp.c
SRCS += $(IDF_PATH)/components/ulp/ulp_riscv/ulp_riscv_utils.c
LDFLAGS += link.ld


.PHONY: default
default: a.out-stripped
a.out-stripped: a.out
	$(STRIP) -g -o $@ $<

a.out: $(SRCS) link.ld
	$(CC) -flto $(CFLAGS) $^ -o $@ $(LDFLAGS)

.PHONY: clean
clean:
	rm -f a.out* link.ld

link.ld: ulp.riscv.ld
	$(CC) -E -P -xc $(CFLAGS) -o $@ $<
