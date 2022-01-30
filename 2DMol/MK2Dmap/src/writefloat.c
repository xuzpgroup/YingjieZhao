#include<stdio.h>
#include<stdlib.h>
#include<math.h>
//write float-type data
int writefloat(int low,int col,float *A,char c[])
{
   int i,j,k;

   FILE *fid;

   fid=fopen(c,"w+");
   if(fid==NULL)   {
      printf("Can't open this file\n");
      return 0;
   }

   for(i=0;i<low;i++)   {
      fprintf(fid,"%5d ",i);
      for(j=0;j<col;j++)   {
         fprintf(fid,"%9.4f ",A[i*col+j]);
      }
      fprintf(fid,"\n");
   }

   fclose(fid);
   return 1;
}
