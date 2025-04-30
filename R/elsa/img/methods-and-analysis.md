![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white&style=flat)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?logo=rstudio&logoColor=white&style=flat)

# Comparative Analysis of Predictive Models

This document presents a brief description and comparison between various classification techniques: Decision Trees (CART and C5.0), Tree-Based Inference, Random Forest, AdaBoost, and Logistic Regression. The goal is to understand their differences, applications, and particularities.

## 1. Decision Trees

### CART (Classification and Regression Trees)

The CART algorithm builds binary trees where each split is based on a metric such as the Gini index. The model is easy to interpret and useful in scenarios where interpretability is crucial. It can be used for both classification and regression problems.

**Advantages:**
- Intuitive and visually interpretable.
- Handles both numerical and categorical variables.

**Disadvantages:**
- Prone to overfitting.
- Small changes in data can lead to very different trees.

---

### C5.0

C5.0 is an improvement over C4.5, using information gain as the splitting criterion. It is more efficient, accurate, and less susceptible to overfitting than CART. C5.0 supports boosting natively, which makes it more robust.

**Advantages:**
- Faster and better performing than C4.5.
- Supports boosting and resampling.

**Disadvantages:**
- Can be more complex to interpret depending on tree depth.
- Not always available natively in all libraries.

---

### Tree-Based Inference

This approach focuses on building statistically significant trees, inferring associations between predictors and the target variable using statistical tests. An example is the `ctree` function from the `party` package in R, which uses association tests instead of purely heuristic metrics.

**Advantages:**
- Better control over statistical significance.
- Tends to generate more stable trees with less overfitting.

**Disadvantages:**
- Can be slower.
- Less commonly used in practice.

---

## 2. Random Forest

Random Forest is an ensemble of multiple CART trees, built using random sampling of data and subsets of variables. The final output is based on majority voting (for classification) or averaging (for regression).

**Advantages:**
- Reduces overfitting by combining multiple trees.
- Excellent predictive performance.

**Disadvantages:**
- Less interpretable than individual trees.
- Can be computationally expensive.

---

## 3. AdaBoost (Adaptive Boosting)

AdaBoost combines several weak classifiers (such as small decision trees) to create a strong classifier. It adjusts sample weights in each iteration, focusing on examples that were misclassified in previous rounds.

**Advantages:**
- High accuracy in many scenarios.
- Robust to overfitting, especially with regularization.

**Disadvantages:**
- Sensitive to noise and outliers.
- The final model can be difficult to interpret.

---

## 4. Logistic Regression

Logistic Regression is a statistical technique used to predict the probability of a binary variable based on independent variables. It serves as a solid baseline model for more complex algorithms.

**Advantages:**
- Easy to interpret.
- Fast and effective for linearly separable data.

**Disadvantages:**
- Assumes a linear relationship between predictors and the log-odds.
- Lower performance with nonlinear data.

---

## Overall Comparison

| Technique              | Interpretability | Overfitting Resistance | Predictive Performance | Computational Complexity |
|------------------------|------------------|-------------------------|-------------------------|---------------------------|
| CART                   | High             | Low                     | Moderate                | Low                       |
| C5.0                   | Moderate         | Medium                  | High                    | Medium                    |
| Inference (e.g. ctree) | High             | High                    | Moderate                | Medium                    |
| Random Forest          | Low              | High                    | High                    | High                      |
| AdaBoost               | Low              | High (with care)        | High                    | High                      |
| Logistic Regression    | High             | Medium                  | Moderate                | Low                       |

---

## Conclusion

Each technique has specific advantages and may be better suited for different contexts. Simpler models like Logistic Regression and CART are excellent for interpretation and initial diagnostics, while methods like Random Forest and AdaBoost provide high performance in more complex tasks, at the cost of greater complexity.

---

- [Inferential tree](./inferential_tree.md)
- [C5.0](./C50_tree.md)
- [CART](./CART_tree.md)
