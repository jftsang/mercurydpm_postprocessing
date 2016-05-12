#ifndef MERCURY_DATAFRAME
#define MERCURY_DATAFRAME

#include"particle.hpp"

typedef struct {
    int Np;
    double time;
    double xmin, xmax, ymin, ymax, zmin, zmax;
    particle* ps;
} mercury_dataframe;

#endif
