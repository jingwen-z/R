####### Median imputation #######

### Apply median imputation ###
# Apply median imputation: model
model <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "medianImpute"
)

# Print model to console
model

# Generalized Linear Model 
#
# 699 samples
#   9 predictor
#   2 classes: 'benign', 'malignant' 
#
# Pre-processing: median imputation (9) 
# Resampling: Cross-Validated (10 fold) 
# Summary of sample sizes: 628, 629, 629, 630, 629, 629, ... 
# Resampling results:
# 
#   ROC        Sens       Spec     
#   0.9921039  0.9694203  0.9541667

####### KNN imputation #######

### Use KNN imputation ###
# Apply KNN imputation: model2
model2 <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "knnImpute"
)

# Print model to console
model2

# Generalized Linear Model 
#
# 699 samples
#   9 predictor
#   2 classes: 'benign', 'malignant' 
#
# Pre-processing: nearest neighbor imputation (9), centered (9), scaled (9) 
# Resampling: Cross-Validated (10 fold) 
# Summary of sample sizes: 629, 629, 629, 629, 629, 629, ... 
# Resampling results:
#
#   ROC        Sens       Spec  
#   0.9906636  0.9716425  0.9295


####### Multiple preprocessing methods #######

### Combining preprocessing methods ###
# Fit glm with median imputation: model1
model1 <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "medianImpute"
)

# Print model1
model1

# Resampling results:
#
#   ROC        Sens       Spec     
#   0.9923337  0.9694686  0.9376667

# Fit glm with median imputation and standardization: model2
model2 <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = c("medianImpute", "center", "scale")
)

# Print model2
model2

# Resampling results:
#
#   ROC        Sens      Spec     
#   0.9915092  0.969372  0.9458333

####### Handling low-information predictors #######

# Q: What's the best reason to remove near zero variance predictors from your data before building a model?
# A: To reduce model-fitting time without reducing model accuracy.

### Remove near zero variance predictors ###




###  ###





#######  #######

###  ###





