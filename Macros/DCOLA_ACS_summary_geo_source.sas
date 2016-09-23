/**************************************************************************
 Program:  DCOLA_ACS_summary_geo_source.sas
 Library:  DCOLA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/04/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create source data for generating summary geogarphy
 data sets.

 Modifications:
	SD 8/22/16 - added additional variable calculations and labels for Latino variables.
**************************************************************************/

%macro DCOLA_ACS_summary_geo_source( source_geo );

  %global source_geo_var source_geo_suffix source_geo_wt_file_fmt source_ds source_ds_work source_geo_label;

  %if %upcase( &source_geo ) = BG00 %then %do;
     %let source_geo_var = GeoBg2000;
     %let source_geo_suffix = _bg;
     %let source_geo_wt_file_fmt = $geobw0f.;
     %let source_ds = Acs_sf_&_years._&_state_ab._bg00;
     %let source_geo_label = Block group;
  %end;
  %else %if %upcase( &source_geo ) = TR00 %then %do;
     %let source_geo_var = Geo2000;
     %let source_geo_suffix = _tr;
     %let source_geo_wt_file_fmt = $geotw0f.;
     %let source_ds = Acs_sf_&_years._&_state_ab._tr00;
     %let source_geo_label = Census tract;
  %end;
  %else %if %upcase( &source_geo ) = BG10 %then %do;
     %let source_geo_var = GeoBg2010;
     %let source_geo_suffix = _bg;
     %let source_geo_wt_file_fmt = $geobw1f.;
     %let source_ds = Acs_sf_&_years._&_state_ab._bg10;
     %let source_geo_label = Block group;
  %end;
  %else %if %upcase( &source_geo ) = TR10 %then %do;
     %let source_geo_var = Geo2010;
     %let source_geo_suffix = _tr;
     %let source_geo_wt_file_fmt = $geotw1f.;
     %let source_ds = Acs_sf_&_years._&_state_ab._tr10;
     %let source_geo_label = Census tract;
  %end;
  %else %do;
    %err_mput( macro=DCOLA_ACS_summary_geo_source, msg=Geograpy &source_geo is not supported. )
    %goto macro_exit;
  %end;
     
  %let source_ds_work = _ACS_&_years._&state_ab._sum&source_geo_suffix;

  %put _global_;

  ** Create new variables for summarizing **;

  data &source_ds_work;

    set ACS.&source_ds;
    
    ** Unweighted sample counts **;
    
    UnwtdPop_&_years. = B00001e1;
    UnwtdHsgUnits_&_years. = B00002e1;

    label
      UnwtdPop_&_years. = "Unweighted sample population, &_years_dash "
      UnwtdHsgUnits_&_years. = "Unweighted sample housing units, &_years_dash ";


    ** Demographics **;

    ** Demographics - Block group-level variables **;
	
    PopUnder5Years_&_years. = sum( B01001e3, B01001e27 );

	PopUnder18Years_&_years. = 
		sum( B01001e3, B01001e4, B01001e5, B01001e6, 
             B01001e27, B01001e28, B01001e29, B01001e30 );

	Pop18_34Years_&_years. = 
		sum(B01001e7, B01001e8, B01001e9, B01001e10, B01001e11, B01001e12, 
			B01001e31, B01001e32, B01001e33, B01001e34, B01001e35, B01001e36 );

	Pop35_64Years_&_years. = 
		sum(B01001e13, B01001e14, B01001e15, B01001e16, B01001e17, B01001e18, B01001e19, 
			B01001e37, B01001e38, B01001e39, B01001e40, B01001e41, B01001e42, B01001e43 );

    Pop65andOverYears_&_years. = 
      sum( B01001e20, B01001e21, B01001e22, B01001e23, B01001e24, B01001e25, 
           B01001e44, B01001e45, B01001e46, B01001e47, B01001e48, B01001e49 );

    mTotPop_&_years. = B01003m1;

    mNumHshlds_&_years. = B11001m1;

    mNumFamilies_&_years. = B11003m1;

    mPopUnder5Years_&_years. = %moe_sum( var=B01001m3 B01001m27 );

	mPopUnder18Years_&_years. = 
      %moe_sum( var=B01001m3 B01001m4 B01001m5 B01001m6 
           			B01001m27 B01001m28 B01001m29 B01001m30 );

	mPop18_34Years_&_years.	 = 
		%moe_sum( var=B01001m7 B01001m8 B01001m9 B01001m10 B01001m11 B01001m12 
					  B01001m31 B01001m32 B01001m33 B01001m34 B01001m35 B01001m36 );

    mPop35_64Years_&_years. = 
	 %moe_sum( var=B01001m13 B01001m14 B01001m15 B01001m16 B01001m17 B01001m18 B01001m19 
				   B01001m37 B01001m38 B01001m39 B01001m40 B01001m41 B01001m42 B01001m43 );

    mPop65andOverYears_&_years. = 
      %moe_sum( var=B01001m20 B01001m21 B01001m22 B01001m23 B01001m24 B01001m25 
           B01001m44 B01001m45 B01001m46 B01001m47 B01001m48 B01001m49 );

	label
	  TotPop_&_years. = "Total population, &_years_dash "
      NumHshlds_&_years. = "Total HHs, &_years_dash "
      NumFamilies_&_years. = "Family HHs, &_years_dash "
      PopUnder5Years_&_years. = "Persons under 5 years old, &_years_dash "
	  PopUnder18Years_&_years. = "Persons under 18 years old, &_years_dash "
	  Pop18_34Years_&_years. = "Persons 18-34 years old, &_years_dash "
	  Pop35_64Years_&_years. = "Persons 35-64 years old, &_years_dash "
	  Pop65andOverYears_&_years. = "Persons 65 years old and over, &_years_dash "
      mTotPop_&_years. = "Total population, MOE, &_years_dash "
      mNumHshlds_&_years. = "Total HHs, MOE, &_years_dash "
      mNumFamilies_&_years. = "Family HHs, MOE, &_years_dash "
      mPopUnder5Years_&_years. = "Persons under 5 years old, MOE, &_years_dash "
	  mPopUnder18Years_&_years. = "Persons under 18 years old, MOE, &_years_dash "
	  mPop18_34Years_&_years. = "Persons 18-34 years old, MOE, &_years_dash "
	  mPop35_64Years_&_years. = "Persons 35-64 years old, MOE,&_years_dash "
	  mPop65andOverYears_&_years. = "Persons 65 years old and over, MOE, &_years_dash "
	  ;

    ** Demographics - Tract-level variables **;

	%if %upcase( &source_geo ) = TR00 or %upcase( &source_geo ) = TR10 %then %do;

	NumFamiliesH_&_years. = B19101Ie1;

	NumHshldsH_&_years. = B19001Ie1;

	Pop5andOverYearsH_&_years. = 
		sum(B01001Ie4, B01001Ie5, B01001Ie6, B01001Ie7, B01001Ie8, B01001Ie9, B01001Ie10, 
			B01001Ie11, B01001Ie12, B01001Ie13, B01001Ie14, B01001Ie15, B01001Ie16,
			B01001Ie18, B01001Ie19, B01001Ie20, B01001Ie21, B01001Ie22, B01001Ie23, B01001Ie24,
			B01001Ie25, B01001Ie26, B01001Ie27, B01001Ie28, B01001Ie29, B01001Ie30, B01001Ie31);

	PopUnder18YearsH_&_years. =
		sum( B01001Ie3, B01001Ie4, B01001Ie5, B01001Ie6, 
			 B01001Ie18, B01001Ie19, B01001Ie20, B01001Ie21 );

	Pop18_34YearsH_&_years.	= 
		sum(B01001Ie7, B01001Ie8, B01001Ie9, B01001Ie10, 
			B01001Ie22, B01001Ie23, B01001Ie24, B01001Ie25);

	Pop35_64YearsH_&_years.	= sum(B01001Ie11, B01001Ie12, B01001Ie13, B01001Ie26, B01001Ie27, B01001Ie28 );

	Pop65andOverYearsH_&_years.	= sum(B01001Ie14, B01001Ie15, B01001Ie16, B01001Ie29, B01001Ie30, B01001Ie31 );

	mNumFamiliesH_&_years. = B19101Im1;

	mNumHshldsH_&_years. = B19001Im1;

	mPop5andOverYearsH_&_years. = 
		sum(B01001Im4 B01001Im5 B01001Im6 B01001Im7 B01001Im8 B01001Im9 B01001Im10 
			B01001Im11 B01001Im12 B01001Im13 B01001Im14 B01001Im15 B01001Im16,
			B01001Im18 B01001Im19 B01001Im20 B01001Im21 B01001Im22 B01001Im23 B01001Im24,
			B01001Im25 B01001Im26 B01001Im27 B01001Im28 B01001Im29 B01001Im30 B01001Im31);

	mPopUnder18YearsH_&_years. = 
		%moe_sum( var= B01001Im3 B01001Im4 B01001Im5 B01001Im6 
			B01001Im18 B01001Im19 B01001Im20 B01001Im21 );

	mPop18_34YearsH_&_years. = 
		%moe_sum( var=B01001Im7 B01001Im8 B01001Im9 B01001Im10 
			B01001Im22 B01001Im23 B01001Im24 B01001Im25 );

	mPop35_64YearsH_&_years. =  
		%moe_sum( var=B01001Im11 B01001Im12 B01001Im13 B01001Im26 B01001Im27 B01001Im28 );

	mPop65andOverYearsH_&_years. = 
		%moe_sum( var=B01001Im14 B01001Im15 B01001Im16 B01001Im29 B01001Im30 B01001Im31 );


    label
		NumFamiliesH_&_years. = "Family HHs, Hispanic/Latino, &_years_dash "
		NumHshldsH_&_years. = "Total HHs, Hispanic/Latino, &_years_dash "
		Pop5andOverYearsH_&_years. = "Persons 5 years old and over Hispanic/Latino, &_years_dash "
		PopUnder18YearsH_&_years. = "Persons under 18 years old, Hispanic/Latino, &_years_dash "
		Pop18_34YearsH_&_years. = "Persons 18-34 years old, Hispanic/Latino, &_years_dash "
		Pop35_64YearsH_&_years. = "Persons 35-64 years old, Hispanic/Latino, &_years_dash "
		Pop65andOverYearsH_&_years. = "Persons 65 years old and over, Hispanic/Latino, &_years_dash "
		mNumFamiliesH_&_years. = "Family HHs, Hispanic/Latino, MOE, &_years_dash "
		mNumHshldsH_&_years. = "Total HHs, Hispanic/Latino, MOE, &_years_dash "
		mNumHshldsA_&_years. = "Total HHs, Asian, Hawaiian, and other Pacific Islander, MOE, &_years_dash "
		mPop5andOverYearsH_&_years. = "Persons 5 years old and over Hispanic/Latino, MOE, &_years_dash "
		mPopUnder18YearsH_&_years. = "Persons under 18 years old, Hispanic/Latino, MOE, &_years_dash "
		mPop18_34YearsH_&_years. = "Persons 18-34 years old, Hispanic/Latino, MOE, &_years_dash "
		mPop35_64YearsH_&_years. = "Persons 35-64 years old, Hispanic/Latino, MOE, &_years_dash "
		mPop65andOverYearsH_&_years. = "Persons 65 years old and over, Hispanic/Latino, MOE, &_years_dash "
    ;
    
	%end;

    %if %upcase( &source_geo ) = TR00 or %upcase( &source_geo ) = TR10 %then %do;
    
      ** Nativity, Citizenship Status, and Language Proficiency **;

      PopForeignBorn_&_years. = B05002e13;
	  PopForeignBornH_&_years. = B06004Ie5;

	  PopNativeBorn_&_years. = B05002e2;
	  PopNativeBornH_&_years. = sum(B06004Ie2 B06004Ie3 B06004Ie4);

	  PopCitizenH_&_years. = sum(B05003Ie4 B05003Ie6 B05003Ie9 B05003Ie11 B05003Ie15 B05003Ie17 B05003Ie20 B05003Ie22);
	  PopNaturalizedH_&_years. = sum(B05003Ie6 B05003Ie11 B05003Ie17 B05003Ie22);
	  PopNonCitizenH_&_years. = sum(B05003Ie7 B05003Ie12 B05003Ie18 B05003Ie23);

	  PopNonEnglish_&_years. = sum(B06007e3, B06007e6 );
	  PopOnlyEnglishH_&_years. = B16006e2;
	  PopSpanishH_&_years. = B16006e3;
	  PopEngVeryWellH_&_years. = B16006e4;
	  PopEngWellH_&_years. = B16006e5;
	  PopEngNotWellH_&_years. = B16006e6;
	  PopNoEnglishH_&_years. = B16006e7;
	  PopEngLessThanVeryWellH_&_years. = sum(B16006e5, B16006e6, B16006e7)
	  PopOtherLangH_&_years. = B16006e8;


	  mPopForeignBornH_&_years. = B06004Im5;
	  mPopForeignBorn_&_years. = B05002m13;

	  mPopNativeBorn_&_years. = B05002m2;
	  mPopNativeBornH_&_years. = %moe_sum( var=B06004Im2 B06004Im3 B06004Im4 );

	  mPopCitizenH_&_years. = %moe_sum( var=B05003Im4 B05003Im6 B05003Im9 B05003Im11 B05003Im15 B05003Im17 B05003Im20 B05003Im22);
	  mPopNaturalizedH_&_years. = %moe_sum( var=B05003Im6 B05003Im11 B05003Im17 B05003Im22);
	  mPopNonCitizenH_&_years. = %moe_sum( var=B05003Im7 B05003Im12 B05003Im18 B05003Im23);

	  mPopNonEnglish_&_years. = %moe_sum( var=B06007m3 B06007m6 );
	  mPopOnlyEnglishH_&_years. = B16006m2;
	  mPopSpanishH_&_years. = B16006m3;
	  mPopEngVeryWellH_&_years. = B16006m4;
	  mPopEngWellH_&_years. = B16006m5;
	  mPopEngNotWellH_&_years. = B16006m6;
	  mPopNoEnglishH_&_years. = B16006m7;
	  mPopEngLessThanVeryWellH_&_years. = sum(B16006m5, B16006m6, B16006m7)
	  mPopOtherLangH_&_years. = B16006m8;


      label 
        PopForeignBorn_&_years. = "Foreign born population, &_years_dash "
		PopForeignBornH_&_years. = "Foreign born persons, Hispanic/Latino, &_years_dash "
		PopNativeBorn_&_years. = "Native born persons, &_years_dash "
		PopNativeBornH_&_years. = "Native born persons, Hispanic/Latino, &_years_dash "
		PopNonEnglish_&_years. = "Speak a language other than English at home, &_years_dash "
		PopCitizenH_&_years. = "Native born persons and naturalized citizens, Hispanic/Latino, &_years_dash "
		PopNaturalizedH_&_years. = "Naturalized citizens, Hispanic/Latino, &_years_dash "
		PopNonCitizenH_&_years. = "Non US citizens, Hispanic/Latino, &_years_dash "
		PopOnlyEnglishH_&_years. = "Speak only English at home, Hispanic/Latino, &_years_dash "
	  	PopSpanishH_&_years. = "Speak Spanish at home, Hispanic/Latino, &_years_dash "
	    PopEngVeryWellH_&_years. = "Speak Spanish at home, English very well, Hispanic/Latino, &_years_dash "
	    PopEngWellH_&_years. = "Speak Spanish at home, English well, Hispanic/Latino, &_years_dash "
	    PopEngNotWellH_&_years. = "Speak Spanish at home, English not well, Hispanic/Latino, &_years_dash "
	    PopNoEnglishH_&_years. = "Speak Spanish at home, English not at all, Hispanic/Latino, &_years_dash "
		PopEngLessThanVeryWellH_&_years. = "Speak Spanish at home, English less than very well, &_years_dash "
	    PopOtherLangH_&_years. = "Speak a language other than English at home, Hispanic/Latino, &_years_dash "
        mPopForeignBorn_&_years. = "Foreign born population, MOE, &_years_dash "
		mPopNativeBorn_&_years. = "Native born persons, &_years_dash "
		mPopNonEnglish_&_years. = "Speak a language other than English at home, MOE, &_years_dash "
		mPopForeignBornH_&_years. = "Foreign-born persons, Hispanic/Latino, MOE, &_years_dash "
		mPopNativeBornH_&_years. = "Native born persons, Hispanic/Latino, MOE, &_years_dash "
		mPopCitizenH_&_years. = "Native born persons and naturalized citizens, Hispanic/Latino, MOE, &_years_dash "
		mPopNaturalizedH_&_years. = "Naturalized citizens, Hispanic/Latino, MOE, &_years_dash "
		mPopNonCitizenH_&_years. = "Non US citizens, Hispanic/Latino, MOE, &_years_dash "
		mPopOnlyEnglishH_&_years. = "Speak only English at home, Hispanic/Latino, MOE, &_years_dash "
	  	mPopSpanishH_&_years. = "Speak Spanish at home, Hispanic/Latino, MOE, &_years_dash "
	    mPopEngVeryWellH_&_years. = "Speak Spanish at home, English very well, Hispanic/Latino, MOE, &_years_dash "
	    mPopEngWellH_&_years. = "Speak Spanish at home, English well, Hispanic/Latino, MOE, &_years_dash "
	    mPopEngNotWellH_&_years. = "Speak Spanish at home, English not well, Hispanic/Latino, MOE, &_years_dash "
	    mPopNoEnglishH_&_years. = "Speak Spanish at home, English not at all, Hispanic/Latino, MOE, &_years_dash "
		mPopEngLessThanVeryWellH_&_years. = "Speak Spanish at home, English less than very well, MOE, &_years_dash "
	    mPopOtherLangH_&_years. = "Speak a language other than English at home, Hispanic/Latino, MOE, &_years_dash "

    %end;
    
    %if %upcase( &source_geo ) = TR00 or %upcase( &source_geo ) = TR10 %then %do;
    
      ** Latino population by country of origin **;

		PopHispMexican_&_years. = B03001e4;
		PopHispPuertoRican_&_years. = B03001e5;
		PopHispCuban_&_years. = B03001e6;
		PopHispDominican_&_years. = B03001e7;
		PopHispOtherCentAmer_&_years. = B03001e15;
		PopHispOtherSouthAmer_&_years. = B03001e26;
		PopHispOtherHispOrig_&_years. = B03001e27;
		PopHispArgentinean_&_years. = B03001e17
		PopHispBolivian_&_years. = B03001e18
		PopHispChilean_&_years. = B03001e19
		PopHispColombian_&_years. = B03001e20
		PopHispCostaRican_&_years. = B03001e9
		PopHispEcuadorian_&_years. = B03001e21
		PopHispElSalvadoran_&_years. = B03001e14
		PopHispGuatemalan_&_years. = B03001e10
		PopHispHonduran_&_years. = B03001e11
		PopHispNicaraguan_&_years. = B03001e12
		PopHispPananamian_&_years. = B03001e13
		PopHispPeruvian_&_years. = B03001e23

		mPopHispMexican_&_years. = B03001m4;
		mPopHispPuertoRican_&_years. = B03001m5;
		mPopHispCuban_&_years. = B03001m6;
		mPopHispDominican_&_years. = B03001m7;
		mPopHispOtherCentAmer_&_years. = B03001m15;
		mPopHispOtherSouthAmer_&_years. = B03001m26;
		mPopHispOtherHispOrig_&_years. = B03001m27;
		mPopHispArgentinean_&_years. = B03001m17
		mPopHispBolivian_&_years. = B03001m18
		mPopHispChilean_&_years. = B03001m19
		mPopHispColombian_&_years. = B03001m20
		mPopHispCostaRican_&_years. = B03001m9
		mPopHispEcuadorian_&_years. = B03001m21
		mPopHispElSalvadoran_&_years. = B03001m14
		mPopHispGuatemalan_&_years. = B03001m10
		mPopHispHonduran_&_years. = B03001m11
		mPopHispNicaraguan_&_years. = B03001m12
		mPopHispPananamian_&_years. = B03001m13
		mPopHispPeruvian_&_years. = B03001m23


	label
		PopHispMexican_&_years. = "Persons of Mexican origin, &_years_dash "
		PopHispPuertoRican_&_years. = "Persons of Puerto Rican origin, &_years_dash "
		PopHispCuban_&_years. = "Persons of Cuban origin, &_years_dash "
		PopHispDominican_&_years. = "Persons of Dominican origin, &_years_dash "
		PopHispOtherCentAmeri_&_years. = "Persons of Other Central American origin, &_years_dash "
		PopHispSouthAmer_&_years. = "Persons of Other South American origin, &_years_dash "
		PopHispOtherHispOrig_&_years. = "Persons of Other Hispanic origin, &_years_dash "
		PopHispArgentinean_&_years. = "Persons of Argentinian origin, &_years_dash "
		PopHispBolivian_&_years. = "Persons of Bolivian origin, &_years_dash "
		PopHispChilean_&_years. = "Persons of Chilean origin, &_years_dash "
		PopHispColombian_&_years. = "Persons of Colombian origin, &_years_dash "
		PopHispCostaRican_&_years. = "Persons of Costa Rican origin, &_years_dash "
		PopHispEcuadorian_&_years. = "Persons of Ecuadorian origin, &_years_dash "
		PopHispElSalvadoran_&_years. = "Persons of El Salvadoran origin, &_years_dash "
		PopHispGuatemalan_&_years. = "Persons of Guatemalan origin, &_years_dash "
		PopHispHonduran_&_years. = "Persons of Honduran origin, &_years_dash "
		PopHispNicaraguan_&_years. = "Persons of Nicaraguan origin, &_years_dash "
		PopHispPananamian_&_years. = "Persons of Panamanian origin, &_years_dash "
		PopHispPeruvian_&_years. = "Persons of Peruvian origin, &_years_dash "
		mPopHispMexican_&_years. = "Persons of Mexican origin, MOE, &_years_dash "
		mPopHispPuertoRican_&_years. = "Persons of Puerto Rican origin, MOE, &_years_dash "
		mPopHispCuban_&_years. = "Persons of Cuban origin, MOE, &_years_dash "
		mPopHispDominican_&_years. = "Persons of Dominican origin, MOE, &_years_dash "
		mPopHispOtherCentAmeri_&_years. = "Persons of Other Central American origin, MOE, &_years_dash "
		mPopHispSouthAmer_&_years. = "Persons of Other South American origin, MOE, &_years_dash "
		mPopHispOtherHispOrig_&_years. = "Persons of Other Hispanic origin, MOE, &_years_dash "
		mPopHispArgentinean_&_years. = "Persons of Argentinian origin, MOE, &_years_dash "
		mPopHispBolivian_&_years. = "Persons of Bolivian origin, MOE, &_years_dash "
		mPopHispChilean_&_years. = "Persons of Chilean origin, MOE, &_years_dash "
		mPopHispColombian_&_years. = "Persons of Colombian origin, MOE, &_years_dash "
		mPopHispCostaRican_&_years. = "Persons of Costa Rican origin, MOE, &_years_dash "
		mPopHispEcuadorian_&_years. = "Persons of Ecuadorian origin, MOE, &_years_dash "
		mPopHispElSalvadoran_&_years. = "Persons of El Salvadoran origin, MOE, &_years_dash "
		mPopHispGuatemalan_&_years. = "Persons of Guatemalan origin, MOE, &_years_dash "
		mPopHispHonduran_&_years. = "Persons of Honduran origin, MOE, &_years_dash "
		mPopHispNicaraguan_&_years. = "Persons of Nicaraguan origin, MOE, &_years_dash "
		mPopHispPananamian_&_years. = "Persons of Panamanian origin, MOE, &_years_dash "
		mPopHispPeruvian_&_years. = "Persons of Peruvian origin, MOE, &_years_dash "

    %end;

    ** Population by race/ethnicity **;
    
    PopWithRace_&_years. = totpop_&_years.;
    PopBlackNonHispBridge_&_years. = B03002e4;
    PopWhiteNonHispBridge_&_years. = B03002e3;
    PopHisp_&_years. = B03002e12;
    PopAsianPINonHispBridge_&_years. = sum( B03002e6, B03002e7 );
    PopNativeAmNonHispBridge_&_years. = B03002e5;
    PopOtherNonHispBridge_&_years. = B03002e8;
    PopMultiracialNonHisp_&_years. = B03002e9;
    
    PopOtherRaceNonHispBridg_&_years. = PopWithRace_&_years. - 
      sum( PopBlackNonHispBridge_&_years., PopWhiteNonHispBridge_&_years., PopHisp_&_years., PopAsianPINonHispBridge_&_years. );

    mPopWithRace_&_years. = mtotpop_&_years.;
    mPopBlackNonHispBridge_&_years. = B03002m4;
    mPopWhiteNonHispBridge_&_years. = B03002m3;
    mPopHisp_&_years. = B03002m12;
    mPopAsianPINonHispBridge_&_years. = %moe_sum( var=B03002m6 B03002m7 );
    mPopNativeAmNonHispBr_&_years. = B03002m5;
    mPopOtherNonHispBridge_&_years. = B03002m8;
    mPopMultiracialNonHisp_&_years. = B03002m9;
    
    mPopOtherRaceNonHispBr_&_years. = 
      %moe_sum( var=B03002m5 B03002m8 B03002m9 );

    label
      PopWithRace_&_years. = "Total population for race/ethnicity, &_years_dash "
      PopBlackNonHispBridge_&_years. = "Non-Hispanic Black/African American population, &_years_dash "
      PopWhiteNonHispBridge_&_years. = "Non-Hispanic White population, &_years_dash "
      PopAsianPINonHispBridge_&_years. = "Non-Hispanic Asian, Hawaiian and other Pacific Islander pop., &_years_dash "
      PopHisp_&_years. = "Hispanic/Latino population, &_years_dash "
      PopNativeAmNonHispBridge_&_years. = "Non-Hispanic American Indian/Alaska Native population, &_years_dash "
      PopOtherNonHispBridge_&_years. = "Non-Hispanic other race population, &_years_dash "
      PopMultiracialNonHisp_&_years. = "Non-Hispanic multiracial population, &_years_dash "
      PopOtherRaceNonHispBridg_&_years. = "All remaining groups other than black, white, Hispanic, and Asian/PI, &_years_dash "
      mPopWithRace_&_years. = "Total population for race/ethnicity, MOE, &_years_dash "
      mPopBlackNonHispBridge_&_years. = "Non-Hispanic Black/African American population, MOE, &_years_dash "
      mPopWhiteNonHispBridge_&_years. = "Non-Hispanic White population, MOE, &_years_dash "
      mPopAsianPINonHispBridge_&_years. = "Non-Hispanic Asian, Hawaiian and other Pacific Islander pop., MOE, &_years_dash "
      mPopHisp_&_years. = "Hispanic/Latino population, MOE, &_years_dash "
      mPopNativeAmNonHispBr_&_years. = "Non-Hispanic American Indian/Alaska Native population, MOE, &_years_dash "
      mPopOtherNonHispBridge_&_years. = "Non-Hispanic other race population, MOE, &_years_dash "
      mPopMultiracialNonHisp_&_years. = "Non-Hispanic multiracial population, MOE, &_years_dash "
      mPopOtherRaceNonHispBr_&_years. = "All remaining groups other than black, white, Hispanic, and Asian/PI, MOE, &_years_dash "
    ;
    
	  ** Population by race/ethnicity alone**;

    PopAloneB_&_years. = sum(B03002e4, B03002e14 );
	PopAloneW_&_years. = sum(B03002e3, B03002e13 );
	PopAloneH_&_years. = B03002e12;
	PopAloneA_&_years. = sum(B03002e6, B03002e7, B03002e16, B03002e17 );
	PopAloneI_&_years. = sum(B03002e5, B03002e15 );
	PopAloneO_&_years. = sum(B03002e8, B03002e18 );
	PopAloneM_&_years. = sum(B03002e9, B03002e19 );
	PopAloneIOM_&_years. = sum(B03002e5, B03002e15, B03002e8, B03002e18, B03002e9, B03002e19 );
	PopAloneAIOM_&_years. = sum(B03002e5, B03002e15, B03002e6, B03002e7, B03002e16, B03002e17, B03002e8, B03002e18, B03002e9, B03002e19 );
	mPopAloneB_&_years.	= %moe_sum( var=B03002m4 B03002m14 );
	mPopAloneW_&_years.	= %moe_sum( var=B03002m3 B03002m13 );
	mPopAloneH_&_years.	= B03002m12;
	mPopAloneA_&_years.	= %moe_sum( var=B03002m6 B03002m7 B03002m16 B03002m17 );
	mPopAloneI_&_years.	= %moe_sum( var=B03002m5 B03002m15 );
	mPopAloneO_&_years.	= %moe_sum( var=B03002m8 B03002m18 );
	mPopAloneM_&_years.	= %moe_sum( var=B03002m9 B03002m19 );
	mPopAloneIOM_&_years. = %moe_sum( var=B03002m5 B03002m15 B03002m8 B03002m18 B03002m9 B03002m19 );
	mPopAloneAIOM_&_years. = %moe_sum( var=B03002m5 B03002m15 B03002m6 B03002m7 B03002m16 B03002m17 B03002m8 B03002m18 B03002m9 B03002m19 );

	label
	  
	  PopAloneB_&_years. = "Black alone population, &_years_dash "
	  PopAloneW_&_years. = "White alone population, &_years_dash "
	  PopAloneH_&_years. = "Hispanic/Latino alone population, &_years_dash "
	  PopAloneA_&_years. = "Asian alone and Native Hawaiian and Other Pacific Islander alone, &_years_dash "
	  PopAloneI_&_years. = "American Indian and Alaska Native alone, &_years_dash "
	  PopAloneO_&_years. = "Some other race alone, &_years_dash "
	  PopAloneM_&_years. = "Two or more races alone, &_years_dash "
	  PopAloneIOM_&_years. = "American Indian/Alaska Native, other race, two or more races, &_years_dash "
	  PopAloneAIOM_&_years.	= "All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
	  mPopAloneB_&_years. = "Black alone population, MOE, &_years_dash "
	  mPopAloneW_&_years. = "White alone population, MOE, &_years_dash "
	  mPopAloneH_&_years. = "Hispanic/Latino alone population, MOE, &_years_dash "
	  mPopAloneA_&_years. = "Asian alone and Native Hawaiian and Other Pacific Islander alone, MOE, &_years_dash "
	  mPopAloneI_&_years. = "American Indian and Alaska Native alone, MOE, &_years_dash "
	  mPopAloneO_&_years. = "Some other race alone, MOE, &_years_dash "
	  mPopAloneM_&_years. = "Two or more races alone, MOE, &_years_dash "
	  mPopAloneIOM_&_years. = "American Indian/Alaska Native, other race, two or more races, MOE, &_years_dash "
	  mPopAloneAIOM_&_years. = "All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
	  ;

   
      ** Employment **;

	%if %upcase( &source_geo ) = TR00 or %upcase( &source_geo ) = TR10 %then %do;
 
	** Employment - Tract-level variables **;

	  PopCivilianEmployed_&_years. = 
        sum( B23001e7, B23001e14, B23001e21, B23001e28, B23001e35, B23001e42, B23001e49, 
             B23001e56, B23001e63, B23001e70, B23001e75, B23001e80, B23001e85,
             B23001e93, B23001e100, B23001e107, B23001e114, B23001e121, B23001e128, 
             B23001e135, B23001e142, B23001e149, B23001e156, B23001e161, B23001e166, B23001e171 );

			PopCivilianEmployedB_&_years. = sum(C23002Be7, C23002Be12, C23002Be20, C23002Be25 );
			PopCivilianEmployedW_&_years. = sum(C23002He7, C23002He12, C23002He20, C23002He25 );
			PopCivilianEmployedH_&_years. = sum(C23002Ie7, C23002Ie12, C23002Ie20, C23002Ie25 );
			PopCivilianEmployedA_&_years. = 
				sum(C23002De7, C23002De12, C23002De20, C23002De25, 
					C23002Ee7, C23002Ee12, C23002Ee20, C23002Ee25 );
			PopCivilianEmployedIOM_&_years. = 
				sum(C23002Ce7, C23002Ce12, C23002Ce20, C23002Ce25, 
					C23002Fe7, C23002Fe12, C23002Fe20, C23002Fe25, 
					C23002Ge7, C23002Ge12, C23002Ge20, C23002Ge25 );
			PopCivilianEmployedAIOM_&_years. = 
				sum(C23002Ce7, C23002Ce12, C23002Ce20, C23002Ce25,
					C23002De7, C23002De12, C23002De20, C23002De25, 
					C23002Ee7, C23002Ee12, C23002Ee20, C23002Ee25, 
					C23002Fe7, C23002Fe12, C23002Fe20, C23002Fe25, 
					C23002Ge7, C23002Ge12, C23002Ge20, C23002Ge25 );

      PopUnemployed_&_years. = 
        sum( B23001e8, B23001e15, B23001e22, B23001e29, B23001e36, B23001e43, B23001e50, 
             B23001e57, B23001e64, B23001e71, B23001e76, B23001e81, B23001e86, 
             B23001e94, B23001e101, B23001e108, B23001e115, B23001e122, B23001e129, 
             B23001e136, B23001e143, B23001e150, B23001e157, B23001e162, B23001e167, B23001e172 );
      
			PopUnemployedB_&_years. = sum(C23002Be8, C23002Be13, C23002Be21, C23002Be26 );
			PopUnemployedW_&_years. = sum(C23002He8, C23002He13, C23002He21, C23002He26 );
			PopUnemployedH_&_years. = sum(C23002Ie8, C23002Ie13, C23002Ie21, C23002Ie26 );
			PopUnemployedA_&_years. = 
				sum(C23002De8, C23002De13, C23002De21, C23002De26, 
					C23002Ee8, C23002Ee13, C23002Ee21, C23002Ee26 );
			PopUnemployedIOM_&_years. = 
				sum(C23002Ce8, C23002Ce13, C23002Ce21, C23002Ce26, 
					C23002Fe8, C23002Fe13, C23002Fe21, C23002Fe26, 
					C23002Ge8, C23002Ge13, C23002Ge21, C23002Ge26 );
			PopUnemployedAIOM_&_years. = 
				sum(C23002Ce8, C23002Ce13, C23002Ce21, C23002Ce26, 
					C23002De8, C23002De13, C23002De21, C23002De26, 
					C23002Ee8, C23002Ee13, C23002Ee21, C23002Ee26, 
					C23002Fe8, C23002Fe13, C23002Fe21, C23002Fe26, 
					C23002Ge8, C23002Ge13, C23002Ge21, C23002Ge26 );

      PopInCivLaborForce_&_years. = sum( PopCivilianEmployed_&_years., PopUnemployed_&_years. );
			PopInCivLaborForceB_&_years. = sum(PopCivilianEmployedB_&_years., PopUnemployedB_&_years.);
			PopInCivLaborForceW_&_years. = sum(PopCivilianEmployedW_&_years., PopUnemployedW_&_years.);
			PopInCivLaborForceH_&_years. = sum(PopCivilianEmployedH_&_years., PopUnemployedH_&_years.);
			PopInCivLaborForceA_&_years. = sum(PopCivilianEmployedA_&_years., PopUnemployedA_&_years.);
			PopInCivLaborForceIOM_&_years. = sum(PopCivilianEmployedIOM_&_years., PopUnemployedIOM_&_years.);
			PopInCivLaborForceAIOM_&_years. = sum(PopCivilianEmployedAIOM_&_years., PopUnemployedAIOM_&_years.);

      mPopCivilianEmployed_&_years. = 
        %moe_sum( var=B23001m7 B23001m14 B23001m21 B23001m28 B23001m35 B23001m42 B23001m49 
             B23001m56 B23001m63 B23001m70 B23001m75 B23001m80 B23001m85
             B23001m93 B23001m100 B23001m107 B23001m114 B23001m121 B23001m128 
             B23001m135 B23001m142 B23001m149 B23001m156 B23001m161 B23001m166 B23001m171 );

			mPopCivilianEmployedB_&_years. = %moe_sum( var=C23002Bm7 C23002Bm12 C23002Bm20 C23002Bm25);
			mPopCivilianEmployedW_&_years. = %moe_sum( var=C23002Hm7 C23002Hm12 C23002Hm20 C23002Hm25);
			mPopCivilianEmployedH_&_years. = %moe_sum( var=C23002Im7 C23002Im12 C23002Im20 C23002Im25);
			mPopCivilianEmployedA_&_years. = %moe_sum( var=C23002Dm7 C23002Dm12 C23002Dm20 C23002Dm25 C23002Em7 C23002Em12 C23002Em20 C23002Em25);
			mPopCivilianEmployedIOM_&_years. = 
				%moe_sum( var=C23002Cm7 C23002Cm12 C23002Cm20 C23002Cm25 
							C23002Fm7 C23002Fm12 C23002Fm20 C23002Fm25 
							C23002Gm7 C23002Gm12 C23002Gm20 C23002Gm25);
			mPopCivilianEmployedAIOM_&_years. = 
				%moe_sum( var=C23002Cm7 C23002Cm12 C23002Cm20 C23002Cm25 
							C23002Dm7 C23002Dm12 C23002Dm20 C23002Dm25 
							C23002Em7 C23002Em12 C23002Em20 C23002Em25 
							C23002Fm7 C23002Fm12 C23002Fm20 C23002Fm25 
							C23002Gm7 C23002Gm12 C23002Gm20 C23002Gm25);

      mPopUnemployed_&_years. = 
        %moe_sum( var=B23001m8 B23001m15 B23001m22 B23001m29 B23001m36 B23001m43 B23001m50 
             B23001m57 B23001m64 B23001m71 B23001m76 B23001m81 B23001m86 
             B23001m94 B23001m101 B23001m108 B23001m115 B23001m122 B23001m129 
             B23001m136 B23001m143 B23001m150 B23001m157 B23001m162 B23001m167 B23001m172 );

			mPopUnemployedB_&_years. = %moe_sum( var=C23002Bm8 C23002Bm13 C23002Bm21 C23002Bm26);
			mPopUnemployedW_&_years. = %moe_sum( var=C23002Hm8 C23002Hm13 C23002Hm21 C23002Hm26);
			mPopUnemployedH_&_years. = %moe_sum( var=C23002Im8 C23002Im13 C23002Im21 C23002Im26);
			mPopUnemployedA_&_years. = %moe_sum( var=C23002Dm8 C23002Dm13 C23002Dm21 C23002Dm26 C23002Em8 C23002Em13 C23002Em21 C23002Em26);
			mPopUnemployedIOM_&_years. = 
				%moe_sum( var=C23002Cm8 C23002Cm13 C23002Cm21 C23002Cm26 
				C23002Fm8 C23002Fm13 C23002Fm21 C23002Fm26 
				C23002Gm8 C23002Gm13 C23002Gm21 C23002Gm26);
			mPopUnemployedAIOM_&_years. = 
				%moe_sum( var=C23002Cm8 C23002Cm13 C23002Cm21 C23002Cm26 
				C23002Dm8 C23002Dm13 C23002Dm21 C23002Dm26 
				C23002Em8 C23002Em13 C23002Em21 C23002Em26 
				C23002Fm8 C23002Fm13 C23002Fm21 C23002Fm26 
				C23002Gm8 C23002Gm13 C23002Gm21 C23002Gm26);

	   mPopInCivLaborForce_&_years. = %moe_sum( var=mPopCivilianEmployed_&_years. mPopUnemployed_&_years. );
      
			mPopInCivLaborForceB_&_years. = %moe_sum( var=mPopCivilianEmployedB_&_years. mPopUnemployedB_&_years. );
			mPopInCivLaborForceW_&_years. = %moe_sum( var=mPopCivilianEmployedW_&_years. mPopUnemployedW_&_years. );
			mPopInCivLaborForceH_&_years. = %moe_sum( var=mPopCivilianEmployedH_&_years. mPopUnemployedH_&_years. );
			mPopInCivLaborForceA_&_years. = %moe_sum( var=mPopCivilianEmployedA_&_years. mPopUnemployedA_&_years. );
			mPopInCivLaborForceIOM_&_years. = %moe_sum( var=mPopCivilianEmployedIOM_&_years. mPopUnemployedIOM_&_years. );
			mPopInCivLaborForceAIOM_&_years. = %moe_sum( var=mPopCivilianEmployedAIOM_&_years. mPopUnemployedAIOM_&_years. );

      label
	  	PopCivilianEmployed_&_years. = "Persons 16+ years old in the civilian labor force and employed, &_years_dash "
			PopCivilianEmployedB_&_years. = "Persons 16+ years old in the civilian labor force and employed, Black/African American, &_years_dash "
			PopCivilianEmployedW_&_years. = "Persons 16+ years old in the civilian labor force and employed, Non-Hispanic White, &_years_dash "
			PopCivilianEmployedH_&_years. = "Persons 16+ years old in the civilian labor force and employed, Hispanic/Latino, &_years_dash "
			PopCivilianEmployedA_&_years. = "Persons 16+ years old in the civilian labor force and employed, Asian and Native Hawaiian and Other Pacific Islander, &_years_dash "
			PopCivilianEmployedIOM_&_years. = "Persons 16+ years old in the civilian labor force and employed, American Indian/Alaska Native, Some other race, Two or more races, &_years_dash "
			PopCivilianEmployedAIOM_&_years. = "Persons 16+ years old in the civilian labor force and employed, All remaining groups other than Black, Non-Hispanic White, Hispanic/Latino, &_years_dash "
	    PopUnemployed_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, &_years_dash "
			PopUnemployedB_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Black/African American, &_years_dash "
			PopUnemployedW_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Non-Hispanic White, &_years_dash "
			PopUnemployedH_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Hispanic/Latino, &_years_dash "
			PopUnemployedA_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Asian and Native Hawaiian and Other Pacific Islander, &_years_dash "
			PopUnemployedIOM_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, American Indian/Alaska Native, Some other race, Two or more races, &_years_dash "
			PopUnemployedAIOM_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, All remaining groups other than Black, Non-Hispanic White, Hispanic/Latino, &_years_dash "
        PopInCivLaborForce_&_years. = "Persons 16+ years old in the civilian labor force, &_years_dash "
			PopInCivLaborForceB_&_years. = "Persons 16+ years old in the civilian labor force, Black/African American, &_years_dash "
			PopInCivLaborForceW_&_years. = "Persons 16+ years old in the civilian labor force, Non-Hispanic White, &_years_dash "
			PopInCivLaborForceH_&_years. = "Persons 16+ years old in the civilian labor force, Hispanic/Latino, &_years_dash "
			PopInCivLaborForceA_&_years. = "Persons 16+ years old in the civilian labor force, Asian and Native Hawaiian and Other Pacific Islander, &_years_dash "
			PopInCivLaborForceIOM_&_years. = "Persons 16+ years old in the civilian labor force, American Indian/Alaska Native, Some other race, Two or more races, &_years_dash "
			PopInCivLaborForceAIOM_&_years. = "Persons 16+ years old in the civilian labor force, All remaining groups other than Black, Non-Hispanic White, Hispanic/Latino, &_years_dash "
		mPopCivilianEmployed_&_years. = "Persons 16+ years old in the civilian labor force and employed, MOE, &_years_dash "
			mPopCivilianEmployedB_&_years. = "Persons 16+ years old in the civilian labor force and employed, Black/African American, MOE, &_years_dash "
			mPopCivilianEmployedW_&_years. = "Persons 16+ years old in the civilian labor force and employed, Non-Hispanic White, MOE, &_years_dash "
			mPopCivilianEmployedH_&_years. = "Persons 16+ years old in the civilian labor force and employed, Hispanic/Latino, MOE, &_years_dash "
			mPopCivilianEmployedA_&_years. = "Persons 16+ years old in the civilian labor force and employed, Asian and Native Hawaiian and Other Pacific Islander, MOE, &_years_dash "
			mPopCivilianEmployedIOM_&_years. = "Persons 16+ years old in the civilian labor force and employed, American Indian/Alaska Native, Some other race, Two or more races, MOE, &_years_dash "
			mPopCivilianEmployedAIOM_&_years. = "Persons 16+ years old in the civilian labor force and employed, All remaining groups other than Black, Non-Hispanic White, Hispanic/Latino, MOE, &_years_dash "
        mPopUnemployed_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, MOE, &_years_dash "
			mPopUnemployedB_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Black/African American, MOE, &_years_dash "
			mPopUnemployedW_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Non-Hispanic White, MOE, &_years_dash "
			mPopUnemployedH_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Hispanic/Latino, MOE, &_years_dash "
			mPopUnemployedA_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, Asian and Native Hawaiian and Other Pacific Islander, MOE, &_years_dash "
			mPopUnemployedIOM_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, American Indian/Alaska Native, Some other race, Two or more races, MOE, &_years_dash "
			mPopUnemployedAIOM_&_years. = "Persons 16+ years old in the civilian labor force and unemployed, All remaining groups other than Black, Non-Hispanic White, Hispanic/Latino, MOE, &_years_dash "
		mPopInCivLaborForce_&_years. = "Persons 16+ years old in the civilian labor force, MOE, &_years_dash "
			mPopInCivLaborForceB_&_years. = "Persons 16+ years old in the civilian labor force, Black/African American, MOE, &_years_dash "
			mPopInCivLaborForceW_&_years. = "Persons 16+ years old in the civilian labor force, Non-Hispanic White, MOE, &_years_dash "
			mPopInCivLaborForceH_&_years. = "Persons 16+ years old in the civilian labor force, Hispanic/Latino, MOE, &_years_dash "
			mPopInCivLaborForceA_&_years. = "Persons 16+ years old in the civilian labor force, Asian and Native Hawaiian and Other Pacific Islander, MOE, &_years_dash "
			mPopInCivLaborForceIOM_&_years. = "Persons 16+ years old in the civilian labor force, American Indian/Alaska Native, Some other race, Two or more races, MOE, &_years_dash "
			mPopInCivLaborForceAIOM_&_years. = "Persons 16+ years old in the civilian labor force, All remaining groups other than Black, Non-Hispanic White, Hispanic/Latino, MOE, &_years_dash "
		;
      
    %end;
    
	 **Employment - Block group-level variables**;

 	  PopEmployedByOcc_&_years. = C24010e1;
			PopEmployedMngmt_&_years. = sum(C24010e3, C24010e39 );
			PopEmployedServ_&_years. = sum(C24010e19, C24010e55 );
			PopEmployedSales_&_years. = sum(C24010e27, C24010e63 );
			PopEmployedNatRes_&_years. = sum(C24010e30, C24010e66 );
			PopEmployedProd_&_years. = sum(C24010e34, C24010e70 );

	   PopEmployedByOccH_&_years. = C24010Ie1;
			PopEmployedMngmtH_&_years. = sum(C24010Ie3, C24010Ie9 );
			PopEmployedServH_&_years. = sum(C24010Ie4, C24010Ie10 );
			PopEmployedSalesH_&_years. = sum(C24010Ie5, C24010Ie11 );
			PopEmployedNatResH_&_years. = sum(C24010Ie6, C24010Ie12 );
			PopEmployedProdH_&_years. = sum(C24010Ie7, C24010Ie13 );

	   mPopEmployedByOcc_&_years. = C24010m1;
			mPopEmployedMngmt_&_years. = %moe_sum( var=C24010m3 C24010m39);
			mPopEmployedServ_&_years. = %moe_sum( var=C24010m19 C24010m55);
			mPopEmployedSales_&_years. = %moe_sum( var=C24010m27 C24010m63);
			mPopEmployedNatRes_&_years. = %moe_sum( var=C24010m30 C24010m66);
			mPopEmployedProd_&_years. = %moe_sum( var=C24010m34 C24010m70);

		  mPopEmployedByOccH_&_years. = C24010Im1;
				mPopEmployedMngmtH_&_years. = %moe_sum( var=C24010Im3 C24010Im9);
				mPopEmployedServH_&_years. = %moe_sum( var=C24010Im4 C24010Im10);
				mPopEmployedSalesH_&_years. = %moe_sum( var=C24010Im5 C24010Im11);
				mPopEmployedNatResH_&_years. = %moe_sum( var=C24010Im6 C24010Im12);
				mPopEmployedProdH_&_years. = %moe_sum( var=C24010Im7 C24010Im13);

	label
		PopEmployedByOcc_&_years. = "Persons 16+ years old employed in civilian occupations, &_years_dash "
			PopEmployedMngmt_&_years. = "Persons 16+ years old employed in management, business, science and arts occupations, &_years_dash "
			PopEmployedServ_&_years. = "Persons 16+ years old employed in service occupations, &_years_dash "
			PopEmployedSales_&_years. = "Persons 16+ years old employed in sales and office occupations, &_years_dash "
			PopEmployedNatRes_&_years. = "Persons 16+ years old employed in natural resources, construction, and maintenance occupations, &_years_dash "
			PopEmployedProd_&_years. = "Persons 16+ years old employed in production, transportation, and material moving occupations, &_years_dash "
		PopEmployedByOccH_&_years. = "Persons 16+ years old employed in civilian occupations, Hispanic/Latino, &_years_dash "
			PopEmployedMngmtH_&_years. = "Persons 16+ years old employed in management, business, science and arts occupations, Hispanic/Latino, &_years_dash "
			PopEmployedServH_&_years. = "Persons 16+ years old employed in service occupations, Hispanic/Latino, &_years_dash "
			PopEmployedSalesH_&_years. = "Persons 16+ years old employed in sales and office occupations, Hispanic/Latino, &_years_dash "
			PopEmployedNatResH_&_years. = "Persons 16+ years old employed in natural resources, construction, and maintenance occupations, Hispanic/Latino, &_years_dash "
			PopEmployedProdH_&_years. = "Persons 16+ years old employed in production, transportation, and material moving occupations, Hispanic/Latino, &_years_dash "
		mPopEmployedByOcc_&_years. = "Persons 16+ years old employed in civilian occupations, MOE, &_years_dash "
			mPopEmployedMngmt_&_years. = "Persons 16+ years old employed in management, business, science and arts occupations, MOE, &_years_dash "
			mPopEmployedServ_&_years. = "Persons 16+ years old employed in service occupations, MOE, &_years_dash "
			mPopEmployedSales_&_years. = "Persons 16+ years old employed in sales and office occupations, MOE, &_years_dash "
			mPopEmployedNatRes_&_years. = "Persons 16+ years old employed in natural resources, construction, and maintenance occupations, MOE, &_years_dash "
			mPopEmployedProd_&_years. = "Persons 16+ years old employed in production, transportation, and material moving occupations, MOE, &_years_dash "
		mPopEmployedByOccH_&_years. = "Persons 16+ years old employed in civilian occupations, Hispanic/Latino, MOE, &_years_dash "
			mPopEmployedMngmtH_&_years. = "Persons 16+ years old employed in management, business, science and arts occupations, Hispanic/Latino, MOE, &_years_dash "
			mPopEmployedServH_&_years. = "Persons 16+ years old employed in service occupations, Hispanic/Latino, MOE, &_years_dash "
			mPopEmployedSalesH_&_years. = "Persons 16+ years old employed in sales and office occupations, Hispanic/Latino, MOE, &_years_dash "
			mPopEmployedNatResH_&_years. = "Persons 16+ years old employed in natural resources, construction, and maintenance occupations, Hispanic/Latino, MOE, &_years_dash "
			mPopEmployedProdH_&_years. = "Persons 16+ years old employed in production, transportation, and material moving occupations, Hispanic/Latino, MOE, &_years_dash "
		;

    ** Education **;

    ** Education - Block group-level variables**;

	Pop25andOverYears_&_years. = B15002e1;

	Pop25andOverWoutHS_&_years. = 
      sum( B15002e3, B15002e4, B15002e5, B15002e6, B15002e7, B15002e8, B15002e9, B15002e10, 
           B15002e20, B15002e21, B15002e22, B15002e23, B15002e24, B15002e25, B15002e26, B15002e27 );

    Pop25andOverWHS_&_years. = 
      sum( B15002e11, B15002e12, B15002e13, B15002e14, B15002e15, B15002e16, B15002e17, B15002e18, 
		   B15002e28, B15002e29, B15002e30, B15002e31, B15002e32, B15002e33, B15002e34, B15002e35 );

	Pop25andOverWSC_&_years. = 
		sum(B15002e12, B15002e13, B15002e14, B15002e15, B15002e16, B15002e17, B15002e18, B15002e29, 
			B15002e30, B15002e31, B15002e32, B15002e33, B15002e34, B15002e35 );

	Pop25andOverWCollege_&_years. = 
      sum( B15002e15, B15002e16, B15002e17, B15002e18, B15002e32, B15002e33, B15002e34, B15002e35 );


	mPop25andOverYears_&_years. = B15002m1;

    mPop25andOverWoutHS_&_years. = 
      %moe_sum( var=B15002m3 B15002m4 B15002m5 B15002m6 B15002m7 B15002m8 B15002m9 B15002m10 
           B15002m20 B15002m21 B15002m22 B15002m23 B15002m24 B15002m25 B15002m26 B15002m27 );

    mPop25andOverWHS_&_years. = 
      %moe_sum( var=B15002m11 B15002m12 B15002m13 B15002m14 B15002m15 B15002m16 B15002m17 B15002m18
					B15002m28 B15002m29 B15002m30 B15002m31 B15002m32 B15002m33 B15002m34 B15002m35 );

	mPop25andOverWSC_&_years. = 
		%moe_sum( var=B15002m12 B15002m13 B15002m14 B15002m15 B15002m16 B15002m17 B15002m18 
					  B15002m29 B15002m30 B15002m31 B15002m32 B15002m33 B15002m34 B15002m35);

    mPop25andOverWCollege_&_years. = 
      %moe_sum( var=B15002m15 B15002m16 B15002m17 B15002m18 B15002m32 B15002m33 B15002m34 B15002m35 );


 label
	  Pop25andOverWoutHS_&_years. = "Persons 25 years old and over without high school diploma, &_years_dash "
	  Pop25andOverWHS_&_years. = "Persons 25 years old and over with a high school diploma or GED, &_years_dash "
	  Pop25andOverWSC_&_years. = "Persons 25 years old and over with some college, &_years_dash "
	  Pop25andOverWCollege_&_years. = "Persons 25+ years old with a bachelors or graduate/prof degree, &_years_dash "
      Pop25andOverYears_&_years. = "Persons 25 years old and over, &_years_dash "
	  mPop25andOverWoutHS_&_years. = "Persons 25 years old and over without high school diploma, MOE, &_years_dash "
      mPop25andOverWHS_&_years. = "Persons 25 years old and over with a high school diploma or GED, MOE, &_years_dash "
	  mPop25andOverWSC_&_years. = "Persons 25 years old and over with some college, MOE, &_years_dash "
	  mPop25andOverWCollege_&_years. = "Persons 25+ years old with a bachelors or graduate/prof degree, MOE, &_years_dash "
      mPop25andOverYears_&_years. = "Persons 25 years old and over, MOE, &_years_dash "
	  ;


	%if %upcase( &source_geo ) = TR00 or %upcase( &source_geo ) = TR10 %then %do;

    ** Education - Tract-level variables **;

	Pop25andOverYearsB_&_years.	= C15002Be1;
	Pop25andOverYearsW_&_years.	= C15002He1;
	Pop25andOverYearsH_&_years.	= C15002Ie1;
	Pop25andOverYearsA_&_years.	= sum(C15002De1, C15002Ee1 );
	Pop25andOverYearsIOM_&_years. = sum(C15002Ce1, C15002Fe1, C15002Ge1 );
	Pop25andOverYearsAIOM_&_years. = sum(C15002Ce1, C15002De1, C15002Ee1, C15002Fe1, C15002Ge1 );
	Pop25andOverYearsFB_&_years.	= B06009e25;
	Pop25andOverYearsNB_&_years. = sum(B06009e7, B06009e13, B06009e19 );


	Pop25andOverWoutHSB_&_years. = sum(C15002Be3, C15002Be8 );
	Pop25andOverWoutHSW_&_years.	= sum(C15002He3, C15002He8 );
	Pop25andOverWoutHSH_&_years. = sum(C15002Ie3, C15002Ie8 );
	Pop25andOverWoutHSA_&_years.	= sum(C15002De3, C15002De8, C15002Ee3, C15002Ee8 );
	Pop25andOverWoutHSIOM_&_years. = sum(C15002Ce3, C15002Ce8, C15002Fe3, C15002Fe8, C15002Ge3, C15002Ge8 );
	Pop25andOverWoutHSAIOM_&_years. = 
		sum(C15002Ce3, C15002Ce8, C15002De3, C15002De8, C15002Ee3, C15002Ee8, 
			C15002Fe3, C15002Fe8, C15002Ge3, C15002Ge8 );
	Pop25andOverWoutHSFB_&_years. = B06009e26;
	Pop25andOverWoutHSNB_&_years. = sum(B06009e8, B06009e14, B06009e20 );

   
	Pop25andOverWHSB_&_years. = sum(C15002Be4, C15002Be5, C15002Be6,  C15002Be9, C15002Be10, C15002Be11 );
	Pop25andOverWHSW_&_years. = sum(C15002He4, C15002He5, C15002He6,  C15002He9, C15002He10, C15002He11 );
	Pop25andOverWHSH_&_years. = sum(C15002Ie4, C15002Ie5, C15002Ie6 , C15002Ie9, C15002Ie10, C15002Ie11 );
	Pop25andOverWHSA_&_years. = 
		sum(C15002De4, C15002De5, C15002De6, C15002De9, C15002De10, C15002De11, 
			C15002Ee4, C15002Ee5, C15002Ee6, C15002Ee9, C15002Ee10, C15002Ee11 );
	Pop25andOverWHSIOM_&_years. = 
		sum(C15002Ce4, C15002Ce5, C15002Ce6,  C15002Ce9, C15002Ce10, C15002Ce11, 
			C15002Fe4, C15002Fe5, C15002Fe6,  C15002Fe9, C15002Fe10, C15002Fe11, 
			C15002Ge4, C15002Ge5, C15002Ge6,  C15002Ge9, C15002Ge10, C15002Ge11 );
	Pop25andOverWHSAIOM_&_years. = 
		sum(C15002Ce4, C15002Ce5, C15002Ce6,  C15002Ce9, C15002Ce10, C15002Ce11, 
			C15002De4, C15002De5, C15002De6, C15002De9, C15002De10, C15002De11, 
			C15002Ee4, C15002Ee5, C15002Ee6, C15002Ee9, C15002Ee10, C15002Ee11, 
			C15002Fe4, C15002Fe5, C15002Fe6,  C15002Fe9, C15002Fe10, C15002Fe11, 
			C15002Ge4, C15002Ge5, C15002Ge6,  C15002Ge9, C15002Ge10, C15002Ge11 );
	Pop25andOverWHSFB_&_years. = sum(B06009e27, B06009e28, B06009e29, B06009e30 );
	Pop25andOverWHSNB_&_years. = 
		sum(B06009e9, B06009e10, B06009e11, B06009e12, B06009e15, B06009e16, 
			B06009e17, B06009e18, B06009e21, B06009e22, B06009e23, B06009e24 );

	Pop25andOverWSCB_&_years. = sum(C15002Be5, C15002Be6, C15002Be10, C15002Be11 );
	Pop25andOverWSCW_&_years. = sum(C15002He5, C15002He6, C15002He10, C15002He11 );
	Pop25andOverWSCH_&_years. = sum(C15002Ie5, C15002Ie6, C15002Ie10, C15002Ie11 );
	Pop25andOverWSCA_&_years. = 
		sum(C15002De5, C15002De6, C15002De10, C15002De11,
			C15002Ee5, C15002Ee6, C15002Ee10, C15002Ee11 );
	Pop25andOverWSCIOM_&_years. = 
		sum(C15002Ce5, C15002Ce6, C15002Ce10, C15002Ce11, 
			C15002Fe5, C15002Fe6, C15002Fe10, C15002Fe11, 
			C15002Ge5, C15002Ge6, C15002Ge10, C15002Ge11 );
	Pop25andOverWSCAIOM_&_years. = 
		sum(C15002Ce5, C15002Ce6, C15002Ce10, C15002Ce11, 
			C15002De5, C15002De6, C15002De10, C15002De11, 
			C15002Ee5, C15002Ee6, C15002Ee10, C15002Ee11, 
			C15002Fe5, C15002Fe6, C15002Fe10, C15002Fe11,
			C15002Ge5, C15002Ge6, C15002Ge10, C15002Ge11 );
	Pop25andOverWSCFB_&_years. = sum(B06009e28, B06009e29, B06009e30 );
	Pop25andOverWSCNB_&_years. = 
		sum(B06009e10, B06009e11, B06009e12, 
			B06009e16, B06009e17, B06009e18, 
			B06009e22, B06009e23, B06009e24 );
    

	mPop25andOverYearsB_&_years. = C15002Bm1;
	mPop25andOverYearsW_&_years. = C15002Hm1;
	mPop25andOverYearsH_&_years. = C15002Im1;
	mPop25andOverYearsA_&_years. = %moe_sum( var=C15002Dm1 C15002Em1);
	mPop25andOverYearsIOM_&_years. = %moe_sum( var=C15002Cm1 C15002Fm1 C15002Gm1);
	mPop25andOverYearsAIOM_&_years. = %moe_sum( var=C15002Cm1 C15002Dm1 C15002Em1 C15002Fm1 C15002Gm1);
	mPop25andOverYearsFB_&_years. = B06009m25;
	mPop25andOverYearsNB_&_years. = %moe_sum( var=B06009m7 B06009m13 B06009m19);

   
	mPop25andOverWoutHSB_&_years. = %moe_sum( var=C15002Bm3 C15002Bm8);
	mPop25andOverWoutHSW_&_years. = %moe_sum( var=C15002Hm3 C15002Hm8);
	mPop25andOverWoutHSH_&_years. = %moe_sum( var=C15002Im3 C15002Im8);
	mPop25andOverWoutHSA_&_years. = %moe_sum( var=C15002Dm3 C15002Dm8 C15002Em3 C15002Em8);
	mPop25andOverWoutHSIOM_&_years. = %moe_sum( var=C15002Cm3 C15002Cm8 C15002Fm3 C15002Fm8 C15002Gm3 C15002Gm8);
	mPop25andOverWoutHSAIOM_&_years.	= 
		%moe_sum( var=C15002Cm3 C15002Cm8 C15002Dm3 C15002Dm8 
			C15002Em3 C15002Em8 C15002Fm3 C15002Fm8 C15002Gm3 C15002Gm8);
	mPop25andOverWoutHSFB_&_years. = B06009m26;
	mPop25andOverWoutHSNB_&_years. = %moe_sum( var=B06009m8 B06009m14 B06009m20);

 

	mPop25andOverWHSB_&_years. = %moe_sum( var=C15002Bm4 C15002Bm5 C15002Bm6  C15002Bm9 C15002Bm10 C15002Bm11);
	mPop25andOverWHSW_&_years. = %moe_sum( var=C15002Hm4 C15002Hm5 C15002Hm6  C15002Hm9 C15002Hm10 C15002Hm11);
	mPop25andOverWHSH_&_years. = %moe_sum( var=C15002Im4 C15002Im5 C15002Im6  C15002Im9 C15002Im10 C15002Im11);
	mPop25andOverWHSA_&_years. = 
		%moe_sum( var=C15002Dm4 C15002Dm5 C15002Dm6 C15002Dm9 C15002Dm10 C15002Dm11 
							  C15002Em4 C15002Em5 C15002Em6 C15002Em9 C15002Em10 C15002Em11);
	mPop25andOverWHSIOM_&_years. = 
		%moe_sum( var=C15002Cm4 C15002Cm5 C15002Cm6  C15002Cm9 C15002Cm10 C15002Cm11 
							  C15002Fm4 C15002Fm5 C15002Fm6  C15002Fm9 C15002Fm10 C15002Fm11 
							  C15002Gm4 C15002Gm5 C15002Gm6  C15002Gm9 C15002Gm10 C15002Gm11);
	mPop25andOverWHSAIOM_&_years. = 
		%moe_sum( var=C15002Cm4 C15002Cm5 C15002Cm6  C15002Cm9 C15002Cm10 C15002Cm11 
							  C15002Dm4 C15002Dm5 C15002Dm6 C15002Dm9 C15002Dm10 C15002Dm11 
							  C15002Em4 C15002Em5 C15002Em6 C15002Em9 C15002Em10 C15002Em11 
							  C15002Fm4 C15002Fm5 C15002Fm6  C15002Fm9 C15002Fm10 C15002Fm11 
							  C15002Gm4 C15002Gm5 C15002Gm6  C15002Gm9 C15002Gm10 C15002Gm11);
	mPop25andOverWHSFB_&_years. = %moe_sum( var=B06009m27 B06009m28 B06009m29 B06009m30);
	mPop25andOverWHSNB_&_years. = 
		%moe_sum( var=B06009m9 B06009m10 B06009m11 B06009m12 B06009m15 B06009m16 
							  B06009m17 B06009m18 B06009m21 B06009m22 B06009m23 B06009m24);


	mPop25andOverWSCB_&_years. = %moe_sum( var=C15002Bm5 C15002Bm6 C15002Bm10 C15002Bm11);
	mPop25andOverWSCW_&_years. = %moe_sum( var=C15002Hm5 C15002Hm6 C15002Hm10 C15002Hm11);
	mPop25andOverWSCH_&_years. = %moe_sum( var=C15002Im5 C15002Im6 C15002Im10 C15002Im11);
	mPop25andOverWSCA_&_years. = 
		%moe_sum( var=C15002Dm5 C15002Dm6 C15002Dm10 C15002Dm11 C15002Em5 C15002Em6 C15002Em10 C15002Em11);
	mPop25andOverWSCIOM_&_years. = 
		%moe_sum( var=C15002Cm5 C15002Cm6 C15002Cm10 C15002Cm11 
					C15002Fm5 C15002Fm6 C15002Fm10 C15002Fm11 
					C15002Gm5 C15002Gm6 C15002Gm10 C15002Gm11);
	mPop25andOverWSCAIOM_&_years. = 
		%moe_sum( var=C15002Cm5 C15002Cm6 C15002Cm10 C15002Cm11 
					C15002Dm5 C15002Dm6 C15002Dm10 C15002Dm11 
					C15002Em5 C15002Em6 C15002Em10 C15002Em11 
					C15002Fm5 C15002Fm6 C15002Fm10 C15002Fm11
					C15002Gm5 C15002Gm6 C15002Gm10 C15002Gm11);
	mPop25andOverWSCFB_&_years. = %moe_sum( var=B06009m28 B06009m29 B06009m30);
	mPop25andOverWSCNB_&_years. = 
		%moe_sum( var=B06009m10 B06009m11 B06009m12 B06009m16 B06009m17 
					B06009m18 B06009m22 B06009m23 B06009m24);

    
    label
			Pop25andOverWoutHSB_&_years. = "Persons 25 years old and over without a high school diploma or GED, Black/African American, &_years_dash "
			Pop25andOverWoutHSW_&_years. = "Persons 25 years old and over without a high school diploma or GED, Non-Hispanic White, &_years_dash "
			Pop25andOverWoutHSH_&_years. = "Persons 25 years old and over without a high school diploma or GED, Hispanic/Latino, &_years_dash "
			Pop25andOverWoutHSA_&_years. = "Persons 25 years old and over without a high school diploma or GED, Asian, Hawaiian and other Pacific Islander, &_years_dash "
			Pop25andOverWoutHSIOM_&_years. = "Persons 25 years old and over without a high school diploma or GED, American Indian/Alaska Native, other race, two or more races, &_years_dash "
			Pop25andOverWoutHSAIOM_&_years. = "Persons 25 years old and over without a high school diploma or GED, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
			Pop25andOverWoutHSFB_&_years. = "Foreign born 25 years and over without high school diploma or GED, &_years_dash "
			Pop25andOverWoutHSNB_&_years. = "Native born persons 25 years and over with some college, &_years_dash"
			Pop25andOverWHSB_&_years. = "Persons 25 years old and over with a high school diploma or GED, Black/African American, &_years_dash "
			Pop25andOverWHSW_&_years. = "Persons 25 years old and over with a high school diploma or GED, Non-Hispanic White, &_years_dash "
			Pop25andOverWHSH_&_years. = "Persons 25 years old and over with a high school diploma or GED, Hispanic/Latino, &_years_dash "
			Pop25andOverWHSA_&_years. = "Persons 25 years old and over with a high school diploma or GED, Asian, Hawaiian and other Pacific Islander, &_years_dash "
			Pop25andOverWHSIOM_&_years. = "Persons 25 years old and over with a high school diploma or GED, American Indian/Alaska Native, other race, two or more races, &_years_dash "
			Pop25andOverWHSAIOM_&_years. = "Persons 25 years old and over with a high school diploma or GED, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
			Pop25andOverWHSFB_&_years. = "Foreign born persons 25 years and over with a high school diploma or GED,  &_years_dash "
			Pop25andOverWHSNB_&_years. = "Native born persons 25 years and over with a high school diploma or GED, &_years_dash"
			Pop25andOverWSCB_&_years. = "Persons 25 years old and over with some college, Black/African American , &_years_dash "
			Pop25andOverWSCW_&_years. = "Persons 25 years old and over with some college, Non-Hispanic White, &_years_dash "
			Pop25andOverWSCH_&_years. = "Persons 25 years old and over with some college, Hispanic/Latino, &_years_dash "
			Pop25andOverWSCA_&_years. = "Persons 25 years old and over with some college, Asian, Hawaiian and other Pacific Islander, &_years_dash "
			Pop25andOverWSCIOM_&_years. = "Persons 25 years old and over with some college, American Indian/Alaska Native, other race, two or more races, &_years_dash "
			Pop25andOverWSCAIOM_&_years. = "Persons 25 years old and over with some college, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
		    Pop25andOverWSCFB_&_years. = "Foreign born 25 years and over with some college "
		 	Pop25andOverWSCNB_&_years. = "Native born persons 25 years and over without a high school diploma or GED, &_years_dash"
		  	Pop25andOverYearsB_&_years. = "Persons 25 years old and over, Black/African American, &_years_dash"
			Pop25andOverYearsW_&_years. = "Persons 25 years old and over, Non-Hispanic White, &_years_dash"
			Pop25andOverYearsH_&_years. = "Persons 25 years old and over, Hispanic/Latino, &_years_dash"
			Pop25andOverYearsA_&_years. = "Persons 25 years old and over, Asian, Hawaiian and other Pacific Islander, &_years_dash"
			Pop25andOverYearsIOM_&_years. = "Persons 25 years old and over, American Indian/Alaska Native, other race, two or more races, &_years_dash"
			Pop25andOverYearsAIOM_&_years. = "Persons 25 years old and over, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash"
	  		Pop25andOverYearsFB_&_years. = "Foreign born persons 25 years and over, &_years_dash "
			Pop25andOverYearsNB_&_years. = "Native born persons 25 years and over with a high school diploma or GED, &_years_dash "
			mPop25andOverWoutHSB_&_years. = "Persons 25 years old and over without a high school diploma or GED, Black/African American, MOE, &_years_dash "
			mPop25andOverWoutHSW_&_years. = "Persons 25 years old and over without a high school diploma or GED, Non-Hispanic White, MOE, &_years_dash "
			mPop25andOverWoutHSH_&_years. = "Persons 25 years old and over without a high school diploma or GED, Hispanic/Latino, MOE, &_years_dash "
			mPop25andOverWoutHSA_&_years. = "Persons 25 years old and over without a high school diploma or GED, Asian, Hawaiian and other Pacific Islander, MOE, &_years_dash "
			mPop25andOverWoutHSIOM_&_years. = "Persons 25 years old and over without a high school diploma or GED, American Indian/Alaska Native, other race, two or more races, MOE, &_years_dash "
			mPop25andOverWoutHSAIOM_&_years. = "Persons 25 years old and over without a high school diploma or GED, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
			mPop25andOverWoutHSFB_&_years. = "Foreign born 25 years and over without high school diploma or GED, MOE, &_years_dash"
			mPop25andOverWoutHSNB_&_years. = "Native born persons 25 years and over without a high school diploma or GED, MOE, &_years_dash"
			mPop25andOverWHSB_&_years. = "Persons 25 years old and over with a high school diploma or GED, Black/African American, MOE, &_years_dash "
			mPop25andOverWHSW_&_years. = "Persons 25 years old and over with a high school diploma or GED, Non-Hispanic White, MOE, &_years_dash "
			mPop25andOverWHSH_&_years. = "Persons 25 years old and over with a high school diploma or GED, Hispanic/Latino, MOE, &_years_dash "
			mPop25andOverWHSA_&_years. = "Persons 25 years old and over with a high school diploma or GED, Asian, Hawaiian and other Pacific Islander, MOE, &_years_dash "
			mPop25andOverWHSIOM_&_years. = "Persons 25 years old and over with a high school diploma or GED, American Indian/Alaska Native, other race, two or more races, MOE, &_years_dash "
			mPop25andOverWHSAIOM_&_years. = "Persons 25 years old and over with a high school diploma or GED, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
		  	mPop25andOverWHSFB_&_years. = "Foreign born persons 25 years and over with a high school diploma or GED,  MOE, &_years_dash"
			mPop25andOverWHSNB_&_years. = "Native born persons 25 years and over with a high school diploma or GED, MOE, &_years_dash"
			mPop25andOverWSCB_&_years. = "Persons 25 years old and over with some college, Black/African American , MOE, &_years_dash "
			mPop25andOverWSCW_&_years. = "Persons 25 years old and over with some college, Non-Hispanic White, MOE, &_years_dash "
			mPop25andOverWSCH_&_years. = "Persons 25 years old and over with some college, Hispanic/Latino, MOE, &_years_dash "
			mPop25andOverWSCA_&_years. = "Persons 25 years old and over with some college, Asian, Hawaiian and other Pacific Islander, MOE, &_years_dash "
			mPop25andOverWSCIOM_&_years. = "Persons 25 years old and over with some college, American Indian/Alaska Native, other race, two or more races, MOE, &_years_dash "
			mPop25andOverWSCAIOM_&_years. = "Persons 25 years old and over with some college, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
			mPop25andOverWSCFB_&_years. = "Foreign born 25 years and over with some college"
			mPop25andOverWSCNB_&_years. = "Native born persons 25 years and over with some college, MOE, &_years_dash"
			mPop25andOverYearsB_&_years. = "Persons 25 years old and over, Black/African American, MOE, &_years_dash "
			mPop25andOverYearsW_&_years. = "Persons 25 years old and over, Non-Hispanic White, MOE, &_years_dash "
			mPop25andOverYearsH_&_years. = "Persons 25 years old and over, Hispanic/Latino, MOE, &_years_dash "
			mPop25andOverYearsA_&_years. = "Persons 25 years old and over, Asian, Hawaiian and other Pacific Islander, MOE, &_years_dash "
			mPop25andOverYearsIOM_&_years. = "Persons 25 years old and over, American Indian/Alaska Native, other race, two or more races, MOE, &_years_dash "
			mPop25andOverYearsAIOM_&_years. = "Persons 25 years old and over, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
			mPop25andOverYearsFB_&_years. = "Foreign born persons 25 years and over, &_years_dash "
			mPop25andOverYearsNB_&_years. = "Native born persons 25 years and over, MOE, &_years_dash "
		;

	%end;
  
    ** Income **;

    ** Income - Block group-level variables **;

	MedFamIncm_&_years. = B19113e1;
		MedFamIncmB_&_years. = B19113Be1;
		MedFamIncmW_&_years. = B19113He1;
		MedFamIncmH_&_years. = B19113Ie1;
		MedFamIncmA_&_years. = sum(B19113De1, B19113Ee1 );
		MedFamIncmIOM_&_years. = sum(B19113Ce1, B19113Fe1, B19113Ge1 );
		MedFamIncmAIOM_&_years. = sum(B19113Ce1, B19113De1, B19113Ee1, B19113Fe1, B19113Ge1 );

	mMedFamIncm_&_years. = B19113m1;
			mMedFamIncmB_&_years. = B19113Bm1;
			mMedFamIncmW_&_years. = B19113Hm1;
			mMedFamIncmH_&_years. = B19113Im1;
			mMedFamIncmA_&_years. = %moe_sum( var=B19113Dm1 B19113Em1);
			mMedFamIncmIOM_&_years. = %moe_sum( var=B19113Cm1 B19113Fm1 B19113Gm1);
			mMedFamIncmAIOM_&_years. = %moe_sum( var=B19113Cm1 B19113Dm1 B19113Em1 B19113Fm1 B19113Gm1);

    label 
	  MedFamIncm_&_years. = "Median family income, &_years_dash "
			MedFamIncmB_&_years. = "Median family income, Black/African American, &_years_dash "
			MedFamIncmW_&_years. = "Median family income, Non-Hispanic White, &_years_dash "
			MedFamIncmH_&_years. = "Median family income, Hispanic/Latino, &_years_dash "
			MedFamIncmA_&_years. = "Median family income, Asian, Native Hawaiian, and other Pacific Islander, &_years_dash "
			MedFamIncmIOM_&_years. = "Median family income, American Indian/Alaska Native, some other race, two or more races, &_years_dash "
			MedFamIncmAIOM_&_years. = "Median family income, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
	  mMedFamIncm_&_years. = "Median family income, MOE, &_years_dash "
			mMedFamIncmB_&_years. = "Median family income, Black/African American, MOE, &_years_dash "
			mMedFamIncmW_&_years. = "Median family income, Non-Hispanic White, MOE, &_years_dash "
			mMedFamIncmH_&_years. = "Median family income, Hispanic/Latino, MOE, &_years_dash "
			mMedFamIncmA_&_years. = "Median family income, Asian, Native Hawaiian, and other Pacific Islander, MOE, &_years_dash "
			mMedFamIncmIOM_&_years. = "Median family income, American Indian/Alaska Native, some other race, two or more races, MOE, &_years_dash "
			mMedFamIncmAIOM_&_years. = "Median family income, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
      ;

    ** Housing **;    

	NumOccupiedHsgUnits_&_years. = B25003e1;
		NumOccupiedHsgUnitsB_&_years. = B25003Be1;
		NumOccupiedHsgUnitsW_&_years. = B25003He1;
		NumOccupiedHsgUnitsH_&_years. = B25003Ie1;
		NumOccupiedHsgUnitsA_&_years. = sum(B25003De1, B25003Ee1 );
		NumOccupiedHsgUnitsIOM_&_years. = sum(B25003Ce1, B25003Fe1, B25003Ge1 );
		NumOccupiedHsgUnitsAIOM_&_years. = sum(B25003Ce1, B25003De1, B25003Ee1, B25003Fe1, B25003Ge1 );

    NumOwnerOccupiedHU_&_years. = B25003e2;
		NumOwnerOccupiedHUB_&_years. = B25003Be2;
		NumOwnerOccupiedHUW_&_years. = B25003He2;
		NumOwnerOccupiedHUH_&_years. = B25003Ie2;
		NumOwnerOccupiedHUA_&_years. = sum(B25003De2, B25003Ee2 );
		NumOwnerOccupiedHUIOM_&_years. = sum(B25003Ce2, B25003Fe2, B25003Ge2 );
		NumOwnerOccupiedHUAIOM_&_years. = sum(B25003Ce2, B25003De2, B25003Ee2, B25003Fe2, B25003Ge2 );

    mNumOccupiedHsgUnits_&_years. = B25003m1;
		mNumOccupiedHsgUnitsB_&_years. = B25003Bm1;
		mNumOccupiedHsgUnitsW_&_years. = B25003Hm1;
		mNumOccupiedHsgUnitsH_&_years. = B25003Im1;
		mNumOccupiedHsgUnitsA_&_years. = %moe_sum( var=B25003Dm1 B25003Em1);
		mNumOccupiedHsgUnitsIOM_&_years. = %moe_sum( var=B25003Cm1 B25003Fm1 B25003Gm1);
		mNumOccupiedHsgUnitsAIOM_&_years. = %moe_sum( var=B25003Cm1 B25003Dm1 B25003Em1 B25003Fm1 B25003Gm1);

    mNumOwnerOccupiedHU_&_years. = B25003m2;
		mNumOwnerOccupiedHUB_&_years. = B25003Bm2;
		mNumOwnerOccupiedHUW_&_years. = B25003Hm2;
		mNumOwnerOccupiedHUH_&_years. = B25003Im2;
		mNumOwnerOccupiedHUA_&_years. = %moe_sum( var=B25003Dm2 B25003Em2);
		mNumOwnerOccupiedHUIOM_&_years. = %moe_sum( var=B25003Cm2 B25003Fm2 B25003Gm2);
		mNumOwnerOccupiedHUAIOM_&_years. = %moe_sum( var=B25003Cm2 B25003Dm2 B25003Em2 B25003Fm2 B25003Gm2);

    label
	  NumOccupiedHsgUnits_&_years. = "Occupied housing units, &_years_dash "
		    NumOccupiedHsgUnitsB_&_years. = "Occupied housing units, Black/African American, &_years_dash "
			NumOccupiedHsgUnitsW_&_years. = "Occupied housing units, Non-Hispanic White, &_years_dash "
			NumOccupiedHsgUnitsH_&_years. = "Occupied housing units, Hispanic/Latino, &_years_dash "
			NumOccupiedHsgUnitsA_&_years. = "Occupied housing units, Asian and Native Hawaiian and Other Pacific Islander, &_years_dash "
			NumOccupiedHsgUnitsIOM_&_years. = "Occupied housing units,  American Indian/Alaska Native, Some other race, Two or more races, &_years_dash "
			NumOccupiedHsgUnitsAIOM_&_years. = "Occupied housing units, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
      NumOwnerOccupiedHU_&_years. = "Owner-occupied housing units, &_years_dash "
	  		NumOwnerOccupiedHUB_&_years. = "Owner-occupied housing units, Black/African American, &_years_dash "
			NumOwnerOccupiedHUW_&_years. = "Owner-occupied housing units, Non-Hispanic White, &_years_dash "
			NumOwnerOccupiedHUH_&_years. = "Owner-occupied housing units, Hispanic/Latino, &_years_dash "
			NumOwnerOccupiedHUA_&_years. = "Owner-occupied housing units, Asian and Native Hawaiian and Other Pacific Islander, &_years_dash "
			NumOwnerOccupiedHUIOM_&_years. = "Owner-occupied housing units, American Indian/Alaska Native, Some other race, Two or more races, &_years_dash "
			NumOwnerOccupiedHUAIOM_&_years. = "Owner-occupied housing units, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
	  mNumOccupiedHsgUnits_&_years. = "Occupied housing units, MOE, &_years_dash "
		    mNumOccupiedHsgUnitsB_&_years. = "Occupied housing units, Black/African American, &_years_dash "
			mNumOccupiedHsgUnitsW_&_years. = "Occupied housing units, Non-Hispanic White, &_years_dash "
			mNumOccupiedHsgUnitsH_&_years. = "Occupied housing units, Hispanic/Latino, &_years_dash "
			mNumOccupiedHsgUnitsA_&_years. = "Occupied housing units, Asian and Native Hawaiian and Other Pacific Islander, &_years_dash "
			mNumOccupiedHsgUnitsIOM_&_years. = "Occupied housing units,  American Indian/Alaska Native, Some other race, Two or more races, &_years_dash "
			mNumOccupiedHsgUnitsAIOM_&_years. = "Occupied housing units, All remaining groups other than Black, Non-Hispanic White, Hispanic, &_years_dash "
      mNumOwnerOccupiedHU_&_years. = "Owner-occupied housing units, MOE, &_years_dash "
			mNumOwnerOccupiedHUB_&_years. = "Owner-occupied housing units, Black/African American, MOE, &_years_dash "
			mNumOwnerOccupiedHUW_&_years. = "Owner-occupied housing units, Non-Hispanic White, MOE, &_years_dash "
			mNumOwnerOccupiedHUH_&_years. = "Owner-occupied housing units, Hispanic/Latino, MOE, &_years_dash "
			mNumOwnerOccupiedHUA_&_years. = "Owner-occupied housing units, Asian and Native Hawaiian and Other Pacific Islander, MOE, &_years_dash "
			mNumOwnerOccupiedHUIOM_&_years. = "Owner-occupied housing units, American Indian/Alaska Native, Some other race, Two or more races, MOE, &_years_dash "
			mNumOwnerOccupiedHUAIOM_&_years. = "Owner-occupied housing units, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &_years_dash "
      ;

  run;

  %if &_state_ab = dc %then %do;

    %** For DC, do full set of geographies **;
    
    %DCOLA_ACS_summary_geo( anc2002, &source_geo )
    %DCOLA_ACS_summary_geo( anc2012, &source_geo )
    %DCOLA_ACS_summary_geo( city, &source_geo )
    %DCOLA_ACS_summary_geo( cluster_tr2000, &source_geo )
    %DCOLA_ACS_summary_geo( eor, &source_geo )
    %DCOLA_ACS_summary_geo( psa2004, &source_geo )
    %DCOLA_ACS_summary_geo( psa2012, &source_geo )
    %DCOLA_ACS_summary_geo( geo2000, &source_geo )
    %DCOLA_ACS_summary_geo( geo2010, &source_geo )
    %DCOLA_ACS_summary_geo( voterpre2012, &source_geo )
    %DCOLA_ACS_summary_geo( ward2002, &source_geo )
    %DCOLA_ACS_summary_geo( ward2012, &source_geo )
    %DCOLA_ACS_summary_geo( zip, &source_geo )
	%DCOLA_ACS_summary_geo( cluster2000, &source_geo )


  %end;
  %else %do;
  
    %** For non-DC, only do census tract summary file **;
    
    %if &source_geo = TR10 %then %do;
      %DCOLA_ACS_summary_geo( geo2010, &source_geo )
    %end;
    %else %if &source_geo = TR00 %then %do;
      %DCOLA_ACS_summary_geo( geo2000, &source_geo )
    %end;

  %end;
  
  ** Cleanup temporary data sets **;
  
  proc datasets library=work nolist;
    delete &source_ds_work /memtype=data;
  quit;
  
  %macro_exit:

%mend DCOLA_ACS_summary_geo_source;



