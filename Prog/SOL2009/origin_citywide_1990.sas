
**************************************************************************
Program: origin_citywide_1990.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/01/2009
Modified: 06/03/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Number of people by national origin, 2000
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
data ncdb90_origin; 
set ncdb.Ncdb_1990_2000_dc   (keep= geo2000 
	 colomb9 cuban9 domin9 othcam9 ecuad9 guatem9 hondur9 
	mexic9 nicarag9 panama9 peru9 prican9 salvad9 
	othsam9 othhisp9 othcam9 nonhisp9 outborn9 
	forborn9 shrfor9 
		); 
	run;


proc download inlib=work outlib=dcola; 
select ncdb90_origin; 
run;

endrsubmit;

	data dcola.ola1990_origin;
set dcola.ncdb90_origin;
	colombia= colomb9 ;
	cuba= cuban9 ;
	dominican= domin9 ;
	central_american1990= othcam9 ;
	ecuador= ecuad9 ;
	gautemalo= guatem9 ;
	hondorus= hondur9 ;
	mexico= mexic9 ;
	nicaragua=nicarag9 ;
	panamanian= panama9 ;
	peru= peru9 ;
	puerto_rico= prican9 ;
	el_salvidor= salvad9 ;
	other_south_american1990= othsam9 ;
	other_hisp_origin= othhisp9 ;
	other_centralamerican1990 = othcam9 ;
	not_hisp_origin = nonhisp9 ;
	bornoutside_notforeign = outborn9 ;
	foreignborn_tot= forborn9 ;
	pop_proportion_foreignborn= shrfor9 ;

	drop colomb9 cuban9 domin9 othcam9 ecuad9 guatem9 hondur9 
	mexic9 nicarag9 panama9 peru9 prican9 salvad9 
	othsam9 othhisp9 othcam9 nonhisp9 outborn9 
	forborn9 shrfor9 ; 
	run;

	proc summary data=dcola.ola1990_origin;
var colombia
	cuba
	dominican
	central_american1990
	ecuador
	gautemalo
	hondorus
	mexico
	nicaragua
	panamanian
	peru
	puerto_rico
	el_salvidor
	other_south_american1990
	other_hisp_origin
	other_centralamerican1990 
	not_hisp_origin 
	bornoutside_notforeign 
	foreignborn_tot
	pop_proportion_foreignborn
	;
output out=dcola.origin1990_citywide sum=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\origin_citywide_1990.csv" lrecl=2000;
proc export data=dcola.origin1990_citywide
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
