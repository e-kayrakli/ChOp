#include <cuda.h>
#include <stdio.h>

#include "../headers/vector_add.h"

__global__ void vector_add(float *out, float *a, float *b, int n) {
    for(int i = 0; i < n; i++){
        out[i] = a[i] + b[i];
    }
}


__global__ void int_vector_add(int *out, int *a, int *b, int size) {
    for(int i = 0; i < size; i++){
        out[i] = a[i] + b[i];
    }
}

extern "C" void call_cuda_vector_add(){

    float *a, *b, *out; 
    float *d_a, *d_b, *d_out;

    // Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    for(int i = 0; i < N; i++){
        a[i] = 6.0f; 
        b[i] = 2.0f;
    }

    // Allocate device memory for a
    cudaMalloc((void**)&d_a,   sizeof(float) * N);
    cudaMalloc((void**)&d_b,   sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);
   
    vector_add<<<1,1>>>(d_out, d_a, d_b, N);

    cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);
   
    for(int i = 0; i < N; i++){
        printf(" %f  \n", out[i]);
    }

    // Cleanup after kernel execution
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);
    free(a);
    free(b);
    free(out);

    // Initialize array
}


extern "C" void call_cuda_param_vector_add(int *h_a, int *h_b, int *out, int size){

    
    int *d_a, *d_b, *d_out;

    // Allocate device memory for a
    cudaMalloc((void**)&d_a,   sizeof(int) * size);
    cudaMalloc((void**)&d_b,   sizeof(int) * size);
    cudaMalloc((void**)&d_out, sizeof(int) * size);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, h_a, sizeof(int) * size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, sizeof(int) * size, cudaMemcpyHostToDevice);
   
    int_vector_add<<<1,1>>>(d_out, d_a, d_b, size);

    cudaMemcpy(out, d_out, sizeof(int) * size, cudaMemcpyDeviceToHost);
   

    // Cleanup after kernel execution
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);

}

