// Period Parameters
const int N = 624;
const int M = 397;
const unsigned int matrixA = 0x9908b0df; // constant vector a
const unsigned int upperMask = 0x80000000; // most significant w-r bits
const unsigned int lowerMask = 0x7fffffff; // least significant r bits

// Tempering Parameters

const unsigned int temperingMaskB = 0x9d2c5680;
const unsigned int temperingMaskC = 0xefc60000;
#define temperingShiftU(y) (y >> 11)
#define temperingShiftS(y) (y << 7)
#define temperingShiftT(y) (y << 15)
#define temperingShiftL(y) (y >> 18)

// initializing the array with a non-zero seed
__device__ void sgenrand(unsigned long seed, unsigned long mt[], int &mti)
{
	mt[0] = seed & 0xffffffff;
	for(mti=1; mti<N; mti++) mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
}

__device__ float rnd(unsigned long mt[], int &mti)
{
	unsigned long y;
	const unsigned long mag01[2] = { 0x0, matrixA };
	// mag01[x] = x * matrixA for x=0,1

	if(mti >= N) // generate N words at one time
	{
		int kk;

		// if sgenrand() has not been called a default initial seed is used
		if(mti == N+1) sgenrand(4357, mt, mti);

		for(kk=0;kk<N-M;kk++)
		{
			y = (mt[kk]&upperMask)|(mt[kk+1]&lowerMask);
			mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
		}

		for(;kk<N-1;kk++)
		{
			y = (mt[kk]&upperMask)|(mt[kk+1]&lowerMask);
			mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
		}

		y = (mt[N-1]&upperMask)|(mt[0]&lowerMask);
		mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];

		mti = 0;
	}

	y = mt[mti++];
	y ^= temperingShiftU(y);
	y ^= temperingShiftS(y) & temperingMaskB;
	y ^= temperingShiftT(y) & temperingMaskC;
	y ^= temperingShiftL(y);

	return  ( (float) y / (unsigned long) 0xffffffff);
}

__device__ void setSeed(int threadno, unsigned long mt[], int &mti)
{
	// It doesn't let me use time, oh well
	// I picked this seed randomly
	unsigned long seed = 0x39FA;

	sgenrand(seed | threadno, mt, mti);
}
