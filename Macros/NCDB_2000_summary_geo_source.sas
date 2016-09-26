/**************************************************************************
 Program:  NCDB_2000_summary_geo_source.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/25/2016
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from NCDB_2000 tract summary file.

**************************************************************************/

%macro NCDB_2000_summary_geo_source( source_geo );

  %global source_geo_var source_geo_suffix source_geo_wt_file_fmt source_ds source_ds_work source_geo_label;

  %if %upcase( &source_geo ) = TR00 %then %do;
     %let source_geo_var = Geo2000;
     %let source_geo_suffix = _tr;
     %let source_geo_wt_file_fmt = $geotw0f.;
     %let source_ds = NCDB_&_years._&_state_ab._tr00;
     %let source_geo_label = Census tract;
  %end;
  %else %do;
    %err_mput( macro=NCDB_2000_summary_geo_source, msg=Geograpy &source_geo is not supported. )
    %goto macro_exit;
  %end;
     
  %let source_ds_work = NCDB_&_years._&state_ab._sum&source_geo_suffix;

  %put _global_;

  ** Create new variables for summarizing **;

	data dcola.ncdb_sum_2000_sol;
		set ncdb.Ncdb_lf_2000_dc;
	
*Owner-occupied housing units;

		NumOwnerOccHsgUnitsAIOM_&_years. = sum(ownocca0, ownocci0, ownocco0, ownoccm0);
 
*Population 25 years and over;

		Pop25andOverYears_&_years. = educpp0;
		Pop25andOverYearsB_&_years. = bp25p0;
		Pop25andOverYearsW_&_years. = xp25p0;
		Pop25andOverYearsH_&_years. = hp25p0;
		Pop25andOverYearsAIOM_&_years. = sum(ap25p0, ip25p0, op25p0, mp25p0);

*With less than high school diploma, 2000;

		Pop25andOverWoutHS_&_years. = sum(educ80, educ110);
		Pop25andOverWoutHSB_&_years. = sum(bedlt90, bedlths0);
		Pop25andOverWoutHSW_&_years. = sum(xedlt90, xedlths0);
		Pop25andOverWoutHSH_&_years. = sum(hedlt90, hedlths0);
		Pop25andOverWoutHSAIOM_&_years. = sum(aedlt90, aedlths0, iedlt90, iedlths0, oedlt90, oedlths0, medlt90, medlths0);

*With high school diploma, 2000;

		Pop25andOverWHS_&_years. = sum(educ120, educa0, educ150, educ160);
		Pop25andOverWHSB_&_years. = sum(bedhsg0, bedasd0, bedsc0, bedba0, bedpro0);
		Pop25andOverWHSW_&_years. = sum(xedhsg0, xedasd0, xedsc0, xedba0, xedpro0);
		Pop25andOverWHSH_&_years. = sum(hedhsg0, hedasd0, hedsc0, hedba0, hedpro0);
		Pop25andOverWHSAIOM_&_years. = sum(aedhsg0, aedasd0, aedsc0, aedba0, aedpro0,
										iedhsg0, iedasd0, iedsc0, iedba0, iedpro0,
										oedhsg0, oedasd0, oedsc0, oedba0, oedpro0,
										medhsg0, medasd0, medsc0, medba0, medpro0);

*With some college, 2000;

		Pop25andOverWSC_&_years. = sum(educa0, educ150, educ160);
		Pop25andOverWSCB_&_years. = sum(bedasd0,, bedsc0,, bedba0,, bedpro0);
		Pop25andOverWSCW_&_years. = sum(xedasd0, xedsc0, xedba0, xedpro0);
		Pop25andOverWSCH_&_years. = sum(hedasd0, hedsc0, hedba0, hedpro0);
		Pop25andOverWSCAIOM_&_years. = sum(aedasd0, aedsc0, aedba0, aedpro0,
										iedasd0, iedsc0, iedba0, iedpro0,
										oedasd0, oedsc0, oedba0, oedpro0,
										medasd0, medsc0, medba0, medpro0);

*Unemployed population, 2000;

		PopUnemployed_&_years. = UNEMPT0N;
		PopUnemployedW_&_years. = sum(xMUNEMP0, xFUNEMP0);
		PopUnemployedB_&_years. = sum(bMUNEMP0, bFUNEMP0);
		PopUnemployedH_&_years. = sum(hMUNEMP0, hFUNEMP0);
		PopUnemployedAIOM_&_years. = sum(aMUNEMP0, aFUNEMP0, iMUNEMP0, iFUNEMP0, oMUNEMP0, oFUNEMP0, mMUNEMP0, mFUNEMP0);

*Civilian labor force, 2000;

		PopInCivLaborForce_&_years. = UNEMPT0D;
		PopInCivLaborForceW_&_years. = (xMUNEMP0, xMEMP0, xFUNEMP0, xFEMP0 );
		PopInCivLaborForceB_&_years. = (bMUNEMP0, bMEMP0, bFUNEMP0, bFEMP0 );
		PopInCivLaborForceH_&_years. = (hMUNEMP0, hMEMP0, hFUNEMP0, hFEMP0 );
		PopInCivLaborForceAIOM_&_years. = (aMUNEMP0, aMEMP0, aFUNEMP0, aFEMP0,
										iMUNEMP0, iMEMP0, iFUNEMP0, iFEMP0,
										oMUNEMP0, oMEMP0, oFUNEMP0, oFEMP0,
										mMUNEMP0, mMEMP0, mFUNEMP0, mFEMP0);

