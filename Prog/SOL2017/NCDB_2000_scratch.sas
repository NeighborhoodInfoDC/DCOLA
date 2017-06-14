
Also, please note that Ncdb.Ncdb_lf_2000_dc is a tract-level data set, so you need to sum all of the observations to get the city total. 

Unemployment rate: 100 * ( rMUNEMP0 + rFUNEMP0 ) / (rMUNEMP0 + rMEMP0 + rFUNEMP0 + rFEMP0 )
Total = UNEMPT0N / UNEMPT0D

%let years=1990, 2000
data ncdb

Ncdb.Ncdb_lf_2000_dc
        (keep=&geo
           trctpop0 forbczn0 forbnoc0
			educ110 aedlths0 bedlths0 hedlths0 iedlths0 medlths0 oedlths0 xedlths0
			)


With less than high school diploma:
		Pop25andOverWoutHS_&_years. = sum(educ80, educ110)
		Pop25andOverWoutHSB_&_years. = sum(bedlt90, bedlths0)
		Pop25andOverWoutHSW_&_years. = sum(xedlt90, xedlths0)
		Pop25andOverWoutHSH_&_years. = sum(hedlt90, hedlths0)
		Pop25andOverWoutHSAIOM_&_years. = sum(aedlt90, aedlths0, iedlt90, iedlths0, oedlt90, oedlths0, medlt90, medlths0)

With high school diploma:
		Pop25andOverWHS_&_years. = sum(educ120, educa0, educ150, educ160)
		Pop25andOverWHSB_&_years. = sum(bedhsg0, bedasd0, bedsc0, bedba0, bedpro0)
		Pop25andOverWHSW_&_years. = sum(xedhsg0, xedasd0, xedsc0, xedba0, xedpro0)
		Pop25andOverWHSH_&_years. = sum(hedhsg0, hedasd0, hedsc0, hedba0, hedpro0)
		Pop25andOverWHSAIOM_&_years. = sum(aedhsg0, aedasd0, aedsc0, aedba0, aedpro0,
											iedhsg0, iedasd0, iedsc0, iedba0, iedpro0,
											oedhsg0, oedasd0, oedsc0, oedba0, oedpro0,
											medhsg0, medasd0, medsc0, medba0, medpro0)

With some college:
		Pop25andOverWSC_&_years. = sum(educa0, educ150, educ160)
		Pop25andOverWSCB_&_years. = sum(bedasd0,, bedsc0,, bedba0,, bedpro0)
		Pop25andOverWSCW_&_years. = sum(xedasd0, xedsc0, xedba0, xedpro0)
		Pop25andOverWSCH_&_years. = sum(hedasd0, hedsc0, hedba0, hedpro0)
		Pop25andOverWSCAIOM_&_years. = sum(aedasd0, aedsc0, aedba0, aedpro0,
					iedasd0, iedsc0, iedba0, iedpro0,
					oedasd0, oedsc0, oedba0, oedpro0,
					medasd0, medsc0, medba0, medpro0)

Unemployed population

PopUnemployed_&_years. = UNEMPT0N
PopUnemployedW_&_years. = sum(xMUNEMP0, xFUNEMP0)
PopUnemployedB_&_years. = sum(bMUNEMP0, bFUNEMP0)
PopUnemployedH_&_years. = sum(hMUNEMP0, hFUNEMP0)
PopUnemployedAIOM_&_years. = sum(aMUNEMP0, aFUNEMP0, iMUNEMP0, iFUNEMP0, oMUNEMP0, oFUNEMP0, mMUNEMP0, mFUNEMP0)

Civilian labor force
PopInCivLaborForce_&_years. = UNEMPT0D
PopInCivLaborForcew_&_years. = (xMUNEMP0 + xMEMP0 + xFUNEMP0 + xFEMP0 )
PopInCivLaborForceB_&_years. = (bMUNEMP0 + bMEMP0 + bFUNEMP0 + bFEMP0 )
PopInCivLaborForceH_&_years. = (hMUNEMP0 + hMEMP0 + hFUNEMP0 + hFEMP0 )
PopInCivLaborForceAIOM_&_years. = (aMUNEMP0 + aMEMP0 + aFUNEMP0 + aFEMP0 +
									iMUNEMP0 + iMEMP0 + iFUNEMP0 + iFEMP0 +
									oMUNEMP0 + oMEMP0 + oFUNEMP0 + oFEMP0 +
									mMUNEMP0 + mMEMP0 + mFUNEMP0 + mFEMP0)



