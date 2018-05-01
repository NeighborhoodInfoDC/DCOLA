/**************************************************************************
 Program:  Tables_ipums_SOIAA_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/01/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Create IPUMS tables for DC State of Immigrants/African
 Americans report, 2018. 

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )

proc format;

  value yeartbl
    0 = '2000'
    2015 = '2011-15'
    2016 = '2012-16';
    
  value raceth
    1 = 'Black'
    2 = 'White'
    3 = 'Latino'
    4 = 'Asian/Pacific Islander'
    5 = 'Other race'
    6 = 'Multiple races';

run;

proc tabulate data=DCOLA.Ipums_SOIAA_2018 format=comma12.0 noseps missing;
  where year in ( 0, 2016 );
  class year;
  var total immigrant_1gen latino_1gen asianpi_1gen african_1gen otherimm_1gen;
  weight perwt;
  table 
    /** Rows **/
    total='Total population' 
    immigrant_1gen='Immigrants (1st gen.)'
    latino_1gen='Latinos' 
    asianpi_1gen='Asian/Pacific Islanders' 
    african_1gen='Africans' 
    otherimm_1gen='Other immigrants',
    /** Columns **/
    sum='Persons' * year=' '
    pctsum<total>='Percent' * year=' ' * f=comma12.1
  ;
  format year yeartbl. raceth raceth.;
run;


proc tabulate data=DCOLA.Ipums_SOIAA_2018 format=comma12.0 noseps missing;
  where year in ( 0, 2016 ) and immigrant_1gen;
  class year;
  class raceth;
  var total;
  weight perwt;
  table 
    /** Rows **/
    
    ( all='Total' raceth='Race/ethnicity' ) * total=' ',
    /** Columns **/
    sum='Persons' * year=' '
    colpctsum='Percent' * year=' ' * f=comma12.1
  ;
  format year yeartbl. raceth raceth.;
run;
