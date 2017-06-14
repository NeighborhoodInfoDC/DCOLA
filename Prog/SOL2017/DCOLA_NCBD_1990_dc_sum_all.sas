/**************************************************************************
 Program:  DCOLA_NCDB_1990_dc_sum_all.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   Somala Diby
 Created:  9/26/2016
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create all standard summary files from NCDB 1990 data.
 
 Modifications:
	9/22/2016: SD Adapted to DCOLA
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( DCOLA )


%NCDB_1990_summary_all( 

  /** State abbreviation. Ex: DC **/
  state_ab = DC,

    /** Year range (xxxx_yy). Ex: 2005_09 **/
  years = 1990

)

