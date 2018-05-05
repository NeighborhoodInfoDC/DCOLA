/**************************************************************************
 Program:  Ipums_SOIAA_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  04/29/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Create DCOLA.Ipums_SOIAA_2018 from 2000 and 2012-16
 IPUMS data.

 DC State of Immigrants/African Americans Report, 2018

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( IPUMS )

%let ipums_keep_a = 
  year serial pernum hhwt perwt gq bpld momloc poploc
  citizen raced hispand age speakeng lingisol;
  
%let ipums_keep_b =
  numprec hhincome diff: empstatd gradeatt ind occ labforce 
  poverty rentgrs school sex speakeng yrimmig yrsusa1 yrsusa2
  trantime tranwork uhrswork valueh 
  ftotinc inctot incwelfr incwage incbus00 incinvst incretir;

data A;

  set
    Ipums.Ipums_2000_dc
      (keep=&ipums_keep_a &ipums_keep_b languagd educ99 ownershd 
       rename=(languagd=languaged ownershd=ownershpd yrimmig=yrimmig00))
    Ipums.Acs_2011_15_dc                        /** Use 2011-15 for LANGUAGED until added to 2012-16 data **/
      (keep=&ipums_keep_a languaged)
    Ipums.Acs_2012_16_dc
      (keep=&ipums_keep_a &ipums_keep_b hud_inc hcov: educd foodstmp owncost ownershpd yrnatur hhtype);

run;


** Add data for mother and father (only if in same household) **;

proc sql noprint;
  create table A_w_parents as
  select
      A_w_mom.*, 
      A_pop.bpld as bpld_pop, A_pop.citizen as citizen_pop, A_pop.raced as raced_pop,
      A_pop.hispand as hispand_pop, A_pop.speakeng as speakeng_pop, 
      A_pop.languaged as languaged_pop
  from
    ( select 
        A.*, 
        A_mom.bpld as bpld_mom, A_mom.citizen as citizen_mom, A_mom.raced as raced_mom,
        A_mom.hispand as hispand_mom, A_mom.speakeng as speakeng_mom, 
        A_mom.languaged as languaged_mom
      from A 
      left join A as A_mom
      on A.year = A_mom.year and A.serial = A_mom.serial and A.momloc = A_mom.pernum
    ) as A_w_mom
  left join A as A_pop
  on A_w_mom.year = A_pop.year and A_w_mom.serial = A_pop.serial and A_w_mom.poploc = A_pop.pernum
  order by A_w_mom.year, A_w_mom.serial, A_w_mom.pernum;
quit;


proc format;
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
run;    

%macro immigrant_vars( bpld=, citizen=, suffix= );

  immigrant_&suffix = 0;

  latino_&suffix = 0;
  asianpi_&suffix = 0;
  african_&suffix = 0;
  otherimm_&suffix = 0;
  
  if &citizen in ( 2, 3 ) then do;
  
    select ( put( &bpld, bpld_a. ) );

      when ( 'US & territories' ) do;
        /** Nothing **/
      end;

      when ( 'Mexico', 'Central America', 'Caribbean', 'South America' ) do;
        latino_&suffix = 1;
      end;

      when ( 'Asia', 'Pacific Islands' ) do;
        asianpi_&suffix = 1;
      end;

      when ( 'Africa' ) do;
        african_&suffix = 1;
      end;

      when ( 'Canada & other North America', 'Europe', 'Australia & New Zealand', 'Other non-US' ) do;
        otherimm_&suffix = 1;
      end;

      when ( 'Missing' ) do;
        latino_&suffix = .;
        asianpi_&suffix = .;
        african_&suffix = .;
        otherimm_&suffix = .;
      end;

      otherwise do;
        %warn_put( msg="Unknown place of birth " _n_= bpld= )
      end;

    end;

    immigrant_&suffix = max( latino_&suffix, asianpi_&suffix, african_&suffix, otherimm_&suffix );
    
  end;

%mend immigrant_vars;


