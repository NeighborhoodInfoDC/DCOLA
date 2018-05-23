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
%File_info( data=Vitalraw.B1016final, printobs=0, freqvars=birthyr )
%File_info( data=Vitalraw.B9final, printobs=0, freqvars=birthyr )
*/

data Births;

  set 
    Vitalraw.B0308final (drop=address)
    Vitalraw.B9final (drop=address)
    Vitalraw.B1016final (drop=address);

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

  %Prenatal_kessner( gest_age=gest_age_n, num_visit=num_visit_n, pre_care=pre_care_n )

run;

%File_info( data=Births, printobs=0, freqvars=birthyr mrace latino_new )

proc univariate data=Births;
  var bweight_n;
run;
