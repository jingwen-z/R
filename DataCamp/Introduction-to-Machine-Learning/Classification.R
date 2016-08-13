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

##################################### k-Nearest Neighbors (k-NN) #####################################

################ Preprocess the data ################
# train and test are pre-loaded

# Store the Survived column of train and test in train_labels and test_labels
train_labels <- train$Survived
test_labels <- test$Survived

# Copy train and test to knn_train and knn_test
knn_train <- train
knn_test <- test

# Drop Survived column for knn_train and knn_test
# dropping a column named column in a data frame named df can be done as follows: df$column <- NULL
knn_train$Survived <- NULL
knn_test$Survived <- NULL

# To define the minimum and maximum, only the training set is used;
# we can't use information on the test set (like the minimums or maximums) to normalize the data.

# Normalize Pclass
min_class <- min(knn_train$Pclass)
max_class <- max(knn_train$Pclass)
knn_train$Pclass <- (knn_train$Pclass - min_class) / (max_class - min_class)
knn_test$Pclass <- (knn_test$Pclass - min_class) / (max_class - min_class)

# Normalize Age
min_age <- min(knn_train$Age)
max_age <- max(knn_train$Age)
knn_train$Age <- (knn_train$Age - min_age) / (max_age - min_age)
knn_test$Age <- (knn_test$Age - min_age) / (max_age - min_age)

# the variable Sex already took values between 0 and 1, hence did not require normalization

################ The knn() function ################
# knn_train, knn_test, train_labels and test_labels are pre-loaded

# Set random seed. Don't remove this line.
set.seed(1)

# Load the class package
library(class)

# Fill in the ___, make predictions using knn: pred
pred <- knn(train = knn_train, test = knn_test, cl = train_labels, k = 5)
    
# Construct the confusion matrix: conf
conf <- table(test_labels, pred)

# Print out the confusion matrix
conf

################ K's choice ################
# knn_train, knn_test, train_labels and test_labels are pre-loaded

# Set random seed. Don't remove this line.
set.seed(1)

# Load the class package, define range and accs
library(class)
range <- 1:round(0.2 * nrow(knn_train))
accs <- rep(0, length(range))

for (k in range) {
  
  # Fill in the ___, make predictions using knn: pred
  pred <- knn(train = knn_train, test = knn_test, cl = train_labels, k = k)
    
  # Fill in the ___, construct the confusion matrix: conf
  conf <- table(test_labels, pred)
    
  # Fill in the ___, calculate the accuracy and store it in accs[k]
  accs[k] <- sum( diag(conf) ) / sum(conf)
}

# Plot the accuracies. Title of x-axis is "k".
plot(range, accs, xlab = "k")

# Calculate the best k
# find out which index is highest in the accs vector
which.max(accs)
# the best k is 73

##################################### The ROC curve #####################################

################  ################








################  ################
