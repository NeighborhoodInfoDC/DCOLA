/*******************************************
* Program: OCCUP_NEW_ALL_0507_DETAIL.sas
* Library: DCOLA
* Project: Latino Databook
* Author: Lesley Freiman
* Created: 08/27/2009
* Modified: 
* Version: SAS 9.1
* Environment: Windows with SAS/Connect
* Description: 
* Modifications:
********************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


*/ Defines libraries /*;
%DCData_lib( DCOLA );
%DCData_lib( General );
%DCData_lib( IPUMS );

rsubmit;

proc format;
value OCC_BIG
	1-43		= 'Management Occupations'
	50-73	 	= 'Business Operations Specialists'
	80-95		= 'Financial Specialists'
	100-124	= 'Computer and Mathematical Occupations'
	130-156	= 'Archiectural and Engineering Occupations'
	160-196	= 'Life, Physical and Social Science Occupations'
	200-206	= 'Community and Social Services Occupations'
	210-215	= 'Legal Occupations'
	220-255	= 'Education, Training, and Library Occupations'
	260-296	= 'Arts, Design, Entertainment, Sports, and Media Occupations'
	300-354	= 'Healthcare Practitioners and Technical Occupations'
	360-365	= 'Healthcare Support Occupations'
	370-395	= 'Protective Service Occupations'
	400-416	= 'Chefs and Head Cooks'
	420-425	= 'Building and Grounds Cleaning and Maintenance Occupations'
	430-465	= 'Personal Care and Service Occupations'
	470-496	= 'Sales Occupations'
	500-593	= 'Office and Administrative Support Occupations'
	600-613	= 'Farming, Fishing, and Forestry Occupations'
	620-676	= 'Construction Trades'
	680-694	= 'Extraction Workers'
	700-762	= 'Installation, Maintenance, and Repair Workers'
	770-896	= 'Production Occupations'
	900-975	= 'Transportation and Material Moving Occupations'
	980-983	= 'Military Specific Occupations'
	992			= 'Unemployed, last worked 5 years ago or earlier or never worked'
	0			= 'N/A (less than 16 years old/unemployed who never worked/NILF who last worked more than 5 years ago)';
run;
proc format;
value OCC_LTTL
0	=	"N/A (less than 16 years old/unemployed who never worked/NILF who last worked more than 5 years ago)	"
1	=	"Chief executives and legislators	"
2	=	"General and Operations Managers	"
4	=	"Advertising and Promotions Managers	"
5	=	"Marketing and Sales Managers	"
6	=	"Public Relations Managers	"
10	=	"Administrative Services Managers	"
11	=	"Computer and Information Systems Managers	"
12	=	"Financial Managers	"
13	=	"Human Resources Managers	"
14	=	"Industrial Production Managers	"
15	=	"Purchasing Managers	"
16	=	"Transportation, Storage, and Distribution Managers	"
20	=	"Farm, Ranch, and Other Agricultural Managers	"
21	=	"Farmers and Ranchers	"
22	=	"Constructions Managers	"
23	=	"Education Administrators	"
30	=	"Engineering Managers	"
31	=	"Food Service Managers	"
32	=	"Funeral Directors	"
33	=	"Gaming Managers	"
34	=	"Lodging Managers	"
35	=	"Medical and Health Services Managers	"
36	=	"Natural Science Managers	"
41	=	"Property, Real Estate, and Community Association Managers	"
42	=	"Social and Community Service Managers	"
43	=	"Miscellaneous managers including postmansters and mail superintendents	"
50	=	"Agents and Business Managers of Artists, Performers, and Athletes	"
51	=	"Purchasing Agents and Buyers, Farm Products	"
52	=	"Wholesale and Retail Buyers, Except Farm Products	"
53	=	"Purchasing Agents, Except Wholesale, Retail, and Farm Products	"
54	=	"Claims Adjusters, Appraisers, Examiners, and Investigators	"
56	=	"Compliance Officers, Except Agriculture, Construction, Health and SAfety, and Transportation	"
60	=	"Cost Estimators	"
62	=	"Human Resources, Training, and Labor Relations Specialists	"
70	=	"Logisticians	"
71	=	"Management Analysts	"
72	=	"Meeting and Convention Planners	"
73	=	"Other Business Operations Specialists	"
80	=	"Accountants and Auditors	"
81	=	"Appraisers and Assessors of Real Estate	"
82	=	"Budget Analysts	"
83	=	"Credit Analysts	"
84	=	"Financial Analysts	"
85	=	"Personal Financial Advisors	"
86	=	"Insurance Underwriters	"
90	=	"Financial Examiners	"
91	=	"Loan Counselors and Officers	"
93	=	"Tax Examiners, Collectors, and Revenue Agents	"
94	=	"Tax Preparers	"
95	=	"Financial Specialists, All Other	"
100	=	"Computer Scientists and Systems Analysts	"
101	=	"Computer Programmers	"
102	=	"Computer Software Engineers	"
104	=	"Computer Support Specialists	"
106	=	"Database Administrators	"
110	=	"Network and Computer Systems Administrators	"
111	=	"Network Systems and Data Communications Analysts	"
120	=	"Actuaries	"
122	=	"Operations Research Analysts	"
124	=	"Miscellaneous mathematical science occupations, including mathematicians and statisticians	"
130	=	"Architects, Except Naval	"
131	=	"Surveyors, Cartographers, and Photogrammetrists	"
132	=	"Aerospace Engineers	"
134	=	"Biomedical and agricultural engineers	"
135	=	"Chemical Engineers	"
136	=	"Civil Engineers	"
140	=	"Computer Hardware Engineers	"
141	=	"Electrical and Electronics Engineers	"
142	=	"Environmental Engineers	"
143	=	"Industrial Engineers, including Health and Safety	"
144	=	"Marine Engineers and Naval Architects	"
145	=	"Materials Engineers	"
146	=	"Mechanical Engineers	"
152	=	"Petroleum, mining and geological engineers, including mining safety engineers	"
153	=	"Miscellaneous engineeers including nuclear engineers	"
154	=	"Drafters	"
155	=	"Engineering Technicians, Except Drafters	"
156	=	"Surveying and Mapping Technicians	"
160	=	"Agricultural and Food Scientists	"
161	=	"Biological Scientists	"
164	=	"Conservation Scientists and Foresters	"
165	=	"Medical Scientists	"
170	=	"Astronomers and Physicists	"
171	=	"Atmospheric and Space Scientists	"
172	=	"Chemists and Materials Scientists	"
174	=	"Environmental Scientists and Geoscientists	"
176	=	"Physical Scientists, All Other	"
180	=	"Economists	"
181	=	"Market and Survey Researchers	"
182	=	"Psychologists	"
184	=	"Urban and Regional Planners	"
186	=	"Miscellaneous social scientists including sociologists	"
190	=	"Agricultural and Food Science Technicians	"
191	=	"Biological Technicians	"
192	=	"Chemical Technicians	"
193	=	"Geological and Petroleum Technicians	"
196	=	"Miscellaneous life, physical, and social science technicians, including social science research assistants and nuclear technicians	"
200	=	"Counselors	"
201	=	"Social Workers	"
202	=	"Miscellaneous Community and Social Service Specialists	"
204	=	"Clergy	"
205	=	"Directors, Religious Activities and Education	"
206	=	"Religious Workers, All Other	"
210	=	"Lawyers, and judges, magistrates, and other judicial workers	"
214	=	"Paralegals and Legal Assistants	"
215	=	"Miscellaneous Legal Support Workers	"
220	=	"Postsecondary Teachers	"
230	=	"Preschool and Kindergarten Teachers	"
231	=	"Elementary and Middle School Teachers	"
232	=	"Secondary School Teachers	"
233	=	"Special Education Teachers	"
234	=	"Other Teachers and Instructors	"
240	=	"Archivists, Curators, and Museum Technicians	"
243	=	"Librarians	"
244	=	"Library Technicians	"
254	=	"Teacher Assistants	"
255	=	"Other Education, Training, and Library Workers	"
260	=	"Artists and Related Workers	"
263	=	"Designers	"
270	=	"Actors	"
271	=	"Producers and Directors	"
272	=	"Athletes, Coaches, Umpires, and Related Workers	"
274	=	"Dancers and Choreographers	"
275	=	"Musicians, Singers, and Related Workers	"
276	=	"Entertainers and Performers, Sports and Related Workers, All Other	"
280	=	"Announcers	"
281	=	"News Analysts, Reporters and Correspondents	"
282	=	"Public Relations Specialists	"
283	=	"Editors	"
284	=	"Technical Writers	"
285	=	"Writers and Authors	"
286	=	"Miscellaneous Media and Communication Workers	"
290	=	"Broadcast and Sound Engineering Technicians and Radio Operators, and media and communication equipment workers, all other	"
291	=	"Photographers	"
292	=	"Television, Video, and Motion Picture Camera Operators and Editors	"
300	=	"Chiropractors	"
301	=	"Dentists	"
303	=	"Dieticians and Nutritionists	"
304	=	"Optometrists	"
305	=	"Pharmacists	"
306	=	"Physicians and Surgeons	"
311	=	"Physician Assistants	"
312	=	"Podiatrists	"
313	=	"Registered Nurses	"
314	=	"Audiologists	"
315	=	"Occupational Therapists	"
316	=	"Physical Therapists	"
320	=	"Radiation Therapists	"
321	=	"Recreational Therapists	"
322	=	"Respiratory Therapists	"
323	=	"SpeechLanguage Pathologists	"
324	=	"Therapists, All Other	"
325	=	"Veterinarians	"
326	=	"Health Diagnosing and Treating Practitioners, All Other	"
330	=	"Clinical Laboratory Technologists and Technicians	"
331	=	"Dental Hygienists	"
332	=	"Diagnostic Related Technologists and Technicians	"
340	=	"Emergency Medical Technicians and Paramedics	"
341	=	"Health Diagnosing and Treating Practitioner Support Technicians	"
350	=	"Licensed Practical and Licensed Vocational Nurses	"
351	=	"Medical Records and Health Information Technicians	"
352	=	"Opticians, Dispensing	"
353	=	"Miscellaneous Health Technologists and Technicians	"
354	=	"Other Healthcare Practitioners and Technical Occupations	"
360	=	"Nursing, Psychiatric, and Home Health Aides	"
361	=	"Occupational Therapist Assistants and Aides	"
362	=	"Physical Therapist Assistants and Aides	"
363	=	"Massage Therapists	"
364	=	"Dental Assistants	"
365	=	"Medical Assistants and Other Healthcare Support Occupations, except dental assistants	"
370	=	"First-Line Supervisors/Managers of Correctional Officers	"
371	=	"First-Line Supervisors/Managers of Police and Detectives	"
372	=	"First-Line Supervisors/Managers of Fire Fighting and Prevention Workers	"
373	=	"Supervisors, Protective Service Workers, All Other	"
374	=	"Fire Fighters	"
375	=	"Fire Inspectors	"
380	=	"Bailiffs, Correctional Officers, and Jailers	"
382	=	"Detectives and Criminal Investigators	"
384	=	"Miscellaneous law enforcement workers	"
385	=	"Police Officers	"
390,395	=	"Miscellaneous protective service workers, except crossing guards, and including animal control workers"
391	=	"Private Detectives and Investigators	"
392	=	"Security Guards and Gaming Surveillance Officers	"
394	=	"Crossing Guards	"
400	=	"Chefs and Head Cooks	"
401	=	"First-Line Supervisors/Managers of Food Preparation and Serving Workers	"
402	=	"Cooks	"
403	=	"Food Preparation Workers	"
404	=	"Bartenders	"
405	=	"Combined Food Preparation and Serving Workers, Including Fast Food	"
406	=	"Counter Attendant, Cafeteria, Food Concession, and Coffee Shop	"
411	=	"Waiters and Waitresses	"
412	=	"Food Servers, Nonrestaurant	"
413	=	"Miscellaneous food preparation and serving related workers including dining room and cafeteria attendants and bartender helpers	"
414	=	"Dishwashers	"
415	=	"Host and Hostess, Restaurant, Lounge, and Coffee Shop	"
420	=	"First-Line Supervisors/Managers of Housekeeping and Janitorial Workers	"
421	=	"First-Line Supervisors/Managers of Landscaping, Lawn Service, and Groundskeeping Workers	"
422	=	"Janitors and Building Cleaners	"
423	=	"Maids and Housekeeping Cleaners	"
424	=	"Pest Control Workers	"
425	=	"Grounds Maintenance Workers	"
430	=	"First-Line Supervisors/Managers of Gaming Workers	"
432	=	"First-Line Supervisors/Managers of Personal Service Workers	"
434	=	"Animal Trainers	"
435	=	"Nonfarm Animal Caretakers	"
440	=	"Gaming Services Workers	"
441	=	"Motion Picture Projectionists	"
442	=	"Ushers, Lobby Attendants, and Ticket Takers	"
443	=	"Miscellaneous Entertainment Attendants and Related Workers	"
446	=	"Funeral Service Workers	"
450	=	"Barbers	"
451	=	"Hairdressers, Hairstylists, and Cosmetologists	"
452	=	"Miscellaneous Personal Appearance Workers	"
453	=	"Baggage Porters, Bellhops, and Concierges	"
454	=	"Tour and Travel Guides	"
455	=	"Transportation Attendants	"
460	=	"Child Care Workers	"
461	=	"Personal and Home Care Aides	"
462	=	"Recreation and Fitness Workers	"
464	=	"Residential Advisors	"
465	=	"Personal Care and Service Workers, All Other	"
470	=	"First-Line Supervisors/Managers of Retail Sales Workers	"
471	=	"First-Line Supervisors/Managers of Non-Retail Sales	"
472	=	"Cashiers	"
474	=	"Counter and Rental Clerks	"
475	=	"Parts Salespersons	"
476	=	"Retail Salespersons	"
480	=	"Advertising Sales Agents	"
481	=	"Insurance Sales Agents	"
482	=	"Securities, Commodities, and Financial Services Sales Agents	"
483	=	"Travel Agents	"
484	=	"Sales Representatives, Services, All Other	"
485	=	"Sales Representatives, Wholesale and Manufacturing	"
490	=	"Models, Demonstrators, and Product Promoters	"
492	=	"Real Estate Brokers and Sales Agents	"
493	=	"Sales Engineers	"
494	=	"Telemarketers	"
495	=	"Door-to-Door Sales Workers, News and Street Vendors, and Related Workers	"
496	=	"Sales and Related Workers, All Other	"
500	=	"First-Line Supervisors/Managers of Office and Administrative Support Workers	"
501	=	"Switchboard Operators, Including Answering Service	"
502	=	"Telephone Operators	"
503	=	"Communications Equipment Operators, All Other	"
510	=	"Bill and Account Collectors	"
511	=	"Billing and Posting Clerks and Machine Operators	"
512	=	"Bookkeeping, Accounting, and Auditing Clerks	"
513	=	"Gaming Cage Workers	"
514	=	"Payroll and Timekeeping Clerks	"
515	=	"Procurement Clerks	"
516	=	"Tellers	"
520	=	"Brokerage Clerks	"
522	=	"Court, Municipal, and License Clerks	"
523	=	"Credit Authorizers, Checkers, and Clerks	"
524	=	"Customer Service Representatives	"
525	=	"Eligibility Interviewers, Government Programs	"
526	=	"File Clerks	"
530	=	"Hotel, Motel, and Resort Desk Clerks	"
531	=	"Interviewers, Except Eligibility and Loan	"
532	=	"Library Assistants, Clerical	"
533	=	"Loan Interviewers and Clerks	"
534	=	"New Account Clerks	"
535	=	"Correspondent clerks and order clerks	"
536	=	"Human Resources Assistants, Except Payroll and Timekeeping	"
540	=	"Receptionists and Information Clerks	"
541	=	"Reservation and Transportation Ticket Agents and Travel Clerks	"
542	=	"Information and Record Clerks, All Other	"
550	=	"Cargo and Freight Agents	"
551	=	"Couriers and Messengers	"
552	=	"Dispatchers	"
553	=	"Meter Readers, Utilities	"
554	=	"Postal Service Clerks	"
555	=	"Postal Service Mail Carriers	"
556	=	"Postal Service Mail Sorters, Processors, and Processing Machine Operators	"
560	=	"Production, Planning, and Expediting Clerks	"
561	=	"Shipping, Receiving, and Traffic Clerks	"
562	=	"Stock Clerks and Order Fillers	"
563	=	"Weighers, Measurers, Checkers, and Samplers, Recordkeeping	"
570	=	"Secretaries and Administrative Assistants	"
580	=	"Computer Operators	"
581	=	"Data Entry Keyers	"
582	=	"Word Processors and Typists	"
584	=	"Insurance Claims and Policy Processing Clerks	"
585	=	"Mail Clerks and Mail Machine Operators, Except Postal Service	"
586	=	"Office Clerks, General	"
590	=	"Office Machine Operators, Except Computer	"
591	=	"Proofreaders and Copy Markers	"
592	=	"Statistical Assistants	"
593	=	"Miscellaneous office and administrative support workers including desktop publishers	"
600	=	"First-Line Supervisors/Managers/Contractors of Farming, Fishing, and Forestry Workers	"
601	=	"Agricultural Inspectors	"
604	=	"Graders and Sorters, Agricultural Products	"
605	=	"Miscellaneous agricultural workers including animal breeders	"
610	=	"Fishing and hunting workers	"
612	=	"Forest and Conservation Workers	"
613	=	"Logging Workers	"
620	=	"First-Line Supervisors/Managers of Construction Trades and Extraction Workers	"
621	=	"Boilermakers	"
622	=	"Brickmasons, Blockmasons, and Stonemasons	"
623	=	"Carpenters	"
624	=	"Carpet, Floor, and Tile Installers and Finishers	"
625	=	"Cement Masons, Concrete Finishers, and Terrazzo Workers	"
626	=	"Construction Laborers	"
630	=	"Paving, Surfacing, and Tamping Equipment Operators	"
632	=	"Construction equipment operators except paving, surfacing, and tamping equipment operators	"
633	=	"Drywall Installers, Ceiling Tile Installers, and Tapers	"
635	=	"Electricians	"
636	=	"Glaziers	"
640	=	"Insulation Workers	"
642	=	"Painters, Construction and Maintenance	"
643	=	"Paperhangers	"
644	=	"Pipelayers, Plumbers, Pipefitters, and Steamfitters	"
646	=	"Plasterers and Stucco Masons	"
650	=	"Reinforcing Iron and Rebar Workers	"
651	=	"Roofers	"
652	=	"Sheet Metal Workers	"
653	=	"Structural Iron and Steel Workers	"
660	=	"Helpers, Construction Trades	"
666	=	"Construction and Building Inspectors	"
670	=	"Elevator Installers and Repairers	"
671	=	"Fence Erectors	"
672	=	"Hazardous Materials Removal Workers	"
673	=	"Highway Maintenance Workers	"
674	=	"Rail-Track Laying and Maintenance Equipment Operators	"
676	=	"Miscellaneous construction workers including septic tank servicers and sewer pipe cleaners	"
680	=	"Derrick, rotary drill, and service unit operators, and roustabouts, oil, gas, and mining	"
682	=	"Earth Drillers, Except Oil and Gar	"
683	=	"Explosives Workers, Ordnance Handling Experts, and Blasters	"
684	=	"Mining Machine Operators	"
694	=	"Miscellaneous extraction workers including roof bolters and helpers	"
700	=	"First-Line Supervisors/Managers of Mechanics, Installers, and Repairers	"
701	=	"Computer, Automated Teller, and Office Machine Repairers	"
702	=	"Radio and Telecommunications Equipment Installers and Repairers	"
703	=	"Avionics Technicians	"
704	=	"Electric Motor, Power Tool, and Related Repairers	"
710	=	"Electrical and electronics repairers, transportation equipment, and industrial and utility	"
711	=	"Electronic Equipment Installers and Repairers, Motor Vehicles	"
712	=	"Electronic Home Entertainment Equipment Installers and Repairers	"
713	=	"Security and Fire Alarm Systems Installers	"
714	=	"Aircraft Mechanics and Service Technicians	"
715	=	"Automotive Body and Related Repairers	"
716	=	"Automotive Glass Installers and Repairers	"
720	=	"Automotive Service Technicians and Mechanics	"
721	=	"Bus and Truck Mechanics and Diesel Engine Specialists	"
722	=	"Heavy Vehicle and Mobile Equipment Service Technicians and Mechanics	"
724	=	"Small Engine Mechanics	"
726	=	"Miscellaneous Vehicle and Mobile Equipment Mechanics, Installers, and Repairers	"
730	=	"Control and Valve Installers and Repairers	"
731	=	"Heating, Air Conditioning, and Refrigeration Mechanics and Installers	"
732	=	"Home Appliance Repairers	"
733	=	"Industrial and Refractory Machinery Mechanics	"
734	=	"Maintenance and Repair Workers, General	"
735	=	"Maintenance Workers, Machinery	"
736	=	"Millwrights	"
741	=	"Electrical Power-Line Installers and Repairers	"
742	=	"Telecommunications Line Installers and Repairers	"
743	=	"Precision Instrument and Equipment Repairers	"
751	=	"Coin, Vending, and Amusement Machine Servicers and Repairers	"
754	=	"Locksmiths and Safe Repairers	"
755	=	"Manufactured Building and Mobile Home Installers	"
756	=	"Riggers	"
761	=	"Helpers--Installation, Maintenance, and Repair Workers	"
762	=	"Other installation, maintenance, and repair workers including commercial divers, and signal and track switch repairers	"
770	=	"First-Line Supervisors/Managers of Production and Operating Workers	"
771	=	"Aircraft Structure, Surfaces, Rigging, and Systems Assemblers	"
772	=	"Electrical, Electronics, and Electromechanical Assemblers	"
773	=	"Engine and Other Machine Assemblers	"
774	=	"Structural Metal Fabricators and Fitters	"
775	=	"Miscellaneous Assemblers and Fabricators	"
780	=	"Bakers	"
781	=	"Butchers and Other Meat, Poultry, and Fish Processing Workers	"
783	=	"Food and Tobacco Roasting, Baking, and Drying Machine Operators and Tenders	"
784	=	"Food Batchmakers	"
785	=	"Food Cooking Machine Operators and Tenders	"
790	=	"Computer Control Programmers and Operators	"
792	=	"Extruding and Drawing Machine Setters, Operators, and Tenders, Metal and Plastic	"
793	=	"Forging Machine Setters, Operators, and Tenders, Metal and Plastic	"
794	=	"Rolling Machine Setters, Operators, and Tenders, metal and Plastic	"
795	=	"Cutting, Punching, and Press Machine Setters, Operators, and Tenders, Metal and Plastic	"
796	=	"Drilling and Boring Machine Tool Setters, Operators, and Tenders, Metal and Plastic	"
800	=	"Grinding, Lapping, Polishing, and Buffing Machine Tool Setters, Operators, and Tenders, Metal and Plastic	"
801	=	"Lathe and Turning Machine Tool Setters, Operators, and Tenders, Metal and Plastic	"
803	=	"Machinists	"
804	=	"Metal Furnace and Kiln Operators and Tenders	"
806	=	"Model Makers and Patternmakers, Metal and Plastic	"
810	=	"Molders and Molding Machine Setters, Operators, and Tenders, Metal and Plastic	"
813	=	"Tool and Die Makers	"
814	=	"Welding, Soldering, and Brazing Workers	"
815	=	"Heat Treating Equipment Setters, Operators, and Tenders, Metal and Plastic	"
820	=	"Plating and Coating Machine Setters, Operators, and Tenders, Metal and Plastic	"
821	=	"Tool Grinders, Filers, and Sharpeners	"
822	=	"Miscellaneous metal workers and plastic workers including milling and planing machine setters, and multiple machine tool setters, and lay-out workers	"
823	=	"Bookbinders and Bindery Workers	"
824	=	"Job Printers	"
825	=	"Prepress Technicians and Workers	"
826	=	"Printing Machine Operators	"
830	=	"Laundry and Dry-Cleaning Workers	"
831	=	"Pressers, Textile, Garment, and Related Materials	"
832	=	"Sewing Machine Operators	"
833	=	"Shoe and Leather Workers and Repairers	"
834	=	"Shoe Machine Operators and Tenders	"
835	=	"Tailors, Dressmakers, and Sewers	"
840	=	"Textile bleaching and dyeing, and cutting machine setters, operators, and tenders	"
841	=	"Textile Knitting and Weaving Machine Setters, Operators, and Tenders	"
842	=	"Textile Winding, Twisting, and Drawing Out Machine Setters, Operators, and Tenders	"
845	=	"Upholsterers	"
846	=	"Miscellaneous textile, apparel, and furnishings workers except upholsterers	"
850	=	"Cabinetmakers and Bench Carpenters	"
851	=	"Furniture Finishers	"
853	=	"Sawing Machine Setters, Operators, and Tenders, Wood	"
854	=	"Woodworking Machine Setters, Operators, and Tenders, Except Sawing	"
855	=	"Miscellaneous woodworkers including model makers and patternmakers	"
860	=	"Power Plant Operators, Distributors, and Dispatchers	"
861	=	"Stationary Engineers and Boiler Operators	"
862	=	"Water and Liquid Waste Treatment Plant and System Operators	"
863	=	"Miscellaneous Plant and System Operators	"
864	=	"Chemical Processing Machine Setters, Operators, and Tenders	"
865	=	"Crushing, Grinding, Polishing, Mixing, and Blending Workers	"
871	=	"Cutting Workers	"
872	=	"Extruding, Forming, Pressing, and Compacting Machine Setters, Operators, and Tenders	"
873	=	"Furnace, Kiln, Oven, Drier, and Kettle Operators and Tenders	"
874	=	"Inspectors, Testers, Sorters, Samplers, and Weighers	"
875	=	"Jewelers and Precious Stone and Metal Workers	"
876	=	"Medical, Dental, and Ophthalmic Laboratory Technicians	"
880	=	"Packaging and Filling Machine Operators and Tenders	"
881	=	"Painting Workers	"
883	=	"Photographic Process Workers and Processing Machine Operators	"
885	=	"Cementing and Gluing Machine Operators and Tenders	"
886	=	"Cleaning, Washing, and Metal Pickling Equipment Operators and Tenders	"
891	=	"Etchers and Engravers	"
892	=	"Molders, Shapers, and Casters, Except Metal and Plastic	"
893	=	"Paper Goods Machine Setters, Operators, and Tenders	"
894	=	"Tire Builders	"
895	=	"Helpers--Production Workers	"
896	=	"Other production workers including semiconductor processors and cooling and freezing equipment operators	"
900	=	"Supervisors, Transportation and Material Moving Workers	"
903	=	"Aircraft Pilots and Flight Engineers	"
904	=	"Air Traffic Controllers and Airfield Operations Specialists	"
911	=	"Ambulance Drivers and Attendants, Except Emergency Medical Technicians	"
912	=	"Bus Drivers	"
913	=	"Driver/Sales Workers and Truck Drivers	"
914	=	"Taxi Drivers and Chauffeurs	"
915	=	"Motor Vehicle Operators, All Other	"
920	=	"Locomotive Engineers and Operators	"
923	=	"Railroad Brake, Signal, and Switch Operators	"
924	=	"Railroad Conductors and Yardmasters	"
926	=	"Subway, Streetcar, and Other Rail Transportation Workers	"
930	=	"Sailors and marine oilers, and ship engineers	"
931	=	"Ship and Boat Captains and Operators	"
935	=	"Parking Lot Attendants	"
936	=	"Service Station Attendants	"
941	=	"Transportation Inspectors	"
942	=	"Miscellaneous transportation workers including bridge and lock tenders and traffic technicians	"
951	=	"Crane and Tower Operators	"
952	=	"Dredge, Excavating, and Loading Machine Operators	"
956	=	"Conveyor operators and tenders, and hoist and winch operators	"
960	=	"Industrial Truck and Tractor Operators	"
961	=	"Cleaners of Vehicles and Equipment	"
962	=	"Laborers and Freight, Stock, and Material Movers, Hand	"
963	=	"Machine Feeders and Offbearers	"
964	=	"Packers and Packagers, Hand	"
965	=	"Pumping Station Operators	"
972	=	"Refuse and Recyclable Material Collectors	"
975	=	"Miscellaneous material moving workers including shuttle car operators, and tank car, truck, and ship loaders	"
980	=	"Military Officer Special and Tactical Operations Leaders/Managers	"
981	=	"First-Line Enlisted Military Supervisors/Managers	"
982	=	"Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members	"
983	=	"Military, Rank Not Specified	"
992	=	"Unemployed, last worked 5 years ago or earlier or never worked	";

run;

data ipums_OCC_UNWGT2; 
set IPUMS.Acs_2005_07_dc   (keep= PERWT HISPAN RACE SEX OCC AGE where=(AGE >=16)
		);
If HISPAN in (1:4) then LATINO = 1;
	else LATINO = 2;

If RACE = 1 then RACE_NEW = 1; 
	else if RACE = 2 then RACE_NEW = 2;
	else if RACE = 3 then RACE_NEW = 3;
	else if RACE in (4:6) then RACE_NEW = 4;
	else RACE_NEW = 5;

If (RACE_NEW = 1 and LATINO = 2) then RACE_ETH = 'White, Non-Hispanic';
	else if (RACE_NEW = 2 and LATINO = 2) then RACE_ETH = 'Black, Non-Hispanic';
	else if (RACE_NEW = 3 and LATINO = 2) then RACE_ETH = 'Native American, Non-Hispanic';
	else if (RACE_NEW = 4 and LATINO = 2) then RACE_ETH = 'Asian, Non-Hispanic';
	else if LATINO = 1 then RACE_ETH = 'Latino or Hispanic';
	else RACE_ETH = 'Other Race, Non-Hispanic';	

OCC_DETAIL =PUT(OCC,OCC_LTTL.);
OCC_LARGE  =PUT(OCC,OCC_BIG.);
TOTSAMP = 1;
Run;

proc download inlib=work outlib=dcola; 
select ipums_OCC_UNWGT2;
run;

endrsubmit;	


proc means data=dcola.ipums_OCC_UNWGT2 chartype;
      var TOTSAMP;
      class  RACE_ETH OCC_DETAIL OCC_LARGE;
	  weight PERWT;
      output out=DCOLA.OCCUP_LTTL_0507_2 sumwgt=;
run;


filename fexport "D:\DCDATA\Libraries\DCOLA\Raw\Occup_Race_0507_DETAIL.csv" lrecl=5000;
proc export data=DCOLA.OCCUP_LTTL_0507_2
	outfile=fexport 
	dbms=csv replace;
	run;

	filename fexport clear;
	run;
