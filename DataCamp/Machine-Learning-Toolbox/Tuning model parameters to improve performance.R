####### Random forests and wine #######

### Fit a random forest ###
# Fit random forest: model
model <- train(
  quality ~ .,
  tuneLength = 1,
  data = wine, method = "ranger",
  trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE)
)

# Print model to console
model

# Random Forest 
#
# 100 samples
#  12 predictor
#
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 80, 80, 80, 80, 80 
# Resampling results:
#
#   RMSE       Rsquared 
#   0.6619301  0.2878064
#
# Tuning parameter 'mtry' was held constant at a value of 3

####### Explore a wider model space #######

### Try a longer tune length ###
# Fit random forest: model
model <- train(
  quality ~ .,
  tuneLength = 3,
  data = wine, method = "ranger",
  trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE)
)

# Print model to console
model

# Plot model
plot(model)

# RMSE was used to select the optimal model using  the smallest value.
# The final value used for the model was mtry = 2. 

####### Custom tuning grids #######

### Fit a random forest with custom tuning ###
# Fit random forest: model
model <- train(
  quality ~ .,
  tuneGrid = data.frame(mtry = c(2,3,7)),
  data = wine, method = "ranger",
  trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE)
)

# Print model to console
model

# Plot model
plot(model)

## RMSE was used to select the optimal model using  the smallest value.
## The final value used for the model was mtry = 7. 

####### Introducing glmnet #######

### Make a custom trainControl ###
# Create custom trainControl: myControl
myControl <- trainControl(
  method = "cv", number = 10,
  summaryFunction = twoClassSummary,
  classProbs = TRUE, # IMPORTANT!
  verboseIter = TRUE
)

### Fit glmnet with custom trainControl ###
# Fit glmnet model: model
model <- train(
  y ~ ., overfit,
  method = "glmnet",
  trControl = myControl
)

## Selecting tuning parameters
## Fitting alpha = 1, lambda = 0.0101 on full training set

# Print model to console
model

## ROC was used to select the optimal model using  the largest value.
## The final values used for the model were alpha = 1 and lambda = 0.01012745. 

# Print maximum ROC statistic
max(model[["results"]][["ROC"]])  ## 0.4871377

####### glmnet with custom tuning grid #######
# The default tuning grid is very small and there are many more 
# potential glmnet models you want to explore.

# lambda: control the amount of penalization in the model
# alpha = 0 is pure ridge regression, and alpha = 1 is pure lasso regression.
# alpha = .05 would be 95% ridge regression and 5% lasso regression

# train() is smart enough to only fit one model per alpha value 
# and pass all of the lambda values at once for simultaneous fitting.


### glmnet with custom trainControl and tuning ###
# Train glmnet with custom trainControl and tuning: model
model <- train(
  y ~ ., overfit,
  tuneGrid = expand.grid(alpha = 0:1, 
  lambda = seq(0.0001, 1, length = 20)),
  method = "glmnet",
  trControl = myControl
)
## Aggregating results
## Selecting tuning parameters
## Fitting alpha = 1, lambda = 1 on full training set

# Print model to console
model
## ROC was used to select the optimal model using  the largest value.
## The final values used for the model were alpha = 1 and lambda = 1.

# Print maximum ROC statistic
max(model[["results"]][["ROC"]])  ## 0.5
