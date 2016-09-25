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

#######  #######

###  ###





###  ###






#######  #######

###  ###



