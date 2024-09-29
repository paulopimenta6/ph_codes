![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

## Statistical Analysis of Sodium (sod) and Potassium (pot) on Hypertension (hip)

### Summary

- [Introduction](#Introduction)
- [Model 1: Sodium, Potassium, and Their Interaction](#Model-1-Sodium-Potassium-and-Their-Interaction)
- [Model 2: Sodium and Potassium without Interaction](#Model-2-Sodium-and-Potassium-without-Interaction)
- [Model 3: Sodium Only](#Model-3-Sodium-Only)
- [Model 4: Potassium Only](#Model-4-Potassium-Only)



### Introduction

The following analysis involves fitting multiple logistic regression models to examine the relationship between sodium (sod) and potassium (pot) levels, and their interaction, on hypertension (hip). The binary outcome hip is modeled as a function of the predictors, and the goodness-of-fit is evaluated for each model.

### Model 1: Sodium, Potassium, and Their Interaction

#### Code:
```r
glm1 <- glm(data = dadosOnda1, hip ~ sod + pot + sod:pot, family = binomial)
summary(glm1)
```
#### Output: 

| Coefficients  | Estimate    | Std. Error  | z value |  Pr(>\|z\|)   |
|---------------|-------------|--------------|---------|------------|
| (Intercept)   | 1.310e+00   | 1.500e-01    | 8.738   | <2e-16 *** |
| sod           | -7.143e-03  | 1.370e-03    | -5.216  | 1.83e-07 ***|
| pot           | -1.488e-02  | 4.802e-03    | -3.099  | 0.00194 ** |
| sod:pot       | 1.704e-04   | 3.626e-05    | 4.699   | 2.61e-06 ***|


#### Interpretation:

- Intercept: The intercept is significant (p < 0.001), indicating the baseline log-odds of hypertension when both sodium and potassium are zero.
- Sodium (sod): A small negative but highly significant effect (p < 0.001), suggesting that increasing sodium reduces the odds of hypertension.
- Potassium (pot): Also significant (p < 0.01), where increasing potassium decreases the odds of hypertension.
- Interaction term (sod): Highly significant (p < 0.001), suggesting that the relationship between sodium and hypertension depends on the level of potassium.

### Model 2: Sodium and Potassium without Interaction

#### Code:
```r
glm2 <- glm(data = dadosOnda1, hip ~ sod + pot, family = binomial)
summary(glm2)
```

#### Output:

|Coefficients   | Estimate    | Std. Error   | z value | Pr(>\|z\|) |   
|---------------|-------------|--------------|---------|------------|
| (Intercept)   | 0.6978450   | 0.0747443    | 9.336   | < 2e-16 ***|
| sod           | -0.0014792  | 0.0006526    |-2.267   | 0.02342 *  | 
| pot           | 0.0058456   | 0.0020583    | 2.840   | 0.00451 ** |

#### Interpretation:

- Intercept: Significant (p < 0.001), indicating the baseline log-odds of hypertension.
- Sodium (sod): Significant with a small negative effect (p < 0.05), suggesting that an increase in sodium slightly reduces the odds of hypertension.
- Potassium (pot): Significant (p < 0.01), where an increase in potassium increases the odds of hypertension, in contrast to the first model, where potassium was protective when considering the interaction.

### Model 3: Sodium Only

#### Code:

```r
glm3 <- glm(data = dadosOnda1, hip ~ sod, family = binomial)
summary(glm3)
```

#### Output:

| Coefficients  | Estimate    | Std. Error   | z value | Pr(>\|z\|) |
|---------------|-------------|--------------|---------|------------|    
| (Intercept)   | 0.7821783   | 0.0687462    | 11.378  | <2e-16 *** | 
| sod           | -0.0005257  | 0.0005619    | -0.936  |  0.349     |

#### Interpretation:

- Sodium (sod): Not significant (p = 0.349), indicating no strong evidence that sodium alone predicts hypertension in this model.

### Model 4: Potassium Only

#### Code: 
```r
glm4 <- glm(data = dadosOnda1, hip ~ pot, family = binomial)
summary(glm4)
```

#### Output:

| Coefficients  |  Estimate   | Std. Error   | z value | Pr(>\|z\|) |
|---------------|-------------|--------------|---------|------------|    
| (Intercept)   | 0.611647    | 0.063982     | 9.560   | <2e-16 *** |
| pot           | 0.003487    | 0.001757     | 1.984   | 0.0473 *   |

#### Interpretation: 

- Potassium (pot): Marginally significant (p = 0.047), suggesting a small but positive effect on hypertension.