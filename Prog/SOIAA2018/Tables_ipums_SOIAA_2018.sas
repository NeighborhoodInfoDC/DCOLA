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
    
  value numprec_a
    1 = "1"
    2 = "2"
    3 = "3"
    4 = "4"
    5 = "5"
    6-high = "6 or more";
    
  value ownershpd_a
    12-13 = "Owner-occupied (ownership rate)"
    21-22 = "Rented"
    0 = "N/A";
    
  value Rent_burden
    0-<30 = "Under 30%"
    30-<50 = "30 - 49%"
    50-high = "50% or more";
    
  value poverty_a
    0 -< 100 = "Below federal poverty level"
    100 -< 200 = "Below 200% federal poverty level"
    200 - high = "200% federal poverty level or higher";

  value incwage_a
    low-<25000 = "Under $25,000"
    25000-<50000 = "$25,000 - 49,999"
    50000-<100000 = "$50,000 - 99,999"
    100000-high = "$100,000 or more";
    
  value trantime_a
    0 = "Worked at home/did not work last week"
    0 <-< 30 = "Under 30 minutes"
    30 -< 60 = "30 - 59 minutes"
    60 -< 90 = "60 - 89 minutes"
    90 -< 120 = "90 - 119 minutes"
    120 - high = "120 minutes or more";
    
  value languaged_a (notsorted)
    1200 = "Spanish"
    0100-0120 = "English"
    6000-6130 = "Amharic, Ethiopian, etc."
    1100-1150 = "French"
    4300-4315 = "Chinese"
    0300-0900, 1400-1700, 2500-2800, 3190, 3300-3400 = "Other European"
    1800-2320 = "Russian, other Slavic"
    3600-4200, 4400-4900, 5110-5310, 5500-5600 = "Other Asian, Pacific Island languages"
    3100-3150 = "Hindi and related"
    6312 = "Kru"
    5400-5440 = "Filipino, Tagalog"
    5700 = "Arabic"
    0200 = "German"
    1000 = "Italian"
    1300 = "Portuguese"
    6300-6310, 6390-6400 = "Other African"
    2900-3050, 5800-5900 = "Other Middle Eastern"
    5000 = "Vietnamese"
    7100-9420, 9601 = "Other";

  value educ99_a
   01="No school completed"
   02-04="Pre-school - 4th grade"
   05="5th - 8th grade"
   06="9th grade"
   07="10th grade"
   08="11th grade"
   09="12th grade, no diploma"
   10="High school graduate, or GED"
   11="Some college, no degree"
   12-13="Associate degree"
   14="Bachelors degree"
   15="Masters degree"
   16="Professional degree"
   17="Doctorate degree";

  value gradeatt_a (notsorted)
    1 = "Nursery school/preschool"
    2 = "Kindergarten"
    3 = "Grade 1 to grade 4"
    4 = "Grade 5 to grade 8"
    5 = "Grade 9 to grade 12"
    6 = "College undergraduate"
    7 = "Graduate or professional school"
    0 = "Not in school";
    
  value youth_disconnect_a (notsorted)
    1 = "In school"
    2 = "HS diploma, at work, not in school"
    3 = "HS diploma, not at work, not in school"
    4 = "No HS diploma, at work, not in school"
    5 = "No HS diploma, not at work, not in school";
    
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


** Demographics **;

%table( pop=immigrant_1gen, poplbl="Immigrants", by=bpld, byfmt=bpld_a., bylbl="% Country of origin" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=citizen, byfmt=citizenf., bylbl="% Citizenship status" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=age, byfmt=age_a., bylbl="% Age" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=sex, byfmt=sex_f., bylbl="% Sex" )

%table( pop=immigrant_1gen, poplbl="Immigrants", by=raceth, byfmt=raceth., bylbl="% Race/ethnicity (self-identified)" )


** Jobs and economic opportunity **;

%table( pop=immigrant_1gen, poplbl="Immigrants", by=poverty, byfmt=poverty_a., bylbl="% Poverty status" )

