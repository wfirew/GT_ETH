clear all

set seed 1234

set obs 1200





gen year=runiform(0,1)

replace year=2011 if year<.5

replace year=2012 if year!=2011

gen id=runiform(1,600) if year==2011

replace id=runiform(1,600) if year==2012


gen bpanel=2



gen gender=1 if id<300
replace gender=0 if id>=300


foreach name in annualturnover otherinc business_income cogs grossp_l totalexpense netincomeloss taxableincome  taxpaybl leftunpaid taxpaid {
gen `name'=runiform(10,1000000) if year==2011
replace `name'=runiform(10,1000000) if year==2012
}
gen aet_gp=taxpaid/grossp_l

gen taxprev=taxpaid/annualturnover

foreach name in annualturnover otherinc business_income cogs grossp_l totalexpense netincomeloss taxableincome  taxpaybl leftunpaid taxpaid {
replace `name'=0 if year==2011 & `name'<300000
replace `name'=0 if year==2012 & `name'<300000
}

gen log_anns=log(annualturnover)

gen log_tax=log(taxpaybl)

gen log_taxp=log(taxpaid)





gen nil_taxdue=1 if leftunpaid==0
replace nil_taxdue=0 if nil_taxdue!=1

gen nil_sales=1 if annualturnover==0
replace nil_sales=0 if nil_sales!=1


gen nil_profit1=1 if grossp_l==0
replace nil_profit1=0 if nil_profit1!=1

gen nil_profit2=1 if netincomeloss==0
replace nil_profit2=0 if nil_profit2!=1

gen nil_taxp=1 if taxpaybl==0 
replace nil_taxp=0 if nil_taxp!=1


gen nil_taxpaid=1 if taxpaid==0 
replace nil_taxpaid=0 if nil_taxpaid!=1


xtile quint = annualturnover, n(5)

gen exit=runiform(0,1)
replace exit=1 if exit<.5
replace exit=0 if exit!=1

gen entry=runiform(0,1)
replace entry=1 if entry<.5
replace entry=0 if entry!=1

gen cat_reg_a=runiform(0,1)
replace cat_reg_a=1 if cat_reg_a<.5
replace cat_reg_a=0 if cat_reg_a!=1

gen cat_reg_b=runiform(0,1)
replace cat_reg_b=1 if cat_reg_b<.5
replace cat_reg_b=0 if cat_reg_b!=1

gen esic_division=runiform(0,1)
replace esic_division=1 if esic_division<.25
replace esic_division=2 if esic_division!=1 & esic_division<.5
replace esic_division=3 if esic_division!=1 & esic_division!=2 & esic_division<.75
replace esic_division=4 if esic_division!=1 & esic_division!=2 & esic_division!=3

gen sector=runiform(0,1)
replace sector=1 if sector<.33
replace sector=2 if sector!=1 & sector<.66
replace sector=3 if sector!=1 & sector!=2 

gen subcity=runiform(0,1)
replace subcity=1 if subcity<.33
replace subcity=2 if subcity!=1 & subcity<.66
replace subcity=3 if subcity!=1 & subcity!=2 


gen esic_sgdesc=esic_division

gen esrm_non=runiform(0,1)
replace esrm_non=1 if esrm_non<.5
replace esrm_non=0 if esrm_non!=1

gen esrm_2011=runiform(0,1)
replace esrm_2011=1 if esrm_2011<.5
replace esrm_2011=0 if esrm_2011!=1

gen esrm_2012=runiform(0,1)
replace esrm_2012=1 if esrm_2012<.5
replace esrm_2012=0 if esrm_2012!=1

gen cat_a=cat_reg_a

xtset id year

duplicates tag id year, gen(isdup)
drop if isdup

save "${data}\artificial_data.dta", replace




exit



/*


gen cat_a=runiform(0,1)

replace cat_a=1 if year<.5
replace cat_a=0 if year>=.5


gen cat_b=runiform(0,1)

replace cat_b=1 if cat_b<.5
replace cat_b=0 if cat_b>=.5



gen cat_c=runiform(0,1)

replace cat_c=1 if cat_c<.5
replace cat_c=0 if cat_c>=.5

gen cat_c_books=runiform(0,1)
replace cat_c_books=1 if cat_c_books<.5
replace cat_c_books=0 if cat_c_books>=.5

gen cat_c_no_books=runiform(0,1)
replace cat_c_no_books=1 if cat_c_books<.5
replace cat_c_no_books=0 if cat_c_books>=.5

gen esrm_year=runiform(0,1)
replace esrm_year=2011 if esrm_year<.5
replace esrm_year=2012 if esrm_year>=.5

gen esrm_2011=runiform(0,1)
replace esrm_2011=1 if esrm_2011<.5
replace esrm_2011=0 if esrm_2011>=.5

gen esrm_2012=runiform(0,1)
replace esrm_2012=1 if esrm_2012<.5
replace esrm_2012=0 if esrm_2012>=.5

gen esrm_non=runiform(0,1)
replace esrm_non=1 if esrm_non<.5
replace esrm_non=0 if esrm_non>=.5







*/





