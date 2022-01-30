#include<stdio.h>
#include<stdlib.h>
#include<math.h>
//calculate ridge distribution
//rg,SUM(lr),contact area(CA),nr,lr
int calridge(float *arg,float *A,float *B,float *C,int flag)
{
   int i,j,k;
   int at;
   float SL,CA,nr,lr,Emin;
   float rg,rc[10];

   //average potential of atoms in flat configurations
   at=(int)(arg[3]);
   Emin=arg[4];
   
   //radius of gyration
   for(i=0;i<3;i++)   rc[i]=0.0;
   for(i=1;i<at+1;i++)   {
      rc[0]=rc[0]+A[i*3+0];
      rc[1]=rc[1]+A[i*3+1];
      rc[2]=rc[2]+A[i*3+2];
   }
   for(i=0;i<3;i++)   rc[i]=rc[i]/at;
   rg=0.0;
   for(i=1;i<at+1;i++)   {
      for(j=0;j<3;j++)   rg=rg+(A[i*3+j]-rc[j])*(A[i*3+j]-rc[j]);
   }
   rg=sqrt(rg/at);
   C[flag*3+0]=rg;

   //ridges
   SL=0.0;
   for(i=1;i<at+1;i++)   {
      if(B[i*4+2]>Emin)   SL=SL+1.0;
   }
   SL=SL/at;
   CA=1.0-SL;
   C[flag*3+1]=SL;
   C[flag*3+2]=CA;

   printf("%5d %9.4f %9.4f %9.4f\n",flag,rg,SL,CA);
   return 1;
}
