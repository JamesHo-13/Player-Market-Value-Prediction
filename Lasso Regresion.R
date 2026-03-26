library(glmnet)


data <- read.csv("players_15.csv")


data <- na.omit(data)

y <- data$value_eur

# Remove non-numeric or irrelevant columns (like names, IDs)
# Adjust this depending on your dataset
x <- data[, sapply(data, is.numeric)]

# Remove the response from predictors
x <- x[, colnames(x) != "value_eur"]

x <- as.matrix(x)


lasso_model <- glmnet(x, y, alpha = 1)


cv_model <- cv.glmnet(x, y, alpha = 1)

cv_model$lambda.min


plot(cv_model)


coef(cv_model, s = "lambda.min")


predictions <- predict(cv_model, s = "lambda.min", newx = x)


set.seed(123)

train_index <- sample(1:nrow(x), 0.8 * nrow(x))

x_train <- x[train_index, ]
y_train <- y[train_index]

x_test <- x[-train_index, ]
y_test <- y[-train_index]

cv_model <- cv.glmnet(x_train, y_train, alpha = 1)

pred <- predict(cv_model, s = "lambda.min", newx = x_test)

mse <- mean((y_test - pred)^2)
mse