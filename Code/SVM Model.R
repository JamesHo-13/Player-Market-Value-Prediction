# -----------------------------
# Libraries
# -----------------------------
#install.packages(c("lava", "recipes"), dependencies = TRUE)
#install.packages("caret", dependencies = TRUE)
library(e1071)
library(dplyr)
library(caret)

# -----------------------------
# Load
# -----------------------------
data <- read.csv("filtered_timeseries_fifa_players.csv")
var <- read.csv("variables.csv")

var <- as.character(unlist(var))
df <- data %>% select(all_of(var)) %>% na.omit()

# -----------------------------
# Split
# -----------------------------
set.seed(123)

train_index <- createDataPartition(df$potential, p = 0.8, list = FALSE)
train <- df[train_index, ]
test  <- df[-train_index, ]

# -----------------------------
# Scale
# -----------------------------
preproc <- preProcess(train, method = c("center", "scale"))

train_scaled <- predict(preproc, train)
test_scaled  <- predict(preproc, test)

# -----------------------------
# Train
# -----------------------------
svm_model <- svm(
  potential ~ .,
  data = train_scaled,
  type = "eps-regression",
  kernel = "radial"
)

# -----------------------------
# Prediction
# -----------------------------
preds <- predict(svm_model, test_scaled)

# -----------------------------
# Evaluate
# -----------------------------
rmse <- sqrt(mean((preds - test_scaled$potential)^2))
mae  <- mean(abs(preds - test_scaled$potential))

rmse
mae

# -----------------------------
# Tune
# -----------------------------
tuned <- tune(
  svm,
  potential ~ .,
  data = train_scaled,
  ranges = list(
    cost = c(0.1, 1, 10),
    gamma = c(0.01, 0.1, 1)
  )
)

best_model <- tuned$best.model
summary(best_model)

# -----------------------------
# Hyperparameter
# -----------------------------
ctrl <- trainControl(
  method = "cv",
  number = 5
)

# -----------------------------
# -----------------------------
svm_grid <- expand.grid(
  sigma = c(0.001, 0.01, 0.1),
  C = c(0.1, 1, 10, 50)
)

# -----------------------------
# -----------------------------
svm_tuned <- train(
  potential ~ .,
  data = train_scaled,
  method = "svmRadial",
  trControl = ctrl,
  tuneGrid = svm_grid,
  metric = "RMSE"
)

# -----------------------------
# -----------------------------
svm_tuned$bestTune

# -----------------------------
# -----------------------------
preds_tuned <- predict(svm_tuned, test_scaled)

# -----------------------------
# -----------------------------
rmse_tuned <- sqrt(mean((preds_tuned - test_scaled$potential)^2))
mae_tuned  <- mean(abs(preds_tuned - test_scaled$potential))

rmse_tuned
mae_tuned

# -----------------------------
# -----------------------------
plot(svm_tuned)

# -----------------------------
# Improvement
# -----------------------------
# tuneGrid = expand.grid(
#   sigma = c(0.01, 0.1),
#   C = c(1, 10),
#   epsilon = c(0.1, 0.2, 0.5)
# )
# 
# svm_grid <- expand.grid(
#   sigma = seq(0.001, 0.1, length = 5),
#   C = seq(1, 50, length = 5)
# )
# 
# ctrl <- trainControl(
#   method = "repeatedcv",
#   number = 5,
#   repeats = 3
# )
