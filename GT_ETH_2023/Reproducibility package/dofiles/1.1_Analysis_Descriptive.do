* Call the data

	use "${data}\artificial_data.dta", clear 


********************************************************************************
** SECTION 4.1: Descriptive 
********************************************************************************

*Table 2 in the paper: Balanced and Unbalanced Panel 

	unique id 
	mat B2 = `r(N)'
	mat B3 = `r(sum)'
	
	unique id if bpanel==2
	mat C2 = `r(N)'
	mat C3 = `r(sum)'
	
	mat B = (B2, C2\B3, C3)
	mat rownames B=`""Number_of_observations""' "Number_of_Firms"
	mat colnames B="Unbalanced_Panel" "Balanced_Panel"
	
	*Table 3		
	outtable using "${tables}\Table2", replace mat (B) caption(Number of Observations and Taxpayers) nobox 

*Table 3: Number and Percentage of Taxpayers by Gender
	*Table 3	
	estpost tab gender year
	esttab using "${tables}\Table3.tex", cells("b" "colpct(fmt(%9.0f))") collabels(none) replace unstack  title("Number and Percentage of Taxpayers by Gender and Year") nonumbers noobs addnotes(Note: The percentage by gender is displayed below the number of taxpayers)


*****************************************************************************************************************************************************************************************
*SECTION FOUR EMPIRICAL EVIDENCE 
*****************************************************************************************************************************************************************************************

	
*****************************************************************************************************************************************************************************************
* 4.1.1 Income Tax Declarations and Payment by Gender
*****************************************************************************************************************************************************************************************

*Table 4: Income tax declared and paid 

	foreach var of varlist annualturnover otherinc business_income cogs grossp_l totalexpense netincomeloss taxableincome  taxpaybl leftunpaid taxpaid  {
	format `var' %3.2f
	ttest `var' if (gender==0| gender==1), by(gender)
	matrix `var'= (r(mu_1), r(N_1), r(mu_2), r(N_2), r(mu_1) - r(mu_2), r(p))
	*estpost ttest `var' if (gender==0| gender==1), by(gender)
	*esttab using "$pr\results\version_2\Table4.tex", cells("`mean(Men)' `mean(Women)' `diff' p(`pvalue')") label append
	}
	
	matrix ttest = annualturnover\otherinc\business_income\cogs\grossp_l\totalexpense\netincomeloss\taxableincome\taxpaybl\leftunpaid\taxpaid 
	matrix rownames ttest= "Annual Turnover" "Other Income" "Business Income" "Cost of Goods Sold" "Gross Profit" "Total Expense" "Net Profit or Loss" "Taxable Income" "Tax payable" "Tax to be paid" "Tax paid"

	matrix colnames ttest= Mean Obs Mean Obs Differences P-value
	
	
	*For Latex
	matrix rownames ttest= "Annual_Turnover" "Other_Income" "Business_Income" "Cost_of_Goods_Sold" "Gross_Profit" "Total_Expense" "Net_Profit_or_Loss" "Taxable_Income" "Tax_payable" "Tax_to_be_paid" "Tax_paid"
	outtable using "${tables}\Table4", replace mat (ttest)	f(%12.0fc %12.0fc %12.0fc %12.0fc %12.0fc %9.3f) nobox caption(Financial Statement, Tax Declarations and Payment by Men and Women-owned Businesses for 2011 to 2017) clabel(tab:table4)
	

*Table 5: Average Effective Income Tax Rates by quint

	forvalues i=2011(1)2012 {
	mean aet_gp if nil_taxdue==0 & year==`i', over(quint)
	mat y`i'=r(table)["b",.] 
	}
	
	mat AET = (y2011\y2012)
	mat rownames AET = "2011" "2012"
	mat colnames AET = "First" "Second" "Third" "Fourth" "Fifth"
	
	outtable using "${tables}\Table5", replace mat (AET)	f(%9.2f %9.2f %9.2f %9.2f %9.2f) nobox caption(Average Effective Tax Rate Per Quintiles of Sales) clabel(tab:table5)


**************************************************************************************************************************************************************************************************************************		
* 4.2 Entry and Exit
**************************************************************************************************************************************************************************************************************************

