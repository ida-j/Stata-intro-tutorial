******** copyright Ida Johnsson, 2016. All right reserved.
set more off 

clear
* load data
sysuse lifeexp

*************** t-tests ***************************
* test that the average life expectancy in the data is equal to 75
ttest lexp==75

* test that the average life expectancy is different in countries with gnppc <4000 and
* countries with gnppc >=4000

gen income_group=0
replace income_group=1 if gnppc>=4000

ttest lexp, by(income_group)

*************** regression analysis ***************************

eststo clear
* OLS regression of life expectancy on GNP 
reg lexp gnppc 

* store estimates
eststo reg1

* predict residuals
predict uhat, r


* predict life expectancy using the estimated coefficients
predict yhat, xb

* calculate lower bound and upper bound of 95% confidence interval of the predicted life expectancy

* standard error of prediction
predict se_yhat, stdp

* lower bound
gen lb=yhat-1.96*se_yhat
label variable lb "95% conf. int. (lb)"

*upper bound
gen ub=yhat+1.96*se_yhat
label variable ub "95% conf. int. (ub)"


* plot observed and predicted life expectancy
graph twoway (scatter lexp gnppc) (line yhat gnppc)

* add 95% confidence interval to the plot
graph twoway (scatter lexp gnppc) (line yhat gnppc) (line lb gnppc) (line ub gnppc)

* OLS regression without constant term
reg lexp gnppc, noconstant
eststo reg2

* OLS regression with added explanatory variable
reg lexp gnppc popgrowth
eststo reg3

* regressions with region dummies
xi: reg lexp gnppc popgrowth i.region
eststo reg4

**** compare regression results
esttab reg1 reg2 reg3 reg4, label


****** Note that there are different ways of including dummy variables in a regresson
* instead of using the xi command we can also generate a set of dummies

tab region, gen(regiond)

* this generates the dummies regiond1, regiond2 and regiond3
* the we can use the syntax regond* to indicate all variables that begin with regiond
reg lexp gnppc popgrowth regiond*
eststo reg5

* check that the estimated coefficients in models 4 and 5 are the same 
esttab reg1 reg2 reg3 reg4 reg5, label
