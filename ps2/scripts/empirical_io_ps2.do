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
** (iii) the number of products, and the sums of the characteristics of competing products belonging to the same subgroup, interacted with the set of subgroup dummy variables and
** (iv) the number of products and the sums of the characteristics of competing products belonging to the same group, interacted with the set of group dummy variables


** Sum fuel for each class in each year and country
egen fuel_by_class = total(fuel), by(yearcountry class)
** Do the same thing for firms
egen fuel_by_firm = total(fuel), by(yearcountry class firm)
** The fuel of other firms is the difference of the previous two variables
gen fuel_of_others = fuel_by_class - fuel_by_firm

egen fuel_by_firm_and_class = total(fuel), by(firm class)

egen hp_by_class = total(horsepower), by(yearcountry class)
egen hp_by_firm = total(horsepower), by(yearcountry class firm)
gen hp_of_others = hp_by_class - hp_by_firm

egen weight_by_class = total(weight), by(yearcountry class)
egen weight_by_firm = total(weight), by(yearcountry class firm)
gen weight_of_others = weight_by_class - weight_by_firm

egen height_by_class = total(height), by(yearcountry class)
egen height_by_firm = total(height), by(yearcountry class firm)
gen height_of_others = height_by_class - height_by_firm


egen width_by_class = total(width), by(yearcountry class)
egen width_by_firm = total(width), by(yearcountry class firm)
gen width_of_others = width_by_class - width_by_firm


** How many distinct products does a firm have in a given year and country?
egen number_co = count(co), by(yearcountry class firm)
** How many total distinct products of all firms in a given year and country?
egen other_products = count(co), by(yearcountry class)

** The difference of that is the number of products of *other* firms
replace other_products = other_products - number_co



** Question 1. Be sure to run all the above code 1 time before running:

mergersim init, price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel = weight width height horsepower weight_by_firm width_by_firm height_by_firm hp_by_firm fuel_by_firm fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products year country2-country5), fe vce(robust)

** Simulate pre-merger market conditions. With these instruments, MC is shown as negative...strange results. Maybe indicates that instruments are wrong or inadequate

mergersim market if year == 1999


* Question 2

** The marginal costs and lerner indicies here make sense. And alpha < 0 and 0 < sigma1 < 1

mergersim init, nests(class) price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel M_lsjg = weight width height horsepower weight_by_firm width_by_firm height_by_firm hp_by_firm fuel_by_firm fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products year country2-country5), fe vce(robust)

mergersim market if year == 1999

* Question 3
mergersim init, nests(domestic class) price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel M_lsjh M_lshg = height width weight horsepower weight_by_firm width_by_firm height_by_firm hp_by_firm fuel_by_firm fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products year country2-country5), fe vce(robust)

* Interaction terms??
** c.fuel_of_others#i.class c.hp_of_others#i.class c.weight_of_others#i.class c.width_of_others#i.class c.height_of_others#i.class c.other_products#i.class c.fuel_of_others#i.domestic c.width_of_others#i.domestic c.other_products#i.domestic c.fuel_of_others#i.domestic c.hp_of_others#i.domestic c.weight_of_others#i.domestic c.height_of_others#i.domestic c.fuel_of_others#i.domestic

** Adding these just makes the model even worse

** ERROR: Sigma 2 should be less than Sigma 1... We find negative MC and very high LI
mergersim market if year == 1999


* We are not given any information on what is the "new EU 2021 fuel standard" so I take the information from https://ec.europa.eu/clima/policies/transport/vehicles/cars_en#tab-0-0

* They list 4.1 liters/100km as the target fuel consumption.

** Codes for firms: AlfaRomeo = 1, kia = 9

** Testing a merger that we are sure would have some effect: a merger between BMW and Volkswagen

mergersim simulate if year == 1999 & country == 3, seller(2) buyer(26) detail

*** a high decrease in CS and a large (but smaller) increase in PS makes sense with this merger



**** The merger of interest: Kia & AlfaRomeo in 1999 in Germany ****

** No effect if MC does not change
mergersim simulate if year == 1999 & country == 3, seller(1) buyer(9) detail


** If both firms have a decrease of MC by 1%

mergersim simulate if year == 1999 & country == 3, seller(1) buyer(9) sellereff(0.01) buyereff(0.01) detail

** The results are strange: both CS and PS decrease, but very little. We would expect them to increase from the synergies of lower MC

**** TESTING with other firms ****


** If Suzuki (low avg fuel expenditure 4.87) merges with BMW (high avg fuel expenditure of 7.33)
mergersim simulate if year == 1999 & country == 3, seller(24) buyer(2) detail

** Results of a Suzuki-BMW merger seem reasonable, with consumer surplus dropping and producer surplus increasing. Now testing with marginal cost dropping by 1%

mergersim simulate if year == 1999 & country == 3, seller(24) buyer(2) sellereff(0.01) buyereff(0.01) detail

** Consumer surplus increases, which we would expect. However, producer surplus actually falls... Since this model has a sigma2 > sigma1, this may explain why we find strange results.



*** Retrying Q4 with Q2 model (nest only by class, not by domestic and class)


mergersim init, nest(class) price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel M_lsjg = weight width height horsepower weight_by_firm width_by_firm height_by_firm hp_by_firm fuel_by_firm fuel_of_others hp_of_others weight_of_others height_of_others width_of_others other_products year country2-country5), fe vce(robust)

** Testing a merger that we are sure would have some effect: a merger between BMW and Volkswagen

mergersim simulate if year == 1999 & country == 3, seller(2) buyer(26) detail

mergersim simulate if year == 1999 & country == 3, seller(2) buyer(26) sellereff(0.01) buyereff(0.01) detail


**** The Merger of Interest: Kia and AlfaRomeo ****


** As before, no effect if MC does not change
mergersim simulate if year == 1999 & country == 3, seller(1) buyer(9) detail


** If both firms have a decrease of MC by 1%

mergersim simulate if year == 1999 & country == 3, seller(1) buyer(9) sellereff(0.01) buyereff(0.01) detail

** This model makes a little more economic sense than the two-nested model: a decrease in MC should result in slightly higher consumer surplus. However, why does PS decrease?



mergersim simulate if year == 1999 & country == 3, seller(24) buyer(2) detail





** If Suzuki (low avg fuel expenditure 4.87) merges with BMW (high avg fuel expenditure of 7.33)
mergersim simulate if year == 1999 & country == 3, seller(24) buyer(2) detail


mergersim simulate if year == 1999 & country == 3, seller(24) buyer(2) sellereff(0.01) buyereff(0.01) detail



