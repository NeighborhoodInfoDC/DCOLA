/**************************************************************************
 Program:  Tables_ipums_b_SOIAA_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/22/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Produce additional tables on native-born vs foreign-
born black population. 

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )


proc format;

  value black_b (notsorted)
    1 = "Native born"
    2 = "1st generation immigrant"
    3 = "2nd generation immigrant"
    0 = "N/A";
  
  value yeartbl
    0 = '2000'
    2015 = '2011-15'
    2016 = '2012-16';
 
run;


data Tables;

  set DCOLA.Ipums_SOIAA_2018;
  where year in ( 0, 2016 ) and statefip = 11;
  
  if raced in ( 200, 801, 830:845, 901:904, 917, 930:935, 
                950:955, 970:973, 980:983, 985, 986, 990 ) then do;
  
    if not immigrant_1gen and not immigrant_2gen then black_b = 1;
    else if immigrant_1gen then black_b = 2;
    else black_b = 3;
    
  end;
  else black_b = 0;

run;


/** Macro table - Start Definition **/

%macro table( year1=0, year2=2016, order=data, pop=, poplbl=, by=, bylbl=, byfmt=, rowstat=colpctsum=' ' * f=comma12.1 );

  proc tabulate data=Tables format=comma12.0 noseps missing;
    where year in ( &year1, &year2 ) and (&pop);
    class year;
    class &by / preloadfmt order=&order;
    var total;
    weight perwt;
    table 
      /** Rows **/
      (
        sum=&poplbl
        &by=&bylbl * &rowstat
      ),
      /** Columns **/
      total=' ' * year=' '
      / rts=60
    ;
    format year yeartbl. &by &byfmt;
  run;

%mend table;

/** End Macro Definition **/


%table( pop=black_b > 0, poplbl="\b Black population", by=black_b, byfmt=black_b., bylbl="\i % Birth status" )

%table( pop=black_b > 0, poplbl="\b Black population", by=black_b, byfmt=black_b., bylbl="\i Persons by birth status", rowstat=sum=' ' * f=comma12.0 )

