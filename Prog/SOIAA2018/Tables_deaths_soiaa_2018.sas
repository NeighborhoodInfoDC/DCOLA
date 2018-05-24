/**************************************************************************
 Program:  Tables_deaths_soiaa_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/23/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Death tables for 2018 State of AA report.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( Vital )

libname vitalraw 'L:\Libraries\Vital\Raw\2018';

/*
%File_info( data=Vitalraw.D0308final, printobs=0, stats=, freqvars=dyear )
%File_info( data=Vitalraw.D0916final, printobs=0, stats=, freqvars=dyear )
*/


proc format;
  value black 
    1 = 'Black'
    2 = 'All others';

data Deaths;

  set 
    Vitalraw.D0308final (drop=address)
    Vitalraw.D0916final (drop=address);

  retain Total 1;

  ** Recoded Hispanic status **;
  
  if race = 'Black' and latino_dec ~= 'Hispanic' then Black = 1;
  else if race not in ( 'Unknown', '' ) then Black = 2;
  
  ** Clean age and date vars **;

  age_n = 1 * age;
  
  byear_n = 1 * byear;
  bmonth_n = 1 * bmonth;
  bday_n = 1 * bday;
  
  if bmonth_n > 12 then bmonth_n = 7;
  if bday_n > 31 then bday_n = 15;

  dyear_n = 1 * dyear;
  dmonth_n = 1 * dmonth;
  dday_n = 1 * dday;
  
  if dmonth_n > 12 then dmonth_n = 7;
  if dday_n > 31 then dday_n = 15;
  
  if 0 <= byear_n < 1900 then do;
  
    /*put byear_n= dyear_n= age_n= age_unit= @;*/

    if age_unit in ( '0', '1' ) then century = 100 * int( ( dyear_n - age_n ) / 100 );
    else if age_unit in ( '2', '4', '5', '6' ) then century = 100 * int( dyear_n / 100 );
    
    byear_n = century + byear_n;
    
    /*put '// ' century= byear_n=;*/
    
  end;
  else if byear_n = 9999 then byear_n = .u;

  ** Calculate age at death in years **;
  
  Birth_dt = mdy( bmonth_n, bday_n, byear_n );
  Death_dt = mdy( dmonth_n, dday_n, dyear_n );

  if ( birth_dt > death_dt ) /*or ( age_unit = '0' and age_calc < 100 )*/ then 
      birth_dt = intnx( 'year', birth_dt, -100, 'sameday' );

  Age_calc = ( Death_dt - Birth_dt ) / 365.25;
  
  ** Age_unit: 0/1=Years, 2=Months, 4=Days, 5=Hours, 6=Minutes, 9=Unknown/Not Classifiable **;
  
  if missing( Age_calc ) then do;
    if age_n > 0 then do;
      select ( age_unit );
        when ( '0', '1' ) Age_calc = age_n;
        when ( '2' ) Age_calc = age_n / 12;
        when ( '4' ) Age_calc = age_n / 365.25;
        when ( '5' ) Age_calc = age_n / ( 365.25 * 24 );
        when ( '6' ) Age_calc = age_n / ( 365.25 * 24 * 60 );
        otherwise do;
          Age_calc = .u;
        end;
      end;
    end;
    else do;
      Age_n = .u;
      Age_calc = .u;
    end;
  end;
  
  if age_unit in ( '0', '1' ) and abs( age_calc - age_n ) > 1 then do;
    /*PUT BIRTH_DT= DEATH_DT= AGE_N= AGE_UNIT= AGE_CALC= @;*/
    birth_dt = intnx( 'year', birth_dt, int( age_calc - age_n ), 'sameday' );
    Age_calc = ( Death_dt - Birth_dt ) / 365.25;
    /*PUT '// ' BIRTH_DT= AGE_CALC=;*/
  end;
  
  format birth_dt death_dt mmddyy10.;
  
  ** Death codes **;
  
  %let icdv = 10;

  ** Create 3-digit death code **;
  
  Icd&icdv._4d = left( compress( upcase( Icd&icdv._4d ), '-' ) );
  
  * Remove trailing X character *;
  
  if substr( reverse( Icd&icdv._4d ), 1, 1 ) = 'X' then
    Icd&icdv._4d = substr( Icd&icdv._4d, 1, length( Icd&icdv._4d ) - 1 );
    
  length Icd&icdv._3d $ 3;
  
  Icd&icdv._3d = Icd&icdv._4d;
  
  label Icd&icdv._3d = "Cause of death (ICD-&icdv, 3-digit)";
  
  format Icd&icdv._3d $Icd&icdv.3a.;
    
  ** Cause of death variables **;
 
  if not( missing( put( Icd&icdv._3d, $Icd&icdv.3v. ) ) ) then do;

    Deaths_w_cause = 1;
    
    Deaths_homicide = 0;
    Deaths_suicide = 0;
    Deaths_accident = 0;
    Deaths_violent = 0;
    Deaths_heart = 0;
    Deaths_cancer = 0;
    Deaths_hiv = 0;
    Deaths_diabetes = 0;
    Deaths_hypert = 0;
    Deaths_cereb = 0;
    Deaths_liver = 0;
    Deaths_respitry = 0;
    Deaths_oth_caus = 0;

    if put( icd10_3d, $icd10s. ) = "Intentional self-harm" then Deaths_suicide = 1;
    else if put( icd10_3d, $icd10s. ) = "Assault" then Deaths_homicide = 1;
    else if icd10_3d in: ( 'V', 'W', 'X' ) then Deaths_accident = 1;
    else if icd10_3d in ( 'I01', 'I11', 'I13' ) or
       put( icd10_3d, $icd10s. ) in: 
         ( "Chronic rheumatic heart diseases",
           "Ischaemic heart diseases",
           "Pulmonary heart disease",
           "Other forms of heart disease" )
      then Deaths_heart = 1;
    else if icd10_3d =: 'C' then Deaths_cancer = 1;
    else if put( icd10_3d, $icd10s. ) = "Human immunodeficiency virus [HIV] disease" then Deaths_hiv = 1;
    else if put( icd10_3d, $icd10s. ) = "Diabetes mellitus" then Deaths_diabetes = 1;
    else if put( icd10_3d, $icd10s. ) = "Hypertensive diseases" then Deaths_hypert = 1;
    else if put( icd10_3d, $icd10s. ) = "Cerebrovascular diseases" then Deaths_cereb = 1;
    else if put( icd10_3d, $icd10s. ) = "Diseases of liver" then Deaths_liver = 1;
    else if icd10_3d =: 'J' then Deaths_respitry = 1;
    else Deaths_oth_caus = 1;

    Deaths_violent = sum( Deaths_suicide, Deaths_homicide, Deaths_accident );
    
  end;
  else do;
    Deaths_w_cause = 0;
  end;
    
  label
    Deaths_homicide = 'Deaths from homicide'
    Deaths_suicide = 'Deaths from suicide'
    Deaths_accident = 'Accidental deaths'
    Deaths_violent = 'Violent deaths (homicide/suicide/accidents)'
    Deaths_heart = 'Deaths from heart disease'
    Deaths_cancer = 'Deaths from cancer'
    Deaths_hiv = 'Deaths from HIV'
    Deaths_diabetes = 'Deaths from diabetes'
    Deaths_hypert = 'Deaths from hypertensive diseases'
    Deaths_cereb = 'Deaths from cerebrovascular diseases'
    Deaths_liver = 'Deaths from liver diseases'
    Deaths_respitry = 'Deaths from respiratory diseases'
    Deaths_oth_caus = 'Deaths from other causes'
    Deaths_w_cause = 'Deaths with cause reported';
  
  drop century;
    
