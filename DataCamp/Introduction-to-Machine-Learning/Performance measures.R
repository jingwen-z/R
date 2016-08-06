################################# Measuring model performance or error #################################

############### The Confusion Matrix ###############
# The titanic dataset is already loaded into your workspace

# Set random seed. Don't remove this line
set.seed(1)

# Have a look at the structure of titanic
str(titanic)

# A decision tree classification model is built on the data
tree <- rpart(Survived ~ ., data = titanic, method = "class")

# Use the predict() method to make predictions, assign to pred
pred <- predict(tree, titanic, type = "class")

# Use the table() method to make the confusion matrix
table(titanic$Survived, pred)
#   pred
#      1   0
#  1 212  78
#  0  53 371

# 212 out of all 265 survivors were correctly predicted to have survived.
# On the other hand, 371 out of the 449 deceased were correctly predicted to have perished.

############### Deriving ratios from the Confusion Matrix ###############
# The confusion matrix is available in your workspace as conf
# `conf` is the same as the result of `table(titanic$Survived, pred)` in exo above

# Assign TP, FN, FP and TN using conf
TP <- conf[1,1] # this will be 212
FN <- conf[1,2] # this will be 78
FP <- conf[2,1] # fill in
TN <- conf[2,2] # fill in

# Calculate and print the accuracy: acc
acc <- (TP + TN) / (TP + FN + FP + TN)
acc  # 0.8165266

# Calculate and print out the precision: prec
prec <- TP / (TP + FP)
prec  # 0.8

# Calculate and print out the recall: rec
rec <- TP / (TP + FN)
rec  # 0.7310345

############### The quality of a regression ###############
# Measuring the sound pressure produced by an airplane's wing under different settings
# The results of this experiment are listed in the air dataset (Source: UCIMLR).

# The air dataset is already loaded into your workspace

# Take a look at the structure of air
str(air)

# Inspect your colleague's code to build the model
fit <- lm(dec ~ freq + angle + ch_length, data = air)

# Use the model to predict for all values: pred
pred <- predict(fit)

# Use air$dec and pred to calculate the RMSE 
# `air$dec` corresponds to the actual sound pressure of observation
# `pred` corresponds to the predicted value of observation
rmse <- sqrt(sum( (air$dec - pred) ^ 2) / nrow(air))
# rmse <- sqrt((1/1503) * sum( (air$dec - pred) ^ 2 ) )

# Print out rmse
rmse  # 5.215778

############### Adding complexity to increase quality ###############
# Adding new variables "velocity" and "thickness"
# Your colleague's more complex model
fit2 <- lm(dec ~ freq + angle + ch_length + velocity + thickness, data = air)

# Use the model to predict for all values: pred2
pred2 <- predict(fit2)

# Calculate rmse2
rmse2 <- sqrt(sum( (air$dec - pred2) ^ 2) / nrow(air))

# Print out rmse2
rmse2  # 4.799244

# Adding complexity seems to have caused the RMSE to decrease, from 5.216 to 4.799.

############### Let's do some clustering! ###############
# The seeds dataset is already loaded into your workspace

# Set random seed. Don't remove this line
set.seed(1)

# Explore the structure of the dataset
str(seeds)

# Group the seeds in three clusters
km_seeds <- kmeans(seeds, 3)

# Color the points in the plot based on the clusters
plot(length ~ compactness, data = seeds, col = km_seeds$cluster)

# Print out the ratio of the WSS to the BSS
km_seeds$tot.withinss / km_seeds$betweenss
# 0.2762846

# The within sum of squares is far lower than the between sum of squares.
# Indicating the clusters are well seperated and overall compact.
# This is further strengthened by the plot you made, where the clusters you made were visually distinct for these two variables. 

################################# Training set and test set #################################

############### Split the sets ###############






###############  ###############






###############  ###############






###############  ###############
