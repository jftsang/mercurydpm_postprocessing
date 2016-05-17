#ifndef COARSE_GRAIN_AT_MULTIPLE_POINTS
#define COARSE_GRAIN_AT_MULTIPLE_POINTS

#include"coarse_grain_at_point"
#include"load_mercury_3d_data.hpp"

cg_fields* coarse_grain_at_multiple_points(
        double* xqs, double* yqs, double* zqs, int Npoints,
        mercury_dataframe frame) {

        cg_fields* cgs = malloc(Npoints * sizeof(cg_fields));
        

        return cgs;
}
#endif
