clear
cd "C:\Users\mason\Documents\projects\empirical_io\empirical_io-problem_sets"

use "data\databeer_ps1.dta"

summarize

* Generate P*Z interaction
gen pz = P*Z
gen hpz = hp*Z
gen ypz = yp*Z

*** FIRST-STAGE regression ----------------------
** Regress price on demand shifters (tv party Z) and supply shifters (hp yp)
** THEN find reduced form for quantity too

reg P hp yp tv party pz
predict phat

* gen phz = phat*Z 

reg Q hp yp tv party pz
predict qhat

*** SECOND-STAGE -----------------
** Demand Equations

reg Q phat tv party pz

* The demand equation above is the same as

ivreg2 Q (P = hp yp) tv party pz

** Supply
reg P qhat hp yp


** Supply is also given by

ivreg2 P (Q = tv party pz) hp yp

*** INVERSE Demand Function ----------------
reg P qhat tv party pz

** Inverse demand can also be found with IV
ivreg2 P (Q = hp yp) tv party pz

*** INVERSE Supply Function --------
reg Q phat hp yp

* Inverse supply is also the same as
ivreg2 Q (P = tv party pz) hp yp

** Pull coefficients from the SECOND-STAGE Demand Equation
gen qstar = -(1/(-4.042743 - 2.01948*Z))*qhat

*** USING ivreg2; adding hpz and ypz interaction terms does not change the demand equation
ivreg2 Q (P pz = hp yp hpz ypz) tv party


ivreg2 P (Q qstar = tv party pz) hp yp



**** QUESTION 5

mean P tv party pz
sum P tv party pz

