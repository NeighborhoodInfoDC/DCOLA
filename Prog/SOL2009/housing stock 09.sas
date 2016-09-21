** program name: housing stock_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  what is the housing stock in Latino neighborhoods? Are they mostly condos?
** Date Created: 6/30/09
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
	rsubmit; proc download data=Realprop.Parcel_base    out=Realprop.Parcel_base  ;run;endrsubmit;
*/



proc sort data = Realprop.Parcel_geo nodupkey out = Parcel_geo 
				(keep = geo2000 
						ward2002 ssl);
	by ssl;
	run;
proc sort data = realprop.parcel_base nodupkey out = parcel_base;
	by ssl;
	run;
data parcel_tot;
	merge parcel_geo parcel_base;
	by ssl;
	if ui_proptype not in ('10','11','12','13','19') then delete;
	if ui_proptype = '10' then single_family = 1;
		else single_family = 0;
	if ui_proptype = '11' then condo = 1;
		else condo = 0;
	if ui_proptype not in ('10','11') then other_housing = 1;
		else other_housing = 0;
	run;
proc means data = parcel_tot noprint ;
	class geo2000;
	var single_family condo other_housing;
	output out = proptype_sum sum=;
	run;



proc sort data = ncdb.ncdb_lf_2000_dc out = ncdb_lf_2000_dc 
				(keep = geo2000 
						trctpop0 /*Total population, 2000  */
						shrhsp0n /*Total Hisp./Latino population, 2000 */
						shr0d );
	by geo2000;
	run;



data latino_proptype;
			merge proptype_sum  (in = a where = (_type_ = 1))
				ncdb.ncdb_lf_2000_dc;
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


proc means data = latino_proptype chartype noprint;
	class majority_hisp over20_hisp;
	var single_family condo other_housing;
	output out = citywide_stock (where = ( _type_ = '00')) sum =;
	output out = majority_stock (where = ( _type_ = '10' and majority_hisp = 1)) sum =;
	output out = over20_stock (where = ( _type_ = '01' and over20_hisp =1)) sum =;
	run;

filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[housing stock 09.xls]data!r9c4:r9c6" /*notab*/;
data _null_ ;	file fdstamps ;	set citywide_stock;	put single_family condo other_housing; 	run;

filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[housing stock 09.xls]data!r10c4:r10c6" /*notab*/;
data _null_ ;	file fdstamps ;	set majority_stock;	put single_family condo other_housing; 	run;

filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[housing stock 09.xls]data!r11c4:r11c6" /*notab*/;
data _null_ ;	file fdstamps ;	set over20_stock;	put single_family condo other_housing; 	run;
