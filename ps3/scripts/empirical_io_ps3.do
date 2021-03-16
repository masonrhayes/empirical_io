** Set directory and load data:

clear

cd "C:\Users\mason\Documents\projects\empirical_io\empirical_io-problem_sets\ps3"

use data/GMdata

* Create variable to indicate panel
egen num_obs = total(inrange(yr, 73, 88)), by(index)

gen panel = 0

replace panel = 1 if num_obs == 4

* Q1

** summary of the data for both the balanced and the unbalanced panel for Sic code 262 which has data on all Paper Mills active in the US

* Unbalanced
sum if sic3 == 262


* Balanced panel with sic3 code 262

sum if sic3 == 262 & panel ==1


* Q2

drop if sic3 == 357

* Set panel variable based on firm and year
xtset index yr

* Unbalanced Panel Model

xtreg ldsal ldnpt ldrst lemp i.yr, fe vce(robust)

* Balanced Panel Model
* uncomment the line below for this question only:
* drop if panel == 0

xtreg ldsal ldnpt ldrst lemp i.yr, fe vce(robust)


* Be sure to re-run the lines 1-14 and 31-34 since non-panel observations were dropped in the previous question.

* exit = 1 if firm exits sometime between the last observed period and the next period

gen exit = 0 if yr != 88
bysort index: replace exit =1 if yr[_n+1] != yr[_n] + 5 & yr[_n] != 88


xtprobit exit ldnpt ldrst lemp ldinv

predict exit_prob



* Question 4
* How many interactions to add??

  forvalues i = 0/3 {
    forvalues j = 0/3 {
    forvalues k = 0/3 {
	forvalues h = 0/3 {
    if `i'+`j'+`k'+`h'<=3 { 
    gen pol`i'`j'`k'`h' = ldnpt^(`i')*ldrst^(`j')*lemp^(`k')*ldinv^(`h')
    }
    }
    }
    }
  }


xtreg ldsal pol*, vce(r)

* There must be a direct way to get residuals...
predict phi
gen residuals = ldsal -  phi


* Make time variable t = 1:4 for yr = 73 to yr = 88, respectively.

gen t = 1
replace t = 2 if yr == 78
replace t = 3 if yr == 83
replace t = 4 if yr == 88


* Set panelvar
xtset index t

** Using GMM: Here, the following code can be interpreted as:
** Productivity in time t+1 is given by the product of: the probability that the firm stays in the market, a constant /rho, and productivity in period t

gmm (f.phi - {b0} - {b1}*f.ldnpt - {b2}*f.ldrst - {b3}*f.lemp - {rho}*(phi - {b0} - {b1}*ldnpt - {b2}*ldrst - {b3}*lemp)), instruments(f.ldnpt f.ldrst f.lemp phi)


* Third Stage

gmm (f.phi - {b0} - {b1}*f.ldnpt - {b2}*f.ldrst - {b3}*f.lemp - {rho}*(phi - {b0} - {b1}*ldnpt - {b2}*ldrst - {b3}*lemp - (1-exit_prob))), instruments(f.ldnpt f.ldrst lemp f.lemp phi)


bysort index t: gen productivity = ldsal - 0.2900*ldnpt - 0.2629*ldrst - 0.6485*lemp


* Productivity of Paper Mill sector, unbalanced panel
sum productivity if sic3 == 262

* Productivity of the firms in balanced panel

sum productivity  if sic3 == 262 & panel == 1


* Productivity of all firms
sum productivity

* Productivity of all firms in balanced panelvar
sum productivity if panel == 1

twoway scatter productivity yr if sic3 == 262












