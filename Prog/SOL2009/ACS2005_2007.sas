/**************************************************************************
 Program:  susie_income_pop_ACS.sas
 Library:  Requests
 Project:  NeighborhoodInfo DC
 Author:   J. Comey
 Created:  07/08/09
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Identify the Latino population, their age breakdown family status, and occupations 
	from ACS website. Not IPUMS

 Modifications:
**************************************************************************/


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
*%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( IPUMS )
proc contents data=IPUMS.PUMS_200507; run;
*Confirmed that this is just DC data;
proc freq data=IPUMS.PUMS_200507;
table HISP;
weight PWGTP ;
run;

data ACS_200507;
	set IPUMS.PUMS_200507;

	if HISP >1 then Latino=1;
	else Latino=0;
	run;

proc freq data=ACS_200507;
table Latino;
weight PWGTP ;
title "Share of population who is Latino,weighted, ACS 2005-2007";
run;
proc sort data=ACS_200507;
by puma;run;
proc freq data=ACS_200507;
table Latino * puma;
weight PWGTP ;
title "Share of population who is Latino by PUMA, weighted, ACS 2005-2007";
run;

*Occupation data;

proc freq data=ACS_200507;
table NAICSP;
weight PWGTP ;
title "Occupations in the District, ACS 2005-2007";
run;

proc freq data=ACS_200507;
table NAICSP * Latino;
weight PWGTP ;
title "Occupations of Latinos/NonLatinos in the District, ACS 2005-2007";
run;



proc freq data=IPUMS.PUMS_200507;
table agep;
by FHISP;
weight PWGTP ;
title "Number of people citywide in the District 2005-2007 micro level ACS, weighted";
run;
proc freq data=IPUMS.PUMS_200507;
table puma;
weight PWGTP ;
title "Number of people (all ages) by PUMA as of 2005-2007 micro level ACS, weighted";
run;
proc sort data=IPUMS.PUMS_200507;
by puma;
run;

proc means data=IPUMS.PUMS_200507 ;
var PINCP;
by puma;
weight PWGTP ;
title "Average income by PUMA as of 2005-2007 micro level ACS, weighted";
run;

proc means data=IPUMS.PUMS_200507 median ;
var PINCP;
by puma;
weight PWGTP ;
title "Median income by PUMA as of 2005-2007 micro level ACS, weighted";
run;


NAICS
