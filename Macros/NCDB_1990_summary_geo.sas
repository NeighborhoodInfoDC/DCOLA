/**************************************************************************
 Program:  NCDB_1990_summary_geo.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/26/2016
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Macro to create NCBD_1990 summary files for a specified
 geography.

**************************************************************************/

%macro NCDB_1990_summary_geo( geo, source_geo );

  %local geo_name geo_wt_file geo_var geo_suffix geo_label count_vars moe_vars
         out_ds;

  %let geo_name = %upcase( &geo );
  %let geo_wt_file = %sysfunc( putc( &geo_name, &source_geo_wt_file_fmt ) );;
  %let geo_var = %sysfunc( putc( &geo_name, $geoval. ) );
  %let geo_suffix = %sysfunc( putc( &geo_name, $geosuf. ) );
  %let geo_label = %sysfunc( putc( &geo_name, $geodlbl. ) );
  
  %let out_ds = NCDB_&_years._&state_ab._sum&source_geo_suffix.&geo_suffix;

  
    %** Count variables for tract data **;
  
    %let count_vars = 

			PopWithRace: PopBlackNonHispBridge:
	        PopWhiteNonHispBridge: PopHisp: PopAsianPINonHispBridge:
	        PopOtherRaceNonHispBridge:
            Pop25andOver: Pop25andOverWoutHS: Pop25andOverWHS: Pop25andOverWSC: 
			PopUnemployed: PopInCivLaborForce: 
			PopUnder18Years: Pop18_24Years: Pop25_64Years:
			Pop65andOverYears: AggHshldIncome: NumHshlds:
			;
                            
  %put _local_;
  
  %if ( &geo_name = GEO1990 and %upcase( &source_geo_var ) = GEO1990 ) %then %do;

    ** Census tracts from census tract source (same year): just recopy selected vars **;
    
    data &_out_lib..&out_ds (label="NCDB summary, &_years_dash, %upcase(&_state_ab), &source_geo_label source, &geo_label");
    
      set &source_ds_work (keep=&geo_var &count_vars);

    run;

  %end;
  %else %do;
  
    ** Transform data from source geography (&source_geo_var) to target geography (&geo_var) **;
    
    %Transform_geo_data(
      dat_ds_name=&source_ds_work,
      dat_org_geo=&source_geo_var,
      dat_count_vars=&count_vars,
      dat_count_moe_vars=,
      dat_prop_vars=,
      wgt_ds_name=General.&geo_wt_file,
      wgt_org_geo=&source_geo_var,
      wgt_new_geo=&geo_var,
      wgt_id_vars=,
      wgt_wgt_var=popwt,
      out_ds_name=&_out_lib..&out_ds,
      out_ds_label=%str(NCDB summary, &_years_dash, %upcase(&_state_ab), &source_geo_label source, &geo_label),
      calc_vars=,
      calc_vars_labels=,
      keep_nonmatch=N,
      show_warnings=10,
      print_diag=Y,
      full_diag=N
    )
    
  %end;  


  ** Add sortedby= to data set descriptor **;

  proc datasets library=&_out_lib memtype=(data) nolist;
    modify &out_ds (sortedby=&geo_var);
  quit;


  %File_info( data=&_out_lib..&out_ds, printobs=0 )

  
  %if %mparam_is_yes( &_finalize ) %then %do;
  
    ** Register metadata **;
    
    %Dc_update_meta_file(
      ds_lib=&_out_lib,
      ds_name=&out_ds,
      creator_process=NCDB_&_years._&state_ab._sum_all.sas,
      restrictions=None,
      revisions=%str(&_revisions)
    )

  %end;



%mend NCDB_1990_summary_geo;


