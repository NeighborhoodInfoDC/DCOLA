
**************************************************************************
Program: origin_citywide_2000.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/01/2009
Modified: 06/03/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Number of people by national origin , 2000
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
data ncdb00_origin; 
set ncdb.Ncdb_lf_2000_dc   (keep= geo2000 
	argntn0 boliva0 chile0 colomb0 cosric0 cuban0 domin0 ecuad0 
	guatem0 hondur0 mexic0 nicarag0 panama0 paragy0 peru0 
	prican0 salvad0 urguay0 venzul0  

	othcam0 othcax0 othsam0 othsax0 othhisp0 othcam0 othcax0 
	nonhisp0 outborn0 forborn0 forbczn0 forbnoc0 shrfor0
		); 
	run;

proc download inlib=work outlib=dcola; 
select ncdb00_origin; 
run;

endrsubmit;


data dcola.ola2000_origin;
set dcola.ncdb00_origin;
	argentina= argntn0 ;
	bolivia= boliva0 ; 
	chile = chile0 ;
	colombia= colomb0 ;
	costa_rico= cosric0 ;
	cuba= cuban0 ;
	dominican= domin0 ;
	central_american1990= othcam0 ;
	central_america2000= othcax0 ;
	ecuador= ecuad0 ;
	gautemalo= guatem0 ;
	hondorus= hondur0 ;
	mexico= mexic0 ;
	nicaragua=nicarag0 ;
	panamanian= panama0 ;
	paraguay= paragy0 ;
	peru= peru0 ;
	puerto_rico= prican0 ;
	el_salvidor= salvad0 ;
	uruguay= urguay0 ;
	venesuela= venzul0 ;
	south_american1990= othsam0 ;
	south_american2000= othsax0 ;
	other_hisp_origin= othhisp0 ;
	other_centralamerican1990 = othcam0 ;
	other_centralamerican2000 = othcax0 ;
	not_hisp_origin = nonhisp0 ;
	bornoutside_notforeign = outborn0 ;
	foreignborn_tot= forborn0 ;
	foreignborn_naturalized= forbczn0 ;
	foreignborn_nonnaturalized= forbnoc0 ; 
	pop_proportion_foreignborn= shrfor0 ;

	drop argntn0 boliva0 chile0 colomb0 cosric0 cuban0 domin0 ecuad0 
	guatem0 hondur0 mexic0 nicarag0 panama0 paragy0 peru0 
	prican0 salvad0 urguay0 venzul0 
	othcam0 othcax0 othsam0 othsax0 othhisp0 othcam0 othcax0 
	nonhisp0 outborn0 forborn0 forbczn0 forbnoc0 shrfor0; 
	run;

	proc summary data=dcola.ola2000_origin;
var argentina
	bolivia
	chile
	colombia
	costa_rico
	cuba
	dominican
	central_american1990
	central_america2000
	ecuador
	gautemalo
	hondorus
	mexico
	nicaragua
	panamanian
	paraguay
	peru
	puerto_rico
	el_salvidor
	uruguay
	venesuela
	south_american1990
	south_american2000
	other_hisp_origin
	other_centralamerican1990
	other_centralamerican2000
	not_hisp_origin
	bornoutside_notforeign
	foreignborn_tot
	foreignborn_naturalized
	foreignborn_nonnaturalized 
	pop_proportion_foreignborn
	;
output out=dcola.origin2000_citywide sum=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\origin_citywide_2000.csv" lrecl=2000;
proc export data=dcola.origin2000_citywide
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
