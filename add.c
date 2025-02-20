#include <stdio.h>

extern int add_numbers(int a, int b);

int main() {
    int a = 22;
    int b = 1;
    int result = add_numbers(a, b);
    printf("Result: %d\n", result);
    return 0;
}

