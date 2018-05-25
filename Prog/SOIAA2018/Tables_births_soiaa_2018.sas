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

/*
%File_info( data=Vitalraw.B0308final, printobs=0, freqvars=birthyr )
%File_info( data=Vitalraw.B9final, printobs=0, freqvars=birthyr num_visit gest_age pre_care )
%File_info( data=Vitalraw.B1016final, printobs=0, freqvars=birthyr num_visit gest_age  )
*/

proc format;
  value black 
    1 = 'Black'
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
  
  ** Check birth dates **;
  
  if not missing( date ) and year( date ) ~= 1 * birthyr then do;
    %warn_put( msg="Birth date in wrong year: " _n_= date= birthyr= birthmo= birthdy= )
  end;
  
  ** Fill in missing vars for 2010 - 2016 data **;
  
  if birthyr in ( '2010', '2011', '2012', '2013', '2014', '2015', '2016' ) then do;
  
    concept_dt = intnx( 'week', date, -1 * gest_age_n, 'same' );
  
    pre_care_n = intck( 'week', concept_dt, dofp_date ) + 1;
    
  end;
  
  if birthyr ~= '2009' then do;  ** Skip prenatal calc for 2009 because too much missing data **;

    %Prenatal_kessner( gest_age=gest_age_n, num_visit=num_visit_n, pre_care=pre_care_n )
    
  end;
  
  if 0 < mage_n < 20 then kMage = 1;
  else if 20 <= mage_n then kMage = 0;
  
  if 0 < bweight_n < 2500 then kbweight = 1;
  else if 2500 <= bweight_n then kbweight = 0;
  
  format date concept_dt mmddyy10.;

run;

%File_info( data=Births, printobs=0, freqvars=birthyr mrace latino_new black )


title2 "** Check 2010 - 2016 computed vars **";

options nolabel;

proc means data=Births n sum mean min max;
  where birthyr in ( '2010', '2011', '2012', '2013', '2014', '2015', '2016' );
run;

options label;

proc print data=Births (obs=100);
  where birthyr in ( '2010', '2011', '2012', '2013', '2014', '2015', '2016' );
  var date gest_age gest_age_n concept_dt num_visit_n dofp_date pre_care_n Births_prenat_1st Births_prenat_adeq;
run;

title2;


** Create tables **;

/** Macro Table - Start Definition **/

%macro Table( var=, label=, title= );

  title3 "&title";

  proc tabulate data=Births format=comma12.0 noseps missing;
    where not( missing( black ) ) and not( missing( &var ) );
    class birthyr black;
    var Total &var;
    table 
      /** Rows **/
      birthyr=' '
      ,
      /** Columns **/
      Total='All births' * sum=' '
      &var=' ' * sum=' ' * (
        all="&label"
        black='By race'
      )
      &var=' ' * pctsum<total>=' ' * (
        all="Percent %lowcase(&label)"
        black='By race'
      ) * f=comma12.1
    ;
    format black black.;
  run;
  
  title3;

%mend Table;

/** End Macro Definition **/



%fdate()

options nodate nonumber;
options missing='-';

ods listing close;

ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Tables_births_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt
    /*bodytitle*/;
    
title1 "State of African Americans Report, 2018";
title2 " ";

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

title3 "All births";

proc tabulate data=Births format=comma12.0 noseps missing;
  where not( missing( black ) );
  class birthyr black;
  var Total;
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
  format black black.;
run;

title3;


%Table( var=kMage, label=Teen\~births, title=Births to teenage mothers )

%Table( var=kbweight, label=Low\~weight\~births, title=%str(Low weight births (under 2,500 grams)) )

%Table( var=Births_prenat_adeq, label=Adequate\~prenatal\~care, title=Births with adequate prenatal care )

%Table( var=Births_prenat_inad, label=Inadequate\~prenatal\~care, title=Births with inadequate prenatal care )

ods rtf close;
ods listing;

title1;
footnote1;

