** program name: tanf_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC BIRTHS files for analysis to Latino Data Book, 1998-2007
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
%DCData_lib( Vital )


/*Download Files for Food Stamps by ward and cluster*/
	rsubmit; proc download data=vital.births_sum_wd02  out=vital.births_sum_wd02;run;endrsubmit;
	rsubmit; proc download data=vital.births_sum_cltr00  out=vital.births_sum_cltr00;	run;endrsubmit;


/*First work with Wards*/
%Macro wardstamps1 ;
		%do i = 2000 %to 2008;

		%let year= &i.;
	data births&year._int;
		set vital.births_sum_wd02 (keep = ward2002 births_total_&year. births_hisp_&year. births_black_&year. births_white_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = births&year._int out =births&year._t prefix = ward&year._;
		run;
	data births&year.;
		set births&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps1;


%macro citybirths (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]citywide!r10c&col1.:r13c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set births&year.;	put citywide_&year.; 	run;
%mend;
	%citybirths (2000, 5);
	%citybirths (2001, 6);
	%citybirths (2002, 7);
	%citybirths (2003, 8);
	%citybirths (2004, 9);
	%citybirths (2005, 10);
	%citybirths (2006, 11);
	%citybirths (2007, 12);
	%citybirths (2008, 13);
%macro wardbirths (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]ward!r9c&col1.:r12c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set births&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardbirths (2000, 4,11);
	%wardbirths (2001, 12,19);
	%wardbirths (2002, 20,27);
	%wardbirths (2003, 28,35);
	%wardbirths (2004, 36,43);
	%wardbirths (2005, 44,51);
	%wardbirths (2006, 52,59);
	%wardbirths (2007, 60,67);
	%wardbirths (2008, 68,75);






*LOW WEIGHT BIRTHS;
%Macro wardstamps2 ;
		%do i = 2001 %to 2006;

		%let year= &i.;
	data birthslow&year._int;
		set vital.births_sum_wd02 (keep = ward2002 births_low_wt_&year. births_low_wt_hsp_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = birthslow&year._int out =birthslow&year._t prefix = ward&year._;
		run;
	data birthslow&year.;
		set birthslow&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps2;


%macro citybirthslow (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]lowwt_citywide!r10c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set birthslow&year.;	put citywide_&year.; 	run;
%mend;
	%citybirthslow(2000, 5);
	%citybirthslow(2001, 6);
	%citybirthslow(2002, 7);
	%citybirthslow(2003, 8);
	%citybirthslow(2004, 9);
	%citybirthslow(2005, 10);
	%citybirthslow(2006, 11);
	%citybirthslow(2007, 12);
	%citybirthslow(2008, 13);
%macro wardbirthslow (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]lowwt_ward!r9c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set birthslow&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardbirthslow (2000, 4,11);
	%wardbirthslow (2001, 12,19);
	%wardbirthslow (2002, 20,27);
	%wardbirthslow (2003, 28,35);
	%wardbirthslow (2004, 36,43);
	%wardbirthslow (2005, 44,51);
	%wardbirthslow (2006, 52,59);
	%wardbirthslow (2007, 60,67);
	%wardbirthslow (2008, 68,75);



*BIRTHS TO TEEN MOTHERS;
		%Macro wardstamps3 ;
		%do i = 2000 %to 2008;

		%let year= &i.;
	data birthsteen&year._int;
		set vital.births_sum_wd02 (keep = ward2002 births_teen_&year. births_teen_hsp_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = birthsteen&year._int out =birthsteen&year._t prefix = ward&year._;
		run;
	data birthsteen&year.;
		set birthsteen&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps3;


%macro citybirthsteen (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]teenbrth_citywide!r10c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set birthsteen&year.;	put citywide_&year.; 	run;
%mend;
	%citybirthsteen(2000, 5);
	%citybirthsteen(2001, 6);
	%citybirthsteen(2002, 7);
	%citybirthsteen(2003, 8);
	%citybirthsteen(2004, 9);
	%citybirthsteen(2005, 10);
	%citybirthsteen(2006, 11);
	%citybirthsteen(2007, 12);
	%citybirthsteen(2008, 13);
%macro wardbirthsteen (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]teenbrth_ward!r9c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set birthsteen&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardbirthsteen (2000, 4,11);
	%wardbirthsteen (2001, 12,19);
	%wardbirthsteen (2002, 20,27);
	%wardbirthsteen (2003, 28,35);
	%wardbirthsteen (2004, 36,43);
	%wardbirthsteen (2005, 44,51);
	%wardbirthsteen (2006, 52,59);
	%wardbirthsteen (2007, 60,67);
	%wardbirthsteen (2008, 68,75);



*Prenatal Care;
		%Macro wardstamps3 ;
		%do i = 2000 %to 2008;

		%let year= &i.;
	data birthsprenat&year._int;
		set vital.births_sum_wd02 (keep = ward2002 births_w_prenat_&year. births_w_prenat_hsp_&year.) /*these are the only indicators for now, add more later*/;
		run;
	proc transpose data = birthsprenat&year._int out =birthsprenat&year._t prefix = ward&year._;
		run;
	data birthsprenat&year.;
		set birthsprenat&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps3;


%macro citybirthsprenat (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]prenat_citywide!r10c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set birthsprenat&year.;	put citywide_&year.; 	run;
%mend;
	%citybirthsprenat(2000, 5);
	%citybirthsprenat(2001, 6);
	%citybirthsprenat(2002, 7);
	%citybirthsprenat(2003, 8);
	%citybirthsprenat(2004, 9);
	%citybirthsprenat(2005, 10);
	%citybirthsprenat(2006, 11);
	%citybirthsprenat(2007, 12);
	%citybirthsprenat(2008, 13);
%macro wardbirthsprenat (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Births 09.xls]prenat_ward!r9c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set birthsprenat&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardbirthsprenat (2000, 4,11);
	%wardbirthsprenat (2001, 12,19);
	%wardbirthsprenat (2002, 20,27);
	%wardbirthsprenat (2003, 28,35);
	%wardbirthsprenat (2004, 36,43);
	%wardbirthsprenat (2005, 44,51);
	%wardbirthsprenat (2006, 52,59);
	%wardbirthsprenat (2007, 60,67);
	%wardbirthsprenat (2008, 68,75);
