** program name: tanf_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC TANF files for analysis to Latino Data Book, 1998-2007
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
	rsubmit; proc download data=tanf.tanf_sum_wd02  out=tanf.tanf_sum_wd02;run;endrsubmit;
	rsubmit; proc download data=tanf.tanf_sum_cltr00  out=tanf.tanf_sum_cltr00;	run;endrsubmit;


/*First work with Wards*/
%Macro wardstamps1 ;
		%do i = 2000 %to 2008;

		%let year= &i.;
	data tanf&year._int;
		set tanf.tanf_sum_wd02 (keep = ward2002 tanf_client_&year. tanf_hisp_&year.
										tanf_black_&year. tanf_white_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = tanf&year._int out =tanf&year._t prefix = ward&year._;
		run;
	data tanf&year.;
		set tanf&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps1;


%macro citytanf (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Tanf 09.xls]citywide!r10c&col1.:r14c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set tanf&year.;	put citywide_&year.; 	run;
%mend;
	%citytanf (2000, 5);
	%citytanf (2001, 6);
	%citytanf (2002, 7);
	%citytanf (2003, 8);
	%citytanf (2004, 9);
	%citytanf (2005, 10);
	%citytanf (2006, 11);
	%citytanf (2007, 12);
	%citytanf (2008, 13);
%macro wardtanf (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Tanf 09.xls]ward!r9c&col1.:r13c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set tanf&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardtanf (2000, 4,11);
	%wardtanf (2001, 12,19);
	%wardtanf (2002, 20,27);
	%wardtanf (2003, 28,35);
	%wardtanf (2004, 36,43);
	%wardtanf (2005, 44,51);
	%wardtanf (2006, 52,59);
	%wardtanf (2007, 60,67);
	%wardtanf (2008, 68,75);
