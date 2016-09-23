####### Logistic regression on sonar #######

### Try a 60/40 split ###
# Shuffle row indices: rows
rows <- sample(nrow(Sonar))

# Randomly order data
Sonar <- Sonar[rows, ]

# Identify row to split on: split
split <- round(nrow(Sonar) * .60)

# Create train
train <- Sonar[1:split, ]

# Create test
test <- Sonar[(split + 1):nrow(Sonar), ]

### Fit a logistic regression model ###
## glm() is a more advanced version of lm() that allows for more varied types of regression models, 
## aside from plain vanilla ordinary least squares regression

# Fit glm model: model
model <- glm(Class ~ ., family = "binomial", train)

# Predict on test: p
p <- predict(model, test, type = "response")

####### Confusion matrix #######

###  ###








###  ###







###  ###





###  ###
