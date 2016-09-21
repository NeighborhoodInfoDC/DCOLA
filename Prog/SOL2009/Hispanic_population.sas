**************************************************************************
 Program:  Hispanic_population.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   J. Comey
 Created:  07/28/09
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Created dataset by age by origin summed by race from Population Estimate data.
Downloaded Populatin Estimates dataset July 28 2009

 Modifications:
**************************************************************************/;


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
*%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( DCOLA )

proc contents data=DCOLA.dc_popprymid;run;
proc format;
  value ORIGIN
	0='Total'
	1='NonHisp'
	2='Hisp';

	value RACE
	1= 'White alone'
	2= 'Black alone'
	3= 'American Indian/Alaska Native Alone'
	4= 'Asian Alone'
	5= 'Native Hawaiian/Pacific Is Alone'
	6= '2 or More races';

	value SEX
	0='Total'
	1='Male'
	2='Female';
	run;

data DCpop_total (where=(sex=0));
	set DCOLA.dc_popprymid;
	where origin ne 0;
run;
data DCpopallrace_Hisp (where=(ORIGIN ne 0));
	set DCpop_total;
run;

proc sort data=DCpopallrace_Hisp ;
by age origin;
run;
proc summary data=DCpopallrace_Hisp;
var CENSUS2000POP popestimate2000 popestimate2001 popestimate2002 popestimate2003 popestimate2004 popestimate2005
	popestimate2006 popestimate2007 popestimate2008;
by age origin;
output out=DCOLA.DCPopbyorigin sum= ;
run;

data DCPopbyorigin_agecat; 
	set DCOLA.DCPopbyorigin ;

	if age <5 then agecat=1;
	else if age <=9 then agecat=2;
	else if age <=14 then agecat=3;	
	else if age <=19 then agecat=4;
	else if age <=24 then agecat=5;
	else if age <=29 then agecat=6;
	else if age <=34 then agecat=7;
	else if age <=39 then agecat=8;
	else if age <=44 then agecat=9;
	else if age <=49 then agecat=10;
	else if age <=54 then agecat=11;
	else if age <=59 then agecat=12;
	else if age <=64 then agecat=13;
	else if age <=69 then agecat=14;
	else if age <=74 then agecat=15;
	else if age <=79 then agecat=16;
	else if age <=84 then agecat=17;
	else if age >=85 then agecat=18;
run;
	proc format;
	value agecat 
	1= '0-4'
	2='5-9'
	3='10-14'
	4='15-19'
	5='20-24'
	6='25-29'
	7='30-34'
	8='35-39'
	9='40-44'
	10='45-49'
	11='50-54'
	12='55-59'
	13='60-64'
	14='65-69'
	15='70-74'
	16='75-79'
	17='80-84'
	18='85plus'
	.='missing';
	run;

proc sort data=DCPopbyorigin_agecat ;
by agecat origin;
run;
proc summary data=DCPopbyorigin_agecat;
var CENSUS2000POP popestimate2000 popestimate2001 popestimate2002 popestimate2003 popestimate2004 popestimate2005
	popestimate2006 popestimate2007 popestimate2008;
by agecat origin;
output out=DCOLA.DCPopbyorigin_agecat sum= ;
run;


**********Export Latino/NonLatino population by age cat over time*******************;

filename fexport "K:\Metro\PTatian\DCData\Libraries\DCOLA\Raw\Latinopop_agecat_2000_2008.csv" lrecl=2000;

proc export data=DCOLA.DCPopbyorigin_agecat
    outfile=fexport
    dbms=csv replace;

run;

filename fexport clear;
run;

signoff;