data Ipums_SOIAA_2018;

  set A_w_parents;

  retain Total 1;
  
  ** Create immigrant flags **;

  %immigrant_vars( bpld=bpld, citizen=citizen, suffix=1gen )

  %immigrant_vars( bpld=bpld_mom, citizen=citizen_mom, suffix=mom )

  %immigrant_vars( bpld=bpld_pop, citizen=citizen_pop, suffix=pop )

  immigrant_2gen = not( immigrant_1gen ) and max( immigrant_mom, immigrant_pop );

  if immigrant_2gen then do;
    latino_2gen = max( latino_mom, latino_pop );
    asianpi_2gen = max( asianpi_mom, asianpi_pop );
    african_2gen = max( african_mom, african_pop );
    otherimm_2gen = max( otherimm_mom, otherimm_pop );
  end;
  else if not immigrant_2gen then do;
    latino_2gen = 0;
    asianpi_2gen = 0;
    african_2gen = 0;
    otherimm_2gen = 0;
  end;

  ** Create African American flag **;

  if not( immigrant_1gen ) and 
    raced in ( 200, 801, 830:845, 901:904, 917, 930:935, 
               950:955, 970:973, 980:983, 985, 986, 990 ) then
    aframerican = 1;
  else aframerican = 0;

  **** Characteristics ****;

  ** Add N/A missing values for 2000 income vars **;
  
  if year = 0 then do;
  
    array inc6{*} hhincome ftotinc inctot incwage incbus00 incinvst incretir;
    
    do i = 1 to dim( inc6 );
    
      if inc6{i} = 999999 then inc6{i} = .n;
      
    end;
  
    if incwelfr = 99999 then incwelfr = .n;
    
  end;
  
  ** Convert income vars to constant $ 2016 dollars **;
  
  if year = 0 then do;
    %dollar_convert( hhincome, hhincome_2016, 1999, 2016 )
    %dollar_convert( ftotinc, ftotinc_2016, 1999, 2016 )
    %dollar_convert( inctot, inctot_2016, 1999, 2016 )
    %dollar_convert( incwage, incwage_2016, 1999, 2016 )
    %dollar_convert( incbus00, incbus00_2016, 1999, 2016 )
    %dollar_convert( incinvst, incinvst_2016, 1999, 2016 )
    %dollar_convert( incretir, incretir_2016, 1999, 2016 )
    %dollar_convert( incwelfr, incwelfr_2016, 1999, 2016 )
  end;
  else if year = 2016 then do;
    hhincome_2016 = hhincome;
    ftotinc_2016 = ftotinc;
    inctot_2016 = inctot;
    incwage_2016 = incwage;
    incbus00_2016 = incbus00;
    incinvst_2016 = incinvst;
    incretir_2016 = incretir;
    incwelfr_2016 = incwelfr;
  end;

  ** Race/ethnicity **;
  
  if hispand = 000 then do;
    select;          /** Non-hispanic **/
      when (raced = 200) raceth = 1;        /** Black **/
      when (raced = 100) raceth = 2;        /** White **/
      when (raced in (400:699)) raceth = 4;      /** Asian/PI **/
      when (raced in (801:990)) raceth = 6;  /** Multiple races **/
      otherwise raceth = 5;       /** Other (Am. Ind, AK Nat., Other race) **/
    end;
  end;
  else if 100 <= hispand <= 499 then do;
    raceth = 3;                 /** Hispanic **/
  end;

  format raced RACED_F.;
  
  ** Year of immigration **;
  
  if year = 0 then do;
  
    select ( yrimmig00 );
      when ( 0 ) yrimmig = .n;
      when ( 1 ) yrimmig = 2000;
      otherwise yrimmig = 1000 + yrimmig00;
    end;
    
  end;
  
  if yrimmig = 0 then yrimmig = .n;
  
  ** HUD income levels (2000) **;
  
  if year = 0 then do;
    %hud_inc_1999()
  end;
  
  ** Rent burden **;
  
  if ownershpd = 22 and hhincome > 0 then Rent_burden = 100 * rentgrs / ( hhincome / 12 );
  
  ** Education **;
  
  if year ~= 0 and not( missing( educd ) ) then do;
    
    select;
    
      when ( educd = 1 ) educ99 = .n;
      when ( educd = 2 ) educ99 = 1;
      when ( educd = 11 ) educ99 = 2;
      when ( educd = 12 ) educ99 = 3;
      when ( educd in ( 14:17 ) ) educ99 = 4;
      when ( educd in ( 22:26 ) ) educ99 = 5;
      when ( educd = 30 ) educ99 = 6;
      when ( educd = 40 ) educ99 = 7;
      when ( educd = 50 ) educ99 = 8;
      when ( educd = 61 ) educ99 = 9;
      when ( educd in ( 63:64 ) ) educ99 = 10;
      when ( educd in ( 65:71 ) ) educ99 = 11;
      when ( educd = 81 ) educ99 = 12;
      when ( educd = 101 ) educ99 = 14;
      when ( educd = 114 ) educ99 = 15;
      when ( educd = 115 ) educ99 = 16;
      when ( educd = 116 ) educ99 = 17;
      
    end;
    
  end;
  else do;
  
    if educ99 = 0 then educ99 = .n;
    
  end;
  
  ** Youth disconnection indicator **;
  
  if 16 <= age < 25 then do;
 
    if gradeatt > 0 then do;
      youth_disconnect = 1;  /** 16-24, in school **/
    end;
    else do;
    
      /** 16-24, not in school **/
    
      if educ99 >= 10 then do;
        if empstatd in ( 10, 12, 14, 15 ) then
          youth_disconnect = 2; /** HS diploma, working **/
        else 
          youth_disconnect = 3; /** HS diploma, not working **/
      end;
      else do;
        if empstatd in ( 10, 12, 14, 15 ) then
          youth_disconnect = 4; /** no HS diploma, working **/
        else 
          youth_disconnect = 5; /** no HS diploma, not working **/
      end;        
      
    end;
     
  end;
  
  ** Health insurance coverage **;
  
  if hcovany = 1 then do;
    health_cov = 1; /** No insurance **/
  end;
  else if hcovany = 2 then do;
    if hcovpriv = 2 then do;
      if hcovpub = 2 then health_cov = 2;  /** Private + public insurance **/
      else health_cov = 3;  /*** Private ins only **/ 
    end;
    else do;
      health_cov = 4;  /** Public ins only **/
    end;
  end;

  label
    Total = "Total"
    immigrant_1gen = "1st generation immigrant"
    latino_1gen = "Latino (1st generation immigrant)"
    asianpi_1gen = "Asian/Pacific Islander (1st generation immigrant)"
    african_1gen = "African (1st generation immigrant)"
    otherimm_1gen = "Other 1st generation immigrant"
    immigrant_mom = "Mother is 1st gen immigrant"
    latino_mom = "Mother is Latino 1st gen immigrant"
    asianpi_mom = "Mother is Asian/PI 1st gen immigrant"
    african_mom = "Mother is African 1st gen immigrant"
    otherimm_mom = "Mother is other 1st gen immigrant"
    immigrant_pop = "Father is 1st gen immigrant"
    latino_pop = "Father is Latino 1st gen immigrant"
    asianpi_pop = "Father is Asian/PI 1st gen immigrant"
    african_pop = "Father is African 1st gen immigrant"
    otherimm_pop = "Father is other 1st gen immigrant"
    immigrant_2gen = "2nd generation immigrant"
    latino_2gen = "Latino (2nd generation immigrant)"
    asianpi_2gen = "Asian/Pacific Islander (2nd generation immigrant)"
    african_2gen = "African (2nd generation immigrant)"
    otherimm_2gen = "Other 2nd generation immigrant"
    aframerican = "African American"
    raceth = "Race/ethnicity"
    Rent_burden = "Rent burden (% income spent on rent)"
    hhincome_2016 = "Household income ($ 2016)"
    incwage_2016 = "Earnings ($ 2016)"
    ftotinc_2016 = "Total family income ($ 2016)"
    inctot_2016 = "Total personal income ($ 2016"
    incwage_2016 = "Wage and salary income ($ 2016)"
    incbus00_2016 = "Business and farm income ($ 2016)"
    incinvst_2016 = "Interest, dividend, and rental income ($ 2016)"
    incretir_2016 = "Retirement income ($ 2016)"
    incwelfr_2016 = "Welfare (public assistance) income ($ 2016)"
    youth_disconnect = "Disconnected youth indicator";

  drop i;

