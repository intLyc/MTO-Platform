% SOM Toolbox
% Version 2.0beta, May 30 2002
% 
% Copyright 1997-2000 by
% Esa Alhoniemi, Johan Himberg, Juha Parhankangas and Juha Vesanto
% Contributed files may contain copyrights of their own.
% 
% SOM Toolbox comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package. This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.
% 
% 
% Demos
% 
%            som_demo1   SOM Toolbox demo 1: basic properties
%            som_demo2   SOM Toolbox demo 2: basic usage
%            som_demo3   SOM Toolbox demo 3: visualization
%            som_demo4   SOM Toolbox demo 4: data analysis
% 
% Creation of structs
% 
%              som_set   create & set (& check) values to structs
%             som_info   print out information on a given struct  
%      som_data_struct   create & initialize a data struct 
%       som_map_struct   create & initialize a map struct 
%     som_topol_struct   create & initialize a topology struct 
%     som_train_struct   create & initialize a train struct 
%         som_clstruct   create a cluster struct
%            som_clset   set properties in a cluster struct
%            som_clget   get stuff from a cluster struct
% 
% Struct conversion and file I/O
% 
%           som_vs1to2   converts a version 1.0 struct to version 2.0 struct
%           som_vs2to1   converts a version 2.0 struct to version 1.0 struct
%        som_read_data   reads a (SOM_PAK format) ASCII data file
%       som_write_data   writes a SOM_PAK format codebook file
%        som_write_cod   writes a SOM_PAK format data file
%         som_read_cod   reads a SOM_PAK format codebook file
% 
% Data preprocessing
% 
%        som_normalize   normalize data set
%      som_denormalize   denormalize data set 
%    som_norm_variable   (de)normalize one variable
%           preprocess   preprocessing GUI
% 
% Initialization and training functions
% 
%             som_make   create, initialize and train a SOM
%         som_randinit   random initialization algorithm
%          som_lininit   linear initialization algorithm
%         som_seqtrain   sequential training algorithm
%       som_batchtrain   batch training algorithm
%              som_gui   SOM initialization and training GUI
%       som_prototrain   a simple version of sequential training: easy to modify
% 
% Clustering algorithms
% 
%           som_kmeans   k-means algorithm (was earlier kmeans)
%      kmeans_clusters   try and evaluate several k-means clusterings
%           neural_gas   neural gas vector quantization algorithm
%          som_linkage   hierarchical clustering algorithms
%        som_cllinkage   hierarchical clustering of SOM
%       som_dmatminima   local minima from distance (or U-) matrix
%     som_dmatclusters   distance (or U-) matrix based clustering
%         som_clspread   spreads clusters to unassinged map units
%           som_cldist   calculate distances between clusters
%         som_gapindex   gap validity index of clustering
%             db_index   Davies-Bouldin validity index of clustering  
% 
% Supervised/classification algorithms
% 
%       som_supervised   supervised SOM algorithm
%                 lvq1   LVQ1 algorithm
%                 lvq3   LVQ3 algorithm
%                  knn   k-NN classification algorithm 
%              knn_old   k-NN classification algorithm (old version)
% 
% SOM error measures
% 
%          som_quality   quantization and topographic error of SOM
%       som_distortion   SOM distortion measure
%      som_distortion3   elements of the SOM distortion measure
% 
% Auxiliary functions
% 
%             som_bmus   calculates BMUs for given data vectors
%         som_eucdist2   pairwise squared euclidian distances between vectors
%            som_mdist   calculates pairwise distances between vectors 
%           som_divide   extract subsets of data based on map
%            som_label   give labels to map units
%        som_label2num   rcodes string data labels to interger class labels 
%        som_autolabel   automatically labels the SOM based on given data
%      som_unit_coords   calculates coordinates in output space for map units
%       som_unit_dists   distances in output space between map units
%      som_unit_neighs   units in 1-neighborhood for each map unit
%     som_neighborhood   calculates neighborhood matrix for the given map
%        som_neighbors   calculates different kinds of neighborhoods 
%           som_neighf   calculates neighborhood function values
%           som_select   GUI for manual selection of map units
%     som_estimate_gmm   create Gaussian mixture model on top of SOM
%  som_probability_gmm   evaluate Gaussian mixture model
%          som_ind2sub   from linear index to subscript index 
%          som_sub2ind   from subscript index to linear index
%          som_ind2cod   from linear index to SOM_PAK linear index 
%          som_cod2ind   from SOM_linear index to SOM_PAK linear index 
%             nanstats   mean, std and median which ignore NaNs
%   som_modify_dataset   add, remove, or extract samples and components
%         som_fillnans   fill NaNs in a data set based on given SOM
%            som_stats   statistics of a data set
%           som_drmake   calculate descriptive rules for a cluster
%           som_dreval   evaluate descriptive rules for a cluster
%         som_drsignif   rule significance measures
% 
% Using SOM_PAK from Matlab
% 
%      som_sompaktrain   uses SOM_PAK to train a map
%           sompak_gui   GUI for using SOM_PAK from Matlab
%          sompak_init   call SOM_PAK's initialization programs from Matlab
%      sompak_init_gui   GUI for using SOM_PAK's initialization from Matlab
%    sompak_rb_control   an auxiliary function for sompak_*_gui functions.
%        sompak_sammon   call SOM_PAK's Sammon program from Matlab
%    sompak_sammon_gui   GUI for using SOM_PAK's Sammon program from Matlab
%         sompak_train   call SOM_PAK's training program from Matlab
%     sompak_train_gui   GUI for using SOM_PAK's training program from Matlab 
% 
% Visualization
% 
%             som_show   basic visualization
%         som_show_add   add labels, hits and trajectories
%       som_show_clear   remove extra markers
%       som_recolorbar   refresh/reconfigure colorbars
%         som_show_gui   GUI for using som_show and associated functions
%             som_grid   visualization of SOM grid
%           som_cplane   component planes and U-matrices
%         som_barplane   bar chart visualization of map
%         som_pieplane   pie chart visualization of map
%        som_plotplane   plot chart visualization of map
%       som_trajectory   launches a GUI for presenting comet-trajectories 
%       som_dendrogram   visualization of clustering tree
%       som_plotmatrix   pairwise scatter plots and histograms
%    som_order_cplanes   order and visualize the component planes
%           som_clplot   plots of clusters (based on cluster struct)
% som_projections_plot   projections plots (see som_projections)
%       som_stats_plot   plots of statistics (see som_stats)
% 
% Auxiliary functions for visualization
% 
%                 hits   calculates hits, or sum of values for each map unit
%             som_hits   calculates the response of data on the map
%             som_umat   calculates the U-matrix
%                  cca   curvilinear component analysis projection algorithm
%              pcaproj   principal component projection algorithm
%               sammon   Sammon's mapping projection algorithm
%       som_connection   connection matrix for map 
%       som_vis_coords   map unit coordinates used in visualizations
%        som_colorcode   create color coding for map/2D data
%         som_bmucolor   colors of the BMUs from a given map color code
%        som_normcolor   simulate indexed colormap
%     som_clustercolor   color coding which depends on clustering structure
%      som_kmeanscolor   color coding according to k-means clustering
%     som_kmeanscolor2   a newer version of the som_kmeanscolor function
%       som_fuzzycolor   a fuzzy color coding 
%         som_coloring   a SOM-based color coding 
%      som_projections   calculates a default set of projections
% 
% Report generation stuff
% 
%     som_table_struct   creates a table struct
%     som_table_modify   modifies a table struct
%      som_table_print   print a table in various formats
%            rep_utils   various utilities for printing report elements
%      som_stats_table   a table of data set statistics
%     som_stats_report   report on data set statistics
% 
% Low level routines used by visualization functions
% 
%            vis_patch   defines hexagonal and rectangular patches
%    vis_som_show_data   returns UserData and subplot handles stored by som_show.m
%        vis_valuetype   used for type checks 
%         vis_footnote   adds a movable text to the current figure 
%          vis_trajgui   the actual GUI started by som_trajectory.m 
% vis_PlaneAxisProperties   set axis properties in visualization functions
% vis_footnoteButtonDownFcn   callback function for vis_footnote.m
%     vis_planeGetArgs   converts topol struct to lattice, msize argument pair
%    vis_show_gui_comp   internal function used by som_show_gui.m
%    vis_show_gui_tool   internal function used by som_show_gui.m
% 
% Other
% 
%           somtoolbox   this file
%            iris.data   IRIS data set (used in demos)
%          License.txt   GNU General Public License 
%        Copyright.txt   Copyright notice
