#include <iostream>
#include <cstdlib>
#include <cmath>
using namespace std;

int main(void)
{
	unsigned long hits = 0, runs = 3276800000, i;
	int j;
	double pi, x, y;

	srand((int) time(NULL));

	for(i=0; i<runs; i++)
	{
		x = (double) rand() / RAND_MAX;
		y = (double) rand() / RAND_MAX;

		if(x*x+y*y<=1) hits++;
	}

	pi = 4.0 * (double) hits / runs;

	cout.precision(8);
	cout << "\nBoringPi\n";
	cout << "Random points used:  " << runs << endl;
	cout << "Pi was calculated as: " << pi << endl;
	cout << "Cmath reckons pi is:  " << M_PI << "\n\n";

	return 0;
}
