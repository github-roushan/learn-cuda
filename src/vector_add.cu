#include <iostream>

__global__ void add(int *a, int *b, int *c) {
    int idx = threadIdx.x;
    c[idx] = a[idx] + b[idx];
}

int main() {
    const int arraySize = 5;
    const int arrayBytes = arraySize * sizeof(int);

    int h_a[arraySize] = {1, 2, 3, 4, 5};
    int h_b[arraySize] = {10, 20, 30, 40, 50};
    int h_c[arraySize];

    int *d_a, *d_b, *d_c;
    cudaMalloc((void**)&d_a, arrayBytes);
    cudaMalloc((void**)&d_b, arrayBytes);
    cudaMalloc((void**)&d_c, arrayBytes);

    cudaMemcpy(d_a, h_a, arrayBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, arrayBytes, cudaMemcpyHostToDevice);

    add<<<1, arraySize>>>(d_a, d_b, d_c);

    cudaMemcpy(h_c, d_c, arrayBytes, cudaMemcpyDeviceToHost);

    for (int i = 0; i < arraySize; i++) {
        std::cout << h_c[i] << " ";
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