run;

%Finalize_data_set( 
  REGISTER_METADATA=N,
  data=Ipums_SOIAA_2018,
  out=Ipums_SOIAA_2018,
  outlib=DCOLA,
  label="DC State of Immigrants/African Americans report 2018, IPUMS",
  sortby=year serial pernum,
  printobs=5,
  freqvars=year hud_inc raceth youth_disconnect health_cov,
  revisions=%str(New file.)
)

** Check mother/father matching results **;

proc print data=Ipums_SOIAA_2018;
  where 
    ( year = 0 and serial in ( 5359750, 5359779, 5359823, 5360068 ) ) or 
    ( year = 2015 and serial in ( 1279726, 1279817, 1279869, 1279976 ) );
  by year serial;
  id pernum;
  var momloc poploc bpld: citizen: immigrant: latino_2gen asianpi_2gen african_2gen otherimm_2gen;
run;

proc freq data=A_w_parents;
  tables bpld_mom bpld_pop;
run;

** Check new variable codings **;

proc freq data=Ipums_SOIAA_2018;
  tables citizen * bpld / missing list;
  tables immigrant_1gen * immigrant_2gen / missing list;
  tables immigrant_1gen * citizen / missing list;
  tables immigrant_1gen * aframerican * raced / missing list;
  tables raceth * hispand * raced / missing list;
  format bpld bpld_a.;
run;

proc format;
  value educ99_b
    low-<10 = 'No HS dipl'
    10-high = 'HS dipl';
  value gradeatt_b
    0 = 'Not in school'
    1-high = 'In school';

proc freq data=Ipums_SOIAA_2018;
  where year in ( 0, 2016 ) and 16 <= age <= 24;
  tables educ99 * gradeatt * empstatd * youth_disconnect / missing list nocum nopercent;
  format educ99 educ99_b. gradeatt gradeatt_b.;
run;

proc freq data=Ipums_SOIAA_2018;
  where year in ( 2016 );
  tables hcovany * hcovpriv * hcovpub * health_cov / missing list nocum nopercent;
run;

