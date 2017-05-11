#include "data_access_helper.h"

float *make_matrix_c(int n_rows, int n_cols)
{
    float *arr = (float *)malloc(n_rows * n_cols * sizeof(float));

    int i, j, count = 0;
    for (i = 0; i <  n_rows; i++)
    {
        for (j = 0; j < n_cols; j++)
        {
            *(arr + i * n_cols + j) = ++count;
        }
    }

    return arr;
}
