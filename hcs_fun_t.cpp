#include"load_mercury_3d_data_multiple.h"
#include"height_at_point.hpp"
#include<stdio.h>

double eps = 1e-12;

int main(int argc, char* argv[]) {
    char filename_base[] = "/home/jmft2/MercuryDPM/MercuryBuild/Drivers/VPeriodic/veryshort4/VPeriodic-veryshort4.data.";
    int first_ind = 0;
    int last_ind = 25580;
    int jump = 100;
    int nframes = (last_ind - first_ind)/jump + 1;
    mercury_dataframe* frames = load_mercury_3d_data_multiple(
            filename_base, first_ind, last_ind, jump);

    for (int i=0; i<nframes; i++) {
        fprintf(stderr, 
            "i=%d, framenumber=%d, time=%f, Np=%d\n", 
            i, first_ind+i*jump, frames[i].time, frames[i].Np);
    }

    double* hs = (double*)malloc(nframes * sizeof(double));
    fprintf(stdout, "t h\n");
    for (int i = 0; i < nframes; i++) {
        hs[i] = height_at_point_xy(0, 0, 4, 4, frames+i);
        fprintf(stdout,
                "%f %f\n", frames[i].time, hs[i]);
    }
}
