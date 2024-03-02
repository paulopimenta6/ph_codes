![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange) ![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

# Association Rules in R

It is an example of code for assocation rules in R. It will be used libraries `arules` e `arulesViz`.

### support

$$ \text{support}(A \rightarrow B) = \frac{A \cap B}{\text{T}} $$

### confident

$$ \text{support}(A \rightarrow B) = \frac{A \cap B}{\text{A}} $$

### lift

$$ \text{support}(A \rightarrow B) = \frac{sup(A \cap B)}{\text{sup(A)*sup(B)}} $$

## Instalation and environment preparation

In case the libraries do not have been installed use the follow commands: 

```R
> install.packages("arules")
> install.packages("arulesViz") \n 
> install.packages("arulesViz", repos = "https://mhahsler.r-universe.dev") \n
> devtools::install_github("mhahsler/arulesViz").
``` 
Maybe you could install also using the command: library("devtools")
```R
> install_github("mhahsler/arulesViz")
```

Do not forget to install Linux library libglpk-dev by command:
```bash
> sudo apt-get install libglpk-dev
```

## Datas

Data used is just an example of binary numbers in a false scenario of a large NATO aerial operation including the main aicraft of alliance members 

## First results

|    LHS   |   RHS    | Support  |Confidence|   Lift   |  Count   |
|----------|----------|----------|----------|----------|----------|
|  EF2000  |  Result  |   0.3    |   1.00   |   1.66   |    3     |
|  Gripen  |  Result  |   0.5    |   0.71   |   1.90   |    5     |
|   F35    |  Result  |   0.4    |   0.50   |   0.83   |    4     |
|   F22    |  Result  |   0.5    |   0.55   |   0.92   |    5     |
|   F15    |  Result  |   0.5    |   0.55   |   0.92   |    5     |
|  Rafale  |  Result  |   0.6    |   0.60   |   1.00   |    6     |


|    LHS   |   RHS    | Support  |Confidence|   Lift   |  Count   |
|----------|----------|----------|----------|----------|----------|
|  Result  |  EF2000  |    0.3   |   0.50   |   1.66   |    3     |
|  Result  |  Gripen  |    0.5   |   0.83   |   1.19   |    5     |
|  Result  |    F35   |    0.4   |   0.66   |   0.83   |    4     |
|  Result  |    F22   |    0.5   |   0.83   |   0.92   |    5     |
|  Result  |    F15   |    0.5   |   0.83   |   0.92   |    5     |
|  Result  |  Rafale  |    0.6   |   1.00   |   1.00   |    6     |

<p align="center">
  <img src="img/regrasAssociacaoOTAN.png" alt="Plot da regra de associação" width="1200">
</p>
