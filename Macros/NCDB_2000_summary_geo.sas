/**************************************************************************
 Program:  NCDB_2000_summary_geo.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/26/2016
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Macro to create NCBD_2000 summary files for a specified
 geography.

**************************************************************************/

%macro NCDB_2000_summary_geo( geo, source_geo );

  %local geo_name geo_wt_file geo_var geo_suffix geo_label count_vars moe_vars
         out_ds;

  %let geo_name = %upcase( &geo );
  %let geo_wt_file = %sysfunc( putc( &geo_name, &source_geo_wt_file_fmt ) );;
  %let geo_var = %sysfunc( putc( &geo_name, $geoval. ) );
  %let geo_suffix = %sysfunc( putc( &geo_name, $geosuf. ) );
  %let geo_label = %sysfunc( putc( &geo_name, $geodlbl. ) );
  
  %let out_ds = NCDB_2000_&state_ab._sum&source_geo_suffix.&geo_suffix;

  
    %** Count variables for tract data **;
  
    %let count_vars = 
            Pop25andOverWoutHS_2000 Pop25andOverWoutHSB_2000
			Pop25andOverWoutHSW_2000 Pop25andOverWoutHSH_2000
			Pop25andOverWoutHSAIOM_2000

			Pop25andOverWHS_2000 Pop25andOverWHSB_2000
			Pop25andOverWHSW_2000 Pop25andOverWHSH_2000
			Pop25andOverWHSAIOM_2000

			Pop25andOverWSC_2000 Pop25andOverWSCB_2000
			Pop25andOverWSCW_2000 Pop25andOverWSCH_2000
			Pop25andOverWSCAIOM_2000

			PopUnemployed_2000 PopUnemployedW_2000
			PopUnemployedB_2000 PopUnemployedH_2000
			PopUnemployedAIOM_2000

			PopInCivLaborForce_2000 PopInCivLaborForceW_2000
			PopInCivLaborForceB_2000 PopInCivLaborForceH_2000
			PopInCivLaborForceAIOM_2000

			PopUnder18Years_2000 PopUnder18YearsB_2000
			PopUnder18YearsW_2000 PopUnder18YearsH_2000
			PopUnder18YearsAIOM_2000

			Pop18_24Years_2000 Pop18_24YearsB_2000
			Pop18_24YearsW_2000 Pop18_24YearsH_2000
			Pop18_24YearsAIOM_2000

			Pop25_64Years_2000 Pop25_64YearsB_2000
			Pop25_64YearsW_2000 Pop25_64YearsH_2000
			Pop25_64YearsAIOM_2000

			Pop65andOverYears_2000 Pop65andOverYearsB_2000
			Pop65andOverYearsW_2000 Pop65andOverYearsH_2000
			Pop65andOverYearsAIOM_2000

			AggHshldIncome_2000 AggHshldIncomeB_2000
			AggHshldIncomeW_2000 AggHshldIncomeH_2000
			AggHshldIncomeAIOM_2000

			NumHshlds_2000 NumHshldsB_2000
			NumHshldsW_2000 NumHshldsH_2000
			NumHshldsAIOM_2000
			;
                          
  %end;
  
  %put _local_;
  
  %if ( &geo_name = GEO2000 and %upcase( &source_geo_var ) = GEO2000 ) %then %do;

    ** Census tracts from census tract source (same year): just recopy selected vars **;
    
    data &_out_lib..&out_ds (label="NCDB summary, 2000, %upcase(&_state_ab), &source_geo_label source, &geo_label");
    
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
      out_ds_label=%str(NCDB summary, 2000, %upcase(&_state_ab), &source_geo_label source, &geo_label),
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
      creator_process=NCDB_2000_&state_ab._sum_all.sas,
      restrictions=None,
      revisions=%str(&_revisions)
    )

  %end;



%mend NCDB_2000_summary_geo;


