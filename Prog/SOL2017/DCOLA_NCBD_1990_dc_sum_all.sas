/**************************************************************************
 Program:  DCOLA_NCDB_2000_dc_sum_all.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   Carl Hedman
 Created:  9/26/2016
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create all standard summary files from NCDB 2000 data.
 
 Modifications:
	9/22/2016: SD Adapted to DCOLA
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( DCOLA )


%NCDB_2000_summary_all( 

  /** State abbreviation. Ex: DC **/
  state_ab = DC,

)

