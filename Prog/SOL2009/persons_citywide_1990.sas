
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
		shr9d shrhsp9n shrnhb9n shroth9n shrnhw9n shrnha9n shrnhi9n 
		); 
	run;

data ola_1990_race;
set ncdb90_race;
    latino = shrhsp9n ;
	black = shrnhb9n ; 
	white = shrnhw9n ;
	asian = shrnha9n ;
	ntv_american = shrnhi9n ; 
	other = shroth9n ;
	denom = shr9d ;
	drop shr9d shrhsp9n shrnhb9n shroth9n shrnhw9n shrnha9n shrnhi9n ; 
	run;

proc download inlib=work outlib=dcola; 
select ola_1990_race; 
run;

endrsubmit;

proc summary data=dcola.ola_1990_race;
var latino white black asian ntv_american other denom;
output out=olatotal90 sum=;
run;



filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\1990_race_citywide.csv" lrecl=2000;
proc export data=olatotal90
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
