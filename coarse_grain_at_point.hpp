#include"particle.hpp"
#include"mercury_dataframe.hpp"
#include"kernfunc.hpp"

#include<cassert>

extern double eps;

typedef struct {
    double xq, yq, zq;
    double rhoq, pxq, pyq, pzq, vxq, vyq, vzq;
} cg_fields;

cg_fields coarse_grain_at_point(
        double xq, double yq, double zq, 
        double ax, double ay, double az,
        particle* ps, int Np
) {
    cg_fields cg;

    cg.xq = xq;
    cg.yq = yq;
    cg.zq = zq;

    cg.rhoq = 0;
    cg.pxq = 0;
    cg.pyq = 0;
    cg.pzq = 0;

    for (int i = 0; i < Np; i++) {
        double kernel = 
            (fabs(ps[i].vx)<=eps && fabs(ps[i].vz)<=eps && fabs(ps[i].vz)<=eps) ? 0 :
                kernfunc(xq, yq, zq,
                         ps[i].x, ps[i].y, ps[i].z, ps[i].r, ax, ay, az);

        cg.rhoq += kernel;
        cg.pxq += kernel*ps[i].vx;
        cg.pyq += kernel*ps[i].vy;
        cg.pzq += kernel*ps[i].vz;
    }
    /*
    fprintf(stdout, "xq=%f, yq=%f, zq=%f, rhoq=%f, pxq=%f\n", 
                    xq, yq, zq, cg.rhoq, cg.pxq);
                    */

    cg.vxq = cg.pxq / cg.rhoq;
    cg.vyq = cg.pyq / cg.rhoq;
    cg.vzq = cg.pzq / cg.rhoq;
    
    return cg;
}

void cg_fields_print(cg_fields* cgs, int Npoints) {
    fprintf(stdout, "j xq yq zq rhoq vxq vyq vzq pxq pyq pzq\n");
    for (int j = 0; j < Npoints; j++) {
        fprintf(stdout, "%d %f %f %f %f %f %f %f %f %f %f\n", 
                j, cgs[j].xq, cgs[j].yq, cgs[j].zq,
                cgs[j].rhoq, 
                cgs[j].vxq, cgs[j].vyq, cgs[j].vzq, 
                cgs[j].pxq, cgs[j].pyq, cgs[j].pzq);
    }
}
