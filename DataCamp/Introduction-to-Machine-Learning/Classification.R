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
# All packages are pre-loaded, as is the data

# Calculation of a complex tree
set.seed(1)
tree <- rpart(Survived ~ ., train, method = "class", control = rpart.control(cp=0.00001))

# Draw the complex tree
fancyRpartPlot(tree)

# Prune the tree: pruned
pruned <- prune(tree, cp = 0.01)

# Draw pruned
fancyRpartPlot(pruned)

# Another way to check if you overfit your model is 
# by comparing the accuracy on the training set with the accuracy on the test set.
# You'd see that the difference between those two is smaller for the simpler tree.

################ Splitting criterion ################
# All packages, emails, train, and test have been pre-loaded

# Set random seed. Don't remove this line.
set.seed(1)

# Train and test tree with gini criterion
tree_g <- rpart(spam ~ ., train, method = "class")
pred_g <- predict(tree_g, test, type = "class")
conf_g <- table(test$spam, pred_g)
acc_g <- sum(diag(conf_g)) / sum(conf_g)

# Change the first line of code to use information gain as splitting criterion
tree_i <- rpart(spam ~ ., train, method = "class", parms = list(split = "information"))
pred_i <- predict(tree_i, test, type = "class")
conf_i <- table(test$spam, pred_i)
acc_i <- sum(diag(conf_i)) / sum(conf_i)

# Draw a fancy plot of both tree_g and tree_i
fancyRpartPlot(tree_g)
fancyRpartPlot(tree_i)

# Print out acc_g and acc_i
acc_g  # 0.8905797
acc_i  # 0.8963768

# using a different splitting criterion can influence the resulting model of your learning algorithm

################  ################







################  ################








################  ################








################  ################








################  ################
