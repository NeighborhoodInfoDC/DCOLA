** program name: sales_prices_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC housing sales median prices for analysis to Latino Data Book, 1998-2007 
					(first single family and then condo)
				Also creates variables on share hispanic by tract as proxies for Hispanic crimes.
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
%DCData_lib( realprop )

/*Download all the files;
	rsubmit; proc download data=Ncdb.Ncdb_lf_2000_dc   out=Ncdb.Ncdb_lf_2000_dc ;run;endrsubmit;
	rsubmit; proc download data=Realprop.Sales_sum_tr00    out=Realprop.Sales_sum_tr00  ;run;endrsubmit;
	rsubmit; proc download data=Realprop.Parcel_geo    out=Realprop.Parcel_geo  ;run;endrsubmit;

*/

proc sort data = ncdb.ncdb_lf_2000_dc out = ncdb_lf_2000_dc 
				(keep = geo2000 
						trctpop0 /*Total population, 2000  */
						shrhsp0n /*Total Hisp./Latino population, 2000 */
						shr0d );
	by geo2000;
	run;
proc sort data = Realprop.Parcel_geo nodupkey out = Parcel_geo 
				(keep = geo2000 
						ward2002 );
	by geo2000;
	run;

proc sort data = Realprop.Sales_sum_tr00 ;
			by geo2000;
			run;
%Macro createset;
		%do i = 2001 %to 2009;
		%let year= &i.;

		data mprice_sf_&year.;
			merge Realprop.Sales_sum_tr00  (in = a /*keep = geo2000 mprice_sf_&year.*/ )
				ncdb.ncdb_lf_2000_dc
				Parcel_geo;
			by geo2000;
			
			if a;
			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.2 then over20_hisp = 1;
				else over20_hisp = 0;
				end;
			run;

		%end;
		%mend;
%createset;



%macro sumsales;
	%do i = 2001 %to 2009;
	%let year= &i.;
	
