#include <iostream>
#include <cmath>
#include "randgen.cu"
using namespace std;

const unsigned long int goes = 10000;
const unsigned long int threads = 256;
const unsigned long int blocks = 1280;

__global__ void kernel(unsigned long *hits);

int main(void)
{
	unsigned long hits[blocks*threads], *dev_hits, totalHits=0;
	double pi;

	cudaMalloc((void**) &dev_hits, threads*blocks*sizeof(unsigned long));

	kernel<<<blocks, threads>>>(dev_hits);

	cudaMemcpy(&hits, dev_hits, threads*blocks*sizeof(unsigned long), cudaMemcpyDeviceToHost);
	cudaFree(dev_hits);

	for(int i=0; i<blocks*threads; i++)
	{
		totalHits += hits[i];
	}

	pi = 4.0 * (double) totalHits / (double) (goes *blocks *threads);

	cout.precision(8);
	cout << "\nCudaPi\n";
	cout << "Random points used:  " << goes*blocks*threads << endl;
	cout << "Pi was calculated as: " << pi << endl;
	cout << "Cmath reckons pi is:  " << M_PI << "\n\n";


	return 0;
}

__global__ void kernel(unsigned long *hits)
{
	float x, y;
	int id = threadIdx.x + blockIdx.x * blockDim.x;
	unsigned long state[N];
	int mti = N+1;

	hits[id]=0;

	setSeed(0x8C*id-12, state, mti);

	for(int j=0; j < goes; j++)
	{
		x = rnd(state, mti);
		y = rnd(state, mti);

		if(x*x+y*y <= 1) hits[id]++;
	}
}

