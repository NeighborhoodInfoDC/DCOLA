/**************************************************************************
 Program:  DCOLA_ACS_summary_geo.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/04/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Macro to create ACS summary files for a specified
 geography.

 Modifications: SD 8/22/2016 - Adapted for State of Latinos study. 
**************************************************************************/

%macro DCOLA_ACS_summary_geo( geo, source_geo );

  %local geo_name geo_wt_file geo_var geo_suffix geo_label count_vars moe_vars
         out_ds;

  %let geo_name = %upcase( &geo );
  %let geo_wt_file = %sysfunc( putc( &geo_name, &source_geo_wt_file_fmt ) );;
  %let geo_var = %sysfunc( putc( &geo_name, $geoval. ) );
  %let geo_suffix = %sysfunc( putc( &geo_name, $geosuf. ) );
  %let geo_label = %sysfunc( putc( &geo_name, $geodlbl. ) );
  
  %let out_ds = ACS_&_years._&state_ab._sum&source_geo_suffix.&geo_suffix;

  %if %upcase( &source_geo ) = BG00 or %upcase( &source_geo ) = BG10 %then %do;
  
    %** Count and MOE variables for block group data **;

    %let count_vars = 
           Unwtd: PopAlone:
           PopWithRace: PopBlack: PopWhite: PopHisp: PopAsian: PopOther: PopMulti: PopEmployed: 
		   NumOccupied: NumOwner: Med:

		   NumFamilies_:

		   PopUnder18Years_:
		   Pop18_34Years_: Pop35_64Years_:
		   Pop65andOverYears_:

		   Pop25andOverYears_: Pop25andOverWoutHS_: Pop25andOverWHS_:
		   Pop25andOverWSC_: Pop25andOverWCollege_:
		   ;
           
    %let moe_vars =
		   mPopUnder18Years_&_years. mPop18_34Years_&_years.
		   mPop35_64Years_&_years. mPop65andOverYears_&_years.

		   mNumHshlds_&_years. mNumFamilies_&_years.

           mPopWithRace_&_years. mPopBlackNonHispBridge_&_years.
           mPopWhiteNonHispBridge_&_years. mPopAsianPINonHispBridge_&_years. 
		   mPopHisp_&_years. mPopNativeAmNonHispBr_&_years.
           mPopOtherNonHispBridge_&_years. mPopMultiracialNonHisp_&_years.
           mPopOtherRaceNonHispBr_&_years. 

		   mPopAloneB_&_years. mPopAloneW_&_years.
		   mPopAloneH_&_years. mPopAloneA_&_years.
		   mPopAloneI_&_years. mPopAloneO_&_years.
		   mPopAloneM_&_years. mPopAloneIOM_&_years.
		   mPopAloneAIOM_&_years.

		   mPopEmployedByOcc_&_years. mPopEmployedMngmt_&_years.
		   mPopEmployedServ_&_years. mPopEmployedSales_&_years.
		   mPopEmployedNatRes_&_years. mPopEmployedProd_&_years.

		   mPopEmployedByOccB_&_years. mPopEmployedMngmtB_&_years.
		   mPopEmployedServB_&_years. mPopEmployedSalesB_&_years.
		   mPopEmployedNatResB_&_years. mPopEmployedProdB_&_years.

	   	   mPopEmployedByOccW_&_years. mPopEmployedMngmtW_&_years.
		   mPopEmployedServW_&_years. mPopEmployedSalesW_&_years.
		   mPopEmployedNatResW_&_years. mPopEmployedProdW_&_years.

		   mPopEmployedByOccH_&_years. mPopEmployedMngmtH_&_years.
		   mPopEmployedServH_&_years. mPopEmployedSalesH_&_years.
		   mPopEmployedNatResH_&_years. mPopEmployedProdH_&_years.

		   mPopEmployedByOccA_&_years. mPopEmployedMngmtA_&_years.
		   mPopEmployedServA_&_years. mPopEmployedSalesA_&_years.
		   mPopEmployedNatResA_&_years. mPopEmployedProdA_&_years.

		   mPopEmployedByOccIOM_&_years. mPopEmployedMngmtIOM_&_years.
		   mPopEmployedServIOM_&_years. mPopEmployedSalesIOM_&_years.
		   mPopEmployedNatResIOM_&_years. mPopEmployedProdIOM_&_years.

		   mPopEmployedByOccAIOM_&_years. mPopEmployedMngmtAIOM_&_years.
		   mPopEmployedServAIOM_&_years. mPopEmployedSalesAIOM_&_years.
		   mPopEmployedNatResAIOM_&_years. mPopEmployedProdAIOM_&_years.

           mPop25andOverWoutHS_&_years. mPop25andOverWHS_&_years. 
		   mPop25andOverWSC_&_years. mPop25andOverWCollege_&_years.

		   mMedFamIncm_&_years. mMedFamIncmB_&_years.
		   mMedFamIncmW_&_years. mMedFamIncmH_&_years.
		   mMedFamIncmA_&_years. mMedFamIncmIOM_&_years.
		   mMedFamIncmAIOM_&_years.

		   mNumOccupiedHsgUnits_&_years. mNumOccupiedHsgUnitsB_&_years.
		   mNumOccupiedHsgUnitsW_&_years. mNumOccupiedHsgUnitsH_&_years.
		   mNumOccupiedHsgUnitsA_&_years. mNumOccupiedHsgUnitsIOM_&_years.
		   mNumOccupiedHsgUnitsAIOM_&_years.

           mNumOwnerOccupiedHU_&_years. mNumOwnerOccupiedHUB_&_years.
		   mNumOwnerOccupiedHUW_&_years. mNumOwnerOccupiedHUH_&_years.
		   mNumOwnerOccupiedHUA_&_years. mNumOwnerOccupiedHUIOM_&_years.
		   mNumOwnerOccupiedHUAIOM_&_years.
           ;
               
  %end;
  %else %do;
  
    %** Count and MOE variables for tract data **;
  
    %let count_vars = 
           Pop18: Pop35: Pop65: PopForeignBorn: PopNativeBorn: PopCitizen: PopNaturalized: PopNonCitizen:
		   PopOnly: PopSpan: PopEng: PopNo: PopOther:
		   PopAlone: PopWithRace: PopBlack: PopWhite: PopHisp: PopAsian: PopNative: PopNonEnglish: PopOther: PopMulti: 
           PopInCivLaborForce: PopCivilian: PopUnemployed: 
           Elderly: Num: Med:;
           
    %let moe_vars =
		   mNumHshlds_&_years. mNumHshldsH_&_years.

		   mNumFamilies_&_years. mNumFamiliesH_&_years.

		   mPopUnder18Years_&_years. mPopUnder18YearsH_&_years.
	
		   mPop18_34Years_&_years. mPop18_34YearsH_&_years.

		   mPop35_64Years_&_years. mPop35_64YearsH_&_years.

		   mPop65andOverYears_&_years. mPop65andOverYearsH_&_years.

		   mPopNativeBorn_&_years. mPopNativeBornH_&_years.
		   mPopForeignBorn_&_years. mPopForeignBornH_&_years.
		   mPopNonEnglish_&_years.
		   mPopCitizenH_&_years. mPopNaturalizedH_&_years. mPopNonCitizenH_&_years. 

		   mPopOnlyEnglishH_&_years. mPopSpanishH_&_years.
		   mPopEngVeryWellH_&_years. mPopEngWellH_&_years.
		   mPopEngNotWellH_&_years. mPopNoEnglishH_&_years.
		   mPopEngLessThanVeryWellH_&_years. mPopOtherLangH_&_years.

           mPopWithRace_&_years. mPopBlackNonHispBridge_&_years.
           mPopWhiteNonHispBridge_&_years. mPopAsianPINonHispBridge_&_years. 
		   mPopHisp_&_years. mPopNativeAmNonHispBr_&_years.
           mPopOtherNonHispBridge_&_years. mPopMultiracialNonHisp_&_years.
           mPopOtherRaceNonHispBr_&_years. 

		   mPopAloneB_&_years. mPopAloneW_&_years.
		   mPopAloneH_&_years. mPopAloneA_&_years.
		   mPopAloneI_&_years. mPopAloneO_&_years.
		   mPopAloneM_&_years. mPopAloneIOM_&_years.
		   mPopAloneAIOM_&_years.

		   mPopHispMexican_&_years. mPopHispPuertoRican_&_years.
		   mPopHispCuban_&_years. mPopHispDominican_&_years.
		   mPopHispOtherCentAmer_&_years. mPopHispOtherSouthAmer_&_years. 
		   mPopHispOtherHispOrig_&_years. mPopHispArgentinean_&_years. 
		   mPopHispBolivian_&_years. mPopHispChilean_&_years. 
		   mPopHispColombian_&_years. mPopHispCostaRican_&_years.
		   mPopHispEcuadorian_&_years. mPopHispElSalvadoran_&_years. 
		   mPopHispGuatemalan_&_years. mPopHispHonduran_&_years. 
		   mPopHispNicaraguan_&_years. mPopHispPananamian_&_years. 
		   mPopHispPeruvian_&_years. 

		   mPopCivilianEmployed_&_years. mPopCivilianEmployedB_&_years.
		   mPopCivilianEmployedW_&_years. mPopCivilianEmployedH_&_years.
		   mPopCivilianEmployedA_&_years. mPopCivilianEmployedIOM_&_years.
		   mPopCivilianEmployedAIOM_&_years.

           mPopUnemployed_&_years. mPopUnemployedB_&_years.
		   mPopUnemployedW_&_years. mPopUnemployedH_&_years.
		   mPopUnemployedA_&_years. mPopUnemployedIOM_&_years.
		   mPopUnemployedAIOM_&_years.

		   mPopInCivLaborForce_&_years. mPopInCivLaborForceB_&_years.
		   mPopInCivLaborForceW_&_years. mPopInCivLaborForceH_&_years.
		   mPopInCivLaborForceA_&_years. mPopInCivLaborForceIOM_&_years.
		   mPopInCivLaborForceAIOM_&_years.

		   /*mPopEmployedByOcc_&_years. mPopEmployedMngmt_&_years.
		   mPopEmployedServ_&_years. mPopEmployedSales_&_years.
		   mPopEmployedNatRes_&_years. mPopEmployedProd_&_years.

		   mPopEmployedByOccB_&_years. mPopEmployedMngmtB_&_years.
		   mPopEmployedServB_&_years. mPopEmployedSalesB_&_years.
		   mPopEmployedNatResB_&_years. mPopEmployedProdB_&_years.

	   	   mPopEmployedByOccW_&_years. mPopEmployedMngmtW_&_years.
		   mPopEmployedServW_&_years. mPopEmployedSalesW_&_years.
		   mPopEmployedNatResW_&_years. mPopEmployedProdW_&_years.

		   mPopEmployedByOccH_&_years. mPopEmployedMngmtH_&_years.
		   mPopEmployedServH_&_years. mPopEmployedSalesH_&_years.
		   mPopEmployedNatResH_&_years. mPopEmployedProdH_&_years.

		   mPopEmployedByOccA_&_years. mPopEmployedMngmtA_&_years.
		   mPopEmployedServA_&_years. mPopEmployedSalesA_&_years.
		   mPopEmployedNatResA_&_years. mPopEmployedProdA_&_years.

		   mPopEmployedByOccIOM_&_years. mPopEmployedMngmtIOM_&_years.
		   mPopEmployedServIOM_&_years. mPopEmployedSalesIOM_&_years.
		   mPopEmployedNatResIOM_&_years. mPopEmployedProdIOM_&_years.

		   mPopEmployedByOccAIOM_&_years. mPopEmployedMngmtAIOM_&_years.
		   mPopEmployedServAIOM_&_years. mPopEmployedSalesAIOM_&_years.
		   mPopEmployedNatResAIOM_&_years. mPopEmployedProdAIOM_&_years.*/

           mPop25andOverWoutHS_&_years. mPop25andOverWoutHSB_&_years.
		   mPop25andOverWoutHSW_&_years. mPop25andOverWoutHSH_&_years.
		   mPop25andOverWoutHSA_&_years. mPop25andOverWoutHSIOM_&_years.
		   mPop25andOverWoutHSAIOM_&_years. mPop25andOverWoutHSFB_&_years.
		   mPop25andOverWoutHSNB_&_years.

		   mPop25andOverWHS_&_years. mPop25andOverWHSB_&_years.
		   mPop25andOverWHSW_&_years. mPop25andOverWHSH_&_years.
		   mPop25andOverWHSA_&_years. mPop25andOverWHSIOM_&_years.
		   mPop25andOverWHSAIOM_&_years. mPop25andOverWHSFB_&_years.
		   mPop25andOverWHSNB_&_years.

		   mPop25andOverWSC_&_years. mPop25andOverWSCB_&_years. 
		   mPop25andOverWSCW_&_years. mPop25andOverWSCH_&_years. 
		   mPop25andOverWSCA_&_years. mPop25andOverWSCIOM_&_years. 
		   mPop25andOverWSCAIOM_&_years. mPop25andOverWSCFB_&_years.
		   mPop25andOverWSCNB_&_years.

		   mPop25andOverWCollege_&_years.

           mPop25andOverYears_&_years. mPop25andOverYearsB_&_years.
		   mPop25andOverYearsW_&_years. mPop25andOverYearsH_&_years.
		   mPop25andOverYearsA_&_years. mPop25andOverYearsIOM_&_years.
		   mPop25andOverYearsAIOM_&_years. mPop25andOverYearsFB_&_years.
		   mPop25andOverYearsNB_&_years.

		   mMedFamIncm_&_years. mMedFamIncmB_&_years.
		   mMedFamIncmW_&_years. mMedFamIncmH_&_years.
		   mMedFamIncmA_&_years. mMedFamIncmIOM_&_years.
		   mMedFamIncmAIOM_&_years.

		   mNumOccupiedHsgUnits_&_years. mNumOccupiedHsgUnitsB_&_years.
		   mNumOccupiedHsgUnitsW_&_years. mNumOccupiedHsgUnitsH_&_years.
		   mNumOccupiedHsgUnitsA_&_years. mNumOccupiedHsgUnitsIOM_&_years.
		   mNumOccupiedHsgUnitsAIOM_&_years.

           mNumOwnerOccupiedHU_&_years. mNumOwnerOccupiedHUB_&_years.
		   mNumOwnerOccupiedHUW_&_years. mNumOwnerOccupiedHUH_&_years.
		   mNumOwnerOccupiedHUA_&_years. mNumOwnerOccupiedHUIOM_&_years.
		   mNumOwnerOccupiedHUAIOM_&_years.
           ;
               
  %end;
  
  %put _local_;
  
  %if ( &geo_name = GEO2000 and %upcase( &source_geo_var ) = GEO2000 ) or 
      ( &geo_name = GEO2010 and %upcase( &source_geo_var ) = GEO2010 ) %then %do;

    ** Census tracts from census tract source (same year): just recopy selected vars **;
    
    data &_out_lib..&out_ds (label="ACS summary, &_years_dash, %upcase(&_state_ab), &source_geo_label source, &geo_label");
    
      set &source_ds_work (keep=&geo_var &count_vars &moe_vars);

    run;

  %end;
  %else %do;
  
    ** Transform data from source geography (&source_geo_var) to target geography (&geo_var) **;
    
    %Transform_geo_data(
      dat_ds_name=&source_ds_work,
      dat_org_geo=&source_geo_var,
      dat_count_vars=&count_vars,
      dat_count_moe_vars=&moe_vars,
      dat_prop_vars=,
      wgt_ds_name=General.&geo_wt_file,
      wgt_org_geo=&source_geo_var,
      wgt_new_geo=&geo_var,
      wgt_id_vars=,
      wgt_wgt_var=popwt,
      out_ds_name=&_out_lib..&out_ds,
      out_ds_label=%str(ACS summary, &_years_dash, %upcase(&_state_ab), &source_geo_label source, &geo_label),
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
      creator_process=DCOLA_ACS_&_years._&state_ab._sum_all.sas,
      restrictions=None,
      revisions=%str(&_revisions)
    )

  %end;



%mend DCOLA_ACS_summary_geo;


