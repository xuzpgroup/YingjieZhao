#include<stdio.h>
#include<stdlib.h>
#include<math.h>
float A[500000],B[500000],C[10000],D[10000];
//read relax.dump data
int readdata(float *arg,char c[])
{
   int i,j,k;
   int ns,np,in,at,id,nbin,flag,hflag;
   char str[100];
   float box[10],r[10];
   FILE *fid;
   int calridge(float *arg,float *A,float *B,float *C,int flag);      
   int enerdist(float *arg,float *A,float *B,float *D,int flag);
   int highlight(float *arg,float *A,float *B,float *D,int flag);
   int writefloat(int low,int col,float *A,char c[]);

   //parameters
   ns=(int)(arg[0]);
   np=(int)(arg[1]);
   in=(int)(arg[2]);
   nbin=(int)(arg[6]);
   hflag=(int)(arg[10]);

   fid=fopen(c,"r");
   if(fid==NULL)   {
      printf("Can't open this file\n");
      return 0;
   }

   //read dump data
   for(i=0;i<3;i++)   fgets(str,100,fid);
   fscanf(fid,"%d\n",&at); 
   arg[3]=at;  
   printf("%5d\n",at);
   fgets(str,100,fid);
   for(i=0;i<3;i++)   fscanf(fid,"%f %f\n",&box[i*2+0],&box[i*2+1]);
   fgets(str,100,fid);
   rewind(fid);

   for(i=0;i<(ns-1)*(9+at);i++)   fgets(str,100,fid);
  
   flag=0;
   for(i=0;i<=np-ns;i=i+in)   {
      for(j=0;j<9;j++)   fgets(str,100,fid);
     
      for(j=0;j<at;j++)   {
         fscanf(fid,"%d %f %f %f %f %f %f %f\n",&id,&r[0],&r[1],&r[2],&r[3],&r[4],&r[5],&r[6]);
         for(k=0;k<3;k++)   A[id*3+k]=r[k];
         for(k=0;k<4;k++)   B[id*4+k]=r[k+3];
      }
          
      //calculate ridge distribution:rg,SUM(lr),contact area,nr,lr
      calridge(arg,A,B,C,flag);      
      enerdist(arg,A,B,D,flag);
      if(hflag==1)   highlight(arg,A,B,D,flag);

      flag=flag+1;
      for(j=0;j<(in-1)*(9+at);j++)   fgets(str,100,fid);
   }
 
   writefloat(flag,3,C,"ridge.dat");
   writefloat(nbin,7,D,"Edis.dat");

   fclose(fid);
   return 1;
}