*Table 7: Exit by gender 	


	*Latex	
	preserve 
	duplicates drop id, force
	estpost tab gender exit
	esttab using "${tables}\Table6.tex", cells("b colpct(fmt(%9.0f))") collabels("Num." "Pct.") replace unstack  title("Number and Percentage of Taxpayers by Gender and Exit Status")  nonumbers noobs

	
*Table 8: Entry by gender 

	estpost tab gender entry 
	esttab using "${tables}\Table7.tex", cells("b colpct(fmt(%9.0f))") collabels("Num." "Pct.") replace unstack  title("Number and Percentage of Taxpayers by Gender and Entry Status")  nonumbers noobs
	restore
	
		
***************************************************************************************************************************************************************************************************************************
	*Gender and Category of taxpayers
***************************************************************************************************************************************************************************************************************************
	
	
*Table 9:  Gender and Category of taxpayers

	preserve 
	duplicates drop id, force 
	
	prtest cat_reg_a if (gender==0| gender==1), by(gender)
	mat B2=`r(P1)'
	mat C2=`r(P2)'
	mat D2=`r(P_diff)'
	mat B3=`r(se1)'
	mat C3=`r(se2)'
	mat D3=`r(z)'

	prtest cat_reg_b if (gender==0| gender==1), by(gender)
	mat B4=`r(P1)'
	mat C4=`r(P2)'
	mat D4=`r(P_diff)'
	mat B5=`r(se1)'
	mat C5=`r(se2)'
	mat D5=`r(z)'
	
	
	mat B6=round(`r(N1)')
	mat C6=round(`r(N2)')

	
	mat cat = (B2,C2,D2 \ B3,C3,D3 \ B4,C4,D4 \ B5,C5,D5 \ B6,C6,.)

	mat rownames cat = "Share_of_Category_A_TP" "_"  "Share_of_Category_B_TP" "_" "Number_of_Observations"
	mat colnames cat =  "Men" "Women" "Differences"
	
	outtable using "${tables}\Table8", replace mat (cat)	f(%12.2fc %12.2fc %9.3f) nobox caption(Share of Individuals by Gender and Tax Category) clabel(tab:table9)

	restore 
	
		
*************************************************************************************************************************************************************************************************************************
	* Industrial classification

*************************************************************************************************************************************************************************************************************************

*Figure 2	
	preserve 
	duplicates drop id, force 
	
	tab esic_division gender if (gender==0| gender==1)
	*tab esic_sgdesc gender if (gender==0| gender==1), row
	
	
	*graph 
	
	gen gen_100=gender*100 if (gender==0 | gender==1)
	bys esic_sgdesc: egen gen_100a=mean(gen_100)
	
	
	bys esic_division: egen count_ind=count(id) // counting taxpayers within industry
	

	set scheme s1mono
	graph hbar gen_100 if count_ind>10, over(esic_division, sort(1) lab(labsize(small))) blabel(bar, format(%5.0f)) ytitle("Women registered business (% total)") ysize(3) xsize(4)  ylab(,labsize(small))
	graph export "${figures}\esic.png", as(png) replace
	



	restore 


	
**********************************************************************************************************************************************************************************************************************
*Gender and Fiscal Device
**********************************************************************************************************************************************************************************************************************
	prtest esrm_non if year==2011, by(gender)
	



**********************************************************************************************************************************************************************************************************************
	
* Nil reporting

**********************************************************************************************************************************************************************************************************************
	foreach var of varlist nil_sales nil_profit1 nil_profit2 nil_taxp nil_taxdue nil_taxpaid  {
	prtest `var' if (gender==0 | gender==1), by(gender)
	matrix `var'= (r(P1), r(N_1), r(P2), r(N_2), r(P_diff), r(p))
	}
	
	matrix prtest = nil_sales\nil_profit1\nil_profit2\nil_taxp\nil_taxdue\nil_taxpaid
	matrix rownames prtest= "Zero_annual_turnover" "Zero_or_negative_gross_profit" "Zero_or_negative_net_profit" "Zero_tax_payable" "Zero_or_negative_tax_to_be_paid" "Zero_tax_payment"
	matrix colnames prtest= Percent Obs Percent Obs Differences P-value

	
	outtable using "${tables}\Table9", replace mat (prtest)	f(%12.2fc %12.0fc %9.2f %12.0fc %12.2fc %12.3fc) nobox caption(Share of Nil filers by Gender of the Business Owner) clabel(tab:table10)
	
