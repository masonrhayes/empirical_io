# Question 1

## Demand and Cost Specification

Quantity consumed (demand) is given by

$$
Q = \beta_0 + \beta_1 P + \beta_2 tv + \beta_3 party + \beta_4 Z + \varepsilon
$$


Supply is estimated by

$$
P = \alpha_0 + \alpha_1 Q + \alpha_2 hp + \alpha_3 yp + \omega
$$


Our cost specification is


$$
C^\prime(\dfrac{Q}{N}) = d_0 + D_1 \dfrac{Q}{N} + d_2 hp + d_3 yp  + \omega
$$



## Empirical Model


$$
Q = \alpha_0 + \alpha_1 \hat P + \alpha_2 tv + \alpha_3 party + \alpha_4 \hat P Z + e
$$


$$
P = \beta_0 + \beta_1 \hat Q + \beta_2 hp + \beta_3 yp - \phi \dfrac{\hat Q}{\alpha_1 + \alpha_4 Z} + u
$$

where $\phi$ is the conduct parameter.


and we have the equilibrium condition with $d_1 = D_1/N$ that:


$$
P + \phi \dfrac{Q}{\alpha_1} = d_0 + d_1 Q + d_2 hp + d_3 yp + \omega
$$

# Question 2


## Choice of Instruments


| Variable                   | Instruments Used                   |
|----------------------------|------------------------------------|
| Price (supply)             | yp, hp (in demand equation)        |
| Quantity consumed (demand) | tv, party, pz (in supply equation) |

Price of hops and price of yeast are used as price instruments, since they should transmit only through the supply side by increasing the cost of producing beer. Assuming price and quantity do not change, there is no economic justification for why consumers' beer consumption should change given a change in the prices of these two inputs.

Number of sports viewers, number of parties, and week before pay (we have to assume that people are paid in the first week of the month) are used as instruments for beer consumption. This is because, at a given equilibrium, an increase in sports viewers or an increase in party-goers will (we hypothesize) increase demand for beer, but leave supply unaffected.


## Biasedness of OLS

If we do not use $\hat P$ in the OLS estimation, then our estimated demand parameters are biased upwards. In particular, the absolute value of the (negative) coefficent for price is lower. This is because when we observe only quantity and price, we may find that they increase or decrease with one another, but we are not observing the exogenous shifts. 

An increase in quantity demanded for example might shift the price upwards and an increase in price might decrease demand, but we cannot observe this without exogenous demand and supply shifters. This is why we use either reduced form estimation or instrumental variables to obtain our results.

## First stage: reduced form

We estimate the following reduced form equations in the first stage by regression $P$ and $Q$ on exogenous covariates:

$$
P = b_0 + b_1 hp + b_2 yp + b_3 tv + b_4 party + b_5 pz + \varepsilon
$$

and

$$
Q =  a_0 + a_1 hp + a_2 yp + a_3 tv + a_4 party + a_5 pz + \omega
$$


Stata code to esimate these two equations is below:

```r
reg P hp yp tv party pz

reg Q hp yp tv party pz
```

After regressing $Q$ and $P$ on the respective covariates, we estimate $\hat Q$ and $\hat P$.


## Demand and Inverse Demand

Demand is given by

$$
Q = \alpha_0 + \alpha_1 \hat P + \alpha_2 tv + \alpha_3 party + \alpha_4 \hat P Z + e
$$

which we estimate with either of the following two commands:

```r
reg Q phat tv party pz

ivreg2 Q (P = hp yp) tv party pz
```

Inverse demand is respectively estimated with the following:

```r
reg P qhat tv party pz

ivreg2 P (Q = hp yp) tv party pz
```

## Elasticity Estimation

We confirm that price elasticity of demand is 50% higher when $Z = 1$. We estimate that $\alpha_1$, the coefficient for $\hat P$ in the demand equation, is $-4.04$ and that the coefficient for $\alpha_4 = -2.02$. This means that when $Z=1$, a price increase of 1 dollar has a 50% larger effect on quantity consumed than in weeks when $Z = 0$. Note that for each of these coefficient estimates, $p << 0.01$


# Question 3 

## Supply and Inverse Supply

From our empirical model, supply is given by the equation:

$$
P = \beta_0 + \beta_1 \hat Q + \beta_2 hp + \beta_3 yp - \phi \dfrac{\hat Q}{\alpha_1 + \alpha_4 Z} + u
$$

and we run regressions just as we did for the demand equations, but with respect to supply and with the appropriate instruments. From the demand equation, we have estimated $\alpha_1$ and $\alpha_2$ and with these values we can generate $Q^\star$ and run the following

```r
gen qstar = -(1/(-4.042743 - 2.01948*Z))*qhat

ivreg2 P (Q qstar = tv party pz) hp yp
```

We estimate that $\beta_1 = 2.90$ and $\phi = 0.83$. However, the 95% confidence interval for $\phi$ is quite high: $CI(\phi) =  (0.290. 1.377)$.

# Question 4

In Question 3 we have found that $\phi = 0.83$, with a 95% confidence interval of $CI(\phi) =  (0.290. 1.377)$. While we do not have a precise estimate of $\phi$, we can say that this is not a Cournot market. Under Cournot, we would expect that $\phi = \dfrac{1}{5}$ since $N =5$. So, we can say that this market is less competitive than under Cournot; there is some degree of collusion. Normally we would interpret the actual different from the Cournot standard using the standard errors and hypothesis testing, however as our standard errors are not corrected we can not do that.


# Question 5


If a cartel was formed we would expect a conduct parameter of $\phi = 1$, as occurs under a monopoly. To work out equilibrium quantity and price in this hypothetical forming of a cartel, we take our parameters estimated for the supply and demand models, plug in our conduct parameter as 1, take averages of all of our variables and plug them in as the variable equilibrium value and solve.


$$
Q = 22.594 - 4.043 P + 0.2516 * 2500 + 2.02 * 100 - 2.02 P * 0.25
$$


$$
P = 3.244 + 2.90 * Q + 1.489 * 40 + 1.987 * 20.06 - \dfrac{Q}{-4.04 - (2.02 *0.25)} + u
$$


Which can be simplified as:

$$
Q = 854.66 - 4.548 P
$$


$$
P = 102.665 + 3.122 Q
$$

Solving for which gives:


$$
Q = 25.51
$$

$$
P = 182.31
$$


These numbers make sense: the mean Q in the dataset is 27.23. With $\phi = 1$, we expected quantity to drop since there is a cartel, and we have found that this is indeed the case.