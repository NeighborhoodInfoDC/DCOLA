/**************************************************************************
 Program:  DCOLA_profile_transpose.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/23/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Transposes calculated indicators for SOL Profiles profiles 
			   and merges calculated statistics for ACS, Vital, NCBD, and Police data at different geographies.
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( DCOLA )


data dcola.clusters;
	set dcola.dcola_profile_city
			dcola.dcola_profile_cltr00;
			_make_profile=1;
run; 

data dcola.city_ward;
	set dcola.dcola_profile_city
			dcola.dcola_profile_wd12;

			if city=1 then ward2012=0;
			_make_profile=1;

run; 

proc transpose data=dcola.clusters out=dcola.sol_clusters; 
var PctHisp_:;
id cltr00; 
run; 

proc transpose data=dcola.clusters out=dcola.sol_crime_hispnghbd_2000; 
var Rate_crimes_pt1_violent: Rate_crimes_pt1_property: ;
where PctHisp_2000 >= 20;
id cltr00; 
run; 

proc transpose data=dcola.clusters out=dcola.sol_crime_hispnghbd_2010_14; 
var Rate_crimes_pt1_violent: Rate_crimes_pt1_property: ;
where PctHisp_2010_14 >= 20;
id cltr00; 
run; 

proc transpose data=dcola.city_ward out=dcola.sol_pres; 
var PopBlackNonHispBridge: PopWhiteNonHispBridge:
	PopHisp_: PopAsnPINonHispBridge: PopOtherRace: PopOthRace:

	PctHispMexican: PctHispPuertoRican:
	PctHispCuban: PctHispDominican:
	PctHispOtherCentAmer: PctHispOtherSouthAmer: 
	PctHispOtherHispOrig: PctHispArgentinean: 
	PctHispBolivian: PctHispChilean: 
	PctHispColombian: PctHispCostaRican:
	PctHispEcuadorian: PctHispElSalvadoran: 
	PctHispGuatemalan: PctHispHonduran: 
	PctHispNicaraguan: PctHispPananamian: 
	PctHispPeruvian: 

	PctForeignBorn: PctNativeBorn: PctCitizen:
	PctNaturalized: PctNonCitizen: PctNonEnglish:

	PctPopUnder18Years: PctPop18_24Years:
	PctPop25_64Years: PctPop65andOverYears:
 
	Pct_births_w_race: Pct_births_black:
	Pct_births_asian: Pct_births_hisp:
	Pct_births_white: Pct_births_oth_rac:

	PctUnemployedW: PctUnemployedB:
	PctUnemployedH: PctUnemployedAIOM:

	Pct25andOverWoutHSW: Pct25andOverWoutHSB:
	Pct25andOverWoutHSH: Pct25andOverWoutHSAIOM: 

	Pct25andOverWHSW: Pct25andOverWHSB:   
	Pct25andOverWHSH: Pct25andOverWHSAIOM:

	Pct25andOverWSCW: Pct25andOverWSCB: 
	Pct25andOverWSCH: Pct25andOverWSCAIOM: 

	PctEmployedMngmtH: PctEmployedServH: 
	PctEmployedSalesH: PctEmployedNatResH: 
	PctEmployedProdH: 

	AvgHshldIncAdjB: AvgHshldIncAdjW: 
	AvgHshldIncAdjH: AvgHshldIncAdjAIOM: 

	PctOwnerOccupiedHUW: PctOwnerOccupiedHUB: 
	PctOwnerOccupiedHUH: PctOwnerOccHsgUnitsHisp:
	PctOwnerOccupiedHUAIOM:

	Pct_births_prenat_adeq: Pct_births_prenat_adeq_blk:
	Pct_births_prenat_adeq_asn Pct_births_prenat_adeq_hsp:
	Pct_births_prenat_adeq_wht: Pct_births_prenat_adeq_oth:

	PctOnlyEnglishH: PctSpanishH:
	PctEngVeryWellH: PctEngWellH:
	PctEngNotWellH: PctNoEnglishH:
	PctEngLessThanVeryWellH: PctOtherLangH:
 ;
id ward2012; 
run; 

proc export data=dcola.sol_pres
	outfile="D:\DCDATA\Libraries\DCOLA\Prog\profile_SOL2017.csv"
	dbms=csv replace;
	run;

proc export data=dcola.sol__clusters
	outfile="D:\DCDATA\Libraries\DCOLA\Prog\LatinoPop_cluster.csv"
	dbms=csv replace;
	run;

proc export data=dcola.sol_crime_hispnghbd_2000
	outfile="D:\DCDATA\Libraries\DCOLA\Prog\crime_LatinoNghbds.csv"
	dbms=csv replace;
	run;

proc export data=dcola.sol_crime_hispnghbd_2010_14
	outfile="D:\DCDATA\Libraries\DCOLA\Prog\crime_LatinoNghbds.csv"
	dbms=csv replace;
	run;
