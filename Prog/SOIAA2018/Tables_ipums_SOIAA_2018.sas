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
    
  value yrimmig_a
    1900 -< 1950 = "1900 - 1949"
    1950 -< 1960 = "1950 - 1959"
    1960 -< 1970 = "1960 - 1969"
    1970 -< 1980 = "1970 - 1979"
    1980 -< 1990 = "1980 - 1989"
    1990 -< 2000 = "1990 - 1999"
    2000 -< 2010 = "2000 - 2009"
    2010 - high = "2010 or later";

  value raceth (notsorted)
    1 = 'Black'
    2 = 'White'
    3 = 'Latino'
    4 = 'Asian/Pacific Islander'
    5 = 'Other (Am. Ind., AK Nat., other race)'
    6 = 'Multiple races';
    
  value raced_a (notsorted)
    200 = "Black"
    100 = "White"
    400-699 = "Asian/Pacific Islander"
    other = "Other (Am. Ind., AK Nat., other race)"
    801-990 = "Multiple races";

  value bpld_a (notsorted) 
    00100-12092, 71040-71050, 90000-90022 = 'US & territories'
    21000-21090 = 'Central America'
    50000-59900 = 'Asia'
    40000-49900 = 'Europe'
    60000-60099 = 'Africa'
    30000-30091 = 'South America'
    25000-26095 = 'Caribbean'
    20000       = 'Mexico'
    15000-19900, 29900, 29999 = 'Canada & other North America'

    /*
    71000-71039 = 'Pacific Islands'
    70000-70020 = 'Australia & New Zealand'
    71090, 80000-80050 = 'Other non-US'
    */

    71000-71039, 70000-70020, 71090, 80000-80050 = 'Other non-US'

    95000-99900, . = 'Missing';
    
  value age_a
    0 -< 18 = 'Under 18'
    18 -< 25 = '18 - 24'
    25 -< 35 = '25 - 34'
    35 -< 45 = '35 - 44'
    45 -< 55 = '45 - 54'
    55 -< 65 = '55 - 64'
    65 -< 75 = '65 - 74'
    75 - high = '75 or older';
    
  value empstatd_a (notsorted)
    10, 12 = "At work/has job"
    14, 15 = "In armed forces"
    20 = "Unemployed"
    30 = "Not in labor force"
    0 = "N/A";
        
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
    7000-7630 = "Installation, maintenance, and repair"
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
    0 -< 100 = "Below federal poverty level (poverty rate)"
    100 -< 200 = "Below 200% federal poverty level"
    200 - high = "200% federal poverty level or higher";

  value incwwo
    .n,. = "N/A"
    low-<0, 0<-high = "Yes, has this source of income"
    0 = "No, does not have this source of income";

  value incwage_a
    .,.n = "N/A"
    low-<10000 = "Under $10,000"
    10000-<25000 = "$10,000 - 24,999"
    25000-<50000 = "$25,000 - 49,999"
    50000-<100000 = "$50,000 - 99,999"
    100000-high = "$100,000 or more";
    
  value incbus_a
    .,.n = "N/A"
    low-<0 = "Loss (<$0)"
    0 = "None ($0)"
    0<-<5000 = "Under $5,000"
    5000-<10000 = "$5,000 - 9,999"
    10000-<15000 = "$10,000 - 14,999"
    15000-<25000 = "$15,000 - 24,999"
    25000-<50000 = "$25,000 - 49,999"
    50000-<75000 = "$50,000 - 74,999"
    75000-high = "$75,000 or more";
    
  value trantime_a
    0 = "Worked at home/did not work last week"
    0 <-< 15 = "Under 15 minutes"
    15 -< 30 = "15 - 29 minutes"
    30 -< 60 = "30 - 59 minutes"
    60 -< 90 = "60 - 89 minutes"
    90 - high = "90 minutes or more";
    
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
   12-13="Associate's degree"
   14="Bachelor's degree"
   15="Master's degree"
   16="Professional degree"
   17="Doctorate degree";

  value educ99_b
   01-05="8th grade or less"
   06-09="9th - 12th grade, no diploma"
   10-11="High school graduate, or GED"
   12-13="Associate's degree"
   14="Bachelor's degree"
   15-17="Master's degree or higher";

  value gradeatt_a (notsorted)
    1 = "Nursery school/preschool"
    2 = "Kindergarten"
    3 = "Grade 1 to grade 4"
    4 = "Grade 5 to grade 8"
    5 = "Grade 9 to grade 12"
    6 = "College undergraduate"
    7 = "Graduate or professional school"
    0 = "Not in school";
    
  value youth_disconnect (notsorted)
    1 = "In school"
    2 = "HS diploma, at work, not in school"
    3 = "HS diploma, not at work, not in school"
    4 = "No HS diploma, at work, not in school"
    5 = "No HS diploma, not at work, not in school";
    
  value health_cov (notsorted)
    1 = "No health insurance"
    3 = "Has private health insurance only"
    4 = "Has public health insurance only"
    2 = "Has public and private health insurance";
    
  value newhhtype (notsorted)
    1 = "Single woman-headed family with related children"
    2 = "Single woman-headed household without related children"
    3 = "Single male-headed household with related children"
    4 = "Single male-headed household without related children"
    5 = "Married couple with related children"
    6 = "Married couple without related children"
    7 = "Person living alone"
    8 = " Other nonfamily households";

	value BPLD_f
  00100 = "Alabama"
  00200 = "Alaska"
  00400 = "Arizona"
  00500 = "Arkansas"
  00600 = "California"
  00800 = "Colorado"
  00900 = "Connecticut"
  01000 = "Delaware"
  01100 = "District of Columbia"
  01200 = "Florida"
  01300 = "Georgia"
  01500 = "Hawaii"
  01600 = "Idaho"
  01610 = "Idaho Territory"
  01700 = "Illinois"
  01800 = "Indiana"
  01900 = "Iowa"
  02000 = "Kansas"
  02100 = "Kentucky"
  02200 = "Louisiana"
  02300 = "Maine"
  02400 = "Maryland"
  02500 = "Massachusetts"
  02600 = "Michigan"
  02700 = "Minnesota"
  02800 = "Mississippi"
  02900 = "Missouri"
  03000 = "Montana"
  03100 = "Nebraska"
  03200 = "Nevada"
  03300 = "New Hampshire"
  03400 = "New Jersey"
  03500 = "New Mexico"
  03510 = "New Mexico Territory"
  03600 = "New York"
  03700 = "North Carolina"
  03800 = "North Dakota"
  03900 = "Ohio"
  04000 = "Oklahoma"
  04010 = "Indian Territory"
  04100 = "Oregon"
  04200 = "Pennsylvania"
  04400 = "Rhode Island"
  04500 = "South Carolina"
  04600 = "South Dakota"
  04610 = "Dakota Territory"
  04700 = "Tennessee"
  04800 = "Texas"
  04900 = "Utah"
  04910 = "Utah Territory"
  05000 = "Vermont"
  05100 = "Virginia"
  05300 = "Washington"
  05400 = "West Virginia"
  05500 = "Wisconsin"
  05600 = "Wyoming"
  05610 = "Wyoming Territory"
  09000 = "Native American"
  09900 = "United States, ns"
  10000 = "American Samoa"
  10010 = "Samoa, 1940-1950"
  10500 = "Guam"
  11000 = "Puerto Rico"
  11500 = "U.S. Virgin Islands"
  11510 = "St. Croix"
  11520 = "St. John"
  11530 = "St. Thomas"
  12000 = "Other US Possessions:"
  12010 = "Johnston Atoll"
  12020 = "Midway Islands"
  12030 = "Wake Island"
  12040 = "Other US Caribbean Islands"
  12041 = "Navassa Island"
  12050 = "Other US Pacific Islands"
  12051 = "Baker Island"
  12052 = "Howland Island"
  12053 = "Jarvis Island"
  12054 = "Kingman Reef"
  12055 = "Palmyra Atoll"
  12056 = "Canton and Enderbury Island"
  12090 = "US outlying areas, ns"
  12091 = "US possessions, ns"
  12092 = "US territory, ns"
  15000 = "Canada"
  15010 = "English Canada"
  15011 = "British Columbia"
  15013 = "Alberta"
  15015 = "Saskatchewan"
  15017 = "Northwest"
  15019 = "Ruperts Land"
  15020 = "Manitoba"
  15021 = "Red River"
  15030 = "Ontario/Upper Canada"
  15031 = "Upper Canada"
  15032 = "Canada West"
  15040 = "New Brunswick"
  15050 = "Nova Scotia"
  15051 = "Cape Breton"
  15052 = "Halifax"
  15060 = "Prince Edward Island"
  15070 = "Newfoundland"
  15080 = "French Canada"
  15081 = "Quebec"
  15082 = "Lower Canada"
  15083 = "Canada East"
  15500 = "St. Pierre and Miquelon"
  16000 = "Atlantic Islands"
  16010 = "Bermuda"
  16020 = "Cape Verde"
  16030 = "Falkland Islands"
  16040 = "Greenland"
  16050 = "St. Helena and Ascension"
  16060 = "Canary Islands"
  19900 = "North America, ns"
  20000 = "Mexico"
  21000 = "Central America"
  21010 = "Belize"
  21020 = "Costa Rica"
  21030 = "El Salvador"
  21040 = "Guatemala"
  21050 = "Honduras"
  21060 = "Nicaragua"
  21070 = "Panama"
  21071 = "Canal Zone"
  21090 = "Central America, ns"
  25000 = "Cuba"
  26000 = "West Indies"
  26010 = "Dominican Republic"
  26020 = "Haiti"
  26030 = "Jamaica"
  26040 = "British West Indies"
  26041 = "Anguilla"
  26042 = "Antigua-Barbuda"
  26043 = "Bahamas"
  26044 = "Barbados"
  26045 = "British Virgin Islands"
  26046 = "Anegada"
  26047 = "Cooper"
  26048 = "Jost Van Dyke"
  26049 = "Peter"
  26050 = "Tortola"
  26051 = "Virgin Gorda"
  26052 = "Br. Virgin Islands, ns"
  26053 = "Cayman Islands"
  26054 = "Dominica"
  26055 = "Grenada"
  26056 = "Montserrat"
  26057 = "St. Kitts-Nevis"
  26058 = "St. Lucia"
  26059 = "St. Vincent"
  26060 = "Trinidad and Tobago"
  26061 = "Turks and Caicos"
  26069 = "Br. Virgin Islands, ns"
  26070 = "Other West Indies"
  26071 = "Aruba"
  26072 = "Netherlands Antilles"
  26073 = "Bonaire"
  26074 = "Curacao"
  26075 = "Dutch St. Maarten"
  26076 = "Saba"
  26077 = "St. Eustatius"
  26079 = "Dutch Caribbean, ns"
  26080 = "French St. Maarten"
  26081 = "Guadeloupe"
  26082 = "Martinique"
  26083 = "St. Barthelemy"
  26089 = "French Caribbean, ns"
  26090 = "Antilles, ns"
  26091 = "Caribbean, ns"
  26092 = "Latin America, ns"
  26093 = "Leeward Islands, ns"
  26094 = "West Indies, ns"
  26095 = "Windward Islands, ns"
  29900 = "Americas, ns"
  30000 = "South America"
  30005 = "Argentina"
  30010 = "Bolivia"
  30015 = "Brazil"
  30020 = "Chile"
  30025 = "Colombia"
  30030 = "Ecuador"
  30035 = "French Guiana"
  30040 = "Guyana"
  30045 = "Paraguay"
  30050 = "Peru"
  30055 = "Suriname"
  30060 = "Uruguay"
  30065 = "Venezuela"
  30090 = "South America, ns"
  30091 = "South and Central America, n.s."
  40000 = "Denmark"
  40010 = "Faeroe Islands"
  40100 = "Finland"
  40200 = "Iceland"
  40300 = "Lapland, ns"
  40400 = "Norway"
  40410 = "Svalbard and Jan Meyen"
  40411 = "Svalbard"
  40412 = "Jan Meyen"
  40500 = "Sweden"
  41000 = "England"
  41010 = "Channel Islands"
  41011 = "Guernsey"
  41012 = "Jersey"
  41020 = "Isle of Man"
  41100 = "Scotland"
  41200 = "Wales"
  41300 = "United Kingdom, ns"
  41400 = "Ireland"
  41410 = "Northern Ireland"
  41900 = "Northern Europe, ns"
  42000 = "Belgium"
  42100 = "France"
  42110 = "Alsace-Lorraine"
  42111 = "Alsace"
  42112 = "Lorraine"
  42200 = "Liechtenstein"
  42300 = "Luxembourg"
  42400 = "Monaco"
  42500 = "Netherlands"
  42600 = "Switzerland"
  42900 = "Western Europe, ns"
  43000 = "Albania"
  43100 = "Andorra"
  43200 = "Gibraltar"
  43300 = "Greece"
  43310 = "Dodecanese Islands"
  43320 = "Turkey Greece"
  43330 = "Macedonia"
  43400 = "Italy"
  43500 = "Malta"
  43600 = "Portugal"
  43610 = "Azores"
  43620 = "Madeira Islands"
  43630 = "Cape Verde Islands"
  43640 = "St. Miguel"
  43700 = "San Marino"
  43800 = "Spain"
  43900 = "Vatican City"
  44000 = "Southern Europe, ns"
  45000 = "Austria"
  45010 = "Austria-Hungary"
  45020 = "Austria-Graz"
  45030 = "Austria-Linz"
  45040 = "Austria-Salzburg"
  45050 = "Austria-Tyrol"
  45060 = "Austria-Vienna"
  45070 = "Austria-Kaernsten"
  45080 = "Austria-Neustadt"
  45100 = "Bulgaria"
  45200 = "Czechoslovakia"
  45210 = "Bohemia"
  45211 = "Bohemia-Moravia"
  45212 = "Slovakia"
  45213 = "Czech Republic"
  45300 = "Germany"
  45301 = "Berlin"
  45302 = "West Berlin"
  45303 = "East Berlin"
  45310 = "West Germany"
  45311 = "Baden"
  45312 = "Bavaria"
  45313 = "Braunschweig"
  45314 = "Bremen"
  45315 = "Hamburg"
  45316 = "Hanover"
  45317 = "Hessen"
  45318 = "Hesse-Nassau"
  45319 = "Lippe"
  45320 = "Lubeck"
  45321 = "Oldenburg"
  45322 = "Rheinland"
  45323 = "Schaumburg-Lippe"
  45324 = "Schleswig"
  45325 = "Sigmaringen"
  45326 = "Schwarzburg"
  45327 = "Westphalia"
  45328 = "Wurttemberg"
  45329 = "Waldeck"
  45330 = "Wittenberg"
  45331 = "Frankfurt"
  45332 = "Saarland"
  45333 = "Nordrhein-Westfalen"
  45340 = "East Germany"
  45341 = "Anhalt"
  45342 = "Brandenburg"
  45344 = "Kingdom of Saxony"
  45345 = "Mecklenburg"
  45346 = "Saxony"
  45347 = "Thuringian States"
  45348 = "Sachsen-Meiningen"
  45349 = "Sachsen-Weimar-Eisenach"
  45350 = "Probable Saxony"
  45351 = "Schwerin"
  45352 = "Strelitz"
  45353 = "Probably Thuringian States"
  45360 = "Prussia, nec"
  45361 = "Hohenzollern"
  45362 = "Niedersachsen"
  45400 = "Hungary"
  45500 = "Poland"
  45510 = "Austrian Poland"
  45511 = "Galicia"
  45520 = "German Poland"
  45521 = "East Prussia"
  45522 = "Pomerania"
  45523 = "Posen"
  45524 = "Prussian Poland"
  45525 = "Silesia"
  45526 = "West Prussia"
  45530 = "Russian Poland"
  45600 = "Romania"
  45610 = "Transylvania"
  45700 = "Yugoslavia"
  45710 = "Croatia"
  45720 = "Montenegro"
  45730 = "Serbia"
  45740 = "Bosnia"
  45750 = "Dalmatia"
  45760 = "Slovonia"
  45770 = "Carniola"
  45780 = "Slovenia"
  45790 = "Kosovo"
  45800 = "Central Europe, ns"
  45900 = "Eastern Europe, ns"
  46000 = "Estonia"
  46100 = "Latvia"
  46200 = "Lithuania"
  46300 = "Baltic States, ns"
  46500 = "Other USSR/Russia"
  46510 = "Byelorussia"
  46520 = "Moldavia"
  46521 = "Bessarabia"
  46530 = "Ukraine"
  46540 = "Armenia"
  46541 = "Azerbaijan"
  46542 = "Republic of Georgia"
  46543 = "Kazakhstan"
  46544 = "Kirghizia"
  46545 = "Tadzhik"
  46546 = "Turkmenistan"
  46547 = "Uzbekistan"
  46548 = "Siberia"
  46590 = "USSR, ns"
  49900 = "Europe, ns."
  50000 = "China"
  50010 = "Hong Kong"
  50020 = "Macau"
  50030 = "Mongolia"
  50040 = "Taiwan"
  50100 = "Japan"
  50200 = "Korea"
  50210 = "North Korea"
  50220 = "South Korea"
  50900 = "East Asia, ns"
  51000 = "Brunei"
  51100 = "Cambodia (Kampuchea)"
  51200 = "Indonesia"
  51210 = "East Indies"
  51220 = "East Timor"
  51300 = "Laos"
  51400 = "Malaysia"
  51500 = "Philippines"
  51600 = "Singapore"
  51700 = "Thailand"
  51800 = "Vietnam"
  51900 = "Southeast Asia, ns"
  51910 = "Indochina, ns"
  52000 = "Afghanistan"
  52100 = "India"
  52110 = "Bangladesh"
  52120 = "Bhutan"
  52130 = "Burma (Myanmar)"
  52140 = "Pakistan"
  52150 = "Sri Lanka (Ceylon)"
  52200 = "Iran"
  52300 = "Maldives"
  52400 = "Nepal"
  53000 = "Bahrain"
  53100 = "Cyprus"
  53200 = "Iraq"
  53210 = "Mesopotamia"
  53300 = "Iraq/Saudi Arabia"
  53400 = "Israel/Palestine"
  53410 = "Gaza Strip"
  53420 = "Palestine"
  53430 = "West Bank"
  53440 = "Israel"
  53500 = "Jordan"
  53600 = "Kuwait"
  53700 = "Lebanon"
  53800 = "Oman"
  53900 = "Qatar"
  54000 = "Saudi Arabia"
  54100 = "Syria"
  54200 = "Turkey"
  54210 = "European Turkey"
  54220 = "Asian Turkey"
  54300 = "United Arab Emirates"
  54400 = "Yemen Arab Republic (North)"
  54500 = "Yemen, PDR (South)"
  54600 = "Persian Gulf States, ns"
  54700 = "Middle East, ns"
  54800 = "Southwest Asia, nec/ns"
  54900 = "Asia Minor, ns"
  55000 = "South Asia, nec"
  59900 = "Asia, nec/ns"
  60000 = "Africa"
  60010 = "Northern Africa"
  60011 = "Algeria"
  60012 = "Egypt"
  60013 = "Libya"
  60014 = "Morocco"
  60015 = "Sudan"
  60016 = "Tunisia"
  60017 = "Western Sahara"
  60019 = "North Africa, ns"
  60020 = "Benin"
  60021 = "Burkina Faso"
  60022 = "Gambia"
  60023 = "Ghana"
  60024 = "Guinea"
  60025 = "Guinea-Bissau"
  60026 = "Ivory Coast"
  60027 = "Liberia"
  60028 = "Mali"
  60029 = "Mauritania"
  60030 = "Niger"
  60031 = "Nigeria"
  60032 = "Senegal"
  60033 = "Sierra Leone"
  60034 = "Togo"
  60038 = "Western Africa, ns"
  60039 = "French West Africa, ns"
  60040 = "British Indian Ocean Territory"
  60041 = "Burundi"
  60042 = "Comoros"
  60043 = "Djibouti"
  60044 = "Ethiopia"
  60045 = "Kenya"
  60046 = "Madagascar"
  60047 = "Malawi"
  60048 = "Mauritius"
  60049 = "Mozambique"
  60050 = "Reunion"
  60051 = "Rwanda"
  60052 = "Seychelles"
  60053 = "Somalia"
  60054 = "Tanzania"
  60055 = "Uganda"
  60056 = "Zambia"
  60057 = "Zimbabwe"
  60058 = "Bassas de India"
  60059 = "Europa"
  60060 = "Gloriosos"
  60061 = "Juan de Nova"
  60062 = "Mayotte"
  60063 = "Tromelin"
  60064 = "Eastern Africa, nec/ns"
  60065 = "Eritrea"
  60070 = "Central Africa"
  60071 = "Angola"
  60072 = "Cameroon"
  60073 = "Central African Republic"
  60074 = "Chad"
  60075 = "Congo"
  60076 = "Equatorial Guinea"
  60077 = "Gabon"
  60078 = "Sao Tome and Principe"
  60079 = "Zaire"
  60080 = "Central Africa, ns"
  60081 = "Equatorial Africa, ns"
  60082 = "French Equatorial Africa, ns"
  60090 = "Southern Africa"
  60091 = "Botswana"
  60092 = "Lesotho"
  60093 = "Namibia"
  60094 = "South Africa (Union of)"
  60095 = "Swaziland"
  60096 = "Southern Africa, ns"
  60099 = "Africa, ns/nec"
  70000 = "Australia and New Zealand"
  70010 = "Australia"
  70011 = "Ashmore and Cartier Islands"
  70012 = "Coral Sea Islands Territory"
  70013 = "Christmas Island"
  70014 = "Cocos Islands"
  70020 = "New Zealand"
  71000 = "Pacific Islands"
  71010 = "New Caledonia"
  71012 = "Papua New Guinea"
  71013 = "Solomon Islands"
  71014 = "Vanuatu (New Hebrides)"
  71015 = "Fiji"
  71016 = "Melanesia, ns"
  71017 = "Norfolk Islands"
  71018 = "Niue"
  71020 = "Cook Islands"
  71022 = "French Polynesia"
  71023 = "Tonga"
  71024 = "Wallis and Futuna Islands"
  71025 = "Western Samoa"
  71026 = "Pitcairn Island"
  71027 = "Tokelau"
  71028 = "Tuvalu"
  71029 = "Polynesia, ns"
  71032 = "Kiribati"
  71033 = "Canton and Enderbury"
  71034 = "Nauru"
  71039 = "Micronesia, ns"
  71040 = "US Pacific Trust Territories"
  71041 = "Marshall Islands"
  71042 = "Micronesia"
  71043 = "Kosrae"
  71044 = "Pohnpei"
  71045 = "Truk"
  71046 = "Yap"
  71047 = "Northern Mariana Islands"
  71048 = "Palau"
  71049 = "Pacific Trust Terr, ns"
  71050 = "Clipperton Island"
  71090 = "Oceania, ns/nec"
  80000 = "Antarctica, ns/nec"
  80010 = "Bouvet Islands"
  80020 = "British Antarctic Terr."
  80030 = "Dronning Maud Land"
  80040 = "French Southern and Antarctic Lands"
  80050 = "Heard and McDonald Islands"
  90000 = "Abroad (unknown) or at sea"
  90010 = "Abroad, ns"
  90011 = "Abroad (US citizen)"
  90020 = "At sea"
  90021 = "At sea (US citizen)"
  90022 = "At sea or abroad (U.S. citizen)"
  95000 = "Other n.e.c."
  99900 = "Missing/blank";
    
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


