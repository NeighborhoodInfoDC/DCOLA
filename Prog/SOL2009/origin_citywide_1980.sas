
**************************************************************************
Program: origin_citywide_1980.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/01/2009
Modified: 06/03/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Number of people by national origin, 1980
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
data ncdb80_origin; 
set ncdb.Ncdb_1980_2000_dc   (keep= geo2000 
	 cuban8 mexic8 prican8 nonhisp8 othhisx8
		); 
	run;


proc download inlib=work outlib=dcola; 
select ncdb80_origin; 
run;

endrsubmit;


data dcola.ola1980_origin;
set dcola.ncdb80_origin;
	cuba= cuban8 ;
	mexico= mexic8 ;
	puerto_rico= prican8 ;
	not_hisp_origin = nonhisp8;
	other_hispan_origin = othhisx8 ;

	drop cuban8 mexic8 prican8 nonhisp8 othhisx8; 
	run;
proc summary data=dcola.ola1980_origin;
var cuba
	mexico
	puerto_rico
	not_hisp_origin 
	other_hispan_origin 
	;
output out=dcola.origin1980_citywide sum=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\origin_citywide_1980.csv" lrecl=2000;
proc export data=dcola.origin1980_citywide
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
