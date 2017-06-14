/**************************************************************************
 Program:  NCDB_1990_summary_geo_source.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/25/2016
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from NCDB_1990 tract summary file.

**************************************************************************/

%macro NCDB_1990_summary_geo_source( source_geo );

  %global source_geo_var source_geo_suffix source_geo_wt_file_fmt source_ds source_ds_work source_geo_label;

  %if %upcase( &source_geo ) = TR90 %then %do;
     %let source_geo_var = Geo1990;
     %let source_geo_suffix = _tr;
     %let source_geo_wt_file_fmt = $geotw1f.;
     %let source_ds = NCDB_&_years._&_state_ab._tr90;
     %let source_geo_label = Census tract;
  %end;
  %else %do;
    %err_mput( macro=NCDB_1990_summary_geo_source, msg=Geograpy &source_geo is not supported. )
    %goto macro_exit;
  %end;
     
  %let source_ds_work = NCDB_&_years._&state_ab._sum&source_geo_suffix;

  %put _global_;

  ** Create new variables for summarizing **;

data dcola.ncdb_sum_1990_sol;
	set ncdb.Ncdb_1990_dc;

*Note:
	- 1990 Census did not disaggregate White and Hispanic identities as they did in 2000 
	and continue to with the ACS. White and non-hispanic are not mutually exclusive here.
	- 1990 Census did not measure "multiracial" population, so AIOM numbers are really AIO;

*Population 25 years and over;

		Pop25andOverYears_&_years. = educpp9;
		Pop25andOverYearsB_&_years. = bp25p9;
		Pop25andOverYearsW_&_years. = xp25p9;
		Pop25andOverYearsH_&_years. = hp25p9;
		Pop25andOverYearsAIOM_&_years. = sum(ap25p9, ip25p9, op25p9, mp25p9);


*With less than high school diploma, 1990;

		Pop25andOverWoutHS_&_years. = sum(educ89, educ119);
		Pop25andOverWoutHSB_&_years. = sum(bedlt99, bedlths9);
		Pop25andOverWoutHSW_&_years. = sum(wedlt99, wedlths9);
		Pop25andOverWoutHSH_&_years. = sum(hedlt99, hedlths9);
		Pop25andOverWoutHSAIOM_&_years. = sum(aedlt99, aedlths9, iedlt99, iedlths9, oedlt99, oedlths9);

*With high school diploma, 1990;

		Pop25andOverWHS_&_years. = sum(educ129, educa9, educ159, educ169);
		Pop25andOverWHSB_&_years. = sum(bedhsg9, bedasd9, bedsc9, bedba9, bedpro9);
		Pop25andOverWHSW_&_years. = sum(wedhsg9, wedasd9, wedsc9, wedba9, wedpro9);
		Pop25andOverWHSH_&_years. = sum(hedhsg9, hedasd9, hedsc9, hedba9, hedpro9);
		Pop25andOverWHSAIOM_&_years. = sum(aedhsg9, aedasd9, aedsc9, aedba9, aedpro9,
										iedhsg9, iedasd9, iedsc9, iedba9, iedpro9,
										oedhsg9, oedasd9, oedsc9, oedba9, oedpro9);

*With some college, 1990;

		Pop25andOverWSC_&_years. = sum(educa9, educ159, educ169);
		Pop25andOverWSCB_&_years. = sum(bedasd9, bedsc9, bedba9, bedpro9);
		Pop25andOverWSCW_&_years. = sum(wedasd9, wedsc9, wedba9, wedpro9);
		Pop25andOverWSCH_&_years. = sum(hedasd9, hedsc9, hedba9, hedpro9);
		Pop25andOverWSCAIOM_&_years. = sum(aedasd9, aedsc9, aedba9, aedpro9,
										iedasd9, iedsc9, iedba9, iedpro9,
										oedasd9, oedsc9, oedba9, oedpro9);

*Unemployed population, 1990;

		PopUnemployed_&_years. = UNEMPT9N;
		PopUnemployedW_&_years. = sum(wMUNEMP9, wFUNEMP9);
		PopUnemployedB_&_years. = sum(bMUNEMP9, bFUNEMP9);
		PopUnemployedH_&_years. = sum(hMUNEMP9, hFUNEMP9);
		PopUnemployedAIOM_&_years. = sum(aMUNEMP9, aFUNEMP9, iMUNEMP9, iFUNEMP9, 
									oMUNEMP9, oFUNEMP9);

*Civilian labor force, 1990;

		PopInCivLaborForce_&_years. = UNEMPT9D;
		PopInCivLaborForceW_&_years. = (wMUNEMP9, wMEMP9, wFUNEMP9, wFEMP9 );
		PopInCivLaborForceB_&_years. = (bMUNEMP9, bMEMP9, bFUNEMP9, bFEMP9 );
		PopInCivLaborForceH_&_years. = (hMUNEMP9, hMEMP9, hFUNEMP9, hFEMP9 );
		PopInCivLaborForceAIOM_&_years. = (aMUNEMP9, aMEMP9, aFUNEMP9, aFEMP9,
										iMUNEMP9, iMEMP9, iFUNEMP9, iFEMP9,
										oMUNEMP9, oMEMP9, oFUNEMP9, oFEMP9);

