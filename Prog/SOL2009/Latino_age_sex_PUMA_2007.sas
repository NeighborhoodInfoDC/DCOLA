/*******************************************
Program: Latino_age_sex_PUMA_2007.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 06/18/2009
Modified: 
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Gives estimate for Latinos by age and sex by PUMA 
			 average estimate 2005-2007 
Modifications:
********************************************/

libname OLAData "D:\DCData\Libraries\DCOLA\Data";

data pums_agesexrace2007_unweighted; 
set oladata.PUMS_2007   (keep= PWGTP PUMA AGEP RAC1P HISP SEX  
		);
If HISP not in ('01', '23') then LATINO = 1;
else LATINO = 0;

If AGEP <5 then agegroup = 'a_0to4';
else if AGEP >=5 and AGEP <12 then agegroup = 'a_5to11';
else if AGEP >=12 and AGEP <18 then agegroup = 'a_12to17';
else if AGEP >=18 and AGEP <24 then agegroup = 'a_18to24';
else if AGEP >=25 and AGEP <65 then agegroup = 'a_25to64';
else agegroup = 'a_65up';

TOTSAMP = 1;
run; 
Proc Format 
Value AGEGROUP 	'a_0to4' = 'Age <5'
				'a_5to11' = 'Age 5 to 11'
			 	'a_12to17' = 'Age 12 to 17'
				'a_18to24' = 'Age 18 to 24'
				'a_25to64' = 'Age 25 to 64'
				'a_65up' = 'Age 65+';
Value LATINO 	1 = 'Latino'
				0 = 'Not Latino';
Value SEX		1 = 'Male'
				2 = 'Female';	

run;
	
	
	
proc summary data=pums_agesexrace2007_unweighted chartype;
      var TOTSAMP;
      class  PUMA LATINO SEX AGEGROUP;
	  weight PWGTP;
      output out=HispAgeSexPUMA2007 sumwgt=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\HispAgeSexPUMA2007.csv" lrecl=2000;
proc export data=HispAgeSexPUMA2007
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
