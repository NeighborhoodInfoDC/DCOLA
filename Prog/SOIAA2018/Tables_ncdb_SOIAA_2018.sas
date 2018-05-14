/**************************************************************************
 Program:  Tables_ncdb_SOIAA_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/08/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Create tables from NCDB data for 2018 SOI/AA reports.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( NCDB )
%DCData_lib( ACS )

proc format;
  value $statecd_a 
    '11' = "District of Columbia"
    other = "Suburbs";
run;

data Tables_ncdb_SOIAA_2018;

  merge
    NCDB.NCDB_master_update
      (keep=geo2010 ucounty statecd trctpop7 trctpop8 trctpop9 trctpop0 trctpop1 trctpop1a 
            forborn7 forborn8 forborn9 forborn0 forborn1a
            shrnhw0n shrnhw1n shrnhw8n shrnhw9n 
            shrblk0n shrblk1n shrblk7n shrblk8n shrblk9n
       where=(put( ucounty, $ctym15f. ) = "47900")
       in=in1)
    Acs.Acs_sf_2012_16_dc_tr10 
      (keep=geo2010 b01001e1 b05006e: b02001e: b03002e:)
    Acs.Acs_sf_2012_16_md_tr10 
      (keep=geo2010 b01001e1 b05006e: b02001e: b03002e:)
    Acs.Acs_sf_2012_16_va_tr10 
      (keep=geo2010 b01001e1 b05006e: b02001e: b03002e:)
    Acs.Acs_sf_2012_16_wv_tr10 
      (keep=geo2010 b01001e1 b05006e: b02001e: b03002e:);
  by geo2010;
  
  if in1;

  Trctpop_1216 = b01001e1;
  Forborn_1216 = b05006e1;
  Latino_1216 = sum( b05006e125, b05006e138, b05006e148 );
  Asianpi_1216 = sum( b05006e47, b05006e121, b05006e122 );
  African_1216 = b05006e91;

  shrblk_1216 = B02001e3;
  shrnhw_1216 = B03002e3;

  drop b01001e1 b05006e: b02001e: b03002e:;

run;
    

%fdate()

ods listing close;

ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Tables_ncdb_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt
    /*bodytitle*/;
    
title1 "State of Immigrants Report, 2018";
title2 "Historical population";
title3 " ";

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';


proc tabulate data=Tables_ncdb_SOIAA_2018 format=comma12.0 noseps missing;
  class statecd;
  var trctpop7 trctpop8 trctpop9 trctpop0 trctpop1 trctpop1a trctpop_1216 
      forborn7 forborn8 forborn9 forborn0 forborn1a forborn_1216
      shrnhw0n shrnhw1n shrnhw8n shrnhw9n shrnhw_1216
      shrblk0n shrblk1n shrblk7n shrblk8n shrblk9n shrblk_1216;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='Total population' *
    ( trctpop7='1970' trctpop8='1980' trctpop9='1990' trctpop0='2000' trctpop1a='2006-10' trctpop_1216='2012-16' )
  ;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='Foreign born persons' *
    ( forborn7='1970' forborn8='1980' forborn9='1990' forborn0='2000' forborn1a='2006-10' forborn_1216='2012-16' )
  ;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='Total population' *
    ( trctpop7='1970' trctpop8='1980' trctpop9='1990' trctpop0='2000' trctpop1='2010' trctpop_1216='2012-16' )
  ;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='African American population' *
    ( shrblk7n='1970' shrblk8n='1980' shrblk9n='1990' shrblk0n='2000' shrblk1n='2010' shrblk_1216='2012-16' )
  ;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='Non-Latino white population' *
    ( shrnhw8n='1980' shrnhw9n='1990' shrnhw0n='2000' shrnhw1n='2010' shrnhw_1216='2012-16' )
  ;
  format statecd $statecd_a.;
run;

ods rtf close;
ods listing;

title1;
footnote1;
