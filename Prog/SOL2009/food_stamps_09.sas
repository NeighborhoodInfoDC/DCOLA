** program name: food_stamps_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC food stamp files for analysis to Latino Data Book
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
%DCData_lib( Tanf )


/*Download Files for Food Stamps by ward and cluster*/
	rsubmit; proc download data=tanf.Fs_sum_wd02  out=tanf.Fs_sum_wd02;run;endrsubmit;
	rsubmit; proc download data=tanf.Fs_sum_cltr00  out=tanf.Fs_sum_cltr00;	run;endrsubmit;


/*First work with Wards*/
%Macro wardstamps1 ;
		%do i = 2000 %to 2008;

		%let year= &i.;
	data foodstamps&year._int;
		set tanf.fs_sum_wd02 (keep = ward2002 fs_client_&year. fs_hisp_&year.
										fs_black_&year. fs_white_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = foodstamps&year._int out =foodstamps&year._t prefix = ward&year._;
		run;
	data foodstamps&year.;
		set foodstamps&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps1;


%macro cityfoodstamps (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Food Stamps 09.xls]citywide!r10c&col1.:r14c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set foodstamps&year.;	put citywide_&year.; 	run;
%mend;
	%cityfoodstamps (2000, 5);
	%cityfoodstamps (2001, 6);
	%cityfoodstamps (2002, 7);
	%cityfoodstamps (2003, 8);
	%cityfoodstamps (2004, 9);
	%cityfoodstamps (2005, 10);
	%cityfoodstamps (2006, 11);
	%cityfoodstamps (2007, 12);
	%cityfoodstamps (2008, 13);
%macro wardfoodstamps (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Food Stamps 09.xls]ward!r9c&col1.:r13c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set foodstamps&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardfoodstamps (2000, 4,11);
	%wardfoodstamps (2001, 12,19);
	%wardfoodstamps (2002, 20,27);
	%wardfoodstamps (2003, 28,35);
	%wardfoodstamps (2004, 36,43);
	%wardfoodstamps (2005, 44,51);
	%wardfoodstamps (2006, 52,59);
	%wardfoodstamps (2007, 60,67);
	%wardfoodstamps (2008, 68,75);
