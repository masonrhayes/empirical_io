clear
cd "C:\Users\mason\Documents\projects\empirical_io\empirical_io-problem_sets"

use "data\databeer_ps1.dta"

summarize

* Generate log price and log quantity
gen lP = log(P)
gen lQ = log(Q)

summarize

* Generate P*Z interaction
gen pz = P*Z

*** FIRST-STAGE regression ----------------------
** Regress price on demand shifters (tv party Z) and supply shifters (hp yp)
** THEN find reduced form for quantity too

reg P hp yp tv party Z
predict phat

reg Q hp yp tv party Z
predict qhat

*** SECOND-STAGE -----------------
** Demand Equations
reg Q phat tv party Z

** Supply
reg P qhat hp yp

*** INVERSE Demand Function ----------------




*** USING ivreg2
* ivreg2 Q (P = hp yp) tv party Z
ivreg2 P (Q = tv party Z) hp yp

