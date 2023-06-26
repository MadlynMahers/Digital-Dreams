#1
#Import Libraries
library(tidyverse)
library(randomForest)

#2
#Load Data
data <- read.csv("DigitalDreams.csv")

#3
#Exploratory Data Analysis
summary(data)

#4
#Check for Missing Values
anyNA(data)

#5
#Visualize data with graphs
plot(data$age, data$score)

#6
#Data Pre-processing
data$age <- as.numeric(data$age)
data$score <- ifelse(data$score > 0, 1, 0)

#7
#Split Data into Training and Test Sets
set.seed(123)
split_index <- createDataPartition(data$score, p = 0.8, list = FALSE)
train_data <- data[split_index,]
test_data <- data[-split_index,]

#8
#Build the Model
model <- randomForest(score ~ age, data =train_data, ntree = 1000)

#9
#Predict on Test Data
predictions <- predict(model, newdata = test_data)

#10
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#11
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#12
#Hyperparameter Tuning
tune_model <- tuneRF(x = as.matrix(train_data[,-1]), y = train_data$score, 
                     ntree = c(1000, 2000, 3000), mtry = c(1, 2, 3))

#13
#Retrain the Model
model <- randomForest(score ~ ., data =train_data, ntree = tune_model$optimal[1], mtry = tune_model$optimal[2])

#14
#Predict on Test Data
predictions <- predict(model, newdata = test_data)

#15
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#16
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#17
#Variable Importance
varImpPlot(model, sort = TRUE)

#18
#Cross Validation
set.seed(123)
cv_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
model_cv <- train(score ~., data = train_data, method = "rf", trControl = cv_control, ntree = 1000, metric = "Accuracy")

#19
#Predict on Test Data
predictions <- predict(model_cv, newdata = test_data)

#20
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#21
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model_cv, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#22
#Variable Importance
varImpPlot(model_cv, sort = TRUE)

#23
#Model Deployment
library(caret)
library(pROC)
model_prediction <- predict(model, newdata = test_data, type = "prob")

#24
#Save Model
saveRDS(model,"model.rds")

#25
#Validated Model on New Data
new_data <- read.csv("NewData.csv")
model <- readRDS("model.rds")
prediction <- predict(model, newdata = new_data, type = "response")

#26
#Plot new ROC Curve
pred_scores <- predict(model, newdata = new_data, type = "prob")[,2]
predobj <- prediction(pred_scores, new_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#27
#Model Optimization
tune_model <- tuneRF(x = as.matrix(new_data[,-1]), y = new_data$score, 
                     ntree = c(1000, 2000, 3000), mtry = c(1, 2, 3))

#28
#Retrain Model with Optimized Parameters
model <- randomForest(score ~ ., data = new_data, ntree = tune_model$optimal[1], mtry = tune_model$optimal[2])

#29
#Predict on Test Data
predictions <- predict(model, newdata = test_data)

#30
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#31
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#32
#Variable Importance
varImpPlot(model, sort = TRUE)

#33
#Cross Validation
set.seed(123)
cv_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
model_cv <- train(score ~., data = new_data, method = "rf", trControl = cv_control, ntree = 1000, metric = "Accuracy")

#34
#Predict on Test Data
predictions <- predict(model_cv, newdata = test_data)

#35
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#36
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model_cv, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#37
#Variable Importance
varImpPlot(model_cv, sort = TRUE)

#38
#Model Deployment
model_prediction <- predict(model, newdata = test_data, type = "prob")

#39
#Save Model
saveRDS(model,"model.rds")

#40
#Model Performance
library(caret)
library(pROC)
roc_curve <- roc(test_data$score, model_prediction[,2])

#41
#Visualize Model Performance
plot(roc_curve, col = "blue", lwd = 2)

#42
#Interpret results
auc(roc_curve)

#43
#Compare with Baseline Model
base_model <- randomForest(score ~ 1, data = train_data, ntree = 1000)
predictions <- predict(base_model, newdata = test_data)

#44
#Evaluate Baseline Model
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#45
#Plot Baseline ROC Curve
pred_scores <- predict(base_model, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#46
#Perform Upsampling
library(caret)
set.seed(789)
up_sampled_data <- upSample(x = train_data[,-1], y = train_data$score)

#47
#Train Model on Upsampled data
model_up <- randomForest(score ~ ., data = up_sampled_data, ntree = 1000)

#48
#Predict on Test Data
predictions <- predict(model_up, newdata = test_data)

#49
#Evaluate Results
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#50
#Plot ROC Curve
pred_scores <- predict(model_up, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#51
#Variable Importance
varImpPlot(model_up, sort = TRUE)

#52
#Cross Validation
set.seed(123)
cv_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
model_cv_up <- train(score ~., data = up_sampled_data, method = "rf", trControl = cv_control, ntree = 1000, metric = "Accuracy")

#53
#Predict on Test Data
predictions <- predict(model_cv_up, newdata = test_data)

#54
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#55
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model_cv_up, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#56
#Variable Importance
varImpPlot(model_cv_up, sort = TRUE)

#57
#Model Deployment
model_prediction <- predict(model_up, newdata = test_data, type = "prob")

#58
#Save Model
saveRDS(model_up,"model_up.rds")

#59
#Model Performance
library(caret)
library(pROC)
roc_up <- roc(test_data$score, model_prediction[,2])

#60
#Visualize Model Performance
plot(roc_up, col = "blue", lwd = 2)

#61
#Interpret results
auc(roc_up)

#62
#Compare with Original Model
model_orig <- readRDS("model.rds")
predictions_orig <- predict(model_orig, newdata = test_data, type = "response")

#63
#Evaluate Original Model
conf_mat_orig <- confusionMatrix(data = predictions_orig, reference = test_data$score)
print(conf_mat_orig)

#64
#Plot Original ROC Curve
pred_scores <- predict(model_orig, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#65
#Perform String Sampling
library(caret)
set.seed(123)
down_sampled_data <- downSample(x = train_data[,-1], y = train_data$score)

#66
#Train Model on Downsampled data
model_down <- randomForest(score ~ ., data = down_sampled_data, ntree = 1000)

#67
#Predict on Test Data
predictions <- predict(model_down, newdata = test_data)

#68
#Evaluate Results
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#69
#Plot ROC Curve
pred_scores <- predict(model_down, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#70
#Variable Importance
varImpPlot(model_down, sort = TRUE)

#71
#Cross Validation
set.seed(123)
cv_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
model_cv_down <- train(score ~., data = down_sampled_data, method = "rf", trControl = cv_control, ntree = 1000, metric = "Accuracy")

#72
#Predict on Test Data
predictions <- predict(model_cv_down, newdata = test_data)

#73
#Evaluation
conf_mat <- confusionMatrix(data = predictions, reference = test_data$score)
print(conf_mat)

#74
#Plot ROC Curve
library(ROCR)
pred_scores <- predict(model_cv_down, newdata = test_data, type = "prob")[,2]
predobj <- prediction(pred_scores, test_data$score)
perf <- performance(predobj, "tpr", "fpr")
plot(perf, col = "red", lwd = 2)

#75
#Variable Importance
varImpPlot(model_cv_down, sort = TRUE)

#76
#Model Deployment
model_prediction <- predict(model_down, newdata = test_data, type = "prob")

#77
#Save Model
saveRDS(model_down,"model_down.rds")

#