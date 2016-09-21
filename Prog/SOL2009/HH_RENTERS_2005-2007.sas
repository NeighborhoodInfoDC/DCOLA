******************
Name: Renters.sas
Author: L. Freiman
Updated: 8/26/2009
		
Purpose: Looks at Race/Ethnicity and Basic Demographics of Heads of Households 2005-2007 to look at renting and income
******************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( Ncdb );
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;


data HH_rental_05_07_UW;
set IPUMS.Acs_2005_07_dc   (keep= HHWT HISPAN RACE SEX RENT HHINCOME PERNUM 
			OWNERSHP POVERTY PUMA PERWT where =(PERNUM =1));

If HISPAN in (1:4) then LATINO = 1;
	else LATINO = 2;

If RACE = 1 then RACE_NEW = 1; 
	else if RACE = 2 then RACE_NEW = 2;
	else if RACE = 3 then RACE_NEW = 3;
	else if RACE in (4:6) then RACE_NEW = 4;
	else RACE_NEW = 5;

If (RACE_NEW = 1 and LATINO = 2) then RACE_ETH = 'White, Non-Hispanic';
	else if (RACE_NEW = 2 and LATINO = 2) then RACE_ETH = 'Black, Non-Hispanic';
	else if (RACE_NEW = 4 and LATINO = 2) then RACE_ETH = 'Asian, Non-Hispanic';
	else if LATINO = 1 then RACE_ETH = 'Latino or Hispanic';
	else RACE_ETH = 'Other Race, Non-Hispanic';	

If (0< poverty < 100) then poverty_dummy = 1;
		else poverty_dummy = 0;

Monthlyincome = (hhincome /12);

If  (rent / (monthlyincome +.0000000000000001)) >= .3 then burden30 = 1;
	else burden30 = 0;

If  (rent / (monthlyincome + .0000000000000001)) >= .5 then burden50 = 1;
	else burden50 = 0;

	label poverty_dummy = "Living under 100% of poverty threshold"
			burden30 = "Spending more than 30% of income on rent"
			burden50 = "Spending more than 50% of income on rent";
TOTSAMP = 1;

run;


proc download inlib=work outlib=dcola; 
select HH_rental_05_07_UW; 
run;

endrsubmit;	

proc summary data=dcola.HH_rental_05_07_UW chartype;
      var TOTSAMP;
      class  BURDEN30 BURDEN50 OWNERSHP RACE_ETH Poverty_Dummy;
	  weight HHWT;
      output out=DCOLA.HH_RENTAL_200507 sumwgt=;
run;
filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HH_RENTAL_DATA_ACS_05-07.csv" lrecl=5000;
proc export data=DCOLA.HH_RENTAL_200507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;


	proc summary data=dcola.HH_rental_05_07_UW;
	where OWNERSHP = 2;
	var RENT;
	class RACE_ETH ;
	Weight HHWT;
	output out=DCOLA.HH_RENTAL_MEDIAN_200507 median=;
run;
filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HH_RENTAL_MEDIAN_ACS_200507.csv" lrecl=5000;
proc export data=DCOLA.HH_RENTAL_MEDIAN_200507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;


proc summary data=dcola.HH_rental_05_07_UW;
	where OWNERSHP = 2;
	var RENT;
	class RACE_ETH BURDEN30 BURDEN50 POVERTY_DUMMY;
	Weight HHWT;
	output out=DCOLA.HH_RENTAL_MEDIAN2_200507 median=;
run;
filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HH_RENTAL_MEDIAN2_ACS_200507.csv" lrecl=5000;
proc export data=DCOLA.HH_RENTAL_MEDIAN2_200507
	outfile=fexport 
	dbms=csv replace;
	run;
	filename fexport clear;
	run;


