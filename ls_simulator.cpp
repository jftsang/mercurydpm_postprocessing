/* Sit at a given x, and measure the height as a function of y and time. */

#include"load_mercury_3d_data_multiple.h"
#include"height_at_point.hpp"
#include<stdio.h>

int main(int argc, char* argv[]) {
    double desired_x = 0;

    char filename_base[] = "/home/jmft2/MercuryDPM/MercuryBuild/Drivers/VPeriodic/veryshort4/VPeriodic-veryshort4.data.";
    int first_ind = 0;
    int last_ind = 25580;
    int jump = 10000;
    int nframes = (last_ind - first_ind)/jump + 1;
    mercury_dataframe* frames = load_mercury_3d_data_multiple(
            filename_base, first_ind, last_ind, jump);
    
    int Ny = 5;
    double* xqs = (double*) malloc(nframes * Ny * sizeof(double));
    double* yqs = (double*) malloc(nframes * Ny * sizeof(double));
    double* tqs = (double*) malloc(nframes * Ny * sizeof(double));
    double* hqs = (double*) malloc(nframes * Ny * sizeof(double));
    for (int i = 0; i < nframes; i++) {
        for (int j = 0; j < Ny; j++) {
            int k = i*Ny + j;
            tqs[k] = frames[i].time;
            xqs[k] = desired_x;
            yqs[k] = frames[i].ymin + (frames[i].ymax - frames[i].ymin)*j/(Ny - 1);
            hqs[k] = height_at_point_xy(xqs[k], yqs[k], -4, 4, frames+i);
            // fprintf(stdout, "i=%d j=%d k=%d t=%f x=%f y=%f h=%f\n", i,j,k, tqs[k], xqs[k], yqs[k], hqs[k]);
        }
    }

    fprintf(stdout, "t y h\n");
    for (int k = 0; k < (nframes * Ny); k++) {
        fprintf(stdout, "%f %f %f %f\n", tqs[k], xqs[k], yqs[k], hqs[k]);
    }

}
