
**************************************************************************
Program: OLA_1980_race_citywide.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/01/2009
Modified: 06/02/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Number of people by Race in DC, 1980
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
data ncdb80_race; 
set ncdb.Ncdb_1980_2000_dc  (keep= geo2000 
		shr8d  shrhsp8n shrnhb8n shrnhj8n shrnhw8n 
		); 
	run;

data ola_1980_race;
set ncdb80_race;
    latino = shrhsp8n; 
	white = shrnhw8n;
	black = shrnhb8n;
	other = shrnhj8n;
	denom = shr8d;
	drop shr8d  shrhsp8n shrnhb8n shrnhj8n shrnhw8n; 
	run;

proc download inlib=work outlib=dcola; 
select ola_1980_race; 
run;

endrsubmit;

proc summary data=dcola.ola_1980_race;
var latino white black other denom;
output out=olatotal sum=;
run;



filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\1980_race_citywide.csv" lrecl=2000;
proc export data=olatotal
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
