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
%DCData_lib( IPUMS )

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

  value bpld_a
    00100-12092, 71040-71050, 90000-90022 = 'US & territories'
    15000-19900, 29900, 29999 = 'Canada & other North America'
    20000       = 'Mexico'
    21000-21090 = 'Central America'
    25000-26095 = 'Caribbean'
    30000-30091 = 'South America'
    40000-49900 = 'Europe'
    50000-59900 = 'Asia'
    71000-71039 = 'Pacific Islands'
    60000-60099 = 'Africa'
    70000-70020 = 'Australia & New Zealand'
    71090, 80000-80050 = 'Other non-US'
    95000-99900, . = 'Missing';
    
  value age_a
    0 -< 18 = 'Under 18'
    18 -< 25 = '18 - 24'
    25 -< 35 = '25 - 34'
    35 -< 45 = '35 - 44'
    45 -< 55 = '45 - 54'
    55 -< 65 = '55 - 64'
    65 -< 75 = '65 - 74'
    75 - high = '75 or higher';
    
  value occ_a
    0, .n = "N/A"
    10-420, 430 = "Management, business, science, and arts"
    425, 500-740 = "Business operations specialists"
    800-950 = "Financial specialists"
    1005-1240 = "Computer and mathematical"
    1300-1560 = "Architecture and engineering occupations"
    1600-1965 = "Life, physical, and social science"
    2000-2060 = "Community and social services"
    2100-2160 = "Legal"
    2200-2550 = "Education, training, and library"
    2600-2920 = "Arts, design, entertainment, sports, and media"
    3000-3540 = "Healthcare practitioners and technical"
    3600-3655 = "Healthcare support"
    3700-3955 = "Protective service"
    4000-4150 = "Food preparation and serving"
    4200-4250 = "Building and grounds cleaning and maintenance"
    4300-4650 = "Personal care and service"
    4700-4965 = "Sales and sales related"
    5000-5940 = "Office and administrative support"
    6005-6130 = "Farming, fishing, and forestry"
    6200-6940 = "Construction and extraction"
    7000-7610 = "Installation, maintenance, and repair"
    7700-8965 = "Production"
    9000-9750 = "Transportation and material moving"
    9800-9830 = "Military specific"
    9920 = "Unemployed";
    
  value ownershpd_a
    12-13 = "Owner-occupied (ownership rate)"
    21-22 = "Rented"
    0 = "N/A";
    
  value Rent_burden
    0-<30 = "Under 30%"
    30-<50 = "30 - 49%"
    50-high = "50% or more";

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
  where year in ( 0, 2016 ) and not( immigrant_1gen );
  class year;
  var total immigrant_2gen latino_2gen asianpi_2gen african_2gen otherimm_2gen;
  weight perwt;
  table 
    /** Rows **/
    total='Non-1gen immigrants' 
    immigrant_2gen='Immigrants (2nd gen.)'
    latino_2gen='Latinos' 
    asianpi_2gen='Asian/Pacific Islanders' 
    african_2gen='Africans' 
    otherimm_2gen='Other immigrants',
    /** Columns **/
    sum='Persons' * year=' '
    pctsum<total>='Percent' * year=' ' * f=comma12.1
  ;
  format year yeartbl. raceth raceth.;
run;

/** Macro table - Start Definition **/

%macro table( year1=0, year2=2016, order=data, pop=, poplbl=, by=, bylbl=, byfmt= );

  proc tabulate data=DCOLA.Ipums_SOIAA_2018 format=comma12.0 noseps missing;
    where year in ( &year1, &year2 ) and (&pop);
    class year;
    class &by / preloadfmt order=&order;
    var total;
    weight perwt;
    table 
      /** Rows **/
      (
        sum=&poplbl
        colpctsum=' ' * &by=&bylbl * f=comma12.1
      ),
      /** Columns **/
      total=' ' * year=' '
      / rts=60
    ;
    format year yeartbl. &by &byfmt;
  run;

%mend table;

/** End Macro Definition **/


%table( pop=immigrant_1gen, poplbl="Immigrants", by=bpld, byfmt=bpld_a., bylbl="% Country of origin" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=citizen, byfmt=citizenf., bylbl="% Citizenship status" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=age, byfmt=age_a., bylbl="% Age" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=sex, byfmt=sex_f., bylbl="% Sex" )

%table( pop=immigrant_1gen and age >= 16, poplbl="Immigrants, 16+ years old", by=empstatd, byfmt=empstatd., bylbl="% Labor force status" )

%table( pop=immigrant_1gen and age >= 16 and empstatd ~= 30, poplbl="Immigrants, 16+ years old in labor force", by=empstatd, byfmt=empstatd., bylbl="% Employment status" )

%table( year1=., order=freq, pop=immigrant_1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="Immigrants, civilian workers 16+ years old", by=occ, byfmt=occ_a., bylbl="% Occupation" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=numprec, byfmt=numprec_f., bylbl="% Household size (persons)" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=ownershpd, byfmt=ownershpd_f., bylbl="% Ownership of dwelling" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=ownershpd, byfmt=ownershpd_a., bylbl="% Ownership of dwelling" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=hud_inc, byfmt=hudinc., bylbl="% HUD income level" )

%table( pop=immigrant_1gen and not( missing( Rent_burden ) ), poplbl="Immigrants, renters with cash rent", by=Rent_burden, byfmt=Rent_burden., bylbl="% Income spent on rent" )


%table( pop=immigrant_1gen, poplbl="Immigrants", by=raceth, byfmt=raceth., bylbl="% Race/ethnicity" )


