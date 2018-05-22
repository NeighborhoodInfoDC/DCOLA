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

** Combine tract-level population and crime data **;

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

proc summary data=A;
  var TotalPop Forborn Latino Asianpi African Natborn White_nb Black_nb Crimes_pt1_2017 Crimes_pt1_violent_2017;
  output out=A_sum sum= / autolabel autoname;
run;


%************************************************************************************
    Calculate crime exposure rate

    Exposure rate of group G is calculated as 

      Exposure = 1000 * ( ( GPop / TotalPop ) * Crimes ) / GPop_sum
      
    where GPop is the tract population of group G, GPop_sum is the total of GPop 
    across all tracts, TotalPop is the total tract population, and Crimes are the
    number of crimes (of a given type) in the tract. 
    
    Summing Exposure over all tracts gives the effective crime rate per 1,000 pop.
%************************************************************************************;

%macro Crime_exp( years=, crimes=, groups= );

  %local i y j v k g;
  
  %let crimes = %lowcase( &crimes );
  %let groups = %lowcase( &groups );
  
  %let i = 1;
  %let y = %scan( &years, &i );

  %do %until ( &y = );
  
    Year = &y;

    %let j = 1;
    %let v = %scan( &crimes, &j );

    %do %until ( &v = );
    
      Crimes = "&v";
      Group = "total";

      Exposure = 1000 * Crimes_&v._&y / TotalPop_sum;

      output;

      %let k = 1;
      %let g = %scan( &groups, &k );

      %do %until ( &g = );

        Group = "&g";
        
        Exposure = 1000 * ( ( ( &g / TotalPop ) * Crimes_&v._&y ) / &g._sum );

        output;

        %let k = %eval( &k + 1 );
        %let g = %scan( &groups, &k );

      %end;

      %let j = %eval( &j + 1 );
      %let v = %scan( &crimes, &j );

    %end;

    %let i = %eval( &i + 1 );
    %let y = %scan( &years, &i );

  %end;

%mend Crime_exp;

** Create data for calculating exposure indices **;

data Crime_exposure_SOIAA_2018;

  set A;
  
  if _n_ = 1 then set A_sum;  ** Merge sum vars with all tract records **;
  
  length Crimes Group $ 40;
  
  %Crime_exp( years=2012 2017, crimes=pt1 pt1_violent pt1_property, groups=Latino AsianPi African Natborn black_nb white_nb )
  
  keep Geo2010 Year Crimes Group Exposure;
  
run;

%File_info( data=Crime_exposure_SOIAA_2018, printobs=40, freqvars=year crimes group )

proc format;

  value $group (notsorted)
    'total' = 'Total population'
    'latino' = 'Latino immigrants'
    'asianpi' = 'Asian/PI immigrants'
    'african' = 'African immigrants'
    'natborn' = 'Native born population'
    'black_nb' = 'African Americans'
    'white_nb' = 'Non-Latino whites';
    
  value $crimes (notsorted)
    'pt1' = 'All crimes'
    'pt1_violent' = 'Violent crimes'
    'pt1_property' = 'Property crimes';
    
run;


** Create summary tables **;

%macro table( select= );

  proc tabulate data=Crime_exposure_SOIAA_2018 format=comma12.2 noseps missing;
    where group in ( &select );
    var Exposure;
    class Year;
    class Crimes Group / preloadfmt order=data;
    table 
      /** Rows **/
      year=' ' * crimes=' ',
      /** Columns **/
      sum=' ' * Exposure='Exposure to crimes \line (effective\~crime\~rate\~per\~1,000\~population)' * Group=' '
    ;
    format Crimes $crimes. Group $group.;
  run;

%mend table;


%fdate()

options nodate nonumber;
options missing='-';

ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Crime_exposure_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt;
ods listing close;

title1 "State of Immigrants Report, 2018";
title2 "Crime Exposure";
title3 " ";

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

%table( select='latino' 'total' 'natborn' )
%table( select='asianpi' 'total' 'natborn' )
%table( select='african' 'total' 'natborn' )

%table( select='black_nb' 'total' 'white_nb' )

ods rtf close;
ods listing;

