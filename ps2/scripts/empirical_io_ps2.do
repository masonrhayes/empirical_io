clear

cd "C:\Users\mason\Documents\projects\empirical_io\empirical_io-problem_sets\ps2"

use data/cars_ps


gen MSIZE = pop/3
* gen market_share = qu/households

sum qu households co



reg princ firm i.co i.country width height weight horsepower households

predict phat

reg qu firm i.co i.country width height weight horsepower households

predict qhat



** Define product 0 as volkswagen golf, co = 285

egen yearcountry=group(year country), label

xtset co yearcountry

mergersim init, price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel = firm yearcountry width height weight horsepower), fe


