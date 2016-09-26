/**************************************************************************
 Program:  SOL_Demographics.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/22/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Calculates Latino demographic variables between 1990 and 2014

 **************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let inc_dollar_yr=2015;
%let racelist=W B H AIOM;
%let racename= NH-White Black-Alone Hispanic All-Other;


%let geography=city Ward2012 cluster_tr2000;

/** Macro Add_Percents- Start Definition **/

%macro add_percents;

%do i = 1 %to 3; 
  %let geo=%scan(&geography., &i., " "); 

    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

data dcola.sol2017;
	merge
		Ncdb.Ncdb_sum&geosuf
	        (keep=&geo
	           TotPop: PopWithRace: PopBlackNonHispBridge:
	           PopWhiteNonHispBridge: PopHisp: PopAsianPINonHispBridge:
	           PopOtherRaceNonHispBridge: NumOwnerOccHsgUnits:)

      	dcola.Ncdb_2000_dc_sum&geosuf
	        (keep=&geo Pop25andOver: PopUnemployed: PopInCiv: PopUnder18: Pop18_24: Pop25_64:
			Pop65: AggHshld: NumHshlds:)

      	dcola.Ncdb_1990_dc_sum&geosuf
			(keep=&geo Pop25andOver: PopUnemployed: PopInCiv: PopUnder18: Pop18_24: Pop25_64:
			Pop65: AggHshld: NumHshlds:)


		equity.acs_2010_14_dc_sum_bg&geosuf
			(keep=TotPop: mTotPop: 
			   PopUnder5Years_: mPopUnder5Years_:
			   PopUnder18Years_: mPopUnder18Years_:
			   Pop18_34Years_:mPop18_34Years_:
			   Pop35_64Years_: mPop35_64Years_:
			   Pop65andOverYears_: mPop65andOverYears_:
			   Pop25andOverYears_: mPop25andOverYears_:
			   PopWithRace: mPopWithRace:
			   PopBlackNonHispBridge: mPopBlackNonHispBridge:
	           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
			   PopHisp: mPopHisp:
			   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
			   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
			   PopMultiracialNonHisp: mPopMultiracialNonHisp:
			   PopAlone: mPopAlone:
	           NumFamilies_: mNumFamilies_:
			   MedFamIncm: mMedFamIncm:
			   PopEmployed:  mPopEmployed:
			   PopEmployedByOcc: mPopEmployedByOcc: 
			   PopEmployedMngmt: mPopEmployedMngmt:
			   PopEmployedServ: mPopEmployedServ: 
			   PopEmployedSales: mPopEmployedSales:
			   PopEmployedNatRes: mPopEmployedNatRes: 
			   PopEmployedProd: mPopEmployedProd:
	           Pop25andOverWoutHS: mPop25andOverWoutHS: 
			   Pop25andOverWHS_: mPop25andOverWHS_:
			   Pop25andOverWSC_: mPop25andOverWSC_:
			   Pop25andOverWCollege_: mPop25andOverWCollege_:
			   NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
			   NumOwnerOccupiedHU: mNumOwnerOccupiedHU:)

		 equity.acs_2010_14_dc_sum_tr&geosuf
			 (keep=TotPop: mTotPop: 
			   PopUnder18YearsH: mPopUnder18YearsH: 
			   Pop18_34YearsH: mPop18_34YearsH:
			   Pop35_64YearsH: mPop35_64YearsH:
			   Pop25_64years: mPop25_64years:
			   Pop25_64yearsH: mPop25_64yearsH:
			   Pop65andOverYearsH: mPop65andOverYearsH:
			   Pop25andOverYearsH: mPop25andOverYearsH: 
			   PopWithRace: mPopWithRace:
			   PopBlackNonHispBridge: mPopBlackNonHispBridge:
	           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
			   PopHisp: mPopHisp:
			   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
			   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
			   PopMultiracialNonHisp: mPopMultiracialNonHisp:
			   PopAlone: mPopAlone:
	           NumFamilies: mNumFamilies:
			   NumHshlds: mNumHshlds:
			   PopEmployed:  mPopEmployed:
			   PopEmployedByOcc: mPopEmployedByOcc: 
			   PopEmployedMngmt: mPopEmployedMngmt:
			   PopEmployedServ: mPopEmployedServ: 
			   PopEmployedSales: mPopEmployedSales:
			   PopEmployedNatRes: mPopEmployedNatRes: 
			   PopEmployedProd: mPopEmployedProd:
	           Pop25andOverWoutHS: mPop25andOverWoutHS: 
			   Pop25andOverWHS: mPop25andOverWHS:
			   Pop25andOverWSC: mPop25andOverWSC:
			   Pop25andOverWCollege: mPop25andOverWCollege:
			   NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
			   NumOwnerOccupiedHU: mNumOwnerOccupiedHU:
			   PopNativeBorn: mPopNativeBorn:
			   PopNonEnglish: mPopNonEnglish:
			   PopForeignBorn: mPopForeignBorn: 
	           PopInCivLaborForce: mPopInCivLaborForce: 
			   PopCivilianEmployed: mPopCivilianEmployed:
	           PopUnemployedH: mPopUnemployed: 
			   rename=(TotPop_2010_14=TotPop_tr_2010_14 mTotPop_2010_14=mTotPop_tr_2010_14))

		dcola.acs_2010_14_dc_sum_bg&geosuf
			(keep=PopHisp: mPopHisp:)

		dcola.acs_2010_14_dc_sum_tr&geosuf
			(keep=Pop5andOverYearsH: mPop5andOverYearsH:
			   PopNativeBornH: mPopNativeBornH:
			   PopForeignBornH: mPopForeignBornH: 
			   PopCitizenH: mPopCitizenH:
			   PopNaturalizedH: mPopNaturalizedH:
	  		   PopNonCitizenH: mPopNonCitizenH:
			   PopNonEnglish: mPopNonEnglish:
			   PopOnlyEnglishH: mPopOnlyEnglishH:
			   PopSpanishH: mPopSpanishH:
			   PopEngVeryWellH: mPopEngVeryWellH:
			   PopEngWellH: mPopEngWellH:
			   PopEngNotWellH: mPopEngNotWellH:
			   PopNoEnglishH: mPopNoEnglishH:
			   PopEngLessThanVeryWellH: mPopEngLessThanVeryWellH:
			   PopOtherLangH: mPopOtherLangH:
			   PopMexican: mPopMexican:
			   PopPuertoRican: mPopPuertoRican:
			   PopCuban: mPopCuban:
			   PopDominican: mPopDominican:
			   PopCentAmerican: mPopCentAmerican:
			   PopSouthAmerican: mPopSouthAmerican:
			   PopOtherHisp: mPopOtherHisp:)

	    Police.Crimes_sum&geosuf
	        (keep=&geo Crime_rate_pop: Crimes_pt1_violent: Crimes_pt1_property: )

		Vital.Births_sum&geosuf
        	(keep=&geo births_total: births_w_race: births_black: births_asian: 
						births_hisp: births_white: births_oth_rac:
						births_w_prenat: births_w_prenat_blk: births_w_prenat_asn: 
						births_w_prenat_hsp: births_w_prenat_wht: births_w_prenat_oth:
						births_prenat_adeq: births_prenat_adeq_blk: births_prenat_adeq_asn: 
						births_prenat_adeq_hsp: births_prenat_adeq_wht: births_prenat_adeq_oth:)
         ;
    	 by &geo;
		;

    ** Population by Race/Ethnicity **;
    
    %Pct_calc( var=PctBlackNonHispBridge, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=1990 2000 2010_14 )
    %Pct_calc( var=PctWhiteNonHispBridge, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHisp, label=% Hispanic, num=PopHisp, den=PopWithRace, years=1990 2000 2010_14 )
    %Pct_calc( var=PctAsnPINonHispBridge, label=% Asian/P.I. non-Hispanic, num=PopAsianPINonHispBridge, den=PopWithRace, years=1990 2000 2010_14 )
    %Pct_calc( var=PctOtherRaceNonHispBridg, label=% All other than Black White Asian P.I. Hispanic, num=PopOtherRaceNonHispBridg, den=PopWithRace, years=1990 2000 2010_14 2010 )

