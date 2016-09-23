/**************************************************************************
 Program:  Ncdb_sum_cl00.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/15
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create Cluster2000 summary file from NCDB tract summary file.
 
 Adapted from Ncdb_sum_all.sas

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb, local=n )

%Create_summary_from_tracts( 
  geo=cluster2000, 
  lib=ncdb,
  data_pre=Ncdb_sum, 
  data_label=%str(NCDB summary, DC),
  count_vars=agg: /****SHOULD CALCULATE AVERAGES avg:****/ Children: elderly: females: grossrent: males: num: 
    people: persons: pop: poverty: tot:, 
  prop_vars=median:, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  register=n,
  creator_process=Ncdb_sum_cl00.sas,
  restrictions=None,
  revisions=%str(New file.),
  mprint=y
)

