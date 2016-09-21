***************************
* Name: FT_YearRound_0507.sas
* Author: L. Freiman
* Created: 9/28/2009
* Updated:		
* Description: People 16+ working Full-Time and Year Round or not
* by race/ethnicity, 2005-2007, DC
******************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;

*/ Pulls ACS File Variables, creates race/ethnicity categories, limits to people 16+,
creates dichotomous Employed/Not employed variable and a dichotomous 
full-time/year-round work variable/*;

data Acs_2005_07_dc;
set ipums.Acs_2005_07_dc (keep = Serial HISPAN RACE HHWT PERWT PERNUM AGE OCC 
	WKSWORK1 UHRSWORK where=(AGE>=16)); 

If HISPAN in (1:4) then LATINO = 1;
	else LATINO = 2;

If RACE = 1 then RACE_NEW = 1; 
	else if RACE = 2 then RACE_NEW = 2;
	else if RACE = 3 then RACE_NEW = 3;
	else if RACE in (4:6) then RACE_NEW = 4;
	else RACE_NEW = 5;

If (RACE_NEW = 1 and LATINO = 2) then RACE_ETH = 'White, Non-Hispanic';
	else if (RACE_NEW = 2 and LATINO = 2) then RACE_ETH = 'Black, Non-Hispanic';
	else if LATINO = 1 then RACE_ETH = 'Latino or Hispanic';
	else RACE_ETH = 'Other Race, Non-Hispanic';	

IF OCC in(0,992) then EMPLOYED = 0;
	else EMPLOYED =1;

If WKSWORK1 >=50 and UHRSWORK >=35 then FT_YearRound =1;
	else FT_YearRound =0; 

Drop OCC; 
Drop HISPAN;
Drop RACE;

TOTSAMP =1;

run;

*/ Downloads ACS data set /*;

proc download inlib=work outlib=dcola;
select Acs_2005_07_dc ;
run;

endrsubmit;


*/ Gives average employed persons per HH by Race/Ethnicity of household head /*;

proc summary data=dcola.Acs_2005_07_dc chartype;
var TOTSAMP;
class RACE_ETH EMPLOYED FT_YearRound;
weight PERWT;
output out=dcola.YearRound_FT_0507 sumwgt=;
run;

*/ exports sas data set to spreadsheet /*;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\YearRound_FT_0507.csv" lrecl=5000;
proc export data=DCOLA.YearRound_FT_0507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;





 
