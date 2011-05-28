#include <omp.h>
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cmath>
using namespace std;

int main(void)
{
	unsigned long totalHits = 0, hits = 0, runs = 3276800000, i;
	int j, id;
	double pi, x, y;
	unsigned int *seeds;

	seeds = new unsigned int [4];

	#pragma omp parallel reduction(+:hits) private(x, y, id)
	{
		id = omp_get_thread_num();
		seeds[id] = time(NULL) ^ id;

		#pragma omp for
		for(i=0; i<runs; i++)
		{

			x = (double) rand_r(&seeds[id]) / RAND_MAX;
			y = (double) rand_r(&seeds[id]) / RAND_MAX;

			if(x*x+y*y<=1)
			{
				hits++;
			}
		}
	}

	delete [] seeds;

	pi = 4.0 * (double) hits / runs;

	cout.precision(8);
	cout << "\nOpenMPi\n";
	cout << "Random points used:  " << runs << endl;
	cout << "Pi was calculated as: " << pi << endl;
	cout << "Cmath reckons pi is:  " << M_PI << "\n\n";

	return 0;
}
