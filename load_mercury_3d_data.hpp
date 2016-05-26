#ifndef M_LOAD_3D_DATA
#define M_LOAD_3D_DATA

#include<fstream>
#include<string>
#include<vector>
#include<cassert>
#include"mercury_dataframe.hpp"

/* Function declarations */

/* For loading a single frame from a MercuryDPM .data file. 
 * The list of particle positions, velocities and radii are stored in the
 * std::vector<double>s that are provided by reference, e.g.
 *
 * std::string filename = "output.data";
 * double desiredTime = 1.5; 
 * std::vector<double> xs;
 * [...]
 * int Np = load_mercury_3d_data(filename, desiredTime, &xs, ...);
 *
 * Set desiredTime=0 if you want to load the first frame from a file. 
 *
 * The return value is the number of particles.
 */

mercury_dataframe load_mercury_3d_data( std::string filename );

mercury_dataframe load_mercury_3d_data(
        std::string filename, 
        double desiredTime  
);

/* Function definitions */

mercury_dataframe load_mercury_3d_data( std::string filename ) {
    return load_mercury_3d_data(filename, 0.0);
}

mercury_dataframe load_mercury_3d_data(
        std::string filename,
        double desiredTime
) {
    mercury_dataframe out;

    std::ifstream dataFile;
    dataFile.open(filename.c_str());

    assert( !dataFile.fail() );

    int Np=0;
    double time=0;
    /* Loop over frames until we reach the frame that we 
     * are looking for.
     */
    while(true) {
        /* Read the first line of the frame */
        dataFile >> Np; // The number of particles.
        dataFile >> time; // The current time.
        dataFile >> out.xmin;
        dataFile >> out.ymin;
        dataFile >> out.zmin;
        dataFile >> out.xmax;
        dataFile >> out.ymax;
        dataFile >> out.zmax;
        std::string line; 
        // Discard the rest of this line.
        std::getline(dataFile, line); 

        if (time < desiredTime) {
            /* Read the following Np lines, which we 
             * ignore. */
            for (int i = 0; i < Np; i++) {
                std::getline(dataFile, line);
            }
        } else {
            /* Finally we have reached the frame that we 
             * are looking for.
             * */

            out.ps = new particle[Np]; 
            for (int i = 0; i < Np; i++) {
                double x, y, z, vx, vy, vz, r, qx, qy, qz, wx, wy, wz, xi;
                dataFile >> x;
                dataFile >> y;
                dataFile >> z;
                dataFile >> vx;
                dataFile >> vy;
                dataFile >> vz;
                dataFile >> r;
                dataFile >> qx;
                dataFile >> qy;
                dataFile >> qz;
                dataFile >> wx;
                dataFile >> wy;
                dataFile >> wz;
                dataFile >> xi;

                out.Np = Np;
                out.time = time;
                out.ps[i].x = x;
                out.ps[i].y = y;
                out.ps[i].z = z;
                out.ps[i].vx = vx;
                out.ps[i].vy = vy;
                out.ps[i].vz = vz;
                out.ps[i].r = r;
                
            }
            break;
        }
    }

    return out;
}

#endif
