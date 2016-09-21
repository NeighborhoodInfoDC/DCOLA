** program name: HMDA_hc_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC HMDA files for analysis to Latino Data Book, 1998-2007
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


/*Download Files for HMDA by ward and cluster*/
	rsubmit; proc download data=hmda.hmda_sum_wd02  out=hmda.hmda_sum_wd02;run;endrsubmit;
	rsubmit; proc download data=hmda.hmda_sum_cltr00  out=hmda.hmda_sum_cltr00;	run;endrsubmit;



/*First work with Wards*/
%Macro wardstamps1 ;
		%do i = 2004 %to 2006;

		%let year= &i.;
	data highcost&year._int;													
		set hmda.hmda_sum_wd02 (keep = ward2002 numhighcostconvorigpurch_&year. numhighownmrtgpurch_hi_&year. 
									numhighownmrtgpurch_bl_&year. numhighownmrtgpurch_wh_&year./*high cost*/);
			run;
	proc transpose data = highcost&year._int out =highcost&year._t prefix = ward&year._;
		run;
	data highcost&year.;
		set highcost&year._t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps1;


%macro citybirths (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[HMDA 09.xls]hcmort_citywide!r10c&col1.:r13c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set highcost&year.;	put citywide_&year.; 	run;
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
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[Hmda 09.xls]hcmort_ward!r9c&col1.:r12c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set highcost&year.;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardbirths (2000, 4,11);
	%wardbirths (2001, 12,19);
	%wardbirths (2002, 20,27);
	%wardbirths (2003, 28,35);
	%wardbirths (2004, 36,43);
	%wardbirths (2005, 44,51);
	%wardbirths (2006, 52,59);
	%wardbirths (2007, 60,67);
	%wardbirths (2008, 13);
	%wardbirths (2008, 68,75);



