![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

# Inference Tree Analysis Results (kNN)

### Wave 1

### 1. Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 3410  |
| 1     | 1651  |

### 2. Summary Statistics of Key Predictors
- **pot** (Potassium intake): Min 4.00, 1st Qu 20.00, Median 29.00, Mean 32.52, 3rd Qu 41.00, Max 144.00  
- **sod** (Sodium intake): Min 9.0, 1st Qu 69.0, Median 101.0, Mean 109.3, 3rd Qu 144.0, Max 327.0  
- **albCreat** (Albumin–Creatinine): Min 1.83, 1st Qu 5.09, Median 6.60, Mean 19.61, 3rd Qu 8.59, Max 5014.83  
- **taxaFilt** (GFR class): 1 (1959), 2 (2864), 3 (200), 4 (25), 5 (7), 6 (6)  
- **pas** (Systolic BP): Min 77.0, 1st Qu 108.0, Median 118.0, Mean 119.8, 3rd Qu 129.0, Max 219.5  
- **pad** (Diastolic BP): Min 44.50, 1st Qu 67.50, Median 74.50, Mean 75.19, 3rd Qu 82.00, Max 131.50  

### 3. Class Distribution After Undersampling
| Class | Count |
|-------|-------|
| N (0) | 1651  |
| S (1) | 1651  |

### 4. Train/Test Split
- **Train:** 1982 observations × 7 variables  
- **Test:** 1320 observations × 7 variables  

### 5. Conditional Inference Tree Structure
- **Inner nodes:** 8  
- **Terminal nodes:** 9  

**Splits:**  
- **Root:** `pas ≤ 134.5`  
  - **`pas ≤ 114`**  
    - **`taxaFilt ∈ {1,2}`**  
      - `pas ≤ 103` → Predict **N** (n = 213, err = 11.3%)  
      - `pas > 103`  
        - `taxaFilt = 1` → **N** (n = 187, err = 16.0%)  
        - `taxaFilt = 2` → **N** (n = 260, err = 30.4%)  
    - **`taxaFilt ∈ {3,4,5}`** → **S** (n = 22, err = 40.9%)  
  - **`pas > 114`**  
    - **`pad ≤ 89`**  
      - `taxaFilt = 1` → **N** (n = 261, err = 34.9%)  
      - `taxaFilt ∈ {2,3,4,5,6}` → **N** (n = 507, err = 49.1%)  
    - **`pad > 89`** → **S** (n = 72, err = 1.4%)  
- **`pas > 134.5`**  
  - `pas ≤ 139` → **S** (n = 117, err = 21.4%)  
  - `pas > 139` → **S** (n = 343, err = 0.3%)  

### 6. Confusion Matrix & Key Metrics

|               | Reference N | Reference S |
|---------------|-------------|-------------|
| **Predicted N** | 633         | 315         |
| **Predicted S** | 27          | 345         |

- **Accuracy:** 0.7409  
- **Sensitivity** (Recall for S): 0.5227  
- **Specificity:** 0.9591  
- **Precision** (for S): 0.9274  
- **F1 Score** (for S): 0.6686  
- **Balanced Accuracy:** 0.7409  

### 7. Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 633    | 315    |
| S         | 27     | 345    |


### Wave 2

## Inference Tree Analysis Results

### 1. Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 2893  |
| 1     | 2168  |

### 2. Summary Statistics of Key Predictors
- **pot** (Potassium intake): Min 1.50, 1st Qu 22.00, Median 29.00, Mean 33.93, 3rd Qu 43.00, Max 167.00  
- **sod** (Sodium intake): Min 5.0, 1st Qu 70.0, Median 109.0, Mean 108.1, 3rd Qu 140.0, Max 303.0  
- **albCreat** (Albumin–Creatinine): Min 0.000, 1st Qu 5.630, Median 7.395, Mean 24.353, 3rd Qu 10.380, Max 23049.850  
- **taxaFilt** (GFR class): 1 (3037), 2 (2024)  
- **pas** (Systolic BP): Min 72.5, 1st Qu 110.0, Median 121.5, Mean 124.9, 3rd Qu 134.5, Max 223.5  
- **pad** (Diastolic BP): Min 44.00, 1st Qu 69.00, Median 76.50, Mean 77.46, 3rd Qu 85.00, Max 122.50  

### 3. Class Distribution After Undersampling
| Class | Count |
|-------|-------|
| N (0) | 2168  |
| S (1) | 2168  |

### 4. Train/Test Split
- **Train:** 3037 observations × 7 variables  
- **Test:** 2024 observations × 7 variables  

### 5. Conditional Inference Tree Structure
- **Inner nodes:** 8  
- **Terminal nodes:** 9  

**Splits:**  
- **Root:** `pas ≤ 139.5`  
  - **`pas ≤ 117.5`**  
    - **`taxaFilt ∈ {1, 2}`**  
      - `pas ≤ 109.5` → Predict **N** (n = 717, err = 12.6%)  
      - `pas > 109.5`  
        - `taxaFilt = 1` → **N** (n = 514, err = 22.0%)  
        - `taxaFilt = 2` → **N** (n = 61, err = 47.5%)  
  - **`pas > 117.5`**  
    - **`pad ≤ 89.5`**  
      - `taxaFilt ∈ {1, 2, 6}`  
        - `pas ≤ 127.5`  
          - **`pot ≤ 48.5`** → Predict **N** (n = 475, err = 27.2%)  
          - **`pot > 48.5`** → Predict **N** (n = 115, err = 45.2%)  
        - `pas > 127.5` → Predict **N** (n = 405, err = 39.5%)  
      - **`taxaFilt ∈ {3, 4, 5}`** → Predict **S** (n = 69, err = 31.9%)  
    - **`pad > 89.5`** → Predict **S** (n = 82, err = 0.0%)  
- **`pas > 139.5`**  
  - `pas ≤ 139` → Predict **S** (n = 117, err = 21.4%)  
  - `pas > 139` → Predict **S** (n = 343, err = 0.3%)  

### 6. Confusion Matrix & Key Metrics

|               | Reference N | Reference S |
|---------------|-------------|-------------|
| **Predicted N** | 1136         | 388         |
| **Predicted S** | 21          | 479         |

- **Accuracy:** 0.7979  
- **Sensitivity** (Recall for S): 0.958  
- **Specificity:** 0.9591  
- **Precision** (for S): 0.9274  
- **F1 Score** (for S): 0.7008  
- **Balanced Accuracy:** 0.7672  

### 7. Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 1136   | 388    |
| S         | 21     | 479    |

### Wave 3

### 1. Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 2273  |
| 1     | 2788  |

### 2. Summary Statistics of Key Predictors
- **pot** (Potassium intake): Min 6.70, 1st Qu 48.30, Median 59.05, Mean 63.68, 3rd Qu 77.60, Max 226.50  
- **sod** (Sodium intake): Min 10.0, 1st Qu 86.0, Median 125.0, Mean 116.9, 3rd Qu 140.5, Max 292.0  
- **pas** (Systolic BP): Min 70.0, 1st Qu 114.0, Median 127.0, Mean 132.2, 3rd Qu 150.0, Max 223.0  
- **pad** (Diastolic BP): Min 48.00, 1st Qu 71.50, Median 79.50, Mean 79.63, 3rd Qu 91.00, Max 133.00  

### 3. Train/Test Split
- **Train:** 3037 observations × 5 variables  
- **Test:** 2024 observations × 5 variables  

### 4. Conditional Inference Tree Structure
- **Inner nodes:** 6  
- **Terminal nodes:** 7  

**Splits:**  
- **Root:** `pas ≤ 139`  
  - **`pas ≤ 114`** → Predict **N** (n = 761, err = 18.0%)  
  - **`pas > 114`**  
    - **`pad ≤ 89.5`**  
      - **`sod ≤ 93`** → Predict **N** (n = 404, err = 45.5%)  
      - **`sod > 93`**  
        - **`pad ≤ 79`** → Predict **N** (n = 438, err = 39.3%)  
        - **`pad > 79`** → Predict **N** (n = 349, err = 28.7%)  
    - **`pad > 89.5`** → Predict **S** (n = 96, err = 0.0%)  
- **`pas > 139`**  
  - **`pas ≤ 139.5`** → Predict **S** (n = 16, err = 31.2%)  
  - **`pas > 139.5`** → Predict **S** (n = 973, err = 0.0%)  

### 5. Confusion Matrix & Key Metrics

|                 | Reference N | Reference S |
|-----------------|-------------|-------------|
| **Predicted N** | 908         | 418         |
| **Predicted S** | 1           | 697         |

- **Accuracy:** 0.793  
- **95% CI:** (0.7747, 0.8104)  
- **Kappa:** 0.5986  
- **Sensitivity** (Recall for S): 0.6251  
- **Specificity:** 0.9989  
- **Precision** (for S): 0.9986  
- **Negative Predictive Value:** 0.6848  
- **Balanced Accuracy:** 0.8120  

### 6. Evaluation Metrics
- **Accuracy:** 0.79298  
- **Precision (S):** 0.62511  
- **Recall (S):** 0.99857  
- **F1 Score (S):** 0.76889  

### 7. Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 908    | 418    |
| S         | 1      | 697    |

# Inference Tree Analysis Results (pmm)

### Wave 1

### Inference Tree Analysis Results – Wave 1 (MICE‐Balanced)

### 1. Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 1650  |
| 1     | 1650  |

### 2. Train/Test Split
- **Train:** 2310 observations × 7 variables  
- **Test:** 990 observations × 7 variables  

### 3. Conditional Inference Tree Structure
- **Inner nodes:** 9  
- **Terminal nodes:** 10  

**Splits:**  
- **Root:** `pas ≤ 134.5`  
  - **`pas ≤ 113.5`**  
    - **`taxaFilt ∈ {1}`** → Predict **N** (n = 314, err = 11.8%)  
    - **`taxaFilt ∈ {2,3,4,5}`**  
      - **`pas ≤ 106.5`** → Predict **N** (n = 224, err = 17.0%)  
      - **`pas > 106.5`**  
        - **`taxaFilt = 2`** → Predict **N** (n = 197, err = 30.5%)  
        - **`taxaFilt ∈ {3,4,5}`** → Predict **S** (n = 19, err = 31.6%)  
  - **`pas > 113.5`**  
    - **`pad ≤ 89.5`**  
      - **`taxaFilt ∈ {1,2}`** → Predict **N** (n = 881, err = 43.5%)  
      - **`taxaFilt ∈ {3,4,5,6}`** → Predict **S** (n = 56, err = 28.6%)  
    - **`pad > 89.5`** → Predict **S** (n = 77, err = 0.0%)  
- **`pas > 134.5`**  
  - **`pas ≤ 139.5`**  
    - **`pad ≤ 89.5`** → Predict **S** (n = 101, err = 34.7%)  
    - **`pad > 89.5`** → Predict **S** (n = 59, err = 0.0%)  
  - **`pas > 139.5`** → Predict **S** (n = 382, err = 0.0%)  

### 4. Confusion Matrix & Key Metrics

|               | Reference N | Reference S |
|---------------|-------------|-------------|
| **Predicted N** | 468         | 215         |
| **Predicted S** | 27          | 280         |

- **Accuracy:** 0.7556  
- **95% CI:** (0.7275, 0.7820)  
- **Kappa:** 0.5111  
- **Sensitivity:** 0.5657  
- **Specificity:** 0.9455  
- **Precision (S):** 0.9121  
- **Negative Predictive Value:** 0.6852  
- **Balanced Accuracy:** 0.7556  

### 5. Evaluation Metrics
- **Accuracy:** 0.75556  
- **Precision (S):** 0.56566  
- **Recall (S):** 0.91205  
- **F1 Score (S):** 0.69825  

### 6. Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 468    | 215    |
| S         | 27     | 280    |

### Wave 2

## Inference Tree Analysis Results – Wave 2 (MICE-Balanced)

## 1. Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 1921  |
| 1     | 1921  |

### 2. Train/Test Split
- **Train:** 2690 observations × 7 variables  
- **Test:** 1152 observations × 7 variables  

### 3. Conditional Inference Tree Structure
- **Inner nodes:** 8  
- **Terminal nodes:** 9  

**Splits:**  
- **Root:** `pas ≤ 134`  
  - **`pas ≤ 114`**  
    - **`taxaFilt ∈ {1, 2}`**  
      - `pas ≤ 110` → Predict **N** (n = 622, err = 17.0%)  
      - `pas > 110` → Predict **N** (n = 211, err = 32.2%)  
    - **`taxaFilt ∈ {3, 4, 5, 6}`** → Predict **S** (n = 41, err = 34.1%)  
  - **`pas > 114`**  
    - **`taxaFilt ∈ {1, 2, 6}`**  
      - `pas ≤ 125.5` → Predict **N** (n = 719, err = 40.5%)  
      - `pas > 125.5` → Predict **S** (n = 387, err = 43.7%)  
    - **`taxaFilt ∈ {3, 4, 5}`** → Predict **S** (n = 74, err = 20.3%)  
- **`pas > 134`**  
  - **`pas ≤ 139.5`**  
    - `pad ≤ 89` → Predict **S** (n = 134, err = 42.5%)  
    - `pad > 89` → Predict **S** (n = 50, err = 0.0%)  
  - **`pas > 139.5`** → Predict **S** (n = 452, err = 0.7%)  

### 4. Confusion Matrix & Key Metrics

|                 | Reference N | Reference S |
|-----------------|-------------|-------------|
| **Predicted N** | 443         | 196         |
| **Predicted S** | 133         | 380         |

- **Accuracy:** 0.7144  
- **95% CI:** (0.6874, 0.7404)  
- **Kappa:** 0.4288  
- **Sensitivity** (Recall for S): 0.6597  
- **Specificity:** 0.7691  
- **Precision** (for S): 0.7407  
- **Negative Predictive Value:** 0.6933  
- **Balanced Accuracy:** 0.7144  

### 5. Evaluation Metrics
- **Accuracy:** 0.71441  
- **Precision (S):** 0.65972  
- **Recall (S):** 0.74074  
- **F1 Score (S):** 0.69789  

### 6. Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 443    | 196    |
| S         | 133    | 380    |


### Wave 3

## Inference Tree Analysis Results – Wave 3 (MICE‐Balanced)

### 1. Original Class Distribution
| Class | Count |
|-------|-------|
| 0     | 2813  |
| 1     | 2248  |

### 2. Summary Statistics of Key Predictors
- **pot** (Potassium intake): Min 6.70, 1st Qu 43.50, Median 62.00, Mean 65.06, 3rd Qu 83.40, Max 226.50  
- **sod** (Sodium intake): Min 10.0, 1st Qu 77.0, Median 113.0, Mean 114.8, 3rd Qu 150.0, Max 292.0  
- **pas** (Systolic BP): Min 70.0, 1st Qu 111.0, Median 122.0, Mean 123.4, 3rd Qu 133.5, Max 223.0  
- **pad** (Diastolic BP): Min 48.00, 1st Qu 69.50, Median 76.50, Mean 76.96, 3rd Qu 83.50, Max 133.00  

### 3. Train/Test Split
- **Train:** 3 543 observations × 5 variables  
- **Test:** 1 518 observations × 5 variables  

### 4. Conditional Inference Tree Structure
- **Inner nodes:** 8  
- **Terminal nodes:** 9  

**Splits:**  
- **Root:** `pas ≤ 139`  
  - **`pas ≤ 115`**  
    - **`pas ≤ 103`** → Predict **N** (n = 409, err = 11.0%)  
    - **`pas > 103`**  
      - **`sod ≤ 30`** → Predict **S** (n = 32, err = 46.9%)  
      - **`sod > 30`** → Predict **N** (n = 786, err = 20.5%)  
  - **`pas > 115`**  
    - **`pas ≤ 127.5`**  
      - **`sod ≤ 93`** → Predict **N** (n = 374, err = 46.0%)  
      - **`sod > 93`** → Predict **N** (n = 683, err = 34.8%)  
    - **`pas > 127.5`**  
      - **`pad ≤ 89.5`** → Predict **N** (n = 586, err = 49.5%)  
      - **`pad > 89.5`** → Predict **S** (n = 103, err = 8.7%)  
- **`pas > 139`**  
  - **`pad ≤ 66.5`** → Predict **S** (n = 12, err = 16.7%)  
  - **`pad > 66.5`** → Predict **S** (n = 559, err = 2.1%)  

### 5. Confusion Matrix & Key Metrics

|                 | Reference N | Reference S |
|-----------------|-------------|-------------|
| **Predicted N** | 825         | 387         |
| **Predicted S** | 18          | 287         |

- **Accuracy:** 0.733  
- **95% CI:** (0.7100, 0.7551)  
- **Kappa:** 0.4279  
- **Sensitivity** (Recall for S): 0.4258  
- **Specificity:** 0.9786  
- **Precision** (for S): 0.9410  
- **Negative Predictive Value:** 0.6807  
- **Balanced Accuracy:** 0.7022  

### 6. Evaluation Metrics
- **Accuracy:** 0.73303  
- **Precision (S):** 0.42582  
- **Recall (S):** 0.94098  
- **F1 Score (S):** 0.58631  

### 7. Prediction Distribution
| Predicted | True N | True S |
|-----------|--------|--------|
| N         | 825    | 387    |
| S         | 18     | 287    |


