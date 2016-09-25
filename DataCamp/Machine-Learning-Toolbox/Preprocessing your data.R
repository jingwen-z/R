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

#######  #######

###  ###







#######  #######

###  ###





#######  #######

###  ###




###  ###





#######  #######

###  ###





