#ifndef COARSE_GRAIN_AT_POINT
#define COARSE_GRAIN_AT_POINT

#include"particle.hpp"
#include"mercury_dataframe.hpp"
#include"kernfunc.hpp"
#include"height_at_point.hpp"

#include<cassert>

extern double eps;

typedef struct {
    double xq, yq, zq;
    double rhoq, pxq, pyq, pzq, vxq, vyq, vzq;
    double vsqq, Tq;
    double pq;
} cg_fields;

cg_fields coarse_grain_at_point(
        double xq, double yq, double zq, 
        double ax, double ay, double az,
        mercury_dataframe *frame 
) {
    cg_fields cg;
    particle* ps = frame->ps;
    int Np = frame->Np;

    cg.xq = xq;
    cg.yq = yq;
    cg.zq = zq;

    cg.rhoq = 0;
    cg.pxq = 0;
    cg.pyq = 0;
    cg.pzq = 0;
    cg.vsqq = 0;
    cg.Tq = 0;
    cg.pq = 0;

    for (int i = 0; i < Np; i++) {
        double kernel = kernfunc(xq, yq, zq,
                            ps[i].x, ps[i].y, ps[i].z, ps[i].r, ax, ay, az, frame);

        if (fabs(ps[i].vx)<=eps && fabs(ps[i].vz)<=eps && fabs(ps[i].vz)<=eps) 
            kernel *= 10;

        cg.rhoq += kernel;
        cg.pxq += kernel*ps[i].vx;
        cg.pyq += kernel*ps[i].vy;
        cg.pzq += kernel*ps[i].vz;
        
        cg.vsqq += kernel * (pow(ps[i].vx,2) + pow(ps[i].vy,2) + pow(ps[i].vz,2));
    }

    cg.vxq = cg.pxq / cg.rhoq;
    cg.vyq = cg.pyq / cg.rhoq;
    cg.vzq = cg.pzq / cg.rhoq;
    cg.vsqq = cg.vsqq / cg.rhoq;
    cg.Tq = cg.vsqq - ( pow(cg.vxq,2) + pow(cg.vyq,2) + pow(cg.vzq,2) );
    cg.pq = height_at_point_xy(xq, yq, ax, ay, frame) - zq;
    
    return cg;
}

void cg_fields_print(cg_fields* cgs, int Npoints) {
    fprintf(stdout, "j xq yq zq rhoq vxq vyq vzq pxq pyq pzq Tq pq\n");
    for (int j = 0; j < Npoints; j++) {
        fprintf(stdout, "%d %f %f %f %f %f %f %f %f %f %f %f %f\n", 
                j, cgs[j].xq, cgs[j].yq, cgs[j].zq,
                cgs[j].rhoq, 
                cgs[j].vxq, cgs[j].vyq, cgs[j].vzq, 
                cgs[j].pxq, cgs[j].pyq, cgs[j].pzq,
                cgs[j].Tq, cgs[j].pq);
    }
}

#endif
