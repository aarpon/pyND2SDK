#include <stdlib.h>
#include <stdio.h>
#include "nd2ReadSDK.h"

#ifndef __DATA_ACCESS_HELPER_H__
#define __DATA_ACCESS_HELPER_H__

#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))

float *make_matrix_c(int nrows, int ncols);

#endif
