#ifndef M_LOAD_3D_DATA_MULT
#define M_LOAD_3D_DATA_MULT

#include<stdio.h>
#include<string.h>
#include"load_mercury_3d_data.hpp"
#include<pthread.h>

/* Function declarations */

/* For loading multiple .data files whose names are of the form 
 * problemname.data.%d. The return value is the number of frames. */
mercury_dataframe* load_mercury_3d_data_multiple(
        char* filename_base,
        int first_ind,
        int last_ind
);

/* For pthreading */
typedef struct {
    char* filename;
    int ind;
    mercury_dataframe frame;
} lm3d_pt_wrapstruct;

void* lm3d_pt_wrapper(void* voidin);

/* Function definitions */

void* lm3d_pt_wrapper(void* voidin) {
    lm3d_pt_wrapstruct* inst = (lm3d_pt_wrapstruct*)voidin;
    inst->frame = load_mercury_3d_data(inst->filename, 0);
    return NULL;
};

mercury_dataframe* load_mercury_3d_data_multiple(
        char* filename_base,
        int first_ind,
        int last_ind
) {
    int nframes = last_ind - first_ind + 1;
    mercury_dataframe* frames;
    frames = new mercury_dataframe[nframes];
    pthread_t threads[nframes];
    lm3d_pt_wrapstruct structs[nframes]; 
    
    for (int i = 0; i < nframes ; i++) {
        /* Construct the filenames. */
        int ind = i + first_ind;
        structs[i].filename = (char*)malloc(strlen(filename_base)+11);
        snprintf(structs[i].filename, strlen(filename_base)+11, 
                    "%s%d", filename_base, ind);
        fprintf(stderr, "%s\n", structs[i].filename);
        
        pthread_create(
                &threads[i], NULL, lm3d_pt_wrapper, &structs[i]);
    }

    for (int i = 0; i < nframes ; i++) {
        pthread_join(threads[i], NULL);
    }

    for (int i = 0; i < nframes; i++) {
        frames[i] = structs[i].frame;
    }

    return frames;
}

#endif
