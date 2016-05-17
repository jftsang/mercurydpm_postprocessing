#ifndef KERNFUNC
#define KERNFUNC

/* For a query position (xq,yq,zq), kernfunc gives the 
 * weight of a particle at (x,y,z) with radius r. The scales ax, ay, az control
 * the 'effective radius' in that direction. 
 * 
 * Essentially, each particle is spherical, but for the purpose of
 * coarse-graining, it affects an ellipsoidal region around it. 
 *
 * A scale ax=0 means 'average over x', and a negative scale ax<0 means 'have
 * periodicity in x'. The bounds of the periodic domain need to be specified
 * separately. 
 *
 * TODO: Reduce dependence on externs.
 * */

#include<math.h>
#include"mercury_dataframe.hpp"

double kernfunc(
        double xq, double yq, double zq, 
        double x, double y, double z, 
        double r, double ax, double ay, double az,
        mercury_dataframe *frame) {
    double kernel = 0;

    /* We weight according to the distance from the point
     * that we are interested in, and to the size of the
     * particle. */

    double difx = fabs(xq - x);
    double dify = fabs(yq - y);
    double difz = fabs(zq - z);

    /* For periodicity */
    if (ax < 0) {
        if (difx > (frame->xmax - frame->xmin)/2) 
            difx = (frame->xmax - frame->xmin - difx);
        ax *= -1;
    }
    if (ay < 0) {
        if (dify > (frame->ymax - frame->ymin)/2) 
            dify = (frame->ymax - frame->ymin - dify);
        ay *= -1;
    }
    if (az < 0) {
        if (difz > (frame->zmax - frame->zmin)/2) 
            difz = (frame->zmax - frame->zmin - difz);
        az *= -1;
    }

    ax*=r;
    ay*=r;
    az*=r;

    double effdistsq;
    if (ax > 0 && ay == 0 && az == 0) {
        effdistsq = pow(difx/ax,2);
    } 
    if (ax > 0 && ay > 0 && az == 0) {
        effdistsq = pow(difx/ax,2) + pow(dify/ay,2);
    } 
    if (ax > 0 && ay == 0 && az > 0) {
        effdistsq = pow(difx/ax,2) + pow(difz/az,2);
    } 
    if (ax > 0 && ay > 0 && az > 0) {
        effdistsq = pow(difx/ax,2) + pow(dify/ay,2) + pow(difz/az,2);
    }
    if (ax == 0 && ay > 0 && az == 0) {
        effdistsq = pow(dify/ay,2);
    }
    if (ax == 0 && ay == 0 && az > 0) {
        effdistsq = pow(difz/az,2);
    }
    if (ax == 0 && ay > 0 && az > 0) {
        effdistsq = pow(dify/ay,2) + pow(difz/az,2);
    } 

    kernel = (effdistsq <= 1)?pow(1 - effdistsq, 3):0;

    return kernel;
}

#endif
