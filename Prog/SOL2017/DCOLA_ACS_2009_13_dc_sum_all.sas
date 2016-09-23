/**************************************************************************
 Program:  DCOLA_ACS_2009_13_dc_sum_all.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   Carl Hedman
 Created:  5/27/2016
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create all standard summary files from ACS 5-year data.
 
 Modifications:
	8/22/2016: Adapted to get 2009-13 estimates for DCOLA.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( DCOLA )


%Equity_ACS_summary_all( 

  /** State abbreviation. Ex: DC **/
  state_ab = DC,

  /** Year range (xxxx_yy). Ex: 2005_09 **/
  years = 2009_13

)

