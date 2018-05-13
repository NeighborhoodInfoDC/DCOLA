/**************************************************************************
 Program:  Crime_exposure_SOIAA_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/13/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Create crime exposure indicators for SOI/AA 2018 reports.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( ACS )
%DCData_lib( Police )

data A;

  merge
    Acs.Acs_sf_2012_16_dc_tr10 (keep=geo2010 b01001e1 b05006e: B05003Ae: B05003Be:)
    Police.Crimes_sum_tr10 (where=(geo2010=:'11'));
  by Geo2010;
  
  Forborn = b05006e1;
  Latino = sum( b05006e125, b05006e138, b05006e148 );
  Asianpi = sum( b05006e47, b05006e121, b05006e122 );
  African = b05006e91;
  
  Natborn = b01001e1 - Forborn;
  White_nb = sum( B05003Ae4, B05003Ae9, B05003Ae15, B05003Ae20 );
  Black_nb = sum( B05003Be4, B05003Be9, B05003Be15, B05003Be20 );

  drop b05006e: B05003Ae: B05003Be:;
  
  rename b01001e1=TotalPop;

run;

%File_info( data=A, printobs=0, freqvars=geo2010 )

proc summary data=A;
  var TotalPop Forborn Latino Asianpi African Natborn White_nb Black_nb Crimes_pt1_2017 Crimes_pt1_violent_2017;
  output out=A_sum sum= / autolabel autoname;
run;

%File_info( data=A_sum, printobs=0 )

%macro Crime_exp( total=TotalPop, crimes= );

  Crime_rate_&crimes. = Crimes_&crimes. / TotalPop_sum;
  
  Latino_exp_&crimes. = ( ( ( Latino / TotalPop ) * Crimes_&crimes. ) / ( Latino_sum / TotalPop_sum ) ) / TotalPop_sum;
  Asianpi_exp_&crimes. = ( ( ( Asianpi / TotalPop ) * Crimes_&crimes. ) / ( Asianpi_sum / TotalPop_sum ) ) / TotalPop_sum;
  African_exp_&crimes. = ( ( ( African / TotalPop ) * Crimes_&crimes. ) / ( African_sum / TotalPop_sum ) ) / TotalPop_sum;

  Natborn_exp_&crimes. = ( ( ( Natborn / TotalPop ) * Crimes_&crimes. ) / ( Natborn_sum / TotalPop_sum ) ) / TotalPop_sum;
  White_nb_exp_&crimes. = ( ( ( White_nb / TotalPop ) * Crimes_&crimes. ) / ( White_nb_sum / TotalPop_sum ) ) / TotalPop_sum;
  Black_nb_exp_&crimes. = ( ( ( Black_nb / TotalPop ) * Crimes_&crimes. ) / ( Black_nb_sum / TotalPop_sum ) ) / TotalPop_sum;
  
%mend Crime_exp;

data Crime_exposure_SOIAA_2018;

  set A;
  
  if _n_ = 1 then set A_sum;  ** Merge sum vars with all tract records **;
  
  %Crime_exp( crimes=pt1_2017 )
  %Crime_exp( crimes=pt1_violent_2017 )
  %Crime_exp( crimes=pt1_property_2017 )
  
  %Crime_exp( crimes=pt1_2012 )
  %Crime_exp( crimes=pt1_violent_2012 )
  %Crime_exp( crimes=pt1_property_2012 )
  
run;

%File_info( data=Crime_exposure_SOIAA_2018, printobs=0 )

ods rtf file="D:\DCData\Libraries\DCOLA\Prog\SOIAA2018\Crime_exposure_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt;
ods startpage=no;

proc tabulate data=Crime_exposure_SOIAA_2018 format=comma12.4 noseps missing;
  var 
    Crime_rate_: Latino_exp_: Asianpi_exp_: African_exp_: Natborn_exp_: White_nb_exp_: Black_nb_exp_:
   ;
  table 
    sum='Exposure to pt 1 crimes, 2017' * (
      Crime_rate_pt1_2017='Total population'
      Latino_exp_pt1_2017='Latino immigrants'
      Natborn_exp_pt1_2017='Native born population'
    );
  table
    sum='Exposure to violent crimes, 2017' * (
      Crime_rate_pt1_violent_2017='Total population'
      Latino_exp_pt1_violent_2017='Latino immigrants'
      Natborn_exp_pt1_violent_2017='Native born population'
    );
  table
    sum='Exposure to property crimes, 2017' * (
      Crime_rate_pt1_property_2017='Total population'
      Latino_exp_pt1_property_2017='Latino immigrants'
      Natborn_exp_pt1_property_2017='Native born population'
    );
run;

proc tabulate data=Crime_exposure_SOIAA_2018 format=comma12.4 noseps missing;
  var 
    Crime_rate_: Latino_exp_: Asianpi_exp_: African_exp_: Natborn_exp_: White_nb_exp_: Black_nb_exp_:
   ;
  table 
    sum='Exposure to pt 1 crimes, 2012' * (
      Crime_rate_pt1_2012='Total population'
      Latino_exp_pt1_2012='Latino immigrants'
      Natborn_exp_pt1_2012='Native born population'
    );
  table
    sum='Exposure to violent crimes, 2012' * (
      Crime_rate_pt1_violent_2012='Total population'
      Latino_exp_pt1_violent_2012='Latino immigrants'
      Natborn_exp_pt1_violent_2012='Native born population'
    );
  table
    sum='Exposure to property crimes, 2012' * (
      Crime_rate_pt1_property_2012='Total population'
      Latino_exp_pt1_property_2012='Latino immigrants'
      Natborn_exp_pt1_property_2012='Native born population'
    );
run;

ods startpage=now;

ods rtf close;
ods listing;
