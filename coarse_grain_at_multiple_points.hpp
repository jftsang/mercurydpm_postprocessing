#ifndef COARSE_GRAIN_AT_MULTIPLE_POINTS
#define COARSE_GRAIN_AT_MULTIPLE_POINTS

#include"coarse_grain_at_point.hpp"
#include"load_mercury_3d_data.hpp"

cg_fields* coarse_grain_at_multiple_points(
        double* xqs, double* yqs, double* zqs, int Npoints,
        mercury_dataframe *frame) {

        cg_fields* cgs = (cg_fields*)malloc(Npoints * sizeof(cg_fields));
        for(int j = 0; j < Npoints; j++) {
            cgs[j] = coarse_grain_at_point(
                    xqs[j], yqs[j], zqs[j], -2, 4, 4, 
                    frame );
        }
        return cgs;
}
#endif
