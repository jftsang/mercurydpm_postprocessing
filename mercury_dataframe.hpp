#ifndef MERCURY_DATAFRAME
#define MERCURY_DATAFRAME

#include"particle.hpp"

/* A dataframe represents the information in a .data file. It is usually wise to
 * pass mercury_dataframes as arguments to functions by reference, not by value,
 * because these tend to be quite large. Do something like:
 *  void function( mercury_dataframe *frame, ...) { ... };
 */

typedef struct {
    int Np;
    double time;
    double xmin, xmax, ymin, ymax, zmin, zmax;
    particle* ps;
} mercury_dataframe;

#endif