*Latino population by country of origin, 2010-2014; 

    %Pct_calc( var=PctHispMexican, label=% Mexican, num=PopHispMexican, den=PopHisp, years=1990 2000 2010_14  )
	%Pct_calc( var=PctHispPuertoRican, label=% Puerto Rican, num=PopHispPuertoRican, den=PopHisp, years=1990 2000 2010_14  )
	%Pct_calc( var=PctHispCuban, label=% Cuban, num=PopHispCuban, den=PopHisp, years=1990 2000 2010_14 )
	%Pct_calc( var=PctHispDominican, label=% Dominican, num=PopHispDominican, den=PopHisp, years=1990 2000 2010_14 )
	%Pct_calc( var=PctHispOtherCentAmer, label=% Central American, num=PopHispOtherCentAmer, den=PopHisp, years=1990 2000 2010_14 )
	%Pct_calc( var=PctHispSouthAmerican, label=% South American, num=PopHispOtherSouthAmer, den=PopHisp, years=1990 2000 2010_14 )
	%Pct_calc( var=PctHispOtherHispOrig, label=% Other Hispanic or Latino, num=PopHispOtherHisp, den=PopHisp, years=1990 2000 2010_14)
    %Pct_calc( var=PctHispArgentinian, label=% Argentinian, num=PopHispArgentinian, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispBolivian, label=% Bolivian, num=PopHispBolivian, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispChilean, label=% Chilean, num=PopHispChilean, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispColombian, label=% Colombian, num=PopHispColombian, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispCosta Rican, label=% Costa Rican, num=PopHispCosta Rican, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispEcuadorian, label=% Ecuadorian, num=PopHispEcuadorian, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispElSalvadoran, label=% ElSalvadoran, num=PopHispElSalvadoran, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispGuatemalan, label=% Guatemalan, num=PopHispGuatemalan, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispHonduran, label=% Honduran, num=PopHispHonduran, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispNicaraguan, label=% Nicaraguan, num=PopHispNicaraguan, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispPeruvian, label=% Peruvian, num=PopHispPeruvian, den=PopHisp, years=1990 2000 2010_14 )
    %Pct_calc( var=PctHispPananamian, label=% Pananamian, num=PopHispPananamian, den=PopHisp, years=1990 2000 2010_14 )

