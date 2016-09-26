/**************************************************************************
 Program:  NCDB_1990_summary_all.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/26/2016
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Main macro for generating all NCBD 1990 summary files.

**************************************************************************/

%macro NCDB_1990_summary_all( 

  /** State abbreviation. Ex: DC **/
  state_ab = DC,
  
  finalize = Y,
  revisions = New file.

  );


  %global _state_ab _out_lib _finalize _revisions;

  %** Program parameters **;

  %let _state_ab   = %lowcase(&state_ab);
  %let _finalize = &finalize;
  %let _revisions = &revisions;


  %** Check if OK to run finalized data sets **;

  %if %mparam_is_yes( &_finalize ) and not &_remote_batch_submit %then %do;
    %warn_mput( macro=NCDB_1990_summary_all, msg=%str(Not a remote batch submit session. Finalize will be set to N.) )
    %let _finalize = N;
  %end;

  %if %mparam_is_yes( &_finalize ) %then %do;
    %let _out_lib = DCOLA;
  %end;
  %else %do;
    %let _out_lib = WORK;
  %end;
  

  **** Create summary files from census tract source ****;

  %NCDB_1990_summary_geo_source( tr90 )


%mend NCDB_1990_summary_all;

