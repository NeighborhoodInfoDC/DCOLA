******************
Name: Basic Demographics of ACS.sas
Author: M. Grosz
Updated: 3/9/09
		
Purpose: Looks at basic demographics of ACS in 2007 to look at renting and income
******************;

%include "K:\Metro\KPettit\HNC2009\programs\rentals\reading_data_in.sas";

libname ipumsdat 'D:\HNC\Data';



%macro demographics (met, ami);
data rentals_&met.;
	set ipumsdat.dc_and_four_cities_42709;
	where metarea = &met.;
	if 0< poverty < 100 then poverty_dummy = 1;
		else poverty_dummy = 0;
	if hhincome < &ami.*.3 then ami_30 = 1;
		else ami_30 = 0;
	if hhincome < &ami.*.5 then ami_50 = 1;
		else ami_50 = 0;
	monthlyincome = hhincome / 12;
		if  rent / monthlyincome >= .3 then burden30 = 1;
			else burden30 = 0;
		if  rent / monthlyincome >= .5 then burden50 = 1;
			else burden50 = 0;
	label poverty_dummy = "Living under 100% of poverty threshold"
			ami_30 = "Income under 30% of AMI"
			ami_50 = "Income under 50% of AMI"
			burden30 = "Spending more than 30% of income on rent"
			burden50 = "Spending more than 50% of income on rent";
run;


proc sort data = rentals_&met. nodupkey out = rentals_hhlds&met.;
	by serial;
	run;
%mend;


%demographics (884, 83200 ); *Washington;
%demographics (052, 57189); *Atlanta;
%demographics (112, 68142); *Boston;
%demographics (336, 52988); *Houston;
%demographics (760, 63895); *Seattle;


%macro output (met, city);
proc freq data = rentals_hhlds&met.;
	table
 	ownershp/*% and number of households that rent*/;
	title "ACS 2007 &city. Area";
	weight hhwt ;
	run;
proc freq data = rentals_hhlds&met.;
	where ownershp = 2;
	table
	poverty_dummy/*% renter households under poverty*/;
	title2 "Renter Households under Poverty";
	weight HHWT ;
	run;
proc freq data = rentals_hhlds&met.;
	where ownershp = 2;
	table	ami_30/*% renter households with annual income under 30% of AMI*/
			ami_50/*% renter households with annual income under 50% of AMI*/;
	title2 "Renter households with annual income under 30% and 50% of AMI";
	weight HHWT ;
	run;
proc freq data = rentals_hhlds&met.;
	where ownershp = 2 ;
	table	burden30/*% renter households spending 30% + on rent*/
			burden50/*% renter households spending 50% + on rent*/;
	weight HHWT ;
	title2 "Renter Households Spending 30% or 50% on rent";
	run;
proc freq data = rentals_hhlds&met.;
	where ownershp = 2 and ami_30 = 1;
	table	burden30/*% renter households spending 30% + on rent*/
			burden50/*% renter households spending 50% + on rent*/;
	weight HHWT ;
	title2 "Renter Households under 30% of AMI Spending 30% or 50% on rent";
	run;
proc freq data = rentals_hhlds&met.;
	where ownershp = 2 and ami_50 = 1;;
	table	burden30/*% renter households spending 30% + on rent*/
			burden50/*% renter households spending 50% + on rent*/;
	weight HHWT ;
	title2 "Renter Households under 50% of AMI Spending 30% or 50% on rent";
	run;
/*Average rent by bedroom size*/;
proc means data = rentals_hhlds&met.;
	class bedrooms;
	var rent;
	where ownershp = 2;
	weight HHWT ;
	title2 "Mean Rent";

	run;
/*Median rent by bedroom size*/
proc means median data = rentals_hhlds&met.;
	class bedrooms;
	var rent;
	where ownershp = 2;
	weight HHWT ;
	title2 "Median Rent";
	run;


%mend;




ods html file="K:\Metro\KPettit\HNC2009\tables\rent\ACS demographics hhweights 042909.xls" ;
%output (884, Washington); 
%output (052, Atlanta);
%output (112,Boston); 
%output (760,Seattle);
%output (336,Houston);
ods html close; 




