/*******************************************
Program: Industry_Latino_DC_05-07.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 08/13/2009
Modified: 
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Tabulates industry groups by race/ethnicity and sex (2005-2007 PUMS estimate average) 
			for persons 16 and over  
Modifications:
********************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( Ncdb );
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;

data ipums_industry_0507unweighted; 
set IPUMS.Acs_2005_07_dc   (keep= PERWT AGE HISPAN RACE SEX IND
		); 
If HISPAN in (1:4) then LATINO = 1;
	else LATINO = 2;

If RACE = 1 then RACE_NEW = 1; 
	else if RACE = 2 then RACE_NEW = 2;
	else if RACE = 3 then RACE_NEW = 3;
	else if RACE in (4:6) then RACE_NEW = 4;
	else RACE_NEW = 5;

If (RACE_NEW = 1 and LATINO = 2) then RACE_ETH = 'White, Non-Hisp';
	else if (RACE_NEW = 2 and LATINO = 2) then RACE_ETH = 'Black, Non-Hisp';
	else if (RACE_NEW = 3 and LATINO = 2) then RACE_ETH = 'Native Amer., Non-Hisp';
	else if (RACE_NEW = 4 and LATINO = 2) then RACE_ETH = 'Asian, Non-Hisp';
	else if LATINO = 1 then RACE_ETH = 'Latino or Hispanic';
	else RACE_ETH = 'Other Race, Non-Hisp';	

If IND in (017:029)
		or IND in (037:049)
		or IND in (057:069) then INDGRP = 'Agrucilture/fishing/Mining/Utilities';
	else if IND = 077 then INDGRP = 'Construction';
	else if IND in (107:399) then INDGRP = 'Manufacturing';
	else if IND in (407:459) then INDGRP = 'Wholesale Trade';
	else if IND in (467:579) then INDGRP = 'Retail Trade';
	else if IND in (607:639) then INDGRP = 'Transportation and Warehousing';
	else if IND in (647:679) then INDGRP = 'Information and Communications';
	else if IND in (687:719) then INDGRP = 'Finance, Insurance, and Real Estate';
	else if IND = 727 then INDGRP = 'Legal Services';
	else if IND = 738 then INDGRP = 'Computer systems design and services';
	else if IND = 739 then INDGRP = 'Management, scientific and technical services';
	else if IND in (728:729)
		or IND = 737 
		or IND in (746:779) then INDGRP = 'Other Professional, Scientific, Management, and Waste Services';
	else if IND = 786 then INDGRP = 'Elementary and secondary schools';
	else if IND = 787 then INDGRP = 'Colleges and universities';
	else if IND = 819 then INDGRP = 'Hospitals';
	else if IND in (788:818)
		or IND in (827:847) then INDGRP = 'Other Educational, Health and Social Services';
	else if IND = 868 then INDGRP ='Restaurants and other food services';
	else if IND in (856:867) 
		or IND = 869 then INDGRP = 'Other Arts, Entertainment, Recreation, and Food Services';
	else if IND in (877:929)then INDGRP = 'Other Services (Except Public Administration)';
	else if IND = 957 then INDGRP = 'Administration of economic programs and space research';
	else if IND = 959 then INDGRP = 'National security and international affairs';
	else if IND in (937:949) then INDGRP = 'Other Public Administration';
	else if IND in (967:987) then INDGRP = 'Armed Forces';
	else if IND = 0 
		or IND = 992 then INDGRP = 'N/A/Did not work last 5 years/Unemployed';


TOTSAMP = 1;
run;
proc format;
	value SEX (notsorted)
		1 = 'male'
		2 = 'female'; 
run;

Data ipums_indrace_16pls_0507;
set ipums_industry_0507unweighted(where = ( AGE >= 16));
run;

proc download inlib=work outlib=dcola; 
select ipums_indrace_16pls_0507; 
run;

endrsubmit;	

proc summary data=dcola.ipums_indrace_16pls_0507 chartype;
      var TOTSAMP;
      class  SEX RACE_ETH INDGRP;
	  weight PERWT;
      output out=DCOLA.INDGRP_RACE_0507 sumwgt=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\IndGrp_Race_0507_V2.csv" lrecl=9000;
proc export data=DCOLA.INDGRP_RACE_0507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
