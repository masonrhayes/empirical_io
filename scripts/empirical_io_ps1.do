clear
cd "C:\Users\mason\Documents\projects\empirical_io\empirical_io-problem_sets"

use "data\databeer_ps1.dta"

summarize

* Generate P*Z interaction
gen pz = P*Z

*** FIRST-STAGE regression ----------------------
** Regress price on demand shifters (tv party Z) and supply shifters (hp yp)
** THEN find reduced form for quantity too

reg P hp yp tv party pz
predict phat

reg Q hp yp tv party pz
predict qhat

*** SECOND-STAGE -----------------
** Demand Equations
reg Q phat tv party Z pz

** Supply
reg P qhat hp yp Z pz

*** INVERSE Demand Function ----------------
reg P qhat tv party pz

*** INVERSE Supply Function --------
reg Q phat hp yp pz

** Pull coefficients from the SECOND-STAGE Demand Equation
gen qstar = -(1/(-4.042127 - 2.022627*Z))*qhat

*** USING ivreg2
ivreg2 Q (P = hp yp Z pz) tv party Z
ivreg2 P (Q = tv party hp yp pz) hp yp qstar

reg P qhat hp yp qstar

