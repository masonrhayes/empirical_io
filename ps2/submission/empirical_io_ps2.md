# Question 1

I use the `mergersim` package as outlined in the "Merger Simulation with Nested Logit Demand" article  [@http://zotero.org/users/6599746/items/C373Y25F]. 

The baseline two-level nested logit model is given by:

$$
\ln(\dfrac{s_j}{s_0}) = \beta x_{tj} + \alpha p_{tj} + \sigma_1 \ln(s_{tj \mid hg}) + \sigma_2 \ln(s_{th \mid g}) + \xi_{tj} 
$$

and the one-level nested logit model introduces $\sigma_2 = 0$ respectively by eliminating the subgroup nesting.

Using `xtset`, I again follow Björnerstedt and Verboven (2014) by timesetting the data, with product meaning a unique value of `co` (a unique brand and model combination) and market meaning a particular country in a given year.

## Defining Instruments

Following the prominent literature, I choose instruments for the endogenous variables of price, fuel, and market shares as follows [@http://zotero.org/users/6599746/items/WYLXKEVD]:

1. Product characteristics
2. Number of products in a market (i.e. in a given year, class, and country)
     * For firm $i$
     * The sum of all products for all firms $j \neq i$
3. Sum of product characteristics of the firm for a given year, class and country
    * Sum of product characteristics for all other firms $j \neq i$ in that year, class and country


If "firms choose fuel consumption strategically in response to competitors and quickly adjust engines in response to new market information", then we would expect that market (year and country) and class (luxury cars are not directly competing with small cars) are important, and that the product characteristics of a firm's competitors in a market and a class are important information that indicate to a firm to adjust engines or not. 

The instruments I have chosen should account for this information.


## Q1 Model

The calculation of the instrumental variables is contained in `empirical_io_ps2.do`. The model in stata, using the package `mergersim` is given by:

```r
mergersim init, price(princ) quantity(qu) marketsize(MSIZE) firm(firm)

xtivreg M_ls (princ fuel = weight width height horsepower weight_by_firm 
              width_by_firm height_by_firm hp_by_firm fuel_by_firm
              fuel_of_others hp_of_others weight_of_others 
              height_of_others width_of_others other_products 
              year country2-country5), fe vce(robust)
```

# Question 2

Now we nest by `class`, running the same code as above but adding the line `nests(class)` in its respective position after initializing the merger simulation.

The estimated log of the group market share `M_lsjg` is also endogenous, so I also instrument for this.

Referring to the equation in Question 1, I find $\alpha = -0.958$ and $\sigma_1 = 0.903$, which fits the model restrictions of $\alpha < 0 < \sigma_1 < \sigma_2 <1$.


# Question 3

To estimate the two-level nested logit model, I add `nests(domestic class)` respectively. The estimated log of the group and subgroup market shares are also instrumented as before.

I find the following estimated coefficients:

| Parameters      | One-level Nested Logit | Two-level Nested Logit |
|-----------------|------------------------|------------------------|
| $\hat \alpha$   | -0.958                 | -0.907                 |
| $\hat \sigma_1$ | 0.903                  | 0.213                  |
| $\hat \sigma_2$ | --                     | 0.896                  |

However, note that in the two-level nested model, $\hat \sigma_2 > \hat \sigma_1$ which does not meet the restriction $\alpha < 0 < \sigma_1 < \sigma_2 <1$.

Additionally, the 95% confidence intervals for $\hat \sigma_1$ and $\hat \sigma_2$ do not overlap, and $\sigma_2$ is not statistically significantly less than 1. These issues suggest either a problem the data, a problem with the model, that I have made an error in constructing the instrumental variables, or that I have failed to use some important instruments.


# Question 4


No information is provided on what is the "new EU 2021 fuel standard" so I take the information from [the European Commission](https://ec.europa.eu/clima/policies/transport/vehicles/cars_en#tab-0-0), which indicates a 2020-2021 fuel efficiency target of 4.1 liters/100km as the target fuel consumption.

Note however that while `fuel efficiency` is defined as "fuel consumption in liters per 100 km" in the Problem Set 2, in the dataset itself, `cars_ps.dta`, fuel efficiency is defined as "liter per km (at 90 km/h)". I simply assume that this is a mistake so that it makes sense to proceed.


## Q4 Model

### Looking at an 'Ideal' Case: BMW & VW Merger

I choose to use the Q2 model – the one-level nested logit model – for this question. 

Before analyzing the Kia-AlfaRomeo merger, I first look at mergers that I would expect have a very large effect in the market. For example, I estimate a merger between BMW and Volkswagen in Germany in 1999:


| Change in        | No change in MC | 1% drop in MC |
|------------------|-----------------|---------------|
| Consumer surplus | -17,510         | -11,848       |
| Producer surplus | 12,557          | 14,934        |

These results fit what we would expect: a merger between such large firms with high market shares result in a drop in CS but an increase in PS. And, a fall in marginal costs slightly offsets the drop in CS. Note additionally that total welfare is lower in the case of no change in MC, but higher if MC drops by 1%.

Now, let us see if the merger with Kia and AlfaRomeo exhibits similar properties


### The Kia & AlfaRomeo Merger

Kia and AlfaRomeo have lower market shares than do BMW or VW:


|                       | BMW   | VW    | Kia   | AlfaRomeo |
|-----------------------|-------|-------|-------|-----------|
| Mean log market share | -7.58 | -7.21 | -9.34 | -8.11     |

Note that the variable `M_ls`, which is equal to $\ln(\dfrac{s_j}{s_0})$, is always negative since it must be the case that $0 < \frac{s_j}{s_0} < 1$. So, a higher absolute value of `M_ls` indicates a lower market share.

Thus, I expect a similar but less extreme effect in the market from a Kia AlfaRomeo merger than from a BMW Volkswagen merger.

I find very little change in surplus following the merger:


| Change in        | No change in MC | 1% drop in MC |
|------------------|-----------------|---------------|
| Consumer surplus | 0               | 74            |
| Producer surplus | 0               | -20           |

Strangely, I find that a drop in MC actually leads to a small reduction in PS. However, it does lead to greater total surplus and greater CS, as predicted.


### Computing the counterfactual quantities and prices

The prices and quantities are found by using the estimated $\hat \alpha$ and $\hat \sigma_1$ in a differentiated product horizontal merger, where competition is in the form of price (Bertrand competition). The equilibrium is then computed by finding the Bertrand-Nash equilibrium given the change in MC from the merger, the combined market share and product characteristics, expected profits given the reactions of competitors, etc.

As discussed in lecture, for each product $j$, the `mergersim` package solves the system of $j$ equations of $j$ unknown prices. Whether using Fixed Point or Newton methods (Newton is the default), the results are very similar.


### The effects of the fuel standard on market surplus


Assuming that the fuel standard has only the impacts that I calculated in Question 4 under the Kia AlfaRomeo merger, then there is an increase in total and consumer surplus. CS increases by 74 and TS by 54.

However, from such a fuel standard we may have other firms with high costs merging with firms with low fuel costs. For example, if Suzuki (low fuel expenditure of 4.87) merges with BMW (high avg fuel expenditure of 7.33), we have:


| Change in        | No change in MC | 1% drop in MC |
|------------------|-----------------|---------------|
| Consumer surplus | -232            | 2,653         |
| Producer surplus | 223             | -556          |
| Total surplus    | -9              | 2097          |

In short, the effect depends on the efficiency benefits of mergers of low-fuel-efficiency and high-fuel-efficiency firms. If marginal costs are indeed reduced, mergers are expected to occur and total surplus to increase.

If there are no efficiency benefits, then mergers may occur to follow regulations but the efficiency benefits may be neutral. This makes since – for firms with low fuel efficiency, they can purchase firms that are very fuel efficient and thereby have a high average fuel efficiency without changing any products.

# References

