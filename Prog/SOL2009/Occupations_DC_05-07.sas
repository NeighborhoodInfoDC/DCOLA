/*******************************************
Program: Occupations_Latino_DC_05-07.sas
Library: DCOLA
Project: Latino Databook
Author: Lesley Freiman
Created: 08/02/2009
Modified: 08/12/2009
Version: SAS 9.1
Environment: Windows with SAS/Connect
Description: Tabulates occupations by race/ethnicity and sex (2005-2007 PUMS estimate average) 
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

data ipums_occuprace_0507unweighted; 
set IPUMS.Acs_2005_07_dc   (keep= PERWT AGE HISPAN RACE SEX OCC
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

If OCC = 23 then OCC2 = 'Education Admin';
	else if OCC = 31 then OCC2 = 'Food Service Managers';
	else if OCC = 41 then OCC2 = 'Property/Community Assoc. Managers';
	else if OCC = 30 then OCC2 = 'Engineering Managers';
	else if OCC in (1:22) 
		or OCC in (32:40) 
		or OCC in (42:43) then OCC2 = 'Other Management';
	else if OCC = 80 then OCC2 = 'Accountants/Auditors';
	else if OCC = 210 then OCC2 = 'Lawyers/Judges/Magistrates/Judicial Workers';
	else if OCC in (214:215) 
		or OCC in (50:79) 
		or OCC in (81:95) then OCC2 = 'Other Business/Financial/Legal Support';
	else if OCC in (100:102) then OCC2 = 'Computer Programmers/Analysts';
	else if OCC in (103:196) then OCC2 = 'Other Computer/Technical/Science';
	else if OCC in (200:201) then OCC2 = 'Social Workers/Counselors';
	else if OCC in (202:206) then OCC2 = 'Other community/social services';
	else if OCC in (220:234) then OCC2 = 'Teachers';
	else if OCC = 254 then OCC2 = 'Teacher Assistant';
	else if OCC in (235:253) 
		or OCC= 255 then OCC2 = 'Other Educational/Library';
	else if OCC in (260:296) then OCC2 = 'Art/entertainment/sports';
	else if OCC = 301 
		or OCC = 306 then OCC2 = 'Doctors/Dentists';
	else if OCC = 311 
		or OCC = 313 then OCC2 = 'Registered nurses/physician assistants';
	else if OCC = 340 then OCC2 = 'Emergency medical technicians';
	else if OCC = 360 then OCC2 = 'Nursing, psychiatric/home health aides';
	else if OCC = 300 
		or OCC in (302:305) 
		or OCC = 312 
		or OCC = 314 
		or OCC = 339 
		or OCC in (341:359) 
		or OCC = 361 
		or OCC = 365 
		then OCC2 = 'Other healthcare and support';
	else if OCC in (315:324)
		or OCC in (326:332)
		or OCC in (362:364)
		or OCC = 911
		then OCC2 = 'Medical Therapists and Technicians';
	else if OCC = 325 then OCC2 = 'Veterinarians';
	else if OCC = 374 or OCC in (382:386) then OCC2 = 'Fire fighters/police officers';
	else if OCC = 392 then OCC2 = 'Security guards';
	else if OCC = 370-373 
		or OCC in (375:381) 
		or OCC in (387:391) 
		or OCC in (393:395) then OCC2 = 'Other Protective Services';
	else if OCC in (400:403) then OCC2 = 'Cooks/Food Prep Workers';
	else if OCC in (411:412) then OCC2 = 'Waiters/food servers';
	else if OCC in (404:410) 
		or OCC in (413:416) then OCC2 ='Other food prep and services';
	else if OCC = 423 then OCC2 = 'Maids/housekeepers';
	else if OCC in (420:422) 
		or OCC in (424:425) then OCC2 = 'Other building cleaning/maintenance';
	else if OCC = 451 then OCC2 = 'Hairdressers, Hairstylists, and Cosmetologists';
	else if OCC = 453 then OCC2 = 'Baggage Porters, Bellhops, and Concierge';  
	else if OCC = 460 then OCC2 = 'Child care workers'; 
	else if OCC = 461 then OCC2 = 'Personal and Home Care Aides'; 
    else if OCC in (430:441) 
		or OCC in (442:450) 
		or OCC = 452 
		or OCC in (454:459) 
		or OCC in (462:465) then OCC2 = 'Other service occupations';
	else if OCC = 472 then OCC2 = 'Cashiers'; 
	else if OCC = 476 then OCC2 = 'Retail Salespersons';
	else if OCC = 481 then OCC2	= 'Insurance Sales Agents';  
	else if OCC = 484 then OCC2 = 'Sales Representatives, All Other'; 
	else if OCC in (470:471) 
		or OCC in (473:475) 
		or OCC in (477:480) 
		or OCC in (482:483) 
		or OCC in (485:496) then OCC2 = 'Other Sales occupations'; 
	else if OCC = 524 then OCC2 = 'Customer service representatives';
    else if OCC = 540 then OCC2 = 'Receptionists';
    else if OCC = 570 then OCC2 = 'Secretaries/admin. assistants';
    else if OCC = 512 or OCC = 586 then OCC2 = 'Office clerks';
    else if OCC in (500:511) 
		or OCC in (513:523) 
		or OCC in (525:539) 
		or OCC in (541:569) 
		or OCC in (571:585) 
		or OCC in (587:593) then OCC2 = 'Other office/admin. support';
    else if OCC in (600:613) then OCC2 = 'Farming/fishing/forestry';
	else if OCC = 623 then OCC2	= 'Carpenters';
	else if OCC = 624 then OCC2 = 'Carpet, Floor, and Tile Installers';
	else if OCC = 625 then OCC2 = 'Cement Masons, Concrete Finishers';
	else if OCC = 626 then OCC2 = 'Construction Laborers';
	else if POCC = 650 then OCC2 = 'Reinforcing Iron and Rebar Workers';
	else if OCC in (635:640) then OCC2 = 'Electricians, Glaziers, Insulation Workers';
	else if OCC = 646 then OCC2 = 'Plasterers and Stucco Masons'; 
	else if OCC = 651 then OCC2 = 'Roofers'; 
	else if OCC = 673 then OCC2 = 'Highway Maintenance Workers'; 
	else if OCC = 710 
		or OCC = 711 then OCC2 = 'Electrical and Electronics Repairers/installers/transporation equipment/industrial/utility'; 
	else if OCC = 714 then OCC2 = 'Aircraft Mechanics and Service Technicians'; 
	else if OCC = 715 then OCC2 = 'Automotive Body and Related Repairers'; 
	else if OCC in (614:622) 
		or OCC in (630:633) 
		or OCC in (642:644) 
		or OCC in (652:653) 
		or OCC = 660 
		or OCC = 666 
		or OCC in (670:672) 
		or OCC in (674:694) 
		or OCC in (700:704) 
		or OCC in (712:713) 
		or OCC = 716 
		or OCC in (720:721) 
		or OCC in (722:730) 
		or OCC in (731:762) then OCC2 = 'Other Construction/manufacturing';
	else if OCC in (770:896) then OCC2 = 'Production';
	else if OCC = 912 then OCC2 = 'Bus Drivers';
	else if OCC = 913 then OCC2 = 'Driver/Sales Workers and Truck Drivers'; 
	else if OCC = 914 then OCC2	= 'Taxi Drivers and Chauffeurs'; 
	else if OCC in (900:904) 
		or OCC in (915:926) 
		or OCC in (930:975) then OCC2 = 'Other Transportation'; 
    else if OCC in (980:983) then OCC2 = 'Military';
    else if OCC = 0 
		or OCC = 992 then OCC2 = 'Did not work last 5 years/under 18/never worked';
	else OCC2 = 'OTHER';
 
TOTSAMP = 1;
run;
proc format;
	value SEX
		1 = 'male'
		2 = 'female'; 
run;

Data ipums_occrace_16pls_0507;
set ipums_occuprace_0507unweighted (where = ( AGE >= 16));
run;

proc download inlib=work outlib=dcola; 
select ipums_occrace_16pls_0507; 
run;

endrsubmit;	

proc summary data=dcola.ipums_occrace_16pls_0507 chartype;
      var TOTSAMP;
      class  SEX RACE_ETH OCC2;
	  weight PERWT;
      output out=DCOLA.OCCUP_RACE_0507 sumwgt=;
run;

filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\Occup_Race_0507_V2.csv" lrecl=9000;
proc export data=DCOLA.OCCUP_RACE_0507
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
