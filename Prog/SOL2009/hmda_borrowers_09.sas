** program name: HMDA_borrowers_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC HMDA borrowers files for analysis to Latino Data Book, 1998-2007
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
	rsubmit; proc download data=Hmda.Hmda_sum_tr00   out=Hmda.Hmda_sum_tr00 ;	run;endrsubmit;



/*First work with Wards*/
%Macro wardstamps1 ;
		%do i = 1997 %to 2006

		%let year= &i.;
	data borrowers&year._int;
		set hmda.hmda_sum_wd02 (keep = ward2002
									/*Conventional home purchase mortgage loans */
									nummrtgorighisp_&year. nummrtgorigasianpi_&year. nummrtgorigblack_&year.
									nummrtgorigwhite_&year. nummrtgorigotherx_&year.   );
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
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[hmda 09.xls]mort_citywide!r10c&col1.:r14c&col1." /*notab*/;
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
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[hmda 09.xls]mort_ward!r9c&col1.:r13c&col2." /*notab*/;
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






*Latino Tracts;
%Macro wardstamps1 ;
		%do i = 1997 %to 2006

		%let year= &i.;
	proc sort data = Ncdb.Ncdb_lf_2000_dc;
		by geo2000;
		run;
	proc sort data = hmda.hmda_sum_tr00;
		by geo2000;
		run;
	data borrowers&year._int (where = (over20_hisp = 1));
		merge hmda.hmda_sum_tr00 (keep = geo2000
									/*Conventional home purchase mortgage loans */
									nummrtgorighisp_&year. nummrtgorigasianpi_&year. nummrtgorigblack_&year.
									nummrtgorigwhite_&year. nummrtgorigotherx_&year.  /* majority_hisp over30_hisp*/)
				Ncdb.Ncdb_lf_2000_dc (keep = geo2000 shrhsp0n trctpop0);
				by geo2000;

			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.2 then over20_hisp = 1;
				else over20_hisp = 0;
				end;
			run;
	proc transpose data = borrowers&year._int out =borrowers&year._t prefix = tract&year._;
		run;
	data borrowers&year.;
		set borrowers&year._t;
		*citywide_&year. = sum (of tract&year._1-tract&year._8);
		rename _name_ = variable_name;
		run;
	%end;
%mend;
%wardstamps1;


%macro wardbirths (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[hmda 09.xls]mort_tract!r9c&col1.:r13c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set borrowers&year.;	put tract&year._1 - tract&year._16; run;
%mend;
	%wardbirths (1997, 4,19);
	%wardbirths (1998, 20,35);
	%wardbirths (1999, 36,51);
	%wardbirths (2000, 52,67);
	%wardbirths (2001, 68,83);
	%wardbirths (2002, 84,99);
	%wardbirths (2003, 100,115);
	%wardbirths (2004, 116,131);
	%wardbirths (2005, 132,147);
	%wardbirths (2006, 148,163);




