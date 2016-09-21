**************************************************************************
 Program:  Hispanic_population.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   MGrosz
 Created:  08/19/09
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  What are the clusters with a lot of Latinos?

 Modifications:
**************************************************************************/;


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
*%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( General )
%DCData_lib( ncdb )

proc sort data = General.Wt_tr00_hmt05 ;
	by geo2000;
	run;

proc sort data = Ncdb.Ncdb_lf_2000_dc ;
	by geo2000;
	run;

data dcola.persons_geo;
	merge General.Wt_tr00_hmt05 
			Ncdb.Ncdb_lf_2000_dc;
		by geo2000;

			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.3 then over30_hisp = 1;
				else over30_hisp = 0;
				end;
	run;

proc means data = dcola.persons_geo noprint nway;
	class cluster_tr2000;
	var /*latino = */shrhsp0n
	/*black = */shrnhb0n  
	/*white = */shrnhw0n 
	/*asian = */shrnha0n 
	/*ntv_american = */shrnhi0n
	/*other = */shrnho0n
	/*denom = */shr0d;
	output  out=dcola.persons_cluster2000 sum = ;
	run;


filename fdstamps  dde  "Excel|K:\Metro\PTatian\DCData\Libraries\DCOLA\Doc\Tables\[persons_ward_1970_2000.xls]persons_ward_2000!r3c12:r50c18" /*notab*/;
	data _null_ ;	
file fdstamps ;	
set dcola.persons_cluster2000;	
put /*latino = */shrhsp0n
	/*black = */shrnhb0n  
	/*white = */shrnhw0n 
	/*asian = */shrnha0n 
	/*ntv_american = */shrnhi0n
	/*other = */shrnho0n
	/*denom = */shr0d;
run;







proc sort data = ncdb.ncdb_lf_2000_dc;
	by geo2000;
	run;
data dcola.persons_geo_ward;
	merge General.Wt_tr00_ward02 
			Ncdb.Ncdb_lf_2000_dc;
		by geo2000;

			if trctpop0 > 0 then do;
			share_hispanic = shrhsp0n / trctpop0;
			if share_hispanic > 0.5 then majority_hisp = 1;
				else majority_hisp = 0;
			if share_hispanic > 0.3 then over30_hisp = 1;
				else over30_hisp = 0;
				end;
	run;
proc sort data = crimes_prop_2007 nodupkey out = testtest;;
	by geo2000;
	where over30_hisp = 1;
	run;
proc freq data = testtest;
	table ward2002;
		where over30_hisp = 1;
		run;
