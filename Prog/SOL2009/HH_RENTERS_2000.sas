******************
Name: HH_Renters_2000.sas
Author: L. Freiman
Updated: 8/26/2009
		
Purpose: Looks at basic demographics for householderss in 2000 ipums to look at renting and income
******************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;


data HH_rental_2000IPUMS_UW;
set IPUMS.IPUMS_2000_dc   (keep= HHWT HISPAND racgen00 SEX RENT HHINCOME 
			OWNERSHD POVERTY PUMA PERWT PERNUM where =(PERNUM =1));

If HISPAND in (1:498) then LATINO = 1;
	else LATINO = 2;

If racgen00 = 1 then RACE_NEW = 1; 
	else if racgen00 = 2 then RACE_NEW = 2;
	else if racgen00 = 3 then RACE_NEW = 3;
	else if racgen00 in (6:7) then RACE_NEW = 4;
	else RACE_NEW = 5;

If (RACE_NEW = 1 and LATINO = 2) then RACE_ETH = 'White, Non-Hispanic';
	else if (RACE_NEW = 2 and LATINO = 2) then RACE_ETH = 'Black, Non-Hispanic';
	else if (RACE_NEW = 4 and LATINO = 2) then RACE_ETH = 'Asian, Non-Hispanic';
	else if LATINO = 1 then RACE_ETH = 'Latino or Hispanic';
	else RACE_ETH = 'Other Race, Non-Hispanic';	

If 0< poverty < 100 then poverty_dummy = 1;
		else poverty_dummy = 0;

Monthlyincome = (hhincome / 12);

If  (rent / (monthlyincome + .0000000000000001)) >= .3 then burden30 = 1;
	else burden30 = 0;

If Ownershd =0 or ownershd = 21 then Own =  0;
	else if Ownershd in (12:13) then Own = 1;
	else Own = 2;

If  (rent / (monthlyincome + .0000000000001)) >= .5 then burden50 = 1;
	else burden50 = 0;

	label poverty_dummy = "Living under 100% of poverty threshold"
			burden30 = "Spending more than 30% of income on rent"
			burden50 = "Spending more than 50% of income on rent";
TOTSAMP = 1;

run;


proc download inlib=work outlib=dcola; 
select HH_rental_2000IPUMS_UW; 
run;

endrsubmit;	

proc summary data=dcola.HH_rental_2000IPUMS_UW chartype;
      var TOTSAMP;
      class  RACE_ETH BURDEN30 BURDEN50 OWN POVERTY_DUMMY ;
	  weight HHWT;
      output out=DCOLA.HH_RENTAL_2000_IPUMS sumwgt=;
run;
filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HH_RENTAL_DATA_ACS_2000.csv" lrecl=5000;
proc export data=DCOLA.HH_RENTAL_2000_IPUMS
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;



proc summary data=dcola.HH_rental_2000IPUMS_UW;
	where OWN = 2;
	var RENT;
	class RACE_ETH ;
	Weight HHWT;
	output out=DCOLA.HH_RENTAL_MEDIAN_2000_IPUMS median=;
run;
filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HH_RENTAL_MEDIAN_ACS_2000.csv" lrecl=5000;
proc export data=DCOLA.HH_RENTAL_MEDIAN_2000_IPUMS
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;



proc summary data=dcola.rental_2000IPUMS_UW;
	where OWN = 2;
	var RENT;
	class RACE_ETH BURDEN30 BURDEN50 POVERTY_DUMMY;
	Weight HHWT;
	output out=DCOLA.HH_RENTAL_MEDIAN2_2000_IPUMS median=;
run;
filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HH_RENTAL_MEDIAN2_ACS_2000.csv" lrecl=5000;
proc export data=DCOLA.HH_RENTAL_MEDIAN2_2000_IPUMS
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;





proc freq data = dcola.HH_rental_05_07_UW;
	table
 	ownershp/*% and number of households that rent*/;
	title "ACS 200507 Ownership";
	weight hhwt ;
	run;
proc freq data = dcola.rental_05_07_UW;
	where ownershp = 2;
	table
	poverty_dummy/*% renter households under poverty*/;
	by RACE_ETH;
	title2 "Renter Households under Poverty";
	weight HHWT ;
	run;

proc freq data = dcola.rental_05_07_UW;
	where ownershp = 2 ;
	table	burden30/*% renter households spending 30% + on rent*/
			burden50/*% renter households spending 50% + on rent*/;
	weight HHWT ;
	title2 "Renter Households Spending 30% or 50% on rent";
	run;
proc freq data = dcola.rental_05_07_UW;
	where ownershp = 2 and ami_30 = 1;
	table	burden30/*% renter households spending 30% + on rent*/
			burden50/*% renter households spending 50% + on rent*/;
	weight HHWT ;
	title2 "Renter Households under 30% of AMI Spending 30% or 50% on rent";
	run;
proc freq data = dcola.rental_05_07_UW;
	where ownershp = 2 and ami_50 = 1;;
	table	burden30/*% renter households spending 30% + on rent*/
			burden50/*% renter households spending 50% + on rent*/;
	weight HHWT ;
	title2 "Renter Households under 50% of AMI Spending 30% or 50% on rent";
	run;
/*Average rent by bedroom size*/;
proc means data = dcola.rental_05_07_UW;
	class bedrooms;
	var rent;
	where ownershp = 2;
	weight HHWT ;
	title2 "Mean Rent";

	run;
/*Median rent by bedroom size*/
proc means median data = dcola.rental_05_07_UW;
	class bedrooms;
	var rent;
	where ownershp = 2;
	weight HHWT ;
	title2 "Median Rent";
	run;







