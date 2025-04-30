![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

# Summary

- [Random Forest (kNN)](#Random-Forest-knn)
- [Random Forest (pmm)](#Random-Forest-pmm)
- [kNN](#kNN)
- [pmm](#pmm)

# Logistic regression (kNN)

### Wave 1 

#### Logistic regression Results

#### Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 3410  |
| 1     | 1651  |

#### Class Distribution After Undersampling
| Class | Count |
|-------|-------|
| N (0) | 1651  |
| S (1) | 1651  |

#### Summary Statistics of Key Predictors
| Variable    | Description         | Min   | 1st Qu | Median | Mean  | 3rd Qu | Max    |
|-------------|----------------------|-------|--------|--------|-------|--------|--------|
| **pot**     | Potassium intake      | 4.00  | 20.00  | 29.00  | 32.52 | 41.00  | 144.00 |
| **sod**     | Sodium intake         | 9.00  | 69.00  | 101.00 | 109.30| 144.00 | 327.00 |
| **albCreat**| Albumin–Creatinine    | 1.83  | 5.09   | 6.60   | 19.61 | 8.59   | 5014.83|
| **taxaFilt**| GFR class (counts)    | 1 (1959), 2 (2864), 3 (200), 4 (25), 5 (7), 6 (6) | | | | | |
| **pas**     | Systolic BP           | 77.00 | 108.00 | 118.00 | 119.80| 129.00 | 219.50 |
| **pad**     | Diastolic BP          | 44.50 | 67.50  | 74.50  | 75.19 | 82.00  | 131.50 |


#### Random Forest: Model Summary – Initial

```r
randomForest(
  formula    = hip ~ .,
  data       = train,
  ntree      = 500,
  importance = TRUE
)

OOB estimate of  error rate: 25.39%
```

| Actual \ Predicted |  S  |  N  | Class Error |
|--------------------|-----|-----|-------------|
| **S**              | 783 | 373 |      0.3227 |
| **N**              | 214 | 942 |      0.1851 |



- **Accuracy:** 0.7273  
- **95% CI:** (0.6984, 0.7548)
- **Sensitivity** (Recall for S): 0.7192 
- **Specificity:** 0.7354   
- **Precision** (for S): 0.7310 
- **AUC:** 0.8142108
- **Balanced Accuracy:** 0.7273

### Wave 2 

#### Logistic regression Results

#### Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 2893  |
| 1     | 2168  |

#### Summary Statistics of Key Predictors
| Variable    | Description         | Min    | 1st Qu | Median | Mean   | 3rd Qu | Max      |
|-------------|----------------------|--------|--------|--------|--------|--------|----------|
| **pot**     | Potassium intake      | 1.50   | 22.00  | 29.00  | 33.93  | 43.00  | 167.00   |
| **sod**     | Sodium intake         | 5.00   | 70.00  | 109.00 | 108.10 | 140.00 | 303.00   |
| **albCreat**| Albumin–Creatinine    | 0.000  | 5.630  | 7.395  | 24.353 | 10.380 | 23049.850|
| **taxaFilt**| GFR class (counts)    | 1 (1614), 2 (3163), 3 (234), 4 (37), 5 (7), 6 (6) | | | | | |
| **pas**     | Systolic BP           | 72.50  | 110.00 | 121.50 | 124.90 | 134.50 | 223.50   |
| **pad**     | Diastolic BP          | 44.00  | 69.00  | 76.50  | 77.46  | 85.00  | 122.50   |

#### Model
| Variable     | Estimate     | Std. Error  | z value | Pr(>\|z\|)   | Significance  |
|--------------|--------------|-------------|---------|------------|----------------|
| (Intercept)  | -12.065426   | 0.442508    | -27.266 | < 2e-16    | ***            |
| pot          | 0.006977     | 0.002894    | 2.411   | 0.01590    | *              |
| sod          | -0.001915    | 0.001019    | -1.880  | 0.06017    | .              |
| pas          | 0.082893     | 0.004561    | 18.173  | < 2e-16    | ***            |
| pad          | 0.018041     | 0.006677    | 2.702   | 0.00689    | **             |

#### Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 736    | 243    |
| S         | 131    | 407    |

- **Accuracy:** 0.7535   
- **95% CI:** (0.731, 0.775)
- **Sensitivity** (Recall for S): 0.6262 
- **Specificity:** 0.8489     
- **Precision** (for S): 0.7565 
- **AUC:** 0.8159986
- **Balanced Accuracy:** 0.7375 

### Wave 3 

#### Logistic regression Results

#### Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 2276  |
| 1     | 2785  |

#### Summary Statistics of Key Predictors
| Variable    | Description         | Min    | 1st Qu | Median | Mean   | 3rd Qu | Max    |
|-------------|----------------------|--------|--------|--------|--------|--------|--------|
| **pot**     | Potassium intake      | 6.70   | 48.30  | 59.05  | 63.68  | 77.60  | 226.50 |
| **sod**     | Sodium intake         | 10.00  | 86.00  | 125.00 | 116.90 | 140.50 | 292.00 |
| **pas**     | Systolic BP           | 70.00  | 114.00 | 127.00 | 132.20 | 150.00 | 223.00 |
| **pad**     | Diastolic BP          | 48.00  | 71.50  | 79.50  | 79.63  | 91.00  | 133.00 |

#### Model
| Variable     | Estimate     | Std. Error  | z value | Pr(>\|z\|)   | Significance  |
|--------------|--------------|-------------|---------|------------|----------------|
| (Intercept)  | -11.400000   | 0.454300    | -25.082 | < 2e-16    | ***            |
| pot          | -0.001593    | 0.001610    | -0.989  | 0.322460   |                |
| sod          | -0.003476    | 0.000946    | -3.674  | 0.000239   | ***            |
| pas          | 0.090080     | 0.004253    | 21.179  | < 2e-16    | ***            |
| pad          | 0.007649     | 0.006496    | 1.178   | 0.238990   |                |

#### Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 522    | 171    |
| S         | 160    | 664    |

- **Accuracy:** 0.7818   
- **95% CI:** (0.7602, 0.8024)
- **Sensitivity** (Recall for S): 0.7952 
- **Specificity:** 0.7654      
- **Precision** (for S): 0.8058 
- **AUC:** 0.8672994
- **Balanced Accuracy:** 0.7803