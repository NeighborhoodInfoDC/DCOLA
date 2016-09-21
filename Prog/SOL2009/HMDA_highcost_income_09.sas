** program name: HMDA_highcost_income_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC HMDA borrowers files for analysis to Latino Data Book, 1998-2007
					high cost loans to Hispanics, by income.
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
%DCData_lib( Hmda )


*Download Files for HMDA by ward and cluster;
	rsubmit; proc download data=hmda.hmda_sum_wd02  out=hmda.hmda_sum_wd02;run;endrsubmit;
	rsubmit; proc download data=hmda.hmda_sum_cltr00  out=hmda.hmda_sum_cltr00;	run;endrsubmit;
	rsubmit; proc download data=Hmda.Hmda_sum_tr00   out=Hmda.Hmda_sum_tr00 ;	run;endrsubmit;



/*First work with Wards*/
%Macro wardstamps1 ;
		%do i = 1997 %to 2006

		%let year= &i.;
	data borrowers&year._int;
		set hmda.hmda_sum_wd02 (keep = ward2002
									/*Conventional home purchase mortgage loans */
									NumHighOwnMrtgPurch_vli_&year.
									NumHighOwnMrtgPurch_li_&year.
									NumHighOwnMrtgPurch_mi_&year.
									NumHighOwnMrtgPurch_hinc_&year.

									NumHighOwnMrtgPurch_hi_vli_&year.
									NumHighOwnMrtgPurch_hi_li_&year.
									NumHighOwnMrtgPurch_hi_mi_&year.
									NumHighOwnMrtgPurch_hi_hinc_&year.   );
			run;
	proc transpose data = borrowers&year._int out =borrowers&year._t prefix = ward&year._;
		run;
	data borrowers&year.;
		set borrowers&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps1;


%macro citybirths (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Tables\[hmda 09.xls]hc_inc_citywide!r10c&col1.:r20c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set borrowers&year.;	put citywide_&year.; 	run;
%mend;
	%citybirths (1997, 5);
	%citybirths (1998, 6);
	%citybirths (1999, 7);
	%citybirths (2000, 8);
	%citybirths (2001, 9);
	%citybirths (2002, 10);
	%citybirths (2003, 11);
	%citybirths (2004, 12);
	%citybirths (2005, 13);
	%citybirths (2006, 14);
%macro wardbirths (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Tables\[hmda 09.xls]mort_ward!r9c&col1.:r13c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set borrowers&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardbirths (1997, 4,11);
	%wardbirths (1998, 12,19);
	%wardbirths (1999, 20,27);
	%wardbirths (2000, 28,35);
	%wardbirths (2001, 36,43);
	%wardbirths (2002, 44,51);
	%wardbirths (2003, 52,59);
	%wardbirths (2004, 60,67);
	%wardbirths (2005, 68,75);
	%wardbirths (2006, 76,83);






	hc_inc_citywide
