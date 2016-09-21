** program name: yrbs07.sas
** previous program name: 
** following program name:
** project name: DCOLA
** Description:  downloads DC YRBS files for analysis to Latino Data Book, 1998-2007
** Date Created: 5/14/09
** Data Updated:  
** mgrosz
***********************************************;

*Schools libnames;

libname ola 'D:\Data\dcola';


*HNC libnames;
%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;
libname library 'D:\Data\dcola'; 


data ola.yrbs07 ;
	infile "D:\Data\dcola\yrbs07_dat.txt"
				lrecl = 20000 /*dlm = ','*/ dsd missover pad;

	INPUT
			@1 Site			$3.
			@17 q1			1.
			@18 q2 1.
			@20 q4 1.
			@226 QNOVWGT 1.
			@358 weight  12.;
			
			run;
