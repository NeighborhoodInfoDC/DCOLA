***************************
* Name: Employed_HH_0507.sas
* Author: L. Freiman
* Created: 9/23/2009
* Updated:		
* Description: Average number of adults and employed adults per household, 
by Latino/Not Latino, 2005-2007, DC
******************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;

*/ Pulls ACS File Variables, creates dichotomous Latino/Non-Latino variable, 
creates dochotomous Employed/Not employed variable /*;

data Acs_2005_07_dc;
set ipums.Acs_2005_07_dc (keep = Serial HISPAN RACE HHWT PERWT PERNUM AGE OCC); 

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

	IF OCC in(0,992) or AGE <16 then EMPLOYED = 0;
	else EMPLOYED =1;

Drop OCC; 
Drop HISPAN;
Drop RACE;
run;

*/ Downloads ACS data set /*;

proc download inlib=work outlib=dcola;
select Acs_2005_07_dc ;
run;

endrsubmit;

*/ Sorts the two dataset /*;

proc sort data=dcola.Acs_2005_07_dc out=dcola.Acs_2005_07_dc_sort;
by serial;
run;

*/ sums earner dummy variable by household /*;

proc summary data=dcola.Acs_2005_07_dc_sort;
var employed;
class serial;
output out=DCOLA.Employed_Per_HH sum=;
run;

*/ Renames Employed stat to better describe new per HH identity /*;

data DCOLA.Employed_Per_HH_RName;
set DCOLA.Employed_Per_HH (Keep= EMPLOYED SERIAL);
Rename Employed = Employed_PerHH;
Run; 

proc sort data=DCOLA.Employed_Per_HH_RName out=DCOLA.Employed_Per_HH_sort2;
by serial;
run;

*/ Merges the Earners Per Household Data onto the ACS Data /*;

data dcola.HH_Merge_0507_Earners;
merge dcola.Acs_2005_07_dc_sort DCOLA.Employed_Per_HH_sort2;
by serial;
if serial ne .;
run;

*/ Limits Data to Heads of Household /*;

data dcola.Earners_HH_with_HeadHouse; 
set dcola.HH_Merge_0507_Earners (keep= SERIAL PERNUM HHWT RACE_ETH 
EMPLOYED_PERHH where =(PERNUM =1));
run;


proc sort data=dcola.Earners_HH_with_HeadHouse 
out=dcola.Earners_HH_with_HeadHouse_sort;
by RACE_ETH;
run; 


*/ Gives average employed persons per HH by Race/Ethnicity of household head /*;

proc summary data=dcola.Earners_HH_with_HeadHouse_sort;
var EMPLOYED_PERHH;
class RACE_ETH;
weight HHWT;
output out=dcola.Household_Earners_byrace mean=;
run;





 
