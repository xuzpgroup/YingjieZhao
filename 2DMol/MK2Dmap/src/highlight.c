#include<stdio.h>
#include<stdlib.h>
#include<math.h>
//highlight the energy distribution
int highlight(float *arg,float *A,float *B,float *D,int flag)
{
   int i,j,k;
   int at,nbin,id,sum,nb,nx,ny,ix,iy;
   float Emin,Emax,dE,et,evdw,bl,hl,r[3];
   FILE *fid1,*fid2;

   //parameters
   at=(int)(arg[3]);
   Emin=arg[4];
   Emax=arg[5];
   nbin=(int)(arg[6]);
   dE=(Emax-Emin)/nbin;
   nx=(int)(arg[7]);
   ny=(int)(arg[8]);
   bl=(int)(arg[9]);
   hl=bl*0.866;

   //XYZ file and loading data
   fid1=fopen("Edis.xyz","w+");
   fid2=fopen("Edis.vel","w+");
   if(fid1==NULL||fid2==NULL)   {
      printf("Can't open this file\n");
      return 0;
   }

   //search for specific region
   for(i=0;i<nbin;i++)   {
      fprintf(fid1,"%5d\n",at);
      fprintf(fid1,"Atoms. Timestep %5d\n",i);
      fprintf(fid2,"%5d\n",at);
      fprintf(fid2,"Atoms. Timestep %5d\n",i);
      for(j=0;j<at;j++)   {
         id=j+1;
         et=B[id*4+2]+B[id*4+3];
         evdw=B[id*4+1]-et;
         ix=j%nx;
         iy=j/nx;
         r[0]=ix*bl+iy%2*bl/2.0;
         r[1]=iy*hl;
         r[2]=0.0;

         /*/non-ridge region
         if(et<Emin)   { 
            fprintf(fid1,"C1 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,0.0,et,B[id*4+2],B[id*4+3],evdw);
            continue;
         }
         nb=floor((et-Emin)/dE);
         //highlight region
         if(nb<i)   { 
            fprintf(fid1,"C2 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,1.0,et,B[id*4+2],B[id*4+3],evdw);
            continue;
         }
         else   { 
            fprintf(fid1,"C3 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,2.0,et,B[id*4+2],B[id*4+3],evdw);
            continue; 
         }*/

         //evdw<-12 eV/nm^2
         if(evdw<-12.0)   { 
            fprintf(fid1,"C1 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,0.0,et,B[id*4+2],B[id*4+3],evdw);
            continue;
         }

         //-12<evdw<-9 eV/nm^2
         if(evdw>=-12.0&&evdw<-9.0)   { 
            fprintf(fid1,"C2 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,1.0,et,B[id*4+2],B[id*4+3],evdw);
            continue;
         }

         //-9.0<evdw<-6.0 eV/nm^2
         if(evdw>=-9.0&&evdw<-6.0)   { 
            fprintf(fid1,"C3 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,2.0,et,B[id*4+2],B[id*4+3],evdw);
            continue; 
         }

         //evdw>=-6.0 eV/nm^2
         if(evdw>=-6.0)   { 
            fprintf(fid1,"C4 %9.4f %9.4f %9.4f\n",r[0],r[1],r[2]);
            fprintf(fid2,"%5d %9.4f %9.4f %9.4f %9.4f %9.4f\n",id,3.0,et,B[id*4+2],B[id*4+3],evdw);
            continue; 
         }

      }
   }

   fclose(fid1);
   fclose(fid2);
   return 1;
}
