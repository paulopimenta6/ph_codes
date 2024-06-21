![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

# Statistics

## Summary

- [About statistical Analysis](#About-statistical-Analysis)
- [Descriptive Statistics](#Descriptive-Statistics)
- [non-Parametric analysis](#non--Parametric-analysis)
- [Correlation and regression analysis](#Correlation-and-regression-analysis)
- [Tutorial for regression analysis](#Tutorial-for-regression-analysis)

## About statistical Analysis

This section is dedicated to statistical analyses divided into two parts: Descriptive and non-parametric. The descriptive part analyzed the data, performed initial treatments, and subsequently created graphs in which one or two variables appeared in combination. Non-parametric statistics were an alternative to classical methods because the analyzed data did not have a normal distribution, and thus, the data were analyzed using the Friedman and Wilcoxon methods (both paired). There is a section dedicated to time series and correlations of pollution analyses.

It is hoped that these results can help in the perception of patterns and indices that relate pollution to kidney diseases.

## Descriptive Statistics
[Descriptive Statistics](./analysis.md)

## Non-Parametric analysis
[non-Parametric analysis](./non_parametric.md)

## Time series analysis

Time series analysis involves the study of datasets that are ordered sequentially over time. The primary goal is to understand the underlying structure and function that produced the observations, and to forecast future values. In this project, time series analysis was used to study trends and patterns in the data related to pollution and kidney disease variables over time.

## Correlation and regression analysis
[Correlation and regression analysis](./corr_and_regression.md)

## Tutorial for regression analysis

This tutorial will explore the statistical methods used in our analysis. We focus on the following key aspects:

#### Normality of Residuals:
Test the normality of residuals using the Anderson-Darling normality test. The test statistic and p-value are reported.

#### Outliers in Residuals:
Examine outliers in residuals by calculating the minimum, 1st quartile, median, mean, 3rd quartile, and maximum values.

#### Independence of Residuals (Durbin-Watson):
Assess the independence of residuals using the Durbin-Watson statistic. The lag, autocorrelation, D-W statistic, and p-value are provided.

#### Homoscedasticity (Breusch-Pagan):
Homoscedasticity is tested using the studentized Breusch-Pagan test. The Breusch-Pagan statistic, degrees of freedom, and p-value are reported.

#### Model Analysis:
Analyze the model using linear regression. The model formula, residuals, coefficients, standard errors, t-values, and p-values are provided. The significance levels and provide interpretations of the results. By the end of this tutorial, you will have a comprehensive understanding of the statistical methods employed in our analysis.

#### Usage:
```R
##Normality test for residuals
ad.test      # p =< 0.05 then residue is not normal
             # p > 0.05 then residue is normal      

##Outliers in the residuals:
summary(rstandard)              # Outliers and leverage points                                
                                # Residuals "max" above value 3, i.e., not between -3 to 3
                                # With max value above 3, i.e., presence of outlier and leverage point
                                

##Independence of residuals (Durbin-Watson):
durbinWatsonTest                # D-W should be between 1 to 3, hence the value will be consistent 
                                # H0: p > 0.05: autocorrelation = 0: independence of residuals
                                # H: p =< 0.05: autocorrelation != 0: no independence of residuals   

## Homoscedasticity (Breusch-Pagan):
bptest                          # p > 0.05: homoscedasticity exists
                                # p =< 0.05: homoscedasticity does not exist      

#Model analysis
summary                        # p > 0.05: coefficient = 0: independent variable has no impact on dependent variable
                               # p =< 0.05: coefficient != 0 independent variable has impact on dependent variable
                               # For every increase/decrease of 1 unit of x (independent variable) the value of the dependent variable increases proportionally to the coefficient   

#F-statistic

                               # R^2 is the best indicator as it relates to simple (linear) regression
                               # R^2 the consumption of the independent variable in percentage explains that of the dependent variable
                               # p =< 0.05 there is a difference between the models
                               # p > 0.05 there is no difference between the models
                               # H0: the value of the mean of the independent variable x occurs independently of the consumption of the dependent variable (without predictor)
                               # H: the value of the dependent variable occurs due to the consumption of the independent variable (with predictor) 
```