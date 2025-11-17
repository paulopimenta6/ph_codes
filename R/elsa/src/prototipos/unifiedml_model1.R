library(unifiedml)
library(glmnet)
data(mtcars)

# Prepare data
X <- as.matrix(mtcars[, -1])
y <- mtcars$mpg  # numeric → automatic regression

# Fit model
mod <- Model$new(glmnet::glmnet)
mod$fit(X, y, alpha = 0, lambda = 0.1)

# Make predictions
predictions <- mod$predict(X)

# Get model summary with feature importance
mod$summary()

# Visualize partial dependence
mod$plot(feature = 1)

# Cross-validation (automatically uses RMSE for regression)
cv_scores <- cross_val_score(mod, X, y, cv = 5)
cat("Mean RMSE:", mean(cv_scores), "\n")