*Latino population by citizenship status, 2010-2014;

	%Pct_calc( var=PctNativeBornH, label=% Native-born Hispanic, num=PopNativeBornH, den=PopHisp, years=2010_14 )
	%Pct_calc( var=PctForeignBornH, label=% Foreign-born Hispanic, num=PopForeignBornH, den=PopHisp, years=2010_14 )
	%Pct_calc( var=PctCitizenH, label=% Naturalized and native born Hispanic citizens, num=PopCitizenH, den=PopHisp, years=2010_14 )
	%Pct_calc( var=PctNaturalizedH, label=% Naturalized foreign-born Hispanic citizens, num=PopNaturalizedH, den=PopHisp, years=2010_14 )
	%Pct_calc( var=PctNonCitizenH, label=% Hispanic foreign-born population who are not US citizens, num=PopNonCitizenH, den=PopHisp, years=2010_14 )

	%Moe_prop_a( var=PctNativeBornH_m_2010_14, mult=100, num=PopNativeBornH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mPopNativeBornH_2010_14, den_moe=mPopHisp_2010_14 );

	%Moe_prop_a( var=PctForeignBornH_m_2010_14, mult=100, num=PopForeignBornH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mForeignBornH_2010_14, den_moe=mPopHisp_2010_14 );

	%Moe_prop_a( var=PctCitizenH_m_2010_14, mult=100, num=PopCitizenH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mPopCitizenH_2010_14, den_moe=mPopHisp_2010_14 );

	%Moe_prop_a( var=PctNaturalizedH_m_2010_14, mult=100, num=PopNaturalizedH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mNaturalizedH_2010_14, den_moe=mPopHisp_2010_14 );

	%Moe_prop_a( var=PctNonCitizenH_m_2010_14, mult=100, num=PopNonCitizenH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mNonCitizenH_2010_14, den_moe=mPopHisp_2010_14 );




