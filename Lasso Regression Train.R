library(glmnet)

data <- read.csv("players_15.csv")
data <- na.omit(data)

x_vars <- data[, sapply(data, is.numeric)]
x_vars <- x_vars[, colnames(x_vars) != "value_eur"]
x_vars <- as.matrix(x_vars)

x_vars <- model.matrix(value_eur~. , data)[,-1]
y_var <- data$value_eur
lambda_seq <- 10^seq(2, -2, by = -.1)

set.seed(472)
train = sample(1:nrow(x_vars), nrow(x_vars)/2)
x_test = (-train)
y_test = y_var[x_test]

cv_output <- cv.glmnet(x_vars[train,], y_var[train],
                       alpha = 1, lambda = lambda_seq,
                       nfolds = 5)

best_lam <- cv_output$lambda.min
best_lam

lasso_best <- glmnet(x_vars[train, ], y_var[train], alpha = 1, lambda = best_lam)
pred <- predict(lasso_best, s = best_lam, newx = x_vars[x_test, ])

final <- cbind(y_var[y_test], pred)
head(final)

actual <- test$actual
preds <- test$predicted
rss <- sum((preds - actual) ^ 2)
tss <- sum((actual - mean(actual)) ^ 2)
rsq <- 1 - rss/tss
rsq

coef(lasso_best)
