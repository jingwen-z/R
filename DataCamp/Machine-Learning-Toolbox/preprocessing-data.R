####### Median imputation #######

### Apply median imputation ###
# Apply median imputation: model
model <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "medianImpute"
)

model

####### KNN imputation #######

### Use KNN imputation ###
# Apply KNN imputation: model2
model2 <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "knnImpute"
)

model2

####### Multiple preprocessing methods #######

### Combining preprocessing methods ###
# Fit glm with median imputation: model1
model1 <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = "medianImpute"
)

model1

# Fit glm with median imputation and standardization: model2
model2 <- train(
  x = breast_cancer_x, y = breast_cancer_y,
  method = "glm",
  trControl = myControl,
  preProcess = c("medianImpute", "center", "scale")
)

model2

####### Handling low-information predictors #######

### Remove near zero variance predictors ###
# Identify near zero variance predictors: remove
remove <- nearZeroVar(bloodbrain_x, names = TRUE, freqCut = 2, uniqueCut = 20)

# Remove from data: bloodbrain_x_small
bloodbrain_x_small <- bloodbrain_x[ , setdiff(colnames(bloodbrain_x), remove)]

### Fit model on reduced blood-brain data ###
# Fit model on reduced data: model
model <- train(x = bloodbrain_x_small, y = bloodbrain_y, method = "glm")

# Print model to console
model


####### Principle components analysis (PCA) #######

### Using PCA as an alternative to nearZeroVar() ###
# Fit glm model using PCA: model
model <- train(
  x = bloodbrain_x, y = bloodbrain_y,
  method = "glm", preProcess = "pca"
)

# Print model to console
model