*Latino population by language proficiency, 2010-2014;

	%Pct_calc( var=PctNonEnglish, label=% Hispanic speak a language other than English at home, num=PopNonEnglish, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctOnlyEnglishH, label=% Hispanic speak English at home, num=PopOnlyEnglishH, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctSpanishH, label=% Hispanic speak Spanish at home, num=PopSpanishH, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctEngVeryWellH, label=% Hispanic anish-speakers who speak English very well, num=EngVeryWellH, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctEngWellH, label=% Hispanic Spanish-speakers who speak English well, num=PopEngWellH, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctEngNotWellH, label=% Hispanic Spanish-speakers who do not speak English well, num=PopEngNotWellH, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctNoEnglishH, label=% Hispanic Spanish-speakers who speak no English, num=PopNoEnglish, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctEngLessThanVeryWellH, label=% Hispanic Spanish-speakers who speak English less than very well, num=PopEngLessThanVeryWellH, den=Pop5andOverYearsH, years=2010_14 )
	%Pct_calc( var=PctOtherLangH, label=% Hispanic who speak other language at home, num=PopOtherLangH, den=Pop5andOverYearsH, years=2010_14 )

	%Moe_prop_a( var=PctNonEnglish_m_2010_14, mult=100, num=PopNonEnglish_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopNonEnglish_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctOnlyEnglishH_m_2010_14, mult=100, num=PopOnlyEnglishH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopOnlyEnglishH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctSpanishH_m_2010_14, mult=100, num=PopSpanishH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopPopSpanishH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctEngVeryWellH_m_2010_14, mult=100, num=PopEngVeryWellH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopEngVeryWellH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctEngWellH_m_2010_14, mult=100, num=PopEngWellH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopEngWellH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctEngNotWellH_m_2010_14, mult=100, num=PopEngNotWellH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopEngNotWellH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctNoEnglishH_m_2010_14, mult=100, num=PopNoEnglishH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopNoEnglishH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctEngLessThanVeryWellH_m_2010_14, mult=100, num=PopEngLessThanVeryWellH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopEngLessThanVeryWellH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

	%Moe_prop_a( var=PctOtherLangH_m_2010_14, mult=100, num=PopOtherLangH_2010_14, den=Pop5andOverYearsH_2010_14, 
                       num_moe=mPopOtherLangH_2010_14, den_moe=mPop5andOverYearsH_2010_14 );

*Latino population by age, 2010-2014;

	%Pct_calc( var=PctPopUnder18Years, label=% children &name., num=PopUnder18Years, den=PopHisp, years= 2010_14 )
    
    %Moe_prop_a( var=PctPopUnder18Years_m_2010_14, mult=100, num=PopUnder18Years_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopUnder18Years_2010_14, den_moe=mPopWithRace_2010_14 );

    %Pct_calc( var=PctPopUnder18YearsH, label=% children &name., num=PopUnder18YearsH, den=PopHisp, years= 2010_14 )
    
    %Moe_prop_a( var=PctPopUnder18YearsH_m_2010_14, mult=100, num=PopUnder18YearsH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mPopUnder18YearsH_2010_14, den_moe=mPopHisp_2010_14 );


	%Pct_calc( var=PctPop18_34Years, label=% persons 18-34 years old &name., num=Pop18_34Years, den=PopWithRace, years= 2010_14 )
	
	%Moe_prop_a( var=PctPop18_34Years_m_2010_14, mult=100, num=Pop18_34Years_2010_14, den=PopWithRace_2010_14, 
	                       num_moe=mPop18_34Years_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctPop18_34YearsH, label=% persons 18-34 years old &name., num=Pop18_34YearsH, den=PopHisp, years= 2010_14 )
	
	%Moe_prop_a( var=PctPop18_34YearsH_m_2010_14, mult=100, num=Pop18_34YearsH_2010_14, den=PopHisp_2010_14, 
	                       num_moe=mPop18_34YearsH_2010_14, den_moe=mPopHisp_2010_14 );


	%Pct_calc( var=PctPop35_64Years, label=% persons 35-64 years old &name., num=Pop35_64Years, den=PopWithRace, years= 2010_14 )
	
	%Moe_prop_a( var=PctPop35_64Years_m_2010_14, mult=100, num=Pop35_64Years_2010_14, den=PopWithRace_2010_14, 
	                       num_moe=mPop35_64Years_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctPop35_64YearsH, label=% persons 35-64 years old &name., num=Pop35_64YearsH, den=PopHisp, years= 2010_14 )
	
	%Moe_prop_a( var=PctPop35_64YearsH_m_2010_14, mult=100, num=Pop35_64YearsH_2010_14, den=PopHisp_2010_14, 
	                       num_moe=mPop35_64YearsH_2010_14, den_moe=mPopHisp_2010_14 );


	%Pct_calc( var=PctPop65andOverYears, label=% seniors &name., num=Pop65andOverYears, den=PopWithRace, years= 2010_14 )

    %Moe_prop_a( var=PctPop65andOverYrs_m_2010_14, mult=100, num=Pop65andOverYears_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPop65andOverYears_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctPop65andOverYearsH, label=% seniors &name., num=Pop65andOverYearsH, den=PopHisp, years= 2010_14 )

    %Moe_prop_a( var=PctPop65andOverYrsH_m_2010_14, mult=100, num=Pop65andOverYearsH_2010_14, den=PopHisp_2010_14, 
                       num_moe=mPop65andOverYearsH_2010_14, den_moe=mPopHisp_2010_14 );

	    ** Total births **;
    
	%Pct_calc( var=Pct_births_w_race, label=% Births with mothers race reported, num=births_w_race, den=births_total, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_black, label=% Births to non-Hisp. Black mothers, num=births_black, den=births_w_race, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_asian, label=% Births to non-Hisp. Asian/PI mothers, num=births_asian, den=births_w_race, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_hisp, label=% Births to Hispanic/Latino mothers, num=births_hisp, den=births_w_race, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_white, label=% Births to non-Hisp. White mothers, num=births_white, den=births_w_race, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_oth_rac, label=% Births to non-Hisp. other race mothers, num=births_oth_rac, den=births_w_race, from=&births_start_yr, to=&births_end_yr)

    ** Total births - 3-year averages **;

    %Pct_calc( var=Pct_births_black_3yr, label=% Total births, 3-year avg., num=births_total_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_black_3yr, label=% Births to non-Hisp. Black mothers, 3-year avg., num=births_black_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_asian_3yr, label=% Births to non-Hisp. Asian/PI mothers, 3-year avg., num=births_asian_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_hisp_3yr, label=% Births to Hispanic/Latino mothers, 3-year avg., num=births_hisp_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_white_3yr, label=% Births to non-Hisp. White mothers, 3-year avg., num=births_white_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_oth_rac_3yr, label=% Births to non-Hisp. other race mothers, 3-year avg., num=births_oth_rac_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr)

	    ** Total births with adequate prenatal care**;
	%Pct_calc( var=Pct_births_prenat_adeq, label=% Births to mothers with adequate prenatal care, num=births_prenat_adeq, den=births_w_prenat, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_prenat_adeq_blk, label=% Births to non-Hisp. Black mothers with adequate prenatal care, num=births_prenat_adeq_blk, den=births_w_prenat_blk, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_prenat_adeq_asn, label=% Births to non-Hisp. Asian/PI mothers with adequate prenatal care, num=births_prenat_adeq_asn, den=births_w_prenat_asn, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_prenat_adeq_hsp, label=% Births to Hispanic/Latino mothers with adequate prenatal care, num=births_prenat_adeq_hsp, den=births_w_prenat_hsp, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_prenat_adeq_wht, label=% Births to non-Hisp. White mothers with adequate prenatal care, num=births_prenat_adeq_wht, den=births_w_prenat_wht, from=&births_start_yr, to=&births_end_yr)
	%Pct_calc( var=Pct_births_prenat_adeq_oth, label=% Births to non-Hisp. other race mothers with adequate prenatal care, num=births_prenat_adeq_oth, den=births_w_prenat_oth, from=&births_start_yr, to=&births_end_yr)


	    ** Jobs and economic opportunity, 2014**;

	%Pct_calc( var=PctUnemployed, label=Unemployment rate (%), num=PopUnemployed, den=PopInCivLaborForce, years=2010_14 )

	%Moe_prop_a( var=PctUnemployed_m_2010_14, mult=100, num=PopUnemployed_2010_14, den=PopInCivLaborForce_2010_14, 
	                       num_moe=mPopUnemployed_2010_14, den_moe=mPopInCivLaborForce_2010_14 );

    %Pct_calc( var=Pct25andOverWoutHS, label=% persons without HS diploma, num=Pop25andOverWoutHS, den=Pop25andOverYears, years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWoutHS_m_2010_14, mult=100, num=Pop25andOverWoutHS_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWoutHS_2010_14, den_moe=mPop25andOverYears_2010_14 );

	%Pct_calc( var=Pct25andOverWHS, label=% persons with HS diploma, num=Pop25andOverWHS, den=Pop25andOverYears, years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWHS_m_2010_14, mult=100, num=Pop25andOverWHS_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWHS_2010_14, den_moe=mPop25andOverYears_2010_14 );

	%Pct_calc( var=Pct25andOverWSC, label=% persons  with some college, num=Pop25andOverWSC, den=Pop25andOverYears, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSC_m_2010_14, mult=100, num=Pop25andOverWSC_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWSC_2010_14, den_moe=mPop25andOverYears_2010_14 );

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");
		 
	%Pct_calc( var=PctUnemployed&race., label=&name. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=2010_14 )

	%Moe_prop_a( var=PctUnemployed&race._m_2010_14, mult=100, num=PopUnemployed&race._2010_14, den=PopInCivLaborForce&race._2010_14, 
	                       num_moe=mPopUnemployed&race._2010_14, den_moe=mPopInCivLaborForce&race._2010_14 );

    %Pct_calc( var=Pct25andOverWoutHS&race., label=% persons &name. without HS diploma, num=Pop25andOverWoutHS&race., den=Pop25andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWoutHS&race._m_2010_14, mult=100, num=Pop25andOverWoutHS&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWoutHS&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%Pct_calc( var=Pct25andOverWHS&race., label=% persons &name. with HS diploma, num=Pop25andOverWHS&race., den=Pop25andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWHS&race._m_2010_14, mult=100, num=Pop25andOverWHS&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWHS&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%Pct_calc( var=Pct25andOverWSC&race., label=% persons &name. with some college, num=Pop25andOverWSC&race., den=Pop25andOverYears&race., years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSC&race._m_2010_14, mult=100, num=Pop25andOverWSC&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWSC&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%end;

	%Pct_calc( var=PctEmployedMngmtH, label=Hispanic persons employed in management, business, science and arts occupations, num=PopEmployedMngmtH, den=PopEmployedByOccH, years=2010_14 )

	%Moe_prop_a( var=PctEmployedMngmtH_m_2010_14, mult=100, num=PopEmployedMngmtH_2010_14, den=PopEmployedByOccH_2010_14, 
	                       num_moe=mPopEmployedMngmtH_2010_14, den_moe=mPopEmployedByOccH_2010_14 );

	%Pct_calc( var=PctEmployedServH, label=Hispanic persons employed in service occupations, num=PopEmployedServH, den=PopEmployedByOccH, years=2010_14 )

	%Moe_prop_a( var=PctEmployedServH_m_2010_14, mult=100, num=PopEmployedServH_2010_14, den=PopEmployedByOccH_2010_14, 
	                       num_moe=mPopEmployedServH_2010_14, den_moe=mPopEmployedByOccH_2010_14 );

	%Pct_calc( var=PctEmployedSalesH, label=Hispanic persons employed in sales and office occupations, num=PopEmployedSalesH, den=PopEmployedByOccH, years=2010_14 )

	%Moe_prop_a( var=PctEmployedSalesH_m_2010_14, mult=100, num=PopEmployedSalesH_2010_14, den=PopEmployedByOccH_2010_14, 
	                       num_moe=mPopEmployedSalesH_2010_14, den_moe=mPopEmployedByOccH_2010_14 );
	
	%Pct_calc( var=PctEmployedNatResH, label=Hispanic persons employed in natural resources, construction, and maintenance occupations, num=PopEmployedNatResH, den=PopEmployedByOccH, years=2010_14 )

	%Moe_prop_a( var=PctEmployedNatResH_m_2010_14, mult=100, num=PopEmployedNatResH_2010_14, den=PopEmployedByOccH_2010_14, 
	                       num_moe=mPopEmployedNatResH_2010_14, den_moe=mPopEmployedByOccH_2010_14 );

	%Pct_calc( var=PctEmployedProdH, label=Hispanic persons employed in production, transportation, and material moving occupations, num=PopEmployedProdH, den=PopEmployedByOccH, years=2010_14 )

	%Moe_prop_a( var=PctEmployedProdH_m_2010_14, mult=100, num=PopEmployedProdH_2010_14, den=PopEmployedByOccH_2010_14, 
	                       num_moe=mPopEmployedProdH_2010_14, den_moe=mPopEmployedByOccH_2010_14 );

	    ** Reported Crimes (per 1,000 pop.) **;
    
    %Pct_calc( var=Rate_crimes_pt1_violent, label=Violent crimes, num=Crimes_pt1_violent, den=Crime_rate_pop, mult=1000, from=&crime_start_yr, to=&crime_end_yr )
    %Pct_calc( var=Rate_crimes_pt1_property, label=Property crimes, num=Crimes_pt1_property, den=Crime_rate_pop, mult=1000, from=&crime_start_yr, to=&crime_end_yr )

	    ** Housing **;    

	%Pct_calc( var=PctOwnerOccupiedHU, label=Homeownership rate &name.(%), num=NumOwnerOccupiedHU, den=NumOccupiedHsgUnits, years=2010_14 )

    %Moe_prop_a( var=PctOwnerOccupiedHU_m_2010_14, mult=100, num=NumOwnerOccupiedHU_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumOwnerOccupiedHU_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctOwnerOccupiedHU&race., label=Homeownership rate &name.(%), num=NumOwnerOccupiedHU&race., den=NumOccupiedHsgUnits&race., years=2010_14 )

    %Moe_prop_a( var=PctOwnerOccupiedHU&race._m_2010_14, mult=100, num=NumOwnerOccupiedHU&race._2010_14, den=NumOccupiedHsgUnits&race._2010_14, 
                       num_moe=mNumOwnerOccupiedHU&race._2010_14, den_moe=mNumOccupiedHsgUnits&race._2010_14 );
    
   	%end;

    %Pct_calc( var=PctOwnerOccHsgUnits, label=Homeownership rate (%), num=NumOwnerOccHsgUnits, den=NumOccupiedHsgUnits, years=2000 )
    %Pct_calc( var=PctOwnerOccHsgUnitsAsianPI, label=Homeownership rate Asian PI(%), num=NumOwnerOccHsgUnitsAsianPI, den=NumOccupiedHsgUnitsAsianPI, years=2000 )
    %Pct_calc( var=PctOwnerOccHsgUnitsBlack, label=Homeownership rate Black(%), num=NumOwnerOccHsgUnitsBlack, den=NumOccupiedHsgUnitsBlack, years=2000 )
    %Pct_calc( var=PctOwnerOccHsgUnitsHisp, label=Homeownership rate Hispanic(%), num=NumOwnerOccHsgUnitsHisp, den=NumOccupiedHsgUnitsHisp, years=2000 )
    %Pct_calc( var=PctOwnerOccHsgUnitsNHWhite, label=Homeownership rate NHWhite(%), num=NumOwnerOccHsgUnitsNHWhite, den=NumOccupiedHsgUnitsNHWhite, years=2000 )
    %Pct_calc( var=PctOwnerOccHsgUnitsOther, label=Homeownership rate Other (%), num=NumOwnerOccHsgUnitsOther, den=NumOccupiedHsgUnitsOther, years=2000 )


	    ** Create flag for generating profile **;
    
    if TotPop_2010_14 >= 100 then _make_profile = 1;
    else _make_profile = 0;
    
 
  run;
    
  %File_info( data=DCOLA.DCOLA_profile&geosuf, printobs=0, contents=n )
  
%end; 
  
%mend add_percents;

/** End Macro Definition **/

%add_percents; 
