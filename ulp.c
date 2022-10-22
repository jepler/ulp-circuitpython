// ULP-RISCV

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "ulp_riscv/ulp_riscv.h"
#include "ulp_riscv/ulp_riscv_utils.h"
#include "ulp_riscv/ulp_riscv_gpio.h"

// global variables will be exported as public symbols, visible from main CPU
__attribute__((used)) uint8_t shared_mem[1024];
__attribute__((used)) uint16_t shared_mem_len = 1024;

int main (void) {
    shared_mem[0] = 10;
    shared_mem_len = 1024;

    bool gpio_level = true;

    ulp_riscv_gpio_init(GPIO_NUM_21);
    ulp_riscv_gpio_output_enable(GPIO_NUM_21);

    while(1) {
        ulp_riscv_gpio_output_level(GPIO_NUM_21, gpio_level);
        ulp_riscv_delay_cycles(shared_mem[0] * 10 * ULP_RISCV_CYCLES_PER_MS);
        gpio_level = !gpio_level;
    }

    // ulp_riscv_shutdown() is called automatically when main exits
    return 0;
}
