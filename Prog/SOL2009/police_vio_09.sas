** program name: police_vio_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC Violent crimes files for analysis to Latino Data Book, 1998-2007
				Also creates variables on share hispanic by tract.
** Date Created: 5/14/09
** Data Updated:  
** mgrosz
***********************************************;

*OLA libnames;

libname ola 'D:\Data\dcola';


*HNC libnames;
%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;
** Define libraries **;
%DCData_lib( ncdb )
%DCData_lib( police )

/*Download all the files;
	rsubmit; proc download data=Ncdb.Ncdb_lf_2000_dc   out=Ncdb.Ncdb_lf_2000_dc ;run;endrsubmit;

	rsubmit; proc download data=Police.Crimes_2001   out=Police.Crimes_2001;run; endrsubmit;
	rsubmit; proc download data=Police.Crimes_2002   out=Police.Crimes_2002;run; endrsubmit;
	rsubmit; proc download data=Police.Crimes_2003   out=Police.Crimes_2003;run; endrsubmit;
	rsubmit; proc download data=Police.Crimes_2004   out=Police.Crimes_2004;run; endrsubmit;
	rsubmit; proc download data=Police.Crimes_2005   out=Police.Crimes_2005;run; endrsubmit;
	rsubmit; proc download data=Police.Crimes_2006   out=Police.Crimes_2006;run; endrsubmit;
	rsubmit; proc download data=Police.Crimes_2007   out=Police.Crimes_2007;run; endrsubmit;
*/

proc sort data = ncdb.ncdb_lf_2000_dc out = ncdb_lf_2000_dc 
				(keep = geo2000 
						trctpop0 /*Total population, 2000  */
						shrhsp0n /*Total Hisp./Latino population, 2000 */
						shr0d );
	by geo2000;
	run;
%Macro createpoliceset;
		%do i = 2001 %to 2007;
		%let year= &i.;
		proc sort data = police.crimes_&year.;
			by geo2000;
			run;
		data crimes_vio_&year.;
			merge police.crimes_&year. (in = a)
				ncdb.ncdb_lf_2000_dc ;
			by geo2000;
			if a;
			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.3 then over30_hisp = 1;
				else over30_hisp = 0;
				end;
			run;

		%end;
		%mend;
%createpoliceset;

proc freq data = crimes_vio_2001;
	table ward2002 * majority_hisp;

	run;



%macro sumpolice;
	%do i = 2001 %to 2007;
	%let year= &i.;
	
proc summary data = crimes_vio_&year. chartype;
		var crimes_pt1_violent ;
		class ward2002 ;
		output out = crimes_vio_&year._all_int (where = (_type_ = '1') keep = ward2002 crimes_pt1_violent _type_) sum = ;
		run;
	proc transpose data = crimes_vio_&year._all_int out =crimes_vio_&year._all_t prefix = ward&year._;
		run;
	data crimes_vio_&year._all;
		set crimes_vio_&year._all_t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;

proc summary data = crimes_vio_&year. chartype;
		var crimes_pt1_violent ;
		class ward2002 ;
		where majority_hisp = 1;
		output out = crimes_vio_&year._majority_int (where = (_type_ = '1') keep = ward2002 crimes_pt1_violent _type_) sum = ;
		run;
	proc transpose data = crimes_vio_&year._majority_int out =crimes_vio_&year._majority_t prefix = ward&year._;
		run;
	data crimes_vio_&year._majority;
		set crimes_vio_&year._majority_t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
proc summary data = crimes_vio_&year. chartype;
		var crimes_pt1_violent ;
		class ward2002 ;
		where over30_hisp = 1;
		output out = crimes_vio_&year._30pct_int (where = (_type_ = '1') keep = ward2002 crimes_pt1_violent _type_) sum = ;
		run;
	proc transpose data = crimes_vio_&year._30pct_int out =crimes_vio_&year._30pct_t prefix = ward&year._;
		run;
	data crimes_vio_&year._30pct;
		set crimes_vio_&year._30pct_t;
		citywide_&year. = sum (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
%end;
%mend;
%sumpolice;






%macro cityall (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[police 09.xls]citywide_vio!r10c&col1.:r10c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set crimes_vio_&year._all;	put citywide_&year.; 	run;
%mend;
	%cityall (2000, 5);
	%cityall (2001, 6);
	%cityall (2002, 7);
	%cityall (2003, 8);
	%cityall (2004, 9);
	%cityall (2005, 10);
	%cityall (2006, 11);
	%cityall (2007, 12);
	%cityall (2008, 13);
%macro wardall (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[police 09.xls]ward_vio!r9c&col1.:r9c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set crimes_vio_&year._all;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardall (2000, 4,11);
	%wardall (2001, 12,19);
	%wardall (2002, 20,27);
	%wardall (2003, 28,35);
	%wardall (2004, 36,43);
	%wardall (2005, 44,51);
	%wardall (2006, 52,59);
	%wardall (2007, 60,67);
	%wardtanf (2008, 68,75);



%macro citymaj (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[police 09.xls]citywide_vio!r11c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set crimes_vio_&year._majority;	put citywide_&year.; 	run;
%mend;
	%citymaj (2000, 5);
	%citymaj (2001, 6);
	%citymaj (2002, 7);
	%citymaj (2003, 8);
	%citymaj (2004, 9);
	%citymaj (2005, 10);
	%citymaj (2006, 11);
	%citymaj (2007, 12);
	%citymaj (2008, 13);
%macro wardmaj (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[police 09.xls]ward_vio!r10c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set crimes_vio_&year._majority;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardmaj (2000, 4,11);
	%wardmaj (2001, 12,19);
	%wardmaj (2002, 20,27);
	%wardmaj (2003, 28,35);
	%wardmaj (2004, 36,43);
	%wardmaj (2005, 44,51);
	%wardmaj (2006, 52,59);
	%wardmaj (2007, 60,67);
	%wardmaj (2008, 68,75);



%macro city30 (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[police 09.xls]citywide_vio!r12c&col1.:r12c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set  crimes_vio_&year._30pct;	put citywide_&year.; 	run;
%mend;
	%city30 (2000, 5);
	%city30 (2001, 6);
	%city30 (2002, 7);
	%city30 (2003, 8);
	%city30 (2004, 9);
	%city30 (2005, 10);
	%city30 (2006, 11);
	%city30 (2007, 12);
	%city30 (2008, 13);
%macro ward30 (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[police 09.xls]ward_vio!r11c&col1.:r11c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set  crimes_vio_&year._30pct;	put ward&year._1 - ward&year._8; run;
%mend;
	%ward30 (2000, 4,11);
	%ward30 (2001, 12,19);
	%ward30 (2002, 20,27);
	%ward30 (2003, 28,35);
	%ward30 (2004, 36,43);
	%ward30 (2005, 44,51);
	%ward30 (2006, 52,59);
	%ward30 (2007, 60,67);
	%ward30 (2008, 68,75);
