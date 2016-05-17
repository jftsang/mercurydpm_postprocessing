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
        fprintf(stderr, "Usage: %s [filename] [desired_time] [desired_x]\n", argv[0]);
        return(-1);
    }

    double desired_time = argc>2?atof(argv[2]):0;
    int Npoints_z = 64; 
    int Npoints_y = 64;
    int Npoints = Npoints_z * Npoints_y + 1;
    double desired_x = argc>3?atof(argv[3]):0;

    mercury_dataframe frame = load_mercury_3d_data(filename, desired_time);
    fprintf(stderr, "Loaded frame: time %f from file %s\n",
                frame.time, filename.c_str());

    xmin = frame.xmin; xmax = frame.xmax;
    ymin = frame.ymin; ymax = frame.ymax;
    zmin = frame.zmin; zmax = frame.zmax;
    std::cerr << "Np = " << frame.Np  << std::endl;
    std::cerr << "Finished loading from data files." << std::endl;

    /* Here is the list of points at which we will query the continuum field */
    double* xqs; xqs = new double[Npoints];
    double* yqs; yqs = new double[Npoints];
    double* zqs; zqs = new double[Npoints];
    cg_fields* cgs; cgs = new cg_fields[Npoints];

    xqs[0] = desired_x; yqs[0] = 0; zqs[0] = 0;
    for (int j = 0; j < Npoints_z; j++) {
        for (int k = 0; k < Npoints_y; k++) {
            xqs[1 + j*Npoints_y + k] = desired_x;
            zqs[1 + j*Npoints_y + k] = zmin + ((zmax-zmin)*(j+1))/(Npoints_z - 1); 
            double ymin_here = -zqs[1 + j*Npoints_y+k] / tan(alpha);
            double ymax_here = +zqs[1 + j*Npoints_y+k] / tan(alpha);
            yqs[1 + j*Npoints_y + k] = ymin_here + ((ymax_here-ymin_here)*k)/(Npoints_y - 1);
        }
    }

    cgs = coarse_grain_at_multiple_points(xqs, yqs, zqs, Npoints, &frame);
    cg_fields_print(cgs, Npoints);

    return 0;
}
