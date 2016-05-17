#include "load_mercury_3d_data_multiple.h"
#include"coarse_grain_at_multiple_points.hpp"
#include<stdio.h>

double xmin, xmax;
double ymin, ymax;
double zmin, zmax;
double eps = 1e-12;

int main(int argc, char* argv[]) {
    char filename_base[] = "/home/jmft2/MercuryDPM/MercuryBuild/Drivers/VPeriodic/veryshort3/VPeriodicveryshort3.data.";
    int first_ind = 0;
    int last_ind = 120;
    int nframes = last_ind - first_ind + 1;
    mercury_dataframe* frames; 

    frames = load_mercury_3d_data_multiple(
            filename_base, first_ind, last_ind
    );

    for (int i = 0; i < nframes; i++) {
        fprintf(stdout, 
            "i=%d, framenumber=%d, time=%f, Np=%d\n", 
            i, first_ind+i, frames[i].time, frames[i].Np);
        /*
        for (int j = 0; j < frames[i].Np; j++) {
            fprintf(stdout, "i = %d, j = %d, x = %f\n", 
                    i, j, frames[i].ps[j].x);
        }
        */

        xmin = frames[i].xmin; xmax = frames[i].xmax;
        ymin = frames[i].ymin; ymax = frames[i].ymax;
        zmin = frames[i].zmin; zmax = frames[i].zmax;
        
        int Npoints = 120;
        double xqs[Npoints];
        double yqs[Npoints];
        double zqs[Npoints];
        cg_fields* cgs = (cg_fields*)malloc(Npoints * sizeof(cg_fields));
        for (int j=0; j<Npoints; j++) {
            xqs[j] = xmin + (xmax-xmin)*j/(Npoints - 1);
            yqs[j] = 0;
            zqs[j] = 0;
        }

        cgs = coarse_grain_at_multiple_points(xqs, yqs, zqs, Npoints, frames+i);
        cg_fields_print(cgs, Npoints);
    }
}
