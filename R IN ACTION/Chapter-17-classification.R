### Chapiter 17: Classification

library(e1071)
library(party)
library(partykit)
library(rpart)
library(rpart.plot)

## 17.1 Preparing the data
loc <- "http://archive.ics.uci.edu/ml/machine-learning-databases/"
ds <- "breast-cancer-wisconsin/breast-cancer-wisconsin.data"
url <- paste(loc, ds, sep = "")

breast <- read.table(url, sep = ",", header = F, na.strings = "?")
names(breast) <- c("ID", "clumpThickness", "sizeUniformity", "shapeUniformity",
                   "maginalAdhesion", "singleEpithelialCellSize", "bareNuclei",
                   "blandChromatin", "normalNucleoli", "mitosis", "class")

df <- breast[-1]
df$class <- factor(df$class, levels = c(2, 4),
                   labels = c("benign", "malignant"))

set.seed(1234)
train <- sample(nrow(df), 0.7*nrow(df))
df.train <- df[train, ]
df.validate <- df[-train, ]

table(df.train$class)
table(df.validate$class)

## 17.2 Logistic regression
fit.logit <- glm(class ~ ., data = df.train, family = binomial())
summary(fit.logit)

prob <- predict(fit.logit, df.validate, type = "response")
logit.pred <- factor(prob > .5, levels = c(FALSE, TRUE),
                     labels = c("benign", "malignant"))
logit.perf <- table(df.validate$class, logit.pred,
                    dnn = c("Actual", "Predicted"))
logit.perf

## 17.3 Decision trees
# Classical decision trees
set.seed(1234)
dtree <- rpart(class ~ ., data = df.train, method = "class",
               parms = list(split = "information"))
dtree$cptable

plotcp(dtree)

dtree.pruned <- prune(dtree, cp = 0.09375)

prp(dtree.pruned, type = 2, extra = 104,
    fallen.leaves = T, main = "Decision Tree")

dtree.pred <- predict(dtree.pruned, df.validate, type = "class")
dtree.perf <- table(df.validate$class, dtree.pred,
                    dnn = c("Actual", "Predicted"))
dtree.perf

# Conditional inference trees
fit.ctree <- ctree(class~., data = df.train)
plot(fit.ctree, main = "Conditional Inference Tree")

ctree.pred <- predict(fit.ctree, df.validate, type = "response")
ctree.perf <- table(df.validate$class,
                    ctree.pred,
                    dnn = c("Actual", "Predicted"))
ctree.perf

## 17.5 Support vector machines
set.seed(1234)
fit.svm <- svm(class~., data = df.train)
fit.svm

svm.pred <- predict(fit.svm, na.omit(df.validate))
svm.perf <- table(na.omit(df.validate)$class,
                  svm.pred, dnn = c("Actual", "Predicted"))
svm.perf

# Tuning an RBF support vector machine
set.seed(1234)
tuned <- tune.svm(class~., data = df.train,
                  gamma = 10^(-6:1),
                  cost = 10^(-10:10))
tuned

fit.svmRBF <- svm(class~., data = df.train, gamma = 0.01, cost = 1)
svmRBF.pred <- predict(fit.svmRBF, na.omit(df.validate))
svmRBF.perf <- table(na.omit(df.validate)$class,
                     svmRBF.pred,
                     dnn = c("Actual", "Predicted"))
svmRBF.perf
