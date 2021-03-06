/**************************************************************************
 Program:  DCOLA_ACS_2010_14_dc_sum_all.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   Carl Hedman
 Created:  5/27/2016
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create all standard summary files from ACS 5-year data.
 
 Modifications:
	8/22/2016: SD Adapted to DCOLA
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( DCOLA )

**options mprint symbolgen mlogic;


%DCOLA_ACS_summary_all( 

  /** State abbreviation. Ex: DC **/
  state_ab = DC,

  /** Year range (xxxx_yy). Ex: 2005_09 **/
  years = 2010_14

)

