/**************************************************************************
 Program:  Tables_births_soiaa_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/22/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Birth tables for 2018 State of AA report.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( Vital )

libname vitalraw 'L:\Libraries\Vital\Raw\2018';

%let GRAMS_TO_LBS = 0.00220462262;

/*
%File_info( data=Vitalraw.B0308final, printobs=0, freqvars=birthyr )
%File_info( data=Vitalraw.B1016final, printobs=0, freqvars=birthyr )
%File_info( data=Vitalraw.B9final, printobs=0, freqvars=birthyr )
*/

proc format;
  value black 
    1 = 'African American'
    2 = 'All others';

data Births;

  set 
    Vitalraw.B0308final (drop=address)
    Vitalraw.B9final (drop=address)
    Vitalraw.B1016final (drop=address);

  retain Total 1;

  if mrace = 'Black' and latino_new ~= 'Hispanic' then Black = 1;
  else if mrace ~= 'Unknown' then Black = 2;

  mage_n = 1 * mage;
  bweight_n = 1 * bweight;
  gest_age_n = 1 * gest_age;
  num_visit_n = 1 * num_visit;
  pre_care_n = 1 * pre_care;

  if mage_n = 99 then mage_n = .u;
  if bweight_n = 9999 then bweight_n = .u;
  if gest_age_n = 99 then gest_age_n = .u;
  if num_visit_n = 99 then num_visit_n = .u;
  if pre_care_n = 99 then pre_care_n = .u;

  if not( missing( bweight_n ) ) then 
    Bweight_lbs = bweight_n * &GRAMS_TO_LBS;
  else 
    Bweight_lbs = .u;
  
  label bweight_lbs = "Child's birth weight (lbs)";
  
  %Prenatal_kessner( gest_age=gest_age_n, num_visit=num_visit_n, pre_care=pre_care_n )
  
  if 0 < mage_n < 20 then kMage = 1;
  else if 20 <= mage_n then kMage = 0;
  
  if 0 < bweight_lbs < 5.5 then kbweight = 1;
  else if 5.5 <= bweight_lbs then kbweight = 0;

run;

%File_info( data=Births, printobs=0, freqvars=birthyr mrace latino_new black )


** Create tables **;

%fdate()

options nodate nonumber;
options missing='-';

ods listing close;

ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Tables_births_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt
    /*bodytitle*/;
    
title1 "State of African Americans Report, 2018";
title2 " ";
title3 "Births";

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';


proc tabulate data=Births format=comma12.0 noseps missing;
  where not( missing( black ) );
  class birthyr black;
  var Total kMage kbweight;
  table 
    /** Rows **/
    Total=' ' * birthyr=' '
    ,
    /** Columns **/
    sum='All births' * (
      all='Total'
      black='By race'
    )
    rowpctsum='Percent' * (
      all='Total'
      black='By race'
    ) * f=comma12.1
  ;
  table 
    /** Rows **/
    kMage=' ' * birthyr=' '
    ,
    /** Columns **/
    sum='Births to teenage mothers' * (
      all='Total'
      black='By race'
    )
    rowpctsum='Percent' * (
      all='Total'
      black='By race'
    ) * f=comma12.1
  ;
  table 
    /** Rows **/
    kbweight=' ' * birthyr=' '
    ,
    /** Columns **/
    sum='Low weight births (under\~5.5\~lbs)' * (
      all='Total'
      black='By race'
    )
    rowpctsum='Percent' * (
      all='Total'
      black='By race'
    ) * f=comma12.1
  ;
  format black black.;
run;

ods rtf close;
ods listing;

title1;
footnote1;

