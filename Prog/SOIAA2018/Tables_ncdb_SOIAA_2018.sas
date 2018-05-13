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

proc format;
  value $statecd_a 
    '11' = "District of Columbia"
    other = "Suburbs";
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


proc tabulate data=NCDB.NCDB_master_update format=comma12.0 noseps missing;
  class statecd;
  var trctpop7 trctpop8 trctpop9 trctpop0 trctpop1a forborn7 forborn8 forborn9 forborn0 forborn1a;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='Total population' *
    ( trctpop7='1970' trctpop8='1980' trctpop9='1990' trctpop0='2000' trctpop1a='2006-10' )
  ;
  table 
    /** Rows **/
    all='Washington metro area' 
    statecd=' ',
    /** Columns **/
    sum='Foreign born persons' *
    ( forborn7='1970' forborn8='1980' forborn9='1990' forborn0='2000' forborn1a='2006-10' )
  ;
  format statecd $statecd_a.;
run;

ods rtf close;
ods listing;

title1;
footnote1;
