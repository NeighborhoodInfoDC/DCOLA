/*******************************************
Program: race_age_PUMA_05-07.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/18/2009
Modified: 
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Gives estimate of average number of people per PUMA 2005-2007 
			 by race/ethnicity and age
Modifications:
********************************************/

libname OLAData "D:\DCData\Libraries\DCOLA\Data";

data pums_cut_2007_unweighted; 
set oladata.PUMS_2007   (keep= PUMA PWGTP AGEP RAC1P HISP SERIALNO  
		);
If HISP not in ('01', '23') then RACE = 'Hisp';
else if RAC1P = 1 and HISP in ('01', '23') then race='White_NH';
else if RAC1P = 2 and HISP in ('01', '23') then race='Black_NH';
else if RAC1P = 6 and HISP in ('01', '23') then race='Asian_NH';
else race='Other_NH';

If AGEP <5 then agegroup = 'a_0to4';
else if AGEP >=5 and AGEP <12 then agegroup = 'a_5to11';
else if AGEP >=12 and AGEP <18 then agegroup = 'a_12to17';
else if AGEP >=18 and AGEP <24 then agegroup = 'a_18to24';
else if AGEP >=25 and AGEP <65 then agegroup = 'a_25to65';
else agegroup = 'a_65up';

If AGEP <1000 then TOTSAMP = 1;
else TOTSAMP = 0;

run;
	
	
proc means data=pums_cut_2007_unweighted chartype;
      var TOTSAMP;
      class  PUMA RACE AGEGROUP;
	  weight PWGTP;
      output out=AgeRacePUMA2007 sum=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\AgeRacePUMA2007.csv" lrecl=2000;
proc export data=AgeRacePUMA2007
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
