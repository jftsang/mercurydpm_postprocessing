#ifndef COARSE_GRAIN_AT_MULTIPLE_POINTS
#define COARSE_GRAIN_AT_MULTIPLE_POINTS

#include"coarse_grain_at_point.hpp"
#include"load_mercury_3d_data.hpp"
#include<pthread.h>

/* Function declaration */

/* For working out continuum fields at a number of different points. The points'
 * coordinates are specified as arrays xqs, yqs, zqs; you also pass the
 * dataframe by reference (not by value, because dataframes tend to be quite
 * large). */

cg_fields* coarse_grain_at_multiple_points(
        double* xqs, double* yqs, double* zqs, int Npoints,
        mercury_dataframe *frame);

/* For pthreading */

typedef struct {
    double xq, yq, zq;
    double ax, ay, az;
    mercury_dataframe *frameptr;
    cg_fields* cgptr;
} cgmp_pt_wrapstruct_;

void* cgmp_pt_wrapper_(void* voidin);

/* Function definitions */

void* cgmp_pt_wrapper_(void* voidin) {
    cgmp_pt_wrapstruct_* inst = (cgmp_pt_wrapstruct_*)voidin;
    *(inst->cgptr) = coarse_grain_at_point(
                      inst->xq, inst->yq, inst->zq, 
                      inst->ax, inst->ay, inst->az,
                      inst->frameptr );
    return NULL;
}


cg_fields* coarse_grain_at_multiple_points(
        double* xqs, double* yqs, double* zqs, int Npoints,
        mercury_dataframe *frame) 
{
        cg_fields* cgs = (cg_fields*)malloc(Npoints * sizeof(cg_fields));
        pthread_t threads[Npoints];
        cgmp_pt_wrapstruct_ structs[Npoints];

        for(int j = 0; j < Npoints; j++) {
            structs[j].xq = xqs[j];
            structs[j].yq = yqs[j];
            structs[j].zq = zqs[j];
            structs[j].ax = -2;
            structs[j].ay = 4;
            structs[j].az = 4;
            structs[j].frameptr = frame;
            structs[j].cgptr = &cgs[j];

            pthread_create(&threads[j], NULL, cgmp_pt_wrapper_, &structs[j]);

            /*
            cgs[j] = coarse_grain_at_point(
                    xqs[j], yqs[j], zqs[j], -2, 4, 4, 
                    frame );
            */
        }

        for (int j = 0; j < Npoints; j++) {
            pthread_join(threads[j], NULL);
        }

        return cgs;
}
#endif
