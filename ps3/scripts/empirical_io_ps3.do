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
drop if panel == 0

xtreg ldsal ldnpt ldrst lemp i.yr, fe vce(robust)


* Be sure to re-run the lines 1-14 and 31-34 since non-panel observations were dropped in the previous question.

* exit = 1 if firm exits sometime between the last observed period and the next period

gen exit = 0
bysort index: replace exit =1 if yr[_n+1] != yr[_n] + 5 & yr[_n] != 88

xtprobit exit lemp ldnpt ldrst ldinv

















