![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)


#### Summary Statistics — Wave 1 

| Variable    | Statistic       | `dadosOnda1Mice_inp` | `dadosOnda1kNN_inp` |
|-------------|------------------|-----------------------|----------------------|
| **hip**     | 0                | 3411                  | 3410                 |
|             | 1                | 1650                  | 1651                 |
| **pot**     | Minimum          | 4.00                  | 4.00                 |
|             | 1st Quartile     | 20.00                 | 20.00                |
|             | Median           | 29.00                 | 29.00                |
|             | Mean             | 32.63                 | 32.52                |
|             | 3rd Quartile     | 41.00                 | 41.00                |
|             | Maximum          | 144.00                | 144.00               |
| **sod**     | Minimum          | 9.0                   | 9.0                  |
|             | 1st Quartile     | 68.0                  | 69.0                 |
|             | Median           | 102.0                 | 101.0                |
|             | Mean             | 109.7                 | 109.3                |
|             | 3rd Quartile     | 145.0                 | 144.0                |
|             | Maximum          | 327.0                 | 327.0                |
| **albCreat** | Minimum         | 1.83                  | 1.83                 |
|              | 1st Quartile    | 5.07                  | 5.09                 |
|              | Median          | 6.60                  | 6.60                 |
|              | Mean            | 19.70                 | 19.61                |
|              | 3rd Quartile    | 8.63                  | 8.59                 |
|              | Maximum         | 5014.83               | 5014.83              |
| **taxaFilt** | Category 1      | 1959                  | 1959                 |
|              | Category 2      | 2864                  | 2864                 |
|              | Category 3      | 200                   | 200                  |
|              | Category 4      | 25                    | 25                   |
|              | Category 5      | 7                     | 7                    |
|              | Category 6      | 6                     | 6                    |
| **pas**     | Minimum          | 77.0                  | 77.0                 |
|             | 1st Quartile     | 108.0                 | 108.0                |
|             | Median           | 118.0                 | 118.0                |
|             | Mean             | 119.8                 | 119.8                |
|             | 3rd Quartile     | 129.0                 | 129.0                |
|             | Maximum          | 219.5                 | 219.5                |
| **pad**     | Minimum          | 44.5                  | 44.5                 |
|             | 1st Quartile     | 67.5                  | 67.5                 |
|             | Median           | 74.5                  | 74.5                 |
|             | Mean             | 75.19                 | 75.19                |
|             | 3rd Quartile     | 82.0                  | 82.0                 |
|             | Maximum          | 131.5                 | 131.5                |


### Comparison of Summary Statistics — Wave 1

#### Variable: Potassium (pot)

| Method            | Mean     | Median | Std. Deviation |
|-------------------|----------|--------|----------------|
| Original (no NA)  | 32.53942 | 29     | 17.43379       |
| kNN               | 32.63327 | 29     | 17.52230       |
| PMM               | 32.51986 | 29     | 17.28874       |

#### Variable: Sodium (sod)

| Method            | Mean     | Median | Std. Deviation |
|-------------------|----------|--------|----------------|
| Original (no NA)  | 109.7099 | 102    | 53.43905       |
| kNN               | 109.7082 | 102    | 53.43264       |
| PMM               | 109.3484 | 101    | 53.04388       |

#### Variable: Systolic Blood Pressure (pas)

| Method            | Mean     | Median | Std. Deviation |
|-------------------|----------|--------|----------------|
| Original (no NA)  | 119.8248 | 118    | 16.61674       |
| kNN               | 119.8248 | 118    | 16.61674       |
| PMM               | 119.8248 | 118    | 16.61674       |

#### Variable: Diastolic Blood Pressure (pad)

| Method            | Mean     | Median | Std. Deviation |
|-------------------|----------|--------|----------------|
| Original (no NA)  | 75.19463 | 74.5   | 10.78453       |
| kNN               | 75.19463 | 74.5   | 10.78453       |
| PMM               | 75.19463 | 74.5   | 10.78453       |
