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
- [Model Comparison and Residual Analysis](#Model-Comparison-and-Residual-Analysis)
- [Initial conclusion](#Initial-conclusion)
- [Analysis of the Residuals Vs Leverage Plot](#Analysis-of-the-Residuals-Vs-Leverage-Plot)

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

- Intercept (1.310): The intercept is significant (p < 0.001), indicating the baseline log-odds of hypertension when both sodium and potassium are zero.
- Sodium (sod) (Estimate = -0.007143): A small negative but highly significant effect (p < 0.001), suggesting that increasing sodium reduces the odds of hypertension.
- Potassium (pot) (Estimate = -0.01488): Also significant (p < 0.01), where increasing potassium decreases the odds of hypertension.
- Interaction term (sod:pot) (Estimate = 0.0001704): Highly significant (p < 0.001), suggesting that the relationship between sodium and hypertension depends on the level of potassium.

- P-values: All coefficients (sodium, potassium, and the interaction) are statistically significant (p < 0.05), suggesting that each variable has a significant effect on hypertension when considered with the interaction.
- Model fit: AIC (6368.9) and residual deviance (6360.9): These values ​​indicate the goodness of fit. Compared to the other models, this one has a good fit (smaller AIC indicates better fit).
- Distribution of residuals: The distribution of residuals appears reasonably symmetric, indicating that the model is not violating the assumptions of logistic regression.


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

- Intercept (0.6978): Significant (p < 0.001), indicating the baseline log-odds of hypertension.
- Sodium (sod) (Estimate = -0.001479): Significant with a small negative effect (p < 0.05), suggesting that an increase in sodium slightly reduces the odds of hypertension.
- Potassium (pot) (Estimate = 0.0058456): Significant (p < 0.01), where an increase in potassium increases the odds of hypertension, in contrast to the first model, where potassium was protective when considering the interaction.
- Model fit: AIC (6390.1): The fit is reasonable, but the model with the interaction has a smaller AIC (i.e., it is better).

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

- Intercept (0.7822): The log-odds of a person having hypertension when sodium is zero.
- Sodium (sod) (Estimate = -0.0005257): Not significant (p = 0.349), indicating no strong evidence that sodium alone predicts hypertension in this model.
- Model fit: AIC (6396.3): The highest AIC value indicates that this model has the worst fit among the models analyzed.

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

- Intercept (0.6116): The log-odds of a person having hypertension when potassium is zero.
- Potassium (pot) (Estimate = 0.003487): Marginally significant (p = 0.047), suggesting a small but positive effect on hypertension.
- Model fit: AIC (6393.2): The fit is better than the model with sodium, but still inferior to the model including both parameters or the interaction.

### Model Comparison and Residual Analysis
#### Residual Deviance and AIC:

- Model 1 (sod + pot + sod): AIC = 6368.9
- Model 2 (sod + pot): AIC = 6390.1
- Model 3 (sod only): AIC = 6396.3
- Model 4 (pot only): AIC = 6393.2

The model with the interaction term (Model 1) has the lowest AIC, indicating a better fit compared to the other models.

#### Standardized Residuals:
Across all models, the residuals are relatively small, and the mean is close to zero, which indicates that the models are fitting the data reasonably well. However, some influential points with high leverage and Cook’s distance suggest further investigation is needed, especially for the interaction model.

#### Initial conclusion

- The model including the interaction between sodium and potassium provides the best fit, with both sodium and potassium significantly affecting hypertension when their interaction is considered.
- Without the interaction, potassium seems to have a slightly positive effect on hypertension, while sodium alone does not show a significant impact.
- Further residual analysis and investigation into influential points are needed to refine the models.


### Analysis of the Residuals Vs Leverage Plot

This plot of residuals versus leverage for the hip ~ sod model provides us with some useful information, even though sodium alone did not show statistical significance in the model. Let's interpret the plot in more detail:

<div style="display: flex; justify-content: space-around;">
  <img src="./regLogBin/hipXsod.png" width="500">  
</div>

1. Standardized Residuals (Std. Pearson Residuals):
- The vertical axis shows the standardized residuals, which indicate how much the actual observations deviate from the model predictions. In a good fit, we would expect these residuals to be randomly distributed around zero.
- Here, the residuals appear to be concentrated around zero, but with some outliers, especially at the top and bottom.

2. Leverage:
- The horizontal axis shows the leverage of each point. Leverage indicates the influence of a particular point on the model fit. A high leverage value suggests that a point may have a large impact on the model estimates.
- Most points have low leverage, with a few exceptions near the right side of the plot, where leverage increases. These points should be watched carefully.

3. Cook's Distance:
- The contour lines (dashed and solid) represent Cook's distance, which measures the influence of each point on the overall estimate of the model coefficients.
- In the graph, some points fall outside the Cook's Distance line, suggesting that these points may be influential. These points have high leverage and may be disproportionately affecting the model fit.

4. General interpretation:
- Although the model did not show significance for the effect of sodium on hypertension, the graph reveals that there are some observations that have high leverage and may be influencing the model. These observations are potential candidates for further analysis.

- The fact that some points are far from the bulk of the data (outliers and high leverage points) suggests that there may be omitted variables or behavior not adequately captured in the model, or even measurement errors for these observations.

5. Conclusion:
Even if sodium is not relevant in the statistical model, it is important to observe the points with high leverage and outliers. These may be distorting the model fit and should be investigated further.