##################################### Decision trees #####################################

################ Learn a decision tree ################
# The train and test set are loaded into your workspace.

# Set random seed. Don't remove this line
set.seed(1)

# Load the rpart, rattle, rpart.plot and RColorBrewer package
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Fill in the ___, build a tree model: tree
tree <- rpart(Survived ~ ., train, method = "class")
# tree <- rpart(Survived ~ Pclass + Sex + Age, train, method = "class")

# Draw the decision tree
fancyRpartPlot(tree)

################ Classify with the decision tree ################
# The train and test set are loaded into your workspace.

# Code from previous exercise
set.seed(1)
library(rpart)
tree <- rpart(Survived ~ ., train, method = "class")

# Predict the values of the test set: pred
pred <- predict(tree, test, type = "class")

# Construct the confusion matrix: conf
conf <- table(test$Survived, pred)

# Print out the accuracy
sum( diag(conf) ) / sum(conf)
# 0.7990654
# Around 80 percent of all test instances have been classified correctly. That's not bad!

################ Pruning the tree ################







################  ################
