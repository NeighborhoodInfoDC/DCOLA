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
  citizen raced hispand speakeng lingisol;
  
%let ipums_keep_b =
  numprec hhincome diff: empstatd gradeatt ind occ labforce 
  poverty rentgrs school sex speakeng trantime tranwork
  uhrswork valueh yrimmig;

data A;

  set
    Ipums.Ipums_2000_dc
      (OBS=300 keep=&ipums_keep_a &ipums_keep_b languagd educ99 ownershd 
       rename=(languagd=languaged ownershd=ownershpd yrimmig=yrimmig00))
    Ipums.Acs_2011_15_dc                        /** Use 2011-15 for LANGUAGED until added to 2012-16 data **/
      (OBS=300 keep=&ipums_keep_a languaged)
    Ipums.Acs_2012_16_dc
      (OBS=300 keep=&ipums_keep_a &ipums_keep_b hud_inc hcov: educd foodstmp owncost ownershpd yrnatur);

run;

/*** 
proc sql noprint;
  create table A_w_parents as
  select 
    A.*, 
    A_mom.bpld as bpld_mom, A_mom.citizen as citizen_mom, A_mom.raced as raced_mom,
    A_mom.hispand as hispand_mom, A_mom.speakeng as speakeng_mom, 
    A_mom.languaged as languaged_mom
  from A 
  left join A as A_mom
  on A.year = A_mom.year and A.serial = A_mom.serial and A.momloc = A_mom.pernum
  order by A.year, A.serial, A.pernum;
quit;

proc print data=A_w_parents;
  where year = 0 and serial in ( 5359750, 5359755, 5359839 );
  id serial pernum;
  by serial;
  var momloc poploc bpld bpld_mom;
run;
***/

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

** Check matching results **;

proc print data=A_w_parents;
  where 
    ( year = 0 and serial in ( 5359750, 5359755, 5359839 ) ) or 
    ( year = 2015 and serial in ( 1279726, 1279722, 1279744 ) );
  by year serial;
  id pernum;
  var momloc poploc bpld bpld_mom bpld_pop;
run;

proc freq data=A_w_parents;
  tables bpld_mom bpld_pop;
run;

proc format;
  value bpld_a
    00100-12092 = 'US & territories'
    15000-19900, 29900, 29999 = 'Other North America'
    20000       = 'Mexico'
    21000-21090 = 'Central America'
    25000-26095 = 'Caribbean'
    30000-30091 = 'South America'
    40000-49900 = 'Europe'
    50000-59900 = 'Asia'
    71000-71090 = 'Pacific Islands'
    60000-60099 = 'Africa'
    70000-70020 = 'Australia & New Zealand'
    71090, 80000-95000 = 'Other non-US'
    . = 'Missing';
run;    

%macro immigrant_vars( src, suffix );

  immigrant_&suffix = 0;

  latino_&suffix = 0;
  asianpi_&suffix = 0;
  african_&suffix = 0;
  otherimm_&suffix = 0;
  
  select ( put( &src, bpld_a. ) );

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

    when ( 'Other North America', 'Europe', 'Australia & New Zealand', 'Other non-US' ) do;
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

%mend immigrant_vars;


data Ipums_SOIAA_2018;

  set A_w_parents;

  retain Total 1;
  
  ** Create immigrant flags **;

  %immigrant_vars( bpld, 1gen )

  %immigrant_vars( bpld_mom, mom )

  %immigrant_vars( bpld_pop, pop )

  immigrant_2gen = max( immigrant_mom, immigrant_pop );

  latino_2gen = max( latino_mom, latino_pop );
  asianpi_2gen = max( asianpi_mom, asianpi_pop );
  african_2gen = max( african_mom, african_pop );
  otherimm_2gen = max( otherimm_mom, otherimm_pop );

  ** Create African American flag **;

  if not( immigrant_1gen ) and 
    raced in ( 200, 801, 830:845, 901:904, 917, 930:935, 
               950:955, 970:973, 980:983, 985, 986, 990 ) then
    aframerican = 1;
  else aframerican = 0;

  **** Characteristics ****;

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
  
  ** HUD income levels (2000) **;
  
  if year = 0 then do;
    %hud_inc_1999()
  end;

run;

proc means data=Ipums_SOIAA_2018 n sum mean min max;
run;

proc freq data=Ipums_SOIAA_2018;
  tables immigrant_1gen * aframerican * raced / missing list;
  tables raceth * hispand * raced / missing list;
  tables raceth;
run;

%Finalize_data_set( 
  data=Ipums_SOIAA_2018,
  out=Ipums_SOIAA_2018,
  outlib=DCOLA,
  label="IPUMS, DC State of Immigrants/African Americans report, 2018",
  sortby=year serial pernum,
  freqvars=year hud_inc,
  revisions=%str(New file.)
)

