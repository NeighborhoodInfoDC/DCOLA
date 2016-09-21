/*******************************************
* Program: HH_TYPE_LATINO.sas
* Library: DCOLA
* Project: Latino Databook
* Author: Lesley Freiman
* Created: 09/02/2009
* Modified: 
* Version: SAS 9.1
* Environment: Windows with SAS/Connect
* Description: 
* Modifications:
********************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;

data Latino_HH_Type_UW; 
set IPUMS.Acs_2005_07_dc   (keep= PERWT HISPAN HHTYPE);
If HISPAN in (1:4) then LATINO = 'Latino';
	else LATINO = 'Not Latino';
HHTYPE_F=PUT(HHTYPE,HHTYPE_F.);
TOTSAMP = 1;
Run;

proc download inlib=work outlib=dcola; 
select Latino_HH_Type_UW;
run;

endrsubmit;	


proc summary data=dcola.Latino_HH_Type_UW chartype;
      var TOTSAMP;
      class  LATINO HHTYPE_F;
	  weight PERWT;
      output out=DCOLA.Latino_HH_Type_0507 sumwgt=;
run;


filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\Latino_HH_Type_0507.csv" lrecl=5000;
proc export data=DCOLA.Latino_HH_Type_0507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
