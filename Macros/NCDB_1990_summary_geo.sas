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
  
  %let out_ds = NCDB_1990_&state_ab._sum&source_geo_suffix.&geo_suffix;

  
    %** Count variables for tract data **;
  
    %let count_vars = 
            Pop25andOverWoutHS_1990 Pop25andOverWoutHSB_1990
			Pop25andOverWoutHSW_1990 Pop25andOverWoutHSH_1990
			Pop25andOverWoutHSAIOM_1990

			Pop25andOverWHS_1990 Pop25andOverWHSB_1990
			Pop25andOverWHSW_1990 Pop25andOverWHSH_1990
			Pop25andOverWHSAIOM_1990

			Pop25andOverWSC_1990 Pop25andOverWSCB_1990
			Pop25andOverWSCW_1990 Pop25andOverWSCH_1990
			Pop25andOverWSCAIOM_1990

			PopUnemployed_1990 PopUnemployedW_1990
			PopUnemployedB_1990 PopUnemployedH_1990
			PopUnemployedAIOM_1990

			PopInCivLaborForce_1990 PopInCivLaborForceW_1990
			PopInCivLaborForceB_1990 PopInCivLaborForceH_1990
			PopInCivLaborForceAIOM_1990

			PopUnder18Years_1990 PopUnder18YearsB_1990
			PopUnder18YearsW_1990 PopUnder18YearsH_1990
			PopUnder18YearsAIOM_1990

			Pop18_24Years_1990 Pop18_24YearsB_1990
			Pop18_24YearsW_1990 Pop18_24YearsH_1990
			Pop18_24YearsAIOM_1990

			Pop25_64Years_1990 Pop25_64YearsB_1990
			Pop25_64YearsW_1990 Pop25_64YearsH_1990
			Pop25_64YearsAIOM_1990

			Pop65andOverYears_1990 Pop65andOverYearsB_1990
			Pop65andOverYearsW_1990 Pop65andOverYearsH_1990
			Pop65andOverYearsAIOM_1990

			AggHshldIncome_1990 AggHshldIncomeB_1990
			AggHshldIncomeW_1990 AggHshldIncomeH_1990
			AggHshldIncomeAIOM_1990

			NumHshlds_1990 NumHshldsB_1990
			NumHshldsW_1990 NumHshldsH_1990
			NumHshldsAIOM_1990
			;
                          
  %end;
  
  %put _local_;
  
  %if ( &geo_name = GEO1990 and %upcase( &source_geo_var ) = GEO1990 ) %then %do;

    ** Census tracts from census tract source (same year): just recopy selected vars **;
    
    data &_out_lib..&out_ds (label="NCDB summary, 1990, %upcase(&_state_ab), &source_geo_label source, &geo_label");
    
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
      out_ds_label=%str(NCDB summary, 1990, %upcase(&_state_ab), &source_geo_label source, &geo_label),
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
      creator_process=NCDB_1990_&state_ab._sum_all.sas,
      restrictions=None,
      revisions=%str(&_revisions)
    )

  %end;



%mend NCDB_1990_summary_geo;


