
**************************************************************************
Program: OLA_1990_race_citywide.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/01/2009
Modified: 06/02/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Number of people by Race in DC, 1990
			 standardized to 2000 census tracts/2002wards
Modifications:

**************************************************************************/;


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( Ncdb );
%DCData_lib( DCOLA );
%DCData_lib( General );


rsubmit;

*/creates a file by race and age on alpha - temp */;
data ncdb90_race; 
set ncdb.Ncdb_1990_2000_dc  (keep= geo2000 
		shr9d shrhsp9n shrnhb9n shrnho9n shrnhw9n shrnha9n shrnhi9n 
		); 
	run;

data ola_1990_race;
set ncdb90_race;
    latino = shrhsp9n ;
	black = shrnhb9n ; 
	white = shrnhw9n ;
	asian = shrnha9n ;
	ntv_american = shrnhi9n ; 
	other = shrnho9n ;
	denom = shr9d ;
	drop shr9d shrhsp9n shrnhb9n shrnho9n shrnhw9n shrnha9n shrnhi9n ; 
	run;

/* transforms tracts to wards */;

%Transform_geo_data(
    dat_ds_name = ola_1990_race,
    dat_org_geo = geo2000, 

	dat_count_vars = latino white black asian ntv_american other denom,

	wgt_ds_name = general.wt_tr00_ward02,
	wgt_org_geo=geo2000,
	wgt_new_geo=ward2002,
    wgt_wgt_var = popwt,
	
    out_ds_name = persons_ward_1990,
    out_ds_label = DC residents by race by ward   
  );
run;

proc download inlib=work outlib=dcola; 
select persons_ward_1990; 
run;

endrsubmit;


filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\persons_ward_1990.csv" lrecl=2000;
proc export data=dcola.persons_ward_1990
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