*Children - Total pop under 18, 1990;

		PopUnder18Years_&_years. = sum(fem49, fem99, fem149, fem179a, men49, men99, men149, men179a);
		PopUnder18YearsB_&_years. = sum(bf59, bm59, bf149, bm149, f179a, bm179a);
		PopUnder18YearsW_&_years. = sum(wf59, wm59, wf149, wm149, f179a, wm179a);
		PopUnder18YearsH_&_years. = sum(hf59, hm59, hf149, hm149, f179a, hm179a);
		PopUnder18YearsAIOM_&_years. = sum(af59, am59, af149, am149, f179a, am179a,
										if59, am59, if149, am149, if179a, am179a,
										of59, om59, of149, om149, of179a, om179a);

*Adults aged 18 to 24 years old, 1990;

		Pop18_24Years_&_years. = sum(fem199a, fem249, men199a, men249); 
		Pop18_24YearsB_&_years. = sum(bf249a, bm249a);
		Pop18_24YearsW_&_years. = sum(wf249a, wm249a);
		Pop18_24YearsH_&_years. = sum(hf249a, hm249a);
		Pop18_24YearsAIOM_&_years. = (af249a, am249a, if249a, im249a, of249a, om249a);

*Adults aged 25 to 64 years old, 1990;

		Pop25_64Years_&_years. = sum(fem299, fem349, fem449, fem549, fem649, 
								men299, men349, men449, men549, men649);
		Pop25_64YearsB_&_years. = sum(bf599a, bm599a, bf649, bm649);
		Pop25_64YearsW_&_years. = sum(wf599a, wm599a, wf649, wm649);
		Pop25_64YearsH_&_years. = sum(hf599a, hm599a, hf649, hm649);
		Pop25_64YearsAIOM_&_years. = sum(af599a, am599a, af649, am649,
									if599a, im599a, if649, im649,
									of599a, om599a, of649, om649);

*Elder adults, 1990;

		Pop65andOverYears_&_years. = sum(fem749, fem759, men749, men759);
		Pop65andOverYearsB_&_years. = sum(bf659, bm659);
		Pop65andOverYearsW_&_years. = sum(wf659, wm659;
		Pop65andOverYearsH_&_years. = sum(hf659, hm659);
		Pop65andOverYearsAIOM_&_years. = sum(af659, am659, if659, im659, of659, om659);

*Aggregate household income, 1990;

		AggHshldIncome_&_years. = avhhin9n;
		AggHshldIncomeB_&_years. = bpcapy9n;
		AggHshldIncomeW_&_years. = wpcapy9n;
		AggHshldIncomeH_&_years. = hpcapy9n;
		AggHshldIncomeAIOM_&_years. = sum(apcapy9n, ipcapy9n, opcapy9n);

*Number of households, 1990;

		NumHshlds_&_years. = nonfam9;
		NumHshldsB_&_years. = bnonfam9;
		NumHshldsW_&_years. = wnonfam9;
		NumHshldsH_&_years. = hnonfam9;
		NumHshldsAIOM_&_years. = sum(anonfam9, ononfam9, inonfam9);

run;
  %if &_state_ab = dc %then %do;

    %** For DC, do full set of geographies **;
    
    %NCDB_1990_summary_geo( anc2002, &source_geo )
    %NCDB_1990_summary_geo( anc2012, &source_geo )
    %NCDB_1990_summary_geo( city, &source_geo )
    %NCDB_1990_summary_geo( cluster_tr2000, &source_geo )
    %NCDB_1990_summary_geo( eor, &source_geo )
    %NCDB_1990_summary_geo( psa2004, &source_geo )
    %NCDB_1990_summary_geo( psa2012, &source_geo )
    %NCDB_1990_summary_geo( geo2000, &source_geo )
    %NCDB_1990_summary_geo( geo2010, &source_geo )
    %NCDB_1990_summary_geo( voterpre2012, &source_geo )
    %NCDB_1990_summary_geo( ward2002, &source_geo )
    %NCDB_1990_summary_geo( ward2012, &source_geo )
    %NCDB_1990_summary_geo( zip, &source_geo )
	%NCDB_1990_summary_geo( cluster2000, &source_geo )


  %end;
  %else %do;
  
    %** For non-DC, only do census tract summary file **;
    
    %if &source_geo = TR90 %then %do;
      %NCDB_1990_summary_geo( geo1990, &source_geo )
    %end;

  %end;
  
  ** Cleanup temporary data sets **;
  
  proc datasets library=work nolist;
    delete &source_ds_work /memtype=data;
  quit;
  
  %macro_exit:

%mend NCDB_1990_summary_geo_source;