proc summary data = mprice_sf_&year. chartype;
		var mprice_sf_&year.  ;
		class ward2002 ;
		output out = mprice_sf_&year._all_int (where = (_type_ = '1') keep = ward2002 mprice_sf_&year.  _type_) mean = ;
		run;
	proc transpose data = mprice_sf_&year._all_int out =mprice_sf_&year._all_t prefix = ward&year._;
		run;
	data mprice_sf_&year._all;
		set mprice_sf_&year._all_t;
		citywide_&year. = mean (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;

proc summary data = mprice_sf_&year. chartype;
		var mprice_sf_&year.  ;
		class ward2002 ;
		where majority_hisp = 1;
		output out = mprice_sf_&year._majority_int (where = (_type_ = '1') keep = ward2002 mprice_sf_&year.  _type_) mean = ;
		run;
	proc transpose data = mprice_sf_&year._majority_int out =mprice_sf_&year._majority_t prefix = ward&year._;
		run;
	data mprice_sf_&year._majority;
		set mprice_sf_&year._majority_t;
		citywide_&year. = mean (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
proc summary data = mprice_sf_&year. chartype;
		var mprice_sf_&year.  ;
		class ward2002 ;
		where over20_hisp = 1;
		output out = mprice_sf_&year._20pct_int (where = (_type_ = '1') keep = ward2002 mprice_sf_&year.  _type_) mean = ;
		run;
	proc transpose data = mprice_sf_&year._20pct_int out =mprice_sf_&year._20pct_t prefix = ward&year._;
		run;
	data mprice_sf_&year._20pct;
		set mprice_sf_&year._20pct_t;
		citywide_&year. = mean (of ward&year._1-ward&year._8);
		*because the only wards with over 30% were 1 and 4;
			ward&year._4 = ward&year._3;
				ward&year._3 = .;
		rename _name_ = variable_name;
		run;
%end;
%mend;
%sumsales;






%macro cityall (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]sf_pr_citywide!r10c&col1.:r10c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_sf_&year._all;	put citywide_&year.; 	run;
%mend;
	%cityall (2000, 5);	%cityall (2001, 6);	%cityall (2002, 7);	%cityall (2003, 8);	%cityall (2004, 9);
	%cityall (2005, 10);	%cityall (2006, 11);	%cityall (2007, 12);	%cityall (2008, 13); %cityall (2009, 14); 

%macro wardall (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]sf_pr_ward!r9c&col1.:r9c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_sf_&year._all;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardall (2000, 4,11);	%wardall (2001, 12,19);	%wardall (2002, 20,27);	%wardall (2003, 28,35);	%wardall (2004, 36,43);
	%wardall (2005, 44,51);	%wardall (2006, 52,59);	%wardall (2007, 60,67);	%wardtanf (2008, 68,75);


%macro citymaj (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]sf_pr_citywide!r11c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_sf_&year._majority;	put citywide_&year.; 	run;
%mend;
	%citymaj (2000, 5);	%citymaj (2001, 6);	%citymaj (2002, 7);%citymaj (2003, 8);
	%citymaj (2004, 9);	%citymaj (2005, 10);	%citymaj (2006, 11);	%citymaj (2007, 12);	%citymaj (2008, 13);%citymaj (2009, 14); 

%macro wardmaj (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]sf_pr_ward!r10c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_sf_&year._majority;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardmaj (2000, 4,11);	%wardmaj (2001, 12,19);	%wardmaj (2002, 20,27);	%wardmaj (2003, 28,35);	%wardmaj (2004, 36,43);
	%wardmaj (2005, 44,51);	%wardmaj (2006, 52,59);	%wardmaj (2007, 60,67);	%wardmaj (2008, 68,75);

%macro city30 (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]sf_pr_citywide!r12c&col1.:r12c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set  mprice_sf_&year._20pct;	put citywide_&year.; 	run;
%mend;
	%city30 (2000, 5);	%city30 (2001, 6);	%city30 (2002, 7);	%city30 (2003, 8);	%city30 (2004, 9);
	%city30 (2005, 10);	%city30 (2006, 11);	%city30 (2007, 12);	%city30 (2008, 13); %city30 (2009, 14);

%macro ward30 (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]sf_pr_ward!r11c&col1.:r11c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set  mprice_sf_&year._20pct;	put ward&year._1 - ward&year._8; run;
%mend;
	%ward30 (2000, 4,11);	%ward30 (2001, 12,19);	%ward30 (2002, 20,27);	%ward30 (2003, 28,35);
	%ward30 (2004, 36,43);	%ward30 (2005, 44,51);	%ward30 (2006, 52,59);	%ward30 (2007, 60,67);	%ward30 (2008, 68,75);



************NOW FOR CONDOS;
%Macro createset;
		%do i = 2001 %to 2009;
		%let year= &i.;

		data mprice_condo_&year.;
			merge Realprop.Sales_sum_tr00  (in = a keep = geo2000 mprice_condo_&year.)
				ncdb.ncdb_lf_2000_dc
				Parcel_geo;
			by geo2000;
			
			if a;
			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.2 then over20_hisp = 1;
				else over20_hisp = 0;
				end;
			run;

		%end;
		%mend;
%createset;



%macro sumsales1;
	%do i = 2001 %to 2009;
	%let year= &i.;
	
proc summary data = mprice_condo_&year. chartype;
		var mprice_condo_&year.  ;
		class ward2002 ;
		output out = mprice_condo_&year._all_int (where = (_type_ = '1') keep = ward2002 mprice_condo_&year.  _type_) mean = ;
		run;
	proc transpose data = mprice_condo_&year._all_int out =mprice_condo_&year._all_t prefix = ward&year._;
		run;
	data mprice_condo_&year._all;
		set mprice_condo_&year._all_t;
		citywide_&year. = mean (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;

proc summary data = mprice_condo_&year. chartype;
		var mprice_condo_&year.  ;
		class ward2002 ;
		where majority_hisp = 1;
		output out = mprice_condo_&year._majority_int (where = (_type_ = '1') keep = ward2002 mprice_condo_&year.  _type_) mean = ;
		run;
	proc transpose data = mprice_condo_&year._majority_int out =mprice_condo_&year._majority_t prefix = ward&year._;
		run;
	data mprice_condo_&year._majority;
		set mprice_condo_&year._majority_t;
		citywide_&year. = mean (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
proc summary data = mprice_condo_&year. chartype;
		var mprice_condo_&year.  ;
		class ward2002 ;
		where over20_hisp = 1;
		output out = mprice_condo_&year._20pct_int (where = (_type_ = '1') keep = ward2002 mprice_condo_&year.  _type_) mean = ;
		run;
	proc transpose data = mprice_condo_&year._20pct_int out =mprice_condo_&year._20pct_t prefix = ward&year._;
		run;
	data mprice_condo_&year._20pct;
		set mprice_condo_&year._20pct_t;
		*because the only wards with over 30% were 1 and 4;
			ward&year._4 = ward&year._3;
				ward&year._3 = .;
		citywide_&year. = mean (of ward&year._1-ward&year._8);
		rename _name_ = variable_name;
		run;
%end;
%mend;
%sumsales1;






%macro cityall (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]condo_pr_citywide!r10c&col1.:r10c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_condo_&year._all;	put citywide_&year.; 	run;
%mend;
	%cityall (2000, 5);	%cityall (2001, 6);	%cityall (2002, 7);	%cityall (2003, 8);	%cityall (2004, 9);
	%cityall (2005, 10);	%cityall (2006, 11);	%cityall (2007, 12);	%cityall (2008, 13); %cityall (2009, 14);

%macro wardall (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]condo_pr_ward!r9c&col1.:r9c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_condo_&year._all;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardall (2000, 4,11);	%wardall (2001, 12,19);	%wardall (2002, 20,27);	%wardall (2003, 28,35);	%wardall (2004, 36,43);
	%wardall (2005, 44,51);	%wardall (2006, 52,59);	%wardall (2007, 60,67);	%wardtanf (2008, 68,75);


%macro citymaj (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]condo_pr_citywide!r11c&col1.:r11c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_condo_&year._majority;	put citywide_&year.; 	run;
%mend;
	%citymaj (2000, 5);	%citymaj (2001, 6);	%citymaj (2002, 7);%citymaj (2003, 8);
	%citymaj (2004, 9);	%citymaj (2005, 10);	%citymaj (2006, 11);	%citymaj (2007, 12);	%citymaj (2008, 13); %citymaj (2009, 14);

%macro wardmaj (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]condo_pr_ward!r10c&col1.:r10c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set mprice_condo_&year._majority;	put ward&year._1 - ward&year._8; run;
%mend;
	%wardmaj (2000, 4,11);	%wardmaj (2001, 12,19);	%wardmaj (2002, 20,27);	%wardmaj (2003, 28,35);	%wardmaj (2004, 36,43);
	%wardmaj (2005, 44,51);	%wardmaj (2006, 52,59);	%wardmaj (2007, 60,67);	%wardmaj (2008, 68,75);

%macro city30 (year, col1);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]condo_pr_citywide!r12c&col1.:r12c&col1." /*notab*/;
	data _null_ ;	file fdstamps ;	set  mprice_condo_&year._20pct;	put citywide_&year.; 	run;
%mend;
	%city30 (2000, 5);	%city30 (2001, 6);	%city30 (2002, 7);	%city30 (2003, 8);	%city30 (2004, 9);
	%city30 (2005, 10);	%city30 (2006, 11);	%city30 (2007, 12);	%city30 (2008, 13); %city30 (2009, 14);

%macro ward30 (year, col1, col2);
filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[sales 09.xls]condo_pr_ward!r11c&col1.:r11c&col2." /*notab*/;
	data _null_ ;	file fdstamps ;	set  mprice_condo_&year._20pct;	put ward&year._1 - ward&year._8; run;
%mend;
	%ward30 (2000, 4,11);	%ward30 (2001, 12,19);	%ward30 (2002, 20,27);	%ward30 (2003, 28,35);
	%ward30 (2004, 36,43);	%ward30 (2005, 44,51);	%ward30 (2006, 52,59);	%ward30 (2007, 60,67);	%ward30 (2008, 68,75);