run;

%File_info( data=Deaths, printobs=0, freqvars=dyear race latino_dec black age_unit )


** Create tables **;

/** Macro Table - Start Definition **/

%macro Table( var=, label= );

  title3 &label;

  proc tabulate data=Deaths format=comma12.0 noseps missing;
    where not( missing( black ) ) and not( missing( &var ) );
    class dyear black;
    var &var;
    table 
      /** Rows **/
      &var=' ' * dyear=' '
      ,
      /** Columns **/
      sum=&label * (
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

%mend Table;

/** End Macro Definition **/



%fdate()

options nodate nonumber;
options missing='-';

ods listing close;

ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Tables_deaths_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt
    /*bodytitle*/;
    
title1 "State of African Americans Report, 2018";
title2 " ";

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

  proc tabulate data=Deaths format=comma12.0 noseps missing;
    where not( missing( black ) ) and deaths_w_cause > 0;
    class dyear black;
    var Total Deaths_: ;
    table 
      /** Pages **/
      dyear
      ,
      /** Rows **/
      Total
      Deaths_homicide 
      Deaths_suicide
      Deaths_accident 
      Deaths_heart
      Deaths_cancer
      Deaths_hiv
      Deaths_diabetes 
      Deaths_hypert
      Deaths_cereb
      Deaths_liver
      Deaths_respitry 
      Deaths_oth_caus       
      ,
      /** Columns **/
      sum='Deaths by cause' * (
        all='Total'
        black='By race'
      )
      pctsum<total>='Percent' * (
        all='Total'
        black='By race'
      ) * f=comma12.1
    ;
    format black black.;
  run;


%Table( var=Total, label="All deaths" )
%Table( var=Deaths_homicide, label="Deaths from homicide" )
%Table( var=Deaths_suicide, label="Deaths from suicide" )
%Table( var=Deaths_accident, label="Deaths from accident" )
%Table( var=Deaths_violent, label="Deaths from violence" )
%Table( var=Deaths_heart, label="Deaths from heart disease" )
%Table( var=Deaths_cancer, label="Deaths from cancer" )
%Table( var=Deaths_hiv, label="HIV related deaths" )
%Table( var=Deaths_diabetes, label="Deaths from diabetes" )
%Table( var=Deaths_hypert, label="Deaths from hypertensive diseases" )
%Table( var=Deaths_cereb, label="Deaths from cerebrovascular diseases" )
%Table( var=Deaths_liver, label="Deaths from liver diseases" )
%Table( var=Deaths_respitry, label="Deaths from respiratory diseases" )

ods rtf close;
ods listing;

title1;
footnote1;

