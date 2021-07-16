#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// generate a lookup table of the sine values
int main()
{
    int i;
    int index =0;
    float j[92];
    float sin_val;
    FILE *fp;

    if((fp=fopen("sindata.txt","w")) == NULL)
    {
        printf("File cannot be opened \n");
        exit(1);
    }
    //calculate the value of sine
    for(i=0 ; i<=90; i++)
        {
            sin_val = sin(M_PI*i/180.0); // convert before the input parameter in radians.
            j[i] = sin_val;
            printf("sin(%d) = %f\n",i,sin_val);
        }
    //format in 23 lines of 4 values and store in a file
    for(i=1 ; i<=23 ; i++)
        {
        fprintf(fp, "DCD\t");
        fprintf(fp, "%f,", j[index]);
        fprintf(fp, "%f,", j[index+1]);
        fprintf(fp, "%f,", j[index+2]);
        if (i != 23){ // Total number is 91 (22*4 + 3) so last line has only 3 values
            fprintf(fp, "%f", j[index+3]);
        }
        fprintf(fp, "\n");
        index+=4;
        }
    fclose(fp);
    return 0;
}
