/*******************************************
* Program: Median_PERS_INCOME_0507.sas
* Library: DCOLA
* Project: Latino Databook
* Author: Lesley Freiman
* Created: 08/27/2009
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

proc format;
value OCC_BIG
	1-43		= 'Management Occupations'
	50-73	 	= 'Business Operations Specialists'
	80-95		= 'Financial Specialists'
	100-124	= 'Computer and Mathematical Occupations'
	130-156	= 'Archiectural and Engineering Occupations'
	160-196	= 'Life, Physical and Social Science Occupations'
	200-206	= 'Community and Social Services Occupations'
	210-215	= 'Legal Occupations'
	220-255	= 'Education, Training, and Library Occupations'
	260-296	= 'Arts, Design, Entertainment, Sports, and Media Occupations'
	300-354	= 'Healthcare Practitioners and Technical Occupations'
	360-365	= 'Healthcare Support Occupations'
	370-395	= 'Protective Service Occupations'
	400-416	= 'Chefs and Head Cooks'
	420-425	= 'Building and Grounds Cleaning and Maintenance Occupations'
	430-465	= 'Personal Care and Service Occupations'
	470-496	= 'Sales Occupations'
	500-593	= 'Office and Administrative Support Occupations'
	600-613	= 'Farming, Fishing, and Forestry Occupations'
	620-676	= 'Construction Trades'
	680-694	= 'Extraction Workers'
	700-762	= 'Installation, Maintenance, and Repair Workers'
	770-896	= 'Production Occupations'
	900-975	= 'Transportation and Material Moving Occupations'
	980-983	= 'Military Specific Occupations'
	992			= 'Unemployed, last worked 5 years ago or earlier or never worked'
	0			= 'N/A (less than 16 years old/unemployed who never worked/NILF who last worked more than 5 years ago)';
run;


data ipums_INC_UNWGT; 
set IPUMS.Acs_2005_07_dc   (keep= PERWT HISPAN RACE inctot SEX OCC AGE where=(AGE >=16) 
		);
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

Run;

data ipums_INC_UNWGT2;
set ipums_INC_UNWGT (keep = PERWT RACE_ETH inctot SEX OCC AGE where=(OCC ^IN (0,992)));
run;

data ipums_INC_UNWGT3;
set ipums_INC_UNWGT2 (keep = PERWT RACE_ETH inctot SEX OCC AGE where=(inctot >0));
run;

proc download inlib=work outlib=dcola; 
select ipums_INC_UNWGT3;
run;

endrsubmit;	


proc summary data=dcola.ipums_INC_UNWGT3 chartype;
      var Inctot;
      class  RACE_ETH ;
	  weight PERWT;
      output out=DCOLA.WRKNG_PERS_INC_0507_v3 median=;
run;


filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\MEDIAN_WRKNG_PERS_INC_0507_V2.csv" lrecl=5000;
proc export data=DCOLA.WRKNG_PERS_INC_0507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