*Children - Total pop under 18, 2000;

		PopUnder18Years_&_years. = sum(fem40, fem90, fem140, fem170a, men40, men90, men140, men170a);
		PopUnder18YearsB_&_years. = sum(bf50, bm50, bf140, bm140, f170a, bm170a);
		PopUnder18YearsW_&_years. = sum(xf50, xm50, xf140, xm140, f170a, xm170a);
		PopUnder18YearsH_&_years. = sum(hf50, hm50, hf140, hm140, f170a, hm170a);
		PopUnder18YearsAIOM_&_years. = sum(af50, am50, af140, am140, f170a, am170a,
										if50, am50, if140, am140, if170a, am170a,
										of50, om50, of140, om140, of170a, om170a,
										mf50, mm50, mf140, mm140, mf170a, mm170a);

*Adults aged 18 to 24 years old, 2000;

		Pop18_24Years_&_years. = sum(fem190a, fem240, men190a, men240); 
		Pop18_24YearsB_&_years. = sum(bf240a, bm240a);
		Pop18_24YearsW_&_years. = sum(xf240a, xm240a);
		Pop18_24YearsH_&_years. = sum(hf240a, hm240a);
		Pop18_24YearsAIOM_&_years. = (af240a, am240a, if240a, im240a,
									of240a, om240a, mf240a, mm240a);

*Adults aged 25 to 64 years old, 2000;

		Pop25_64Years_&_years. = sum(fem290, fem340, fem440, fem540, fem640, 
								men290, men340, men440, men540, men640);
		Pop25_64YearsB_&_years. = sum(bf590a, bm590a, bf640, bm640);
		Pop25_64YearsW_&_years. = sum(xf590a, xm590a, xf640, xm640);
		Pop25_64YearsH_&_years. = sum(hf590a, hm590a, hf640, hm640);
		Pop25_64YearsAIOM_&_years. = sum(af590a, am590a, af640, am640,
									if590a, im590a, if640, im640,
									of590a, om590a, of640, om640,
									mf590a, mm590a, mf640, mm640);

*Elder adults, 2000;

		Pop65andOverYears_&_years. = sum(fem740, fem750, men740, men750);
		Pop65andOverYearsB_&_years. = sum(bf650, bm650);
		Pop65andOverYearsW_&_years. = sum(xf650, xm650;
		Pop65andOverYearsH_&_years. = sum(hf650, hm650);
		Pop65andOverYearsAIOM_&_years. = sum(af650, am650, if650, im650
										of650, om650, mf650, mm650);

*Aggregate household income, 2000;

		AggHshldIncome_&_years. = avhhin0n;
		AggHshldIncomeB_&_years. = bpcapy0n;
		AggHshldIncomeW_&_years. = xpcapy0n;
		AggHshldIncomeH_&_years. = hpcapy0n;
		AggHshldIncomeAIOM_&_years. = sum(apcapy0n, ipcapy0n, mpcapy0n, opcapy0n);

*Number of households, 2000;

		NumHshlds_&_years. = nonfam0;
		NumHshldsB_&_years. = bnonfam0;
		NumHshldsW_&_years. = xnonfam0;
		NumHshldsH_&_years. = hnonfam0;
		NumHshldsAIOM_&_years. = sum(anonfam0, ononfam0, inonfam0, mnonfam0);

run;

  %if &_state_ab = dc %then %do;

    %** For DC, do full set of geographies **;
    
    %NCDB_2000_summary_geo( anc2002, &source_geo )
    %NCDB_2000_summary_geo( anc2012, &source_geo )
    %NCDB_2000_summary_geo( city, &source_geo )
    %NCDB_2000_summary_geo( cluster_tr2000, &source_geo )
    %NCDB_2000_summary_geo( eor, &source_geo )
    %NCDB_2000_summary_geo( psa2004, &source_geo )
    %NCDB_2000_summary_geo( psa2012, &source_geo )
    %NCDB_2000_summary_geo( geo2000, &source_geo )
    %NCDB_2000_summary_geo( geo2010, &source_geo )
    %NCDB_2000_summary_geo( voterpre2012, &source_geo )
    %NCDB_2000_summary_geo( ward2002, &source_geo )
    %NCDB_2000_summary_geo( ward2012, &source_geo )
    %NCDB_2000_summary_geo( zip, &source_geo )
	%NCDB_2000_summary_geo( cluster2000, &source_geo )


  %end;
  %else %do;
  
    %** For non-DC, only do census tract summary file **;
    
    %else %if &source_geo = TR00 %then %do;
      %NCDB_2000_summary_geo( geo2000, &source_geo )
    %end;

  %end;
  
  ** Cleanup temporary data sets **;
  
  proc datasets library=work nolist;
    delete &source_ds_work /memtype=data;
  quit;
  
  %macro_exit:

%mend NCDB_2000_summary_geo_source;
