#include<iostream>
#include<fstream>
#include<cmath>
#include<string>
#include<vector>
#include<mpi.h>
#include<cstdlib>
#include<cassert>
#include"load_mercury_3d_data.hpp"
#include"coarse_grain_at_multiple_points.hpp"

double pi = 3.1415926535898;
double eps = 1e-12;
double xmin, xmax;
double ymin, ymax;
double zmin, zmax;
double alpha = 25 * (pi / 180);

int main(int argc, char* argv[]) {

    /* Load the data file */
    std::string filename;
    if (argc > 1) 
        filename = argv[1];
    else {
        fprintf(stderr, "Usage: %s [filename]\n", argv[0]);
        return(-1);
    }

    int Npoints = 256;

    mercury_dataframe frame;
    frame = load_mercury_3d_data(filename);
    fprintf(stderr, "Loaded frame: time %f from file %s\n",
                frame.time, filename.c_str());

    xmin = frame.xmin; xmax = frame.xmax;
    ymin = frame.ymin; ymax = frame.ymax;
    zmin = frame.zmin; zmax = frame.zmax;

    zmin = 0; zmax = 1;
    std::cerr << "Np = " << frame.Np  << std::endl;
    std::cerr << "Finished loading from data files." << std::endl;

    /* Here is the list of points at which we will query the continuum field */
    double* xqs; xqs = new double[Npoints];
    double* yqs; yqs = new double[Npoints];
    double* zqs; zqs = new double[Npoints];
    cg_fields* cgs; cgs = new cg_fields[Npoints];

    for (int j = 0; j < Npoints; j++) {
        xqs[j] = 0;
        yqs[j] = 0;
        zqs[j] = zmin + ((zmax-zmin)*j)/(Npoints - 1); 
    }

    cgs = coarse_grain_at_multiple_points(xqs, yqs, zqs, -2, 4, 4, Npoints, &frame);
    cg_fields_print(cgs, Npoints);

    return 0;
}
