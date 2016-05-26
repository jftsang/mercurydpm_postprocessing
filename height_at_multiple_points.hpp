#ifndef HEIGHT_AT_MULTIPLE_POINTS
#define HEIGHT_AT_MULTIPLE_POINTS

#include"height_at_point.hpp"
#include<pthread.h>

typedef struct {
    double xq, yq, ax, ay;
    mercury_dataframe *frameptr;
    double* hq;
} hmp_pt_wrapstruct_;

void* hmp_pt_wrapper_(void* voidin);

void* hmp_pt_wrapper_(void* voidin) {
    hmp_pt_wrapstruct_* inst = (hmp_pt_wrapstruct_*)voidin;
    *(inst->hq) = height_at_point_xy(
            inst->xq, inst->yq, inst->ax, inst->ay, 
            inst->frameptr );
    return NULL;
}

double* height_at_multiple_points(
        double* xqs, double* yqs, double ax, double ay, int Npoints, mercury_dataframe *frame) 
{
    double* hqs = (double*)malloc(Npoints*sizeof(double));
    pthread_t threads[Npoints];
    hmp_pt_wrapstruct_ structs[Npoints];

    for(int j = 0; j < Npoints; j++) {
        structs[j].xq = xqs[j];
        structs[j].yq = yqs[j];
        structs[j].ax = ax;
        structs[j].ay = ay;
        structs[j].frameptr = frame;
        structs[j].hq = &hqs[j];

        pthread_create(&threads[j], NULL,
                hmp_pt_wrapper_, &structs[j]);
    }

    for (int j = 0; j < Npoints; j++) {
        pthread_join(threads[j], NULL);
    }

    return hqs;
}

#endif
