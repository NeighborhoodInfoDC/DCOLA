* program name: tracts_with_latinos_09.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  what are the tracts with high shares of latinos?

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
proc sort data = general.geo2000;
	by geo2000;
	run;


		data ola.tracts_latino;
			merge ncdb_lf_2000_dc
				Parcel_geo
				general.geo2000;
			by geo2000;
			
			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.2 then over20_hisp = 1;
				else over20_hisp = 0;
				end;
			run;
proc means sum data = ola.tracts_latino;
*	where over20_hisp = 1;
	var shrhsp0n trctpop0;
	run;
