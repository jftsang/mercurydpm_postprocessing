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

int main(int argc, char* argv[]) {

    /* Load the data file */
    std::string filename;
    if (argc > 1) 
        filename = argv[1];
    else {
        fprintf(stderr, "Usage: %s [filename]\n", argv[0]);
        return(-1);
    }

    double a = 2.0;

    int Npoints_z = 32; 
    int Npoints_y = 64;
    int Npoints_x = 32;
    int Npoints = Npoints_z * Npoints_y * Npoints_x;

    mercury_dataframe frame;
    frame = load_mercury_3d_data(filename);
    fprintf(stderr, "Loaded frame: time %f from file %s\n",
                frame.time, filename.c_str());

    xmin = frame.xmin; xmax = frame.xmax;
    ymin = frame.ymin; ymax = frame.ymax;
    zmin = frame.zmin; zmax = frame.zmax;
    particle* ps = frame.ps;
    std::cerr << "Np = " << frame.Np  << std::endl;
    std::cerr << "Finished loading from data files." << std::endl;

    /* Here is the list of points at which we will query the continuum field */
    double* zqs; zqs = new double[Npoints];
    double* yqs; yqs = new double[Npoints];
    double* xqs; xqs = new double[Npoints];
    cg_fields* cgs; cgs = new cg_fields[Npoints];

    for (int j = 0; j < Npoints_z; j++) {
        for (int k = 0; k < Npoints_y; k++) {
            for (int l = 0; l < Npoints_x; l++) {
                zqs[j*Npoints_y*Npoints_x + k*Npoints_x + l] = zmin + ((zmax-zmin)*j)/(Npoints_z - 1); 
                yqs[j*Npoints_y*Npoints_x + k*Npoints_x + l] = ymin + ((ymax-ymin)*k)/(Npoints_y - 1); 
                xqs[j*Npoints_y*Npoints_x + k*Npoints_x + l] = xmin + ((xmax-xmin)*l)/(Npoints_x - 1); 
            }
        }
    }

    cgs = coarse_grain_at_multiple_points(xqs, yqs, zqs, Npoints, &frame);

    cg_fields_print(cgs, Npoints);

    return 0;
}
