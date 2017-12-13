library(RColorBrewer)
library(ROCR)
library(class)
library(rpart)
library(rattle)
library(rpart.plot)


########## Decision trees ##########

##### Learn a decision tree #####
set.seed(1)

tree <- rpart(Survived ~ ., train, method = "class")
fancyRpartPlot(tree)

##### Classify with the decision tree #####
# Predict the values of the test set: pred
pred <- predict(tree, test, type = "class")

# Construct the confusion matrix: conf
conf <- table(test$Survived, pred)

# Print out the accuracy
sum( diag(conf) ) / sum(conf)

##### Pruning the tree #####
set.seed(1)
tree <- rpart(Survived ~ ., train,
              method = "class",
              control = rpart.control(cp = 0.00001))

# Draw the complex tree
fancyRpartPlot(tree)

# Prune the tree: pruned
pruned <- prune(tree, cp = 0.01)

# Draw pruned
fancyRpartPlot(pruned)

##### Splitting criterion #####
set.seed(1)

# Train and test tree with gini criterion
tree_g <- rpart(spam ~ ., train, method = "class")
pred_g <- predict(tree_g, test, type = "class")
conf_g <- table(test$spam, pred_g)
acc_g <- sum(diag(conf_g)) / sum(conf_g)

# Change the first line of code to use information gain as splitting criterion
tree_i <- rpart(spam ~ ., train, method = "class",
                parms = list(split = "information"))
pred_i <- predict(tree_i, test, type = "class")
conf_i <- table(test$spam, pred_i)
acc_i <- sum(diag(conf_i)) / sum(conf_i)

# Draw a fancy plot of both tree_g and tree_i
fancyRpartPlot(tree_g)
fancyRpartPlot(tree_i)

acc_g
acc_i


########## k-Nearest Neighbors (k-NN) ##########

##### Preprocess the data #####
train_labels <- train$Survived
test_labels <- test$Survived

# Copy train and test to knn_train and knn_test
knn_train <- train
knn_test <- test

# Drop Survived column for knn_train and knn_test
knn_train$Survived <- NULL
knn_test$Survived <- NULL

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


################ The knn() function ################
set.seed(1)

pred <- knn(train = knn_train, test = knn_test, cl = train_labels, k = 5)
conf <- table(test_labels, pred)
conf

##### K's choice #####
set.seed(1)

range <- 1:round(0.2 * nrow(knn_train))
accs <- rep(0, length(range))

for (k in range) {
  pred <- knn(train = knn_train, test = knn_test, cl = train_labels, k = k)
  conf <- table(test_labels, pred)
  accs[k] <- sum(diag(conf)) / sum(conf)
}

plot(range, accs, xlab = "k")
which.max(accs)

########## The ROC curve ##########

##### Creating the ROC curve #####
set.seed(1)

tree <- rpart(income ~ ., train, method = "class")

all_probs <- predict(tree, test, type = "prob")
all_probs

probs <- all_probs[, 2]

# Make a prediction object: pred
pred <- prediction(probs, test$income)

# Make a performance object: perf
perf <- performance(pred, "tpr", "fpr")
plot(perf)

##### The area under the curve (AUC) #####
set.seed(1)
tree <- rpart(income ~ ., train, method = "class")
probs <- predict(tree, test, type = "prob")[, 2]

pred <- prediction(probs, test$income)
perf <- performance(pred, "auc")

AUC <- perf@y.values[[1]]
AUC

############# A decision tree model VS a k-Nearest Neighbor model #############

pred_t <- prediction(probs_t, test$spam)
pred_k <- prediction(probs_k, test$spam)

# Make the performance objects for both models: perf_t, perf_k
perf_t <- performance(pred_t, "tpr", "fpr")
perf_k <- performance(pred_k, "tpr", "fpr")

# Draw the ROC lines using draw_roc_lines()
draw_roc_lines(perf_t, perf_k)

# Decision tree works best.