%table( pop=immigrant_1gen and age >= 16, poplbl="Immigrants, 16+ years old", by=empstatd, byfmt=empstatd., bylbl="% Labor force status" )

%table( pop=immigrant_1gen and age >= 16 and empstatd ~= 30, poplbl="Immigrants, 16+ years old in labor force", by=empstatd, byfmt=empstatd., bylbl="% Employment status" )

%table( pop=immigrant_1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="Immigrants, civilian workers 16+ years old", by=incwage_2016, byfmt=incwage_a., bylbl="% Annual earnings/wages ($ 2016)" )

%table( pop=immigrant_1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="Immigrants, civilian workers 16+ years old", by=incbus00_2016, byfmt=incwage_a., bylbl="% Annual business income ($ 2016)" )

%table( year1=., order=freq, pop=immigrant_1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="Immigrants, civilian workers 16+ years old", by=occ, byfmt=occ_a., bylbl="% Occupation" )

%table( pop=immigrant_1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="Immigrants, civilian workers 16+ years old", by=trantime, byfmt=trantime_a., bylbl="% Travel time to work" )

%table( pop=immigrant_1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="Immigrants, civilian workers 16+ years old", by=tranwork, byfmt=tranwork_f., bylbl="% Travel time to work" )

%table( pop=immigrant_1gen and age >= 65, poplbl="Immigrants, 65+ years old", by=incretir_2016, byfmt=incwage_a., bylbl="% Annual retirement income ($ 2016)" )


** Housing **;

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=numprec, byfmt=numprec_a., bylbl="% Household size (persons)" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=ownershpd, byfmt=ownershpd_f., bylbl="% Ownership of dwelling" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=ownershpd, byfmt=ownershpd_a., bylbl="% Ownership of dwelling" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=hhincome, byfmt=incwage_a., bylbl="% Household income" )

%table( pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=hud_inc, byfmt=hudinc., bylbl="% HUD income level" )

%table( pop=immigrant_1gen and not( missing( Rent_burden ) ), poplbl="Immigrants, renters with cash rent", by=Rent_burden, byfmt=Rent_burden., bylbl="% Income spent on rent" )


** Language **;

%table( year2=2015, pop=immigrant_1gen and age >= 5, poplbl="Immigrants, 5+ years old", by=languaged, byfmt=languaged_a., bylbl="% Language spoken" )

%table( year2=2015, pop=immigrant_1gen and age >= 5, poplbl="Immigrants, 5+ years old", by=speakeng, byfmt=speakeng_f., bylbl="% English proficiency" )

%table( year2=2015, pop=immigrant_1gen and gq in ( 1, 2, 5 ), poplbl="Immigrants, not in group quarters", by=lingisol, byfmt=lingisol_f., bylbl="% Linguistically isolated" )

%table( year2=2015, pop=immigrant_2gen and age >= 5, poplbl="2nd generation immigrants, 5+ years old", by=languaged, byfmt=languaged_a., bylbl="% Language spoken" )

%table( year2=2015, pop=immigrant_2gen and age >= 5, poplbl="2nd generation immigrants, 5+ years old", by=speakeng, byfmt=speakeng_f., bylbl="% English proficiency" )

%table( year2=2015, pop=immigrant_2gen and gq in ( 1, 2, 5 ), poplbl="2nd generation immigrants, not in group quarters", by=lingisol, byfmt=lingisol_f., bylbl="% Linguistically isolated" )


** Education **;

%table( pop=immigrant_1gen and age >= 18, poplbl="Immigrants, 18+ years", by=educ99, byfmt=educ99_a., bylbl="% Highest level of education" )

%table( pop=immigrant_1gen and 3 <= age <= 18, poplbl="Immigrants, 3-18 years", by=gradeatt, byfmt=gradeatt_a., bylbl="% School attendance" )

%table( pop=immigrant_1gen and 16 <= age <= 24, poplbl="Immigrants, 16-24 years", by=youth_disconnect, byfmt=youth_disconnect_a., bylbl="% Youth disconnection" )

