#include "load_mercury_3d_data_multiple.h"
#include<stdio.h>

int main(int argc, char* argv[]) {
    char filename_base[] = "/home/jmft2/MercuryDPM/MercuryBuild/Drivers/VPeriodic/veryshort3/VPeriodicveryshort3.data.";
    int first_ind = 0;
    int last_ind = 4;
    int nframes = last_ind - first_ind + 1;
    mercury_dataframe* frames; 

    frames = load_mercury_3d_data_multiple(
            filename_base, first_ind, last_ind
    );

    for (int i = 0; i < nframes; i++) {
        fprintf(stdout, 
            "i=%d, framenumber=%d, time=%f, Np=%d\n", 
            i, first_ind+i, frames[i].time, frames[i].Np);
        for (int j = 0; j < frames[i].Np; j++) {
            fprintf(stdout, "i = %d, j = %d, x = %f\n", 
                    i, j, frames[i].ps[j].x);
        }
    }
}
