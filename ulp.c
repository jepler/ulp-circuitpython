// ULP-RISCV

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "ulp_riscv/ulp_riscv.h"
#include "ulp_riscv/ulp_riscv_utils.h"
#include "ulp_riscv/ulp_riscv_gpio.h"

#define EXPORT __attribute__((used,visibility("default")))
// global variables will be exported as public symbols, visible from main CPU
EXPORT uint8_t shared_mem[1024];
EXPORT uint16_t shared_mem_len = 1024;

#undef ULP_RISCV_CYCLES_PER_MS
#define ULP_RISCV_CYCLES_PER_MS (int)(1000*ULP_RISCV_CYCLES_PER_US)

#define GPIO (GPIO_NUM_3)
int main (void) {
    shared_mem[0] = 10;
    shared_mem_len = 1024;

    bool gpio_level = true;

    ulp_riscv_gpio_init(GPIO);
    ulp_riscv_gpio_output_enable(GPIO);

    while(1) {
        ulp_riscv_gpio_output_level(GPIO, gpio_level);
        ulp_riscv_delay_cycles(shared_mem[0] * 10 * ULP_RISCV_CYCLES_PER_MS);
        gpio_level = !gpio_level;
    }

    // ulp_riscv_shutdown() is called automatically when main exits
    return 0;
}