%fdate()

**options orientation=landscape;
options nodate nonumber;
options missing='-';

/** Macro All_tables - Start Definition **/

%macro All_tables( poppre=, lblpre=, geo= );

  %local pop1gen pop2gen geoselect geolbl;
  
  %let poppre = %lowcase( &poppre );
  %let geo = %lowcase( &geo );

  %if &poppre = aframerican or &poppre = total %then %do;
    %let pop1gen = &poppre;
    %let pop2gen = 0;
  %end;
  %else %do;
    %let pop1gen = &poppre._1gen;
    %let pop2gen = &poppre._2gen;
  %end;
  
  %if &geo = dc %then %do;
    %let geoselect = (statefip = 11);
    %let geolbl = District of Columbia;
  %end;
  %else %if &geo = suburbs %then %do;
    %let geoselect = (statefip ~= 11);
    %let geolbl = Washington metro area excluding DC;
  %end;
  %else %do;
    %let geoselect = 1;
    %let geolbl = Washington metro area (including DC);
  %end;
  
  ** Create table data subset **;
  
  data Tables;
  
    set DCOLA.Ipums_SOIAA_2018;
    
    where &geoselect;
    
  run;

  ods listing close;

  ods rtf file="&_dcdata_default_path\DCOLA\Prog\SOIAA2018\Tables_ipums_SOIAA_2018_&poppre._&geo..rtf" style=Styles.Rtf_arial_9pt
      /*bodytitle*/;
      
  title1 "State of Immigrants Report, 2018";
  title2 "&lblpre, &geolbl";
  title3 " ";

  footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

  %if &poppre = immigrant %then %do;

    title4 "\i Immmigrant population overview";
    
    proc tabulate data=Tables format=comma12.0 noseps missing;
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
      format year yeartbl.;
    run;

    proc tabulate data=Tables format=comma12.0 noseps missing;
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
      format year yeartbl.;
    run;
    
  %end;


  title4 "\i Demographics";

  %if &poppre ~= aframerican and &poppre ~= total %then %do;
  
    %if &poppre = immigrant %then %do;

      %table( pop=&pop1gen, poplbl="\b &lblpre", by=bpld, byfmt=bpld_a., bylbl="\i % Country of origin" )
      
    %end;
    %else %do;
    
      %table( order=freq, pop=&pop1gen, poplbl="\b &lblpre", by=bpld, byfmt=bpld_f., bylbl="\i % Country of origin" )
      
    %end;

    %table( pop=&pop1gen, poplbl="\b &lblpre", by=citizen, byfmt=citizenf., bylbl="\i % Citizenship status" )

    %table( pop=&pop1gen, poplbl="\b &lblpre", by=yrimmig, byfmt=yrimmig_a., bylbl="\i % Year immigrated to US" )

    %table( pop=&pop1gen, poplbl="\b &lblpre", by=yrsusa2, byfmt=yrsusa2_f., bylbl="\i % Years in US" )

    %table( pop=&pop1gen, poplbl="\b &lblpre", by=raced, byfmt=raced_a., bylbl="\i % Race (self-identified)" )

    %table( pop=&pop1gen, poplbl="\b &lblpre", by=raceth, byfmt=raceth., bylbl="\i % Race/ethnicity (self-identified)" )
    
  %end;

  %table( pop=&pop1gen, poplbl="\b &lblpre", by=age, byfmt=age_a., bylbl="\i % Age" )

  %table( pop=&pop1gen, poplbl="\b &lblpre", by=age, byfmt=age_a., bylbl="\i Persons by age", rowstat=sum=' ' * f=comma12.0 )

  %table( pop=&pop2gen, poplbl="\b &lblpre (2nd gen)", by=age, byfmt=age_a., bylbl="\i % Age" )

  %table( pop=&pop1gen and sex=2, poplbl="\b &lblpre, female", by=age, byfmt=age_a., bylbl="\i % Age" )

  %table( pop=&pop1gen and sex=1, poplbl="\b &lblpre, male", by=age, byfmt=age_a., bylbl="\i % Age" )

  %table( pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=newhhtype, byfmt=newhhtype., bylbl="\i % Household type" )


  title4 "\i Jobs and economic opportunity";

  %table( pop=&pop1gen, poplbl="\b &lblpre", by=poverty, byfmt=poverty_a., bylbl="\i % Poverty status" )

  %table( pop=&pop1gen and 16 <= age and empstatd in ( 10, 12, 20, 30 ), poplbl="\b &lblpre, civilians 16+ years old", by=empstatd, byfmt=empstatd_a., bylbl="\i % Labor force status" )

  %table( pop=&pop1gen and age >= 16 and empstatd in ( 10, 12, 20 ), poplbl="\b &lblpre, civilians 16+ years old in labor force", by=empstatd, byfmt=empstatd_a., bylbl="\i % Employment status (unemployment rate)" )

  %table( year1=., order=freq, pop=&pop1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="\b &lblpre, civilian workers 16+ years old", by=occ, byfmt=occ_a., bylbl="\i % Occupation" )

  %table( pop=&pop1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="\b &lblpre, civilian workers 16+ years old", by=trantime, byfmt=trantime_a., bylbl="\i % Travel time to work" )

  %table( pop=&pop1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="\b &lblpre, civilian workers 16+ years old", by=tranwork, byfmt=tranwork_f., bylbl="\i % Means of travel to work" )

  %table( pop=&pop1gen and age >= 16 and empstatd in ( 10, 12 ), poplbl="\b &lblpre, civilian workers 16+ years old", by=incwage_2016, byfmt=incwage_a., bylbl="\i % Annual earnings/wages ($ 2016)" )

  %table( pop=&pop1gen and age >= 16, poplbl="\b &lblpre, 16+ years old", by=incbus00_2016, byfmt=incwwo., bylbl="\i % With business income" )

  %table( pop=&pop1gen and age >= 16 and incbus00_2016 ~= 0, poplbl="\b &lblpre, 16+ years old with business income", by=incbus00_2016, byfmt=incbus_a., bylbl="\i % Annual business income ($ 2016)" )

  %table( pop=&pop1gen and age >= 16, poplbl="\b &lblpre, 16+ years old", by=incinvst_2016, byfmt=incwwo., bylbl="\i % With investment income" )

  %table( pop=&pop1gen and age >= 16 and incinvst_2016 ~= 0, poplbl="\b &lblpre, 16+ years old with investment income", by=incinvst_2016, byfmt=incbus_a., bylbl="\i % Annual investment income ($ 2016)" )

  %table( pop=&pop1gen and age >= 65, poplbl="\b &lblpre, 65+ years old", by=incretir_2016, byfmt=incwwo., bylbl="\i % With retirement income, excluding Social Security" )

  %table( pop=&pop1gen and age >= 65, poplbl="\b &lblpre, 65+ years old", by=incss_2016, byfmt=incwwo., bylbl="\i % With Social Security income" )

  %table( pop=&pop1gen and age >= 65, poplbl="\b &lblpre, 65+ years old", by=incretirss_2016, byfmt=incwwo., bylbl="\i % With retirement income, including Social Security" )

  %table( pop=&pop1gen and age >= 65 and incretir_2016 ~= 0, poplbl="\b &lblpre, 65+ years old with retirement income, excluding Social Security", by=incretir_2016, byfmt=incwage_a., bylbl="\i % Annual retirement income w/o SS ($ 2016)" )

  %table( pop=&pop1gen and age >= 65 and incss_2016 ~= 0, poplbl="\b &lblpre, 65+ years old with Social Security income", by=incss_2016, byfmt=incwage_a., bylbl="\i % Annual Social Security income ($ 2016)" )

  %table( pop=&pop1gen and age >= 65 and incretirss_2016 ~= 0, poplbl="\b &lblpre, 65+ years old with retirement income, including Social Security", by=incretirss_2016, byfmt=incwage_a., bylbl="\i % Annual retirement income with SS ($ 2016)" )


  title4 "\i Housing";

  %table( pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=numprec, byfmt=numprec_a., bylbl="\i % Household size (persons)" )

  %table( pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=ownershpd, byfmt=ownershpd_f., bylbl="\i % Ownership of dwelling" )

  %table( pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=ownershpd, byfmt=ownershpd_a., bylbl="\i % Ownership of dwelling" )

  %table( pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=hhincome_2016, byfmt=incwage_a., bylbl="\i % Household income ($ 2016)" )

  %table( pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=hud_inc, byfmt=hudinc., bylbl="\i % HUD income level" )

  %table( pop=&pop1gen and not( missing( Rent_burden ) ), poplbl="\b &lblpre, renters with cash rent", by=Rent_burden, byfmt=Rent_burden., bylbl="\i % Income spent on rent" )
  
  
  title4 "\i Health and human services";
  
  %table( pop=&pop1gen and age >= 15, poplbl="\b &lblpre, 15+ years old", by=incwelfr_2016, byfmt=incwwo., bylbl="\i % With welfare benefits income" )

  %table( pop=&pop1gen and age >= 15 and incwelfr_2016 ~= 0, poplbl="\b &lblpre, 15+ years old with welfare benefits income", by=incwelfr_2016, byfmt=incbus_a., bylbl="\i % Annual welfare benefits income ($ 2016)" )

  %table( year1=., pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=foodstmp, byfmt=foodstmp_f., bylbl="\i % With SNAP (food stamp) benefits" )

  %table( year1=., pop=&pop1gen, poplbl="\b &lblpre", by=health_cov, byfmt=health_cov., bylbl="\i % With health insurance coverage" )

  %table( year1=., pop=&pop2gen, poplbl="\b &lblpre (2nd gen)", by=health_cov, byfmt=health_cov., bylbl="\i % With health insurance coverage" )


  %if &poppre ~= aframerican and &poppre ~= total %then %do;

    title4 "\i Language";

    %table( year2=2015, pop=&pop1gen and age >= 5, poplbl="\b &lblpre, 5+ years old", by=languaged, byfmt=languaged_a., bylbl="\i % Language spoken (condensed)" )
    
    %if &poppre ~= immigrant %then %do;

      %table( order=freq, year2=2015, pop=&pop1gen and age >= 5, poplbl="\b &lblpre, 5+ years old", by=languaged, byfmt=languaged_f., bylbl="\i % Language spoken (detailed)" )
    
    %end;

    %table( year2=2015, pop=&pop1gen and age >= 5, poplbl="\b &lblpre, 5+ years old", by=speakeng, byfmt=speakeng_f., bylbl="\i % English proficiency" )

    %table( year2=2015, pop=&pop1gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre, not living in group quarters", by=lingisol, byfmt=lingisol_f., bylbl="\i % Living in linguistically isolated household" )
    
    %table( year2=2015, pop=&pop2gen and age >= 5, poplbl="\b &lblpre (2nd gen), 5+ years old", by=languaged, byfmt=languaged_a., bylbl="\i % Language spoken (condensed)" )

    %if &poppre ~= immigrant %then %do;

      %table( order=freq, year2=2015, pop=&pop2gen and age >= 5, poplbl="\b &lblpre (2nd gen), 5+ years old", by=languaged, byfmt=languaged_f., bylbl="\i % Language spoken (detailed)" )
    
    %end;

    %table( year2=2015, pop=&pop2gen and age >= 5, poplbl="\b &lblpre (2nd gen), 5+ years old", by=speakeng, byfmt=speakeng_f., bylbl="\i % English proficiency" )

    %table( year2=2015, pop=&pop2gen and gq in ( 1, 2, 5 ), poplbl="\b &lblpre (2nd gen), not living in group quarters", by=lingisol, byfmt=lingisol_f., bylbl="\i % Living in linguistically isolated household" )
    
  %end;


  title4 "\i Education";

  %table( pop=&pop1gen and age >= 18, poplbl="\b &lblpre, 18+ years old", by=educ99, byfmt=educ99_b., bylbl="\i % Highest level of education" )

  %table( pop=&pop1gen and 3 <= age < 18 and educ99 < 10, poplbl="\b &lblpre, 3-17 years old not HS graduate", by=gradeatt, byfmt=gradeatt_a., bylbl="\i % School attendance" )

  %table( pop=&pop1gen and 3 <= age < 18 and educ99 < 10 and gradeatt = 0, poplbl="\b &lblpre, 3-17 years old not HS graduate and not in school", by=age, byfmt=age_f., bylbl="\i % Age" )

  %table( pop=&pop2gen and 3 <= age < 18 and educ99 < 10, poplbl="\b &lblpre (2nd gen), 3-17 years old not HS graduate", by=gradeatt, byfmt=gradeatt_a., bylbl="\i % School attendance" )

  %table( pop=&pop2gen and 3 <= age < 18 and educ99 < 10 and gradeatt = 0, poplbl="\b &lblpre (2nd gen), 3-17 years old not HS graduate and not in school", by=age, byfmt=age_f., bylbl="\i % Age" )

  %table( pop=&pop1gen and 16 <= age <= 24, poplbl="\b &lblpre, 16-24 years old", by=youth_disconnect, byfmt=youth_disconnect., bylbl="\i % Youth disconnection" )

  %table( pop=&pop2gen and 16 <= age <= 24, poplbl="\b &lblpre (2nd gen), 16-24 years old", by=youth_disconnect, byfmt=youth_disconnect., bylbl="\i % Youth disconnection" )


  ods rtf close;
  ods listing;

  title1;
  footnote1;
  
  proc datasets library=work nolist;
    delete Tables /memtype=data;
  quit;

%mend All_tables;

/** End Macro Definition **/


%All_tables( poppre=immigrant, lblpre=Immigrants, geo=dc )

%All_tables( poppre=immigrant, lblpre=Immigrants, geo=suburbs )

%All_tables( poppre=latino, lblpre=Latinos, geo=dc )

%All_tables( poppre=asianpi, lblpre=Asians/Pacific Islanders, geo=dc )

%All_tables( poppre=african, lblpre=Africans, geo=dc )

%All_tables( poppre=aframerican, lblpre=African Americans, geo=dc )

%All_tables( poppre=total, lblpre=Total population, geo=dc )

