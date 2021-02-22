****** TO RUN before each Question ******

clear

cd "C:\Users\mason\Documents\projects\empirical_io\empirical_io-problem_sets\ps2"

use data/cars_ps

gen MSIZE = pop/3

egen yearcountry=group(year country), label

xtset co yearcountry

****** END of preliminary steps ******

** We need to create instruments for price, fuel economy, and (sub)group market shares, which are all endogenous.

** For example we need to create a variable fuel_of_others that is the sum of fuel for all products that are not product j

** We need the following instruments as from Brenkers and Verboven 2006:
** (i) the products' observed characteristics,
** (ii) the number of products, and the sums of characteristics of other products of the same firm belonging to the same subgroup, interacted with the set of subgroup dummy variables
** (iii) the number of products, and the sums of the characteristics of competing products belonging to the same subgroup, interacted with the set of subgroup dummy variables andiv
** (iv) the number of productsand the sums of the characteristics of competing products belonging to the same group, interacted with the set of group dummy variables


egen fuel_by_class = total(fuel), by(class)
egen fuel_by_model = total(fuel), by(co)
gen fuel_of_others = fuel_by_class - fuel_by_model

egen hp_by_class = total(horsepower), by(class)
egen hp_by_model = total(horsepower), by(co)
gen hp_of_others = hp_by_class - hp_by_model

egen weight_by_class = total(weight), by(class)
egen weight_by_model = total(weight), by(co)
gen weight_of_others = weight_by_class - weight_by_model

egen height_by_class = total(height), by(class)
egen height_by_model = total(height), by(co)
gen height_of_others = height_by_class - height_by_model


egen width_by_class = total(width), by(class)
egen width_by_model = total(width), by(co)
gen width_of_others = width_by_class - width_by_model



egen number_co = count(co), by(co)



egen other_products = count(co)
replace other_products = other_products - number_co


** Question 1

mergersim init, price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel = domestic width height horsepower fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products i.class yearcountry), fe

** Simulate pre-merger market conditions

mergersim market if year == 1998


* Question 2

** Here we find negative marginal costs; there is likely some error in the model or the instrument calculation..

mergersim init, nest(class) price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel M_lsjg = domestic width height horsepower fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products yearcountry), fe

mergersim market if year == 1998

* Question 3
mergersim init, nest(domestic class) price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel M_lsjh M_lshg = width height horsepower fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products), fe

mergersim market if year == 1998















