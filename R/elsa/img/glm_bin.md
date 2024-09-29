![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

## Statistical Analysis of Sodium (sod) and Potassium (pot) on Hypertension (hip)

### Introduction

The following analysis involves fitting multiple logistic regression models to examine the relationship between sodium (sod) and potassium (pot) levels, and their interaction, on hypertension (hip). The binary outcome hip is modeled as a function of the predictors, and the goodness-of-fit is evaluated for each model.

#### Model 1: Sodium, Potassium, and Their Interaction

#### Code:
```r
glm1 <- glm(data = dadosOnda1, hip ~ sod + pot + sod:pot, family = binomial)
summary(glm1)
```
#### Output: 

| Coefficients: | Estimate    | Std. Error  | z value  | Pr(>|z|)    |
|---------------|-------------|-------------|----------|-------------|
| (Intercept)   | 1.310e+00   | 1.500e-01   | 8.738    | <2e-16      |
| sod           | -7.143e-03  | 1.370e-03   | -5.216   | 1.83e-07    |
| pot           | -1.488e-02  | 4.802e-03   | -3.099   | 0.00194     |
| sod:pot       | 1.704e-04   | 3.626e-05   | 4.699    | 2.61e-06    |


| Variável | Valor | Descrição |
| -------- | ----- | ----------- |
| A        | 1     | Inteiro     |
| B        | 2     |             |




#### Interpretation:

- Intercept: The intercept is significant (p < 0.001), indicating the baseline log-odds of hypertension when both sodium and potassium are zero.
- Sodium (sod): A small negative but highly significant effect (p < 0.001), suggesting that increasing sodium reduces the odds of hypertension.
- Potassium (pot): Also significant (p < 0.01), where increasing potassium decreases the odds of hypertension.
- Interaction term (sod): Highly significant (p < 0.001), suggesting that the relationship between sodium and hypertension depends on the level of potassium.