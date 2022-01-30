The FeatureExtraction directory includes:
The code of pHash and PCA algorithm;
The Scripts to calculate SASA, Rg, and LF.

The MDscripts directory includes:
The input files of different constraints and surface interaction;
The data files of various size.

The BatchMD directory includes:
The C# code to generate directories and input files with different parameters;
The bash script to submit MD tasks in batches.

The MK2Dmap directory includes:
The bash script to copy the relax.dump file (generated from MD simulations), call the main.py file, and generate the Edis.vel file in batches;
The tcl script to color the atoms according to the energy values in the Edis.vel file;
The C code in src directory to compiled as shared library 'libread.so'.

The MKPointSet directory includes:
The bash script to copy the relax.dump file (generated from MD simulations) in batches;
The C# code to convert relax.dump to PointSet (txt type flies).

The MKXYZ directory includes:
The bash script to copy the xyz file (generated from MD simulations) in batches;
The C# code to cut the xyz file in the specific frame, and the xyz files are used to calculate SASA and Rg in VMD.

The UnsupervisedLearning directory includes:
The code of K-means algorithm;
The label results for different models.

The G_model, G+T_model, 2features+3D_model, 3features+3D_model directories,
and G+T+P_model.py, G+P_model.py,2features+2D_model.py, 3features+2D_model.py files
are the code of different statistical learning models.

The Metrics directory includes:
The evaluation results of different models.
