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

reg P hp yp tv party pz hpz ypz
predict phat

reg Q hp yp tv party pz hpz ypz
predict qhat

*** SECOND-STAGE -----------------
** Demand Equations
reg Q phat tv party pz hpz ypz

** Supply
reg P qhat hp yp hpz ypz

*** INVERSE Demand Function ----------------
reg P qhat tv party pz

*** INVERSE Supply Function --------
reg Q phat hp yp pz hpz ypz

** Pull coefficients from the SECOND-STAGE Demand Equation
gen qstar = -(1/(-4.027677 - 2.006747*Z))*qhat

*** USING ivreg2
ivreg2 Q (P = hp yp Z pz) tv party Z
ivreg2 P (Q = tv party hp yp pz) hp yp qstar

reg P qhat hp yp qstar

