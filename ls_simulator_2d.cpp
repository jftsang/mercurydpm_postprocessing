/* Laser scanner simulator, in 2D, in which everything happens on the y=0 line. */

#include"load_mercury_3d_data_multiple.h"
#include"height_at_multiple_points.hpp"
#include<stdio.h>

int main(int argc, char* argv[]) {
    char* filename_base;
    int first_ind, last_ind, jump;
    double desired_x;
    size_t Nx;
    if (argc > 5)
    {
        filename_base = argv[1];
        first_ind = atoi(argv[2]);
        last_ind = atoi(argv[3]);
        jump = atoi(argv[4]);
        Nx = atoi(argv[5]);
    }
    else
    {
        fprintf(stderr, "Usage: %s filename_base first_ind last_ind jump Nx\n", argv[0]);
        fprintf(stderr, "Example: %s ~/MercuryDPM/MercuryBuild/Drivers/Jonny/SineCurrent-shallow-lowk-norf.data. 800 1000 100 256\n", argv[0]);
        exit(-1);
    }
    size_t nframes = (last_ind - first_ind)/jump + 1;
    mercury_dataframe frame;
    
    double* xqs = (double*) malloc(Nx * sizeof(double));
    double* yqs = (double*) malloc(Nx * sizeof(double));
    double* tqs = (double*) malloc(Nx * sizeof(double));
    double* hqs = (double*) malloc(Nx * sizeof(double));

    for (int i = 0; i < nframes; i++) {
        int ind = first_ind + jump*i;
        char* filename = (char*)malloc(strlen(filename_base)+11);
        snprintf(filename, strlen(filename_base)+11, 
                    "%s%d", filename_base, ind);
        fprintf(stderr, "%s\n", filename);
        frame = load_mercury_3d_data(filename);

        if (i==0)
            fprintf(stdout, "%lu ", Nx);
        for (int j = 0; j < Nx; j++) {
            tqs[j] = frame.time;
            xqs[j] = frame.xmin + (frame.xmax - frame.xmin)*j/(Nx - 1);
            yqs[j] = 0;
            if (i==0)
                fprintf(stdout, "%f ", xqs[j]);
        }
        if (i==0)
            fprintf(stdout, "\n");

        hqs = height_at_multiple_points(xqs, yqs, 5, 5, Nx, &frame);
        fprintf(stdout, "%f ", frame.time);
        for (int j = 0; j < Nx; j++)
            fprintf(stdout, "%f ", hqs[j]);
        fprintf(stdout, "\n");
    }

}
