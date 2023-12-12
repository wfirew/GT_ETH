version 16
clear all 

********************************************************************************
* PROJECT: Gender and Taxation
* TITLE: Does unequal tax burden contribute to women-owned businesses leaving the tax net?
*******************************************************************************

*** Outline:
	*	Part 0: 	  Set initial configuration and globals 
	*	Part 1: 	  Analysis
	*	Part 2: 	  Appendix

*** OBSERVATIONS:	

*** WRITTEN BY:		Alemayehu Ambel and Firew Woldeyes

*** LAST TIME MODIFIED:		12/12/2023

********************************************************************************
* 					PART 0: Set initial configurations and globals
*******************************************************************************


global pr  "C:\Users\wfire\My Drive (firew.research@gmail.com)\WB\GT_ETH_2023\Reproducibility package" // personal computer

**** Setting up folders
	global data				"${pr}\data"
	global dofiles			"${pr}\dofiles"
	global outputs			"${pr}\outputs"
	global tables			"${outputs}\tables\tables_paper"
	global tables_app 		"${outputs}\tables\tables_appendix"
	global figures			"${outputs}\figures"

	global main_tables        1   /// See switch
	
	sysdir set PLUS "${dofiles}/ado"
	
*** Install required packages

local packages estout outtable ietoolkit unique

foreach package in `packages' {
	capture which `package'
	if _rc == 111 { 
		ssc install `package'
	}
}

	ieboilstart, version(16.0)	
	`r(version)'

********************************************************************************
*	Part 1:  Data analysis
********************************************************************************

*** Generate main descriptive and regression results
	*** Execute dofiles
	
	if (${main_tables} == 1) {
		do "${dofiles}/1.1_Analysis_Descriptive.do" 
		do "${dofiles}/1.2_Analysis_Regression.do"
	}

*******************************************************************************
*	Part 3: Appendix files 
********************************************************************************

*** Produce additional analytical files here
	*** Execute dofiles
	
	if (${main_tables} == 1) {
		do "${dofiles}/2_Appendix.do" 
	}
