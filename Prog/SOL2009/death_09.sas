** program name: viodeath_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC Violent Deaths files for analysis to Latino Data Book, 1998-2007
** Date Created: 5/14/09
** Data Updated:  
** mgrosz
***********************************************;

*Schools libnames;

libname ola 'D:\Data\dcola';


*HNC libnames;
%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;
** Define libraries **;
%DCData_lib( vital )


/*Download Files for Food Stamps by ward and cluster*/
	rsubmit; proc download data=vital.deaths_sum_wd02  out=vital.deaths_sum_wd02;run;endrsubmit;
	rsubmit; proc download data=vital.deaths_sum_cltr00  out=vital.deaths_sum_cltr00;	run;endrsubmit;


/*First work with Wards*/
%Macro warddeath1 ;
		%do i = 2001 %to 2005;

		%let year= &i.;
	data deaths&year._int;
		set vital.deaths_sum_wd02 (keep = ward2002 deaths_total_&year. deaths_hisp_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = deaths&year._int out =deaths&year._t prefix = ward&year._;
		run;
	data deaths&year.;
		set deaths&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%warddeath1;


%macro citydeath (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[death 09.xls]citywide!r10c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set deaths&year.;	put citywide_&year.; 	run;
%mend;
	%citydeath (2000, 5);
	%citydeath (2001, 6);
	%citydeath (2002, 7);
	%citydeath (2003, 8);
	%citydeath (2004, 9);
	%citydeath (2005, 10);
	%citydeath (2006, 11);
	%citydeath (2007, 12);
	%citydeath (2008, 13);
%macro warddeath (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[death 09.xls]ward!r9c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set deaths&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%warddeath (2000, 4,11);
	%warddeath (2001, 12,19);
	%warddeath (2002, 20,27);
	%warddeath (2003, 28,35);
	%warddeath (2004, 36,43);
	%warddeath (2005, 44,51);
	%warddeath (2006, 52,59);
	%warddeath (2007, 60,67);
	%warddeath (2008, 68,75);
