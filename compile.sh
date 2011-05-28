g++ -o3 boringPi.cc -o boringPi
g++ -fopenmp openMPi.cc -o openMPi
nvcc -arch=compute_20 -code=compute_20 cudaPi.cu -o cudaPi
