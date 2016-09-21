
**************************************************************************
Program: OLA_2000_race_citywide.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/01/2009
Modified: 06/02/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Number of people by Race in DC, 2000
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
data ncdb00_race; 
set ncdb.Ncdb_lf_2000_dc   (keep= geo2000 
		shr0d shrhsp0n shrnhb0n shrnhw0n shrnha0n shrnhi0n shrnho0n   
		); 
	run;

data ola_2000_race;
set ncdb00_race;
    latino = shrhsp0n ;
	black = shrnhb0n ; 
	white = shrnhw0n ;
	asian = shrnha0n ;
	ntv_american = shrnhi0n ; 
	other = shrnho0n ;
	denom = shr0d ;
	drop  shr0d shrhsp0n shrnhb0n shrnhw0n shrnha0n shrnhi0n shrnho0n; 
	run;

proc download inlib=work outlib=dcola; 
select ola_2000_race; 
run;

endrsubmit;

proc summary data=dcola.ola_2000_race;
var latino white black asian ntv_american other denom;
output out=olatotal00 sum=;
run;



filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\2000_race_citywide.csv" lrecl=2000;
proc export data=olatotal00
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
