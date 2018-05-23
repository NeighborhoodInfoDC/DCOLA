/**************************************************************************
 Program:  Tables_tanf_soiaa_2018.sas
 Library:  DCOLA
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  05/22/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Create TANF and SNAP case tables for AA report.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCOLA )
%DCData_lib( TANF )

%fdate()

options nodate nonumber;
options missing='-';

ods listing close;

ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Tables_tanf_SOIAA_2018.rtf" style=Styles.Rtf_arial_9pt
    /*bodytitle*/;
    
title1 "State of African Americans Report, 2018";
title2 " ";

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';


proc tabulate data=Tanf.tanf_sum_city format=comma12.0 noseps missing;
  var tanf_black_2000-tanf_black_2016 tanf_client_2000-tanf_client_2016;
  table 
    /** Rows **/
    tanf_black_2000='2000'
    tanf_black_2001='2001'
    tanf_black_2002='2002'
    tanf_black_2003='2003'
    tanf_black_2004='2004'
    tanf_black_2005='2005'
    tanf_black_2006='2006'
    tanf_black_2007='2007'
    tanf_black_2008='2008'
    tanf_black_2009='2009'
    tanf_black_2010='2010'
    tanf_black_2011='2011'
    tanf_black_2012='2012'
    tanf_black_2013='2013'
    tanf_black_2014='2014'
    tanf_black_2015='2015'
    tanf_black_2016='2016'
    ,
    /** Columns **/
    sum='\qr Non-Hispanic\~black\~persons\~receiving TANF benefits'
  ;
  table 
    /** Rows **/
    tanf_client_2000='2000'
    tanf_client_2001='2001'
    tanf_client_2002='2002'
    tanf_client_2003='2003'
    tanf_client_2004='2004'
    tanf_client_2005='2005'
    tanf_client_2006='2006'
    tanf_client_2007='2007'
    tanf_client_2008='2008'
    tanf_client_2009='2009'
    tanf_client_2010='2010'
    tanf_client_2011='2011'
    tanf_client_2012='2012'
    tanf_client_2013='2013'
    tanf_client_2014='2014'
    tanf_client_2015='2015'
    tanf_client_2016='2016'
    ,
    /** Columns **/
    sum='\qr Total\~persons\~receiving TANF benefits'
  ;

run;


proc tabulate data=Tanf.Fs_sum_city format=comma12.0 noseps missing;
  var fs_black_2000-fs_black_2016 fs_client_2000-fs_client_2016;
  table 
    /** Rows **/
    fs_black_2000='2000'
    fs_black_2001='2001'
    fs_black_2002='2002'
    fs_black_2003='2003'
    fs_black_2004='2004'
    fs_black_2005='2005'
    fs_black_2006='2006'
    fs_black_2007='2007'
    fs_black_2008='2008'
    fs_black_2009='2009'
    fs_black_2010='2010'
    fs_black_2011='2011'
    fs_black_2012='2012'
    fs_black_2013='2013'
    fs_black_2014='2014'
    fs_black_2015='2015'
    fs_black_2016='2016'
    ,
    /** Columns **/
    sum='\qr Non-Hispanic\~black\~persons\~receiving SNAP benefits'
  ;
  table 
    /** Rows **/
    fs_client_2000='2000'
    fs_client_2001='2001'
    fs_client_2002='2002'
    fs_client_2003='2003'
    fs_client_2004='2004'
    fs_client_2005='2005'
    fs_client_2006='2006'
    fs_client_2007='2007'
    fs_client_2008='2008'
    fs_client_2009='2009'
    fs_client_2010='2010'
    fs_client_2011='2011'
    fs_client_2012='2012'
    fs_client_2013='2013'
    fs_client_2014='2014'
    fs_client_2015='2015'
    fs_client_2016='2016'
    ,
    /** Columns **/
    sum='\qr Total\~persons\~receiving SNAP benefits'
  ;

run;

ods rtf close;
ods listing;

title1;
footnote1;

