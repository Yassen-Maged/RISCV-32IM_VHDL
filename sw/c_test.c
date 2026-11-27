// c_test.c
volatile int result_out = 0;

int add_squares(int a, int b) {
    return (a * a) + (b * b);
}

__attribute__((section(".text.init"), used))
void _start(void) {
    // Set stack pointer (x2) to top of data memory (adjust to match your RAM size)
    __asm__ volatile ("li sp, 0x1000");

    int arr[4] = {2, -3, 5, 7};
    int sum = 0;
    for (int i = 0; i < 4; i++) {
        sum += add_squares(arr[i], i + 1);
    }

    result_out = sum;

    while (1) {
        // Trap for waveform inspection
    }
}
