
* Call the data

	use "${data}\artificial_data.dta", clear 

***********************************************************************************************************************************************************
* SECTION 4.2 Regression analysis 
***********************************************************************************************************************************************************
	xtset id year
***********************************************************************************************************************************************************
*4.2.1 *Quantile Regression Analysis TAx declarations and payment
***********************************************************************************************************************************************************
	
*With controls
*Tax compliance and enforcment 
	qreg log_anns	i.gender i.year i.sector i.subcity cat_a esrm_2* if taxpaid!=., vce(robust) 
	local r2 = 1-(e(sum_adev)/e(sum_rdev))	
	estadd local r2=round(1-(e(sum_adev)/e(sum_rdev)),.01)
	*outreg2 using 		"$pr\results\version_2\qcompl_cont.doc", replace ctitle(Sales) addtext(Time Dummy, Yes, Controls, Yes) keep(i.gender) adds("Pseudo R2", `r2') adec(4)
	
	eststo log_anns
	
	qreg log_tax 	i.gender i.year i.sector i.subcity cat_a esrm_2* if taxpaid!=., vce(robust)
	local r2 = 1-(e(sum_adev)/e(sum_rdev))	
	estadd local r2=round(1-(e(sum_adev)/e(sum_rdev)),.01)
	*outreg2 using 		"$pr\results\version_2\qcompl_cont.doc", append ctitle(Taxable income) addtext(Time Dummy, Yes, Controls, Yes) keep(i.gender) adds("Pseudo R2", `r2') adec(4)
	eststo log_taxd 
	
	
	qreg log_taxp  	i.gender i.year i.sector i.subcity cat_a esrm_2* if taxpaid!=., vce(robust)
	local r2 = 1-(e(sum_adev)/e(sum_rdev))	
	estadd local r2=round(1-(e(sum_adev)/e(sum_rdev)),.01)	
	*outreg2 using 		"$pr\results\version_2\qcompl_cont.doc", append ctitle(Tax due) addtext(Time Dummy, Yes, Controls, Yes) keep(i.gender) adds("Pseudo R2", `r2') adec(4)
	eststo log_taxp
	


	
	esttab 	log_anns  log_taxd log_taxp using "${tables}\Table10.tex", replace mtitles("Sales" "Tax payable" "Tax payment")  /// 
			keep(1.gender _cons)  title(Quantile Regression Result for Tax Declarations  and Payment Indicators) /// 
			coeflabels(1.gender "Women-owned" _cons "Constant") stats(r2 N, labels ("Pseudo R2" "Observations")) /// 
			 addnotes(All of the regression models above include a time dummy.) 
			 
	
****************************************************************************************************************************************
*4.2.2 Positive Tax liabilities:  Linear Probability 
*****************************************************************************************************************************************

	reg nil_sales  i.gender i.year i.sector esrm_2* cat_a i.subcity if taxpaid!=., vce(robust)
	
	eststo nil_sales

	reg nil_taxp 	i.gender i.year i.sector esrm_2* cat_a i.subcity if taxpaid!=., vce(robust)

	eststo nil_taxp 
	
	reg nil_taxpaid  i.gender i.year i.sector esrm_2* cat_a i.subcity , vce(robust)

	eststo nil_taxpaid
	
		esttab 	nil_sales  nil_taxp nil_taxpaid using "${tables}\Table11.tex", replace mtitles("Sales" "Tax payable" "Tax payment")  /// 
			keep(1.gender _cons)  title(Linear Probability Model for Reporting Zero Sales, Tax Liabilities, and Payment) /// 
			coeflabels(1.gender "Women-owned" _cons "Constant") stats(r2 N, labels ("R2" "Observations")) /// 
			 addnotes(All of the regression models above include a time dummy.) 
		
**********************************************************************************************************************************************
* 4.2.3. Exit	
**********************************************************************************************************************************************
	reg exit i.gender i.year i.sector esrm_2* cat_a i.subcity, vce(robust)
	
	eststo exit1 
	
	
	reg exit i.gender i.gender#c.taxprev taxprev i.year i.sector esrm_2* cat_a i.subcity, vce(robust)
	
	eststo exit2

	

	esttab 	exit1 exit2  using "${tables}\Table12.tex", replace /// 
	keep(1.gender 1.gender#c.taxprev taxprev _cons)  title(Linear Probability Model for Exiting the Formal Tax System) /// 
	coeflabels(1.gender "Women-owned" 1.gender#c.taxprev "Women * Tax paid/Sales" taxprev "Tax paid/Sales" _cons "Constant") /// 
			 addnotes(All of the regression models above include a time dummy.) /// 
			 mtitles("Exit" "Exit interacted with Tax burden") stats(r2 N, labels("R2" "Observations"))
	
	
