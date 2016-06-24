/* Laser scanner simulator: Sit at a given x, and measure the height as a
 * function of y and time. */

#include"load_mercury_3d_data_multiple.h"
#include"height_at_multiple_points.hpp"
#include<stdio.h>

int main(int argc, char* argv[]) {
    double desired_x = 0;

    char* filename_base;
    if (argc > 1)
        filename_base = argv[1];
    else
    {
        fprintf(stderr, "Usage: %s filename_base\n", argv[0]);
        fprintf(stderr, "Example: %s /home/jmft2/MercuryDPM/MercuryBuild/Drivers/VPeriodic/flatbed-beta60/VPeriodic-flatbed-beta60.data.\n", argv[0]);
        exit(-1);
    }
    int first_ind =  500000;
    int last_ind  = 1000000;
    int jump      =  100000;
    int nframes = (last_ind - first_ind)/jump + 1;
    mercury_dataframe frame;
    
    int Ny = 256;
    double* xqs = (double*) malloc(Ny * sizeof(double));
    double* yqs = (double*) malloc(Ny * sizeof(double));
    double* tqs = (double*) malloc(Ny * sizeof(double));
    double* hqs = (double*) malloc(Ny * sizeof(double));

    fprintf(stdout, "t x y h\n");
    for (int i = 0; i < nframes; i++) {
        int ind = first_ind + jump*i;
        char* filename = (char*)malloc(strlen(filename_base)+11);
        snprintf(filename, strlen(filename_base)+11, 
                    "%s%d", filename_base, ind);
        fprintf(stderr, "%s\n", filename);
        frame = load_mercury_3d_data(filename);

        for (int j = 0; j < Ny; j++) {
            tqs[j] = frame.time;
            xqs[j] = desired_x;
            yqs[j] = frame.ymin + (frame.ymax - frame.ymin)*j/(Ny - 1);
        }
        hqs = height_at_multiple_points(xqs, yqs, -5, 5, Ny, &frame);
        for (int j = 0; j < Ny; j++) {
            fprintf(stdout, "%f %f %f %f\n", tqs[j], xqs[j], yqs[j], hqs[j]);
        }
    }

}
