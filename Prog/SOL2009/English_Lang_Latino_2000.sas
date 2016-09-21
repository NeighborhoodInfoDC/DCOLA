/*******************************************
* Program: Englist_Lang_Latino_2000.sas
* Library: DCOLA
* Project: Latino Databook
* Author: Lesley Freiman
* Created: 09/29/2009
* Modified: 
* Version: SAS 9.1
* Environment: Windows with SAS/Connect
* Description: Shows English Ability of DC Latinos age 16+, 2000  
* Modifications:
********************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;

data ENG_LATINO_2000_UNWGT; 
set IPUMS.Ipums_2000_dc (keep= PERWT racgen00 HISPAND bpld 
SPEAKENG AGE where=(AGE >=16));

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

If SPEAKENG in (3,4) then ENG_LANG = 'Very Well';
	else if SPEAKENG = 5 then ENG_LANG = 'Well';
	else if SPEAKENG in (1,6) then ENG_LANG = 'No_or_Not_well';
	else ENG_LANG = '.';

IF bpld in (100:11500) then Foreign_Born = 0;
Else Foreign_Born = 1;

TOTSAMP = 1;
Run;

proc download inlib=work outlib=dcola; 
select ENG_LATINO_2000_UNWGT;
run;

endrsubmit;	


proc summary data=dcola.ENG_LATINO_2000_UNWGT chartype;
      var TOTSAMP;
      class  LATINO Foreign_Born ENG_LANG;
	  weight PERWT;
      output out=DCOLA.ENGLISH_LATINO_2000 sumwgt=;
run;


filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\ENGLISH_LATINO_2000.csv" lrecl=5000;
proc export data=DCOLA.ENGLISH_LATINO_2000
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