Age - 2000

Under 18
Total = 
Black = sum(bf50, bm50, bf140, bm140, f170a, bm170a)
White = sum(xf50, xm50, xf140, xm140, f170a, xm170a)
PopUnder18YearsH_&_years. = sum(hf50, hm50, hf140, hm140, f170a, hm170a)
AIOM = sum(af50, am50, af140, am140, f170a, am170a,
		if50, am50, if140, am140, if170a, am170a,
		of50, om50, of140, om140, of170a, om170a,
		mf50, mm50, mf140, mm140, mf170a, mm170a)



18-24
Total = 
Black = sum(bf240a, bm240a)
White = sum(xf240a, xm240a)
Pop18_24YearsH_&_years. = sum(hf240a, hm240a)
AIOM = (af240a, am240a, if240a, im240a,
		of240a, om240a, mf240a, mm240a)

25-64
Total = 
Black = sum(bf590a, bm590a, bf640, bm640)
White = sum(xf590a, xm590a, xf640, xm640)
Pop25_64YearsH_&_years. = sum(hf590a, hm590a, hf640, hm640)
AIOM = sum(af590a, am590a, af640, am640,
		if590a, im590a, if640, im640,
		of590a, om590a, of640, om640,
		mf590a, mm590a, mf640, mm640)

65+
Total = 
Black = sum(bf650, bm650)
White = sum(xf650, xm650
Pop65andOverYearsH_&_years. = sum(hf650, hm650
AIOM = sum(af650, am650, if650, im650
of650, om650, mf650, mm650)



Age - 1990

Under 18
Total = 
Black = sum(bf59, bm59, bf149, bm149, f179a, bm179a)
White = sum(xf59, xm59, xf149, xm149, f179a, xm179a)
Hispanic = sum(hf59, hm59, hf149, hm149, f179a, hm179a)
AIOM = sum(af59, am59, af149, am149, f179a, am179a,
		if59, am59, if149, am149, if179a, am179a,
		of59, om59, of149, om149, of179a, om179a,
		mf59, mm59, mf149, mm149, mf179a, mm179a)

18-24
Total = 
Black = sum(bf249a, bm249a)
White = sum(xf249a, xm249a)
Hispanic = sum(hf249a, hm249a)
AIOM = (af249a, am249a, if249a, im249a,
		of249a, om249a, mf249a, mm249a)

25-64
Total = 
Black = sum(bf599a, bm599a, bf649, bm649)
White = sum(xf599a, xm599a, xf649, xm649)
Hispanic = sum(hf599a, hm599a, hf649, hm649)
AIOM = sum(af599a, am599a, af649, am649,
		if599a, im599a, if649, im649,
		of599a, om599a, of649, om649,
		mf599a, mm599a, mf649, mm649)

65+
Total = 
Black = sum(bf659, bm659)
White = sum(xf659, xm659
Hispanic = sum(hf659, hm659
AIOM = sum(af659, am659, if659, im659
of659, om659, mf659, mm659)


Aggregate household income - 2000

Total = avhhin0n
Black = bpcapy0n
White = hpcapy0n
Hispanic = xpcapy0n
AIOM = sum(apcapy0n, ipcapy0n, mpcapy0n, opcapy0n)

NumHshlds - 2000

Total = nonfam0
Black = anonfam0
White = xnonfam0
Hispanic = hnonfam0
AIOM = sum(anonfam0, ononfam0, inonfam0, mnonfam0)


Language proficiency

spnene0n	N	Values	Persons 65+ years old who speak Spanish and speak English not well or not at all, 2000
spneno0n	N	Values	Persons 18-64 years old who speak Spanish and speak English not well or not at all, 2000
spneny0n	N	Values	Persons 5-17 years old who speak Spanish and speak English not well or not at all, 2000

spnene9n	N	Values	Persons 65+ years old who speak Spanish and speak English not well or not at all, 1990
spneno9n	N	Values	Persons 18-64 years old who speak Spanish and speak English not well or not at all, 1990
spneny9n	N	Values	Persons 5-17 years old who speak Spanish and speak English not well or not at all, 1990
