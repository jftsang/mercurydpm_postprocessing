#ifndef HEIGHT_AT_POINT
#define HEIGHT_AT_POINT

#include"particle.hpp"
#include"mercury_dataframe.hpp"
#include"kernfunc.hpp"

#include<assert.h>
#include<algorithm>

extern double eps;

double height_at_point_xy(
    double xq, double yq, 
    double ax, double ay, 
    mercury_dataframe *frame
) {
    double height;
    particle* ps = frame->ps;
    int Np = frame->Np;

    double* zs_weighted = (double*)malloc(Np * sizeof(double));
    for (int i = 0; i < Np; i++) {
        zs_weighted[i] = ps[i].z 
                * kernfunc(xq,yq,0,ps[i].x,ps[i].y,ps[i].z, ps[i].r, ax, ay, 0,
                frame);
    }
    height = *std::max_element(zs_weighted, zs_weighted+Np);
    return height;
}

#endif
