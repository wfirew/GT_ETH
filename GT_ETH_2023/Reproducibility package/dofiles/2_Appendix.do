* Call the data

	use "${data}\artificial_data.dta", clear 


*********************************************************************************************************************************************************************************************************
** SECTION Appendix
*********************************************************************************************************************************************************************************************************

	forvalues i=2011(1)2012 {
	mean aet_gp if nil_taxdue==0 & year==`i' & gender==0, over(quint)
	mat y`i'=r(table)["b",.] 
	}
	
	mat AET = (y2011\y2012)
	mat rownames AET = "2011" "2012"
	mat colnames AET = "First" "Second" "Third" "Fourth" "Fifth"
	
	outtable using "${tables_app}\TableA2", replace mat (AET)	f(%9.2f %9.2f %9.2f %9.2f %9.2f) nobox caption(Average Effective Tax Rate Per Quintiles of Sales for Men-owned Businesses) clabel(tab:tableA2)
	
	forvalues i=2011(1)2012 {
	mean aet_gp if nil_taxdue==0 & year==`i' & gender==1, over(quint)
	mat y`i'=r(table)["b",.] 
	}
	
	mat AET = (y2011\y2012)
	mat rownames AET = "2011" "2012"
	mat colnames AET = "First" "Second" "Third" "Fourth" "Fifth"
	
	outtable using "${tables_app}\TableA3", replace mat (AET)	f(%9.2f %9.2f %9.2f %9.2f %9.2f) nobox caption(Average Effective Tax Rate Per Quintiles of Sales for Women-owned Businesses) clabel(tab:tableA3)