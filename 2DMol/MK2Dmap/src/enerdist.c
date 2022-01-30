#include<stdio.h>
#include<stdlib.h>
#include<math.h>
//calculate energy distribution
int enerdist(float *arg,float *A,float *B,float *D,int flag)
{
   int i,j,k;
   int at,nbin,id,sum,nb;
   float Emin,Emax,dE,et,Et,E0,dE2;

   //parameters
   at=(int)(arg[3]);
   Emin=arg[4];
   Emax=arg[5];
   nbin=(int)(arg[6]);
   dE=(Emax-Emin)/nbin;
   dE2=dE*0.043/0.8621;  //eV/nm^2

   for(i=0;i<7000;i++)   D[i]=0.0;

   sum=0;Et=0.0;E0=0;
   for(i=0;i<at;i++)   {
      id=i+1;
      et=B[id*4+2]+B[id*4+3];
      E0=E0+et;
      //et=B[id*4+3];
      if(et<Emin||et>Emax)   continue;
      nb=floor((et-Emin)/dE);
      D[nb*7+1]=D[nb*7+1]+1.0;
      D[nb*7+4]=D[nb*7+4]+et;
      sum=sum+1;
      Et=Et+et;
      //printf("%5d %9.4f %9.4f\n",id,B[id*4+2],B[id*4+3]);
   }
   for(i=0;i<nbin;i++)   {
      D[i*7+0]=(Emin+i*dE+dE/2.0)*0.043/0.8621;//eV/nm^2
      D[i*7+2]=D[i*7+1]/sum/dE2;
      if(i!=0)   D[i*7+3]=D[(i-1)*7+3]+D[i*7+2]*dE2;
      if(i==0)   D[i*7+3]=D[i*7+2]*dE2;
      D[i*7+5]=D[i*7+4]/Et/dE2;
      if(i!=0)   D[i*7+6]=D[(i-1)*7+6]+D[i*7+5]*dE2;
      if(i==0)   D[i*7+6]=D[i*7+5]*dE2;
   }
   printf("%9.4f %9.4f %9.4f %5d\n",Emin,Emax,Et/E0,sum);

   return 1;
}
