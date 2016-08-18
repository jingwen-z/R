##################################### Regression: simple and linear! #####################################

############### Simple linear regression: your first step! ###############
# The kang_nose dataset and nose_width_new are already loaded in your workspace.

# Plot nose length as function of nose width.
plot(kang_nose, xlab = "nose width", ylab = "nose length")

# Fill in the ___, describe the linear relationship between the two variables: lm_kang
# model the nose_length by the nose_width variable
lm_kang <- lm(nose_length ~ nose_width, data = kang_nose)

# Print the coefficients of lm_kang
lm_kang$coefficients
#  (Intercept)  nose_width 
#    27.893058    2.701175 

# Predict and print the nose length of the escaped kangoroo
predict(lm_kang, nose_width_new)
#         1 
#  703.1869 
# With a nose width of 250mm, your prediction tells us Skippy has a nose length of around 700mm.

############### Performance measure: RMSE ###############
# Build model and make plot
lm_kang <- lm(nose_length ~ nose_width, data=kang_nose)
plot(kang_nose, xlab = "nose width", ylab = "nose length")
abline(lm_kang$coefficients, col = "red")

# Apply predict() to lm_kang: nose_length_est
nose_length_est <- predict(lm_kang)

# Calculate difference between the predicted and the true values: res
res <- kang_nose$nose_length - nose_length_est

# Calculate RMSE, assign it to rmse and print it
rmse <- sqrt( sum(res^2) / nrow(kang_nose) )
rmse
# 43.26288

############### Performance measures: R-squared ###############
# You can compare the RMSE to the total variance of your response by calculating the R^2
# The closer R^2 to 1, the greater the degree of linear association is between the predictor and the response variable.

# Calculate the residual sum of squares: ss_res
ss_res <- sum(res^2)

# Determine the total sum of squares: ss_tot
ss_tot <- sum((kang_nose$nose_length - mean(kang_nose$nose_length) )^2 )

# Calculate R-squared and assign it to r_sq. Also print it.
r_sq <- 1 - ( ss_res / ss_tot )
r_sq

# Apply summary() to lm_kang
summary(lm_kang)  # 0.7768914
# An R-squared of 0.77 is pretty neat!

############### Another take at regression: be critical ###############
# world_bank_train and cgdp_afg is available for you to work with

# Plot urb_pop as function of cgdp
plot(world_bank_train, xlab = "cgdp", ylab = "urb_pop")

# Set up a linear model between the two variables: lm_wb
lm_wb <- lm(urb_pop ~ cgdp, data = world_bank_train)

# Add a red regression line to your scatter plot
abline(lm_wb$coefficients, col = "red")

# Summarize lm_wb and select R-squared
summary(lm_wb)$r.squared  # 0.3822067
# linear model is barely acceptable and far from satisfying
# R-squared is quite low and the regression line doesn't seem to fit well

# Predict the urban population of afghanistan based on cgdp_afg
predict(lm_wb, cgdp_afg)  # 45.01204 

############### Non-linear, but still linear? ###############
# world_bank_train and cgdp_afg is available for you to work with

# Plot: change the formula and xlab
plot(urb_pop ~ log(cgdp), data = world_bank_train, 
     xlab = "log(GDP per Capita)", 
     ylab = "Percentage of urban population")

# Linear model: change the formula
lm_wb <- lm(urb_pop ~ log(cgdp), data = world_bank_train)

# Add a red regression line to your scatter plot
abline(lm_wb$coefficients, col = "red")

# Summarize lm_wb and select R-squared
summary(lm_wb)$r.squared  # 0.5787588

# Predict the urban population of afghanistan based on cgdp_afg
predict(lm_wb, cgdp_afg)  # 25.86759
# this model predicts the urban population of Afghanistan to be around 26%

## The second model clearly is better to predict the percentage of urban population based on the GDP per capita. 
## The type of the second model is called log-linear, as you take the logarithm of your predictor variable, 
## but leave your response variable unchanged. Overall your model still has quite a lot of unexplained variance. 
## If you want more precise predictions, you'll have to add other relevant variables in a multivariable linear model.

##################################### Multivariable Linear Regression #####################################

############### Going all-in with predictors! ###############
# shop_data has been loaded in your workspace

# Add a plot: sales as a function of inventory. Is linearity plausible?
plot(sales ~ sq_ft, shop_data)
plot(sales ~ size_dist, shop_data)
plot(sales ~ inv, shop_data)

# Build a linear model for net sales based on all other variables: lm_shop
lm_shop <- lm(sales ~ ., shop_data)

# Summarize lm_shop
summary(lm_shop)
# Multiple R-squared:  0.9932
# Adjusted R-squared:  0.9916 

############### Are all predictors relevant? ###############

# exo 1
# shop_data, shop_new and lm_shop have been loaded in your workspace

# Plot the residuals in function of your fitted observations
plot(x = lm_shop$fitted.values, y = lm_shop$residuals)

# Make a Q-Q plot of your residual quantiles
qqnorm(x = lm_shop$fitted.values, y = lm_shop$residuals, ylab = "Residual Quantiles")

# Summarize your model, are there any irrelevant predictors?
summary(lm_shop)

# Predict the net sales based on shop_new.
predict(lm_shop, shop_new)  # 262.5006

## There is no clear pattern in your residuals.
## Moreover, the residual quantiles are approximately on one line.
## From the small p-values you can conclude that every predictor is important!

# exo 2
# choco_data has been loaded in your workspace

# Add a plot:  energy/100g as function of total size. Linearity plausible?
plot(energy ~ protein, choco_data)
plot(energy ~ fat, choco_data)
plot(energy ~ size, choco_data)

# Build a linear model for the energy based on all other variables: lm_choco
lm_choco <- lm(energy ~ ., choco_data)

# Plot the residuals in function of your fitted observations
plot(x = lm_choco$fitted.values, y = lm_choco$residuals)

# Make a Q-Q plot of your residual quantiles
qqnorm(x = lm_choco$fitted.values, y = lm_choco$residuals)

# Summarize lm_choco
summary(lm_choco)

## Call:
## lm(formula = energy ~ ., data = choco_data)

## Residuals:
##      Min       1Q   Median       3Q      Max 
## -107.084  -35.756   -8.323   36.100  104.660 

## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1338.3334    40.0928  33.381  < 2e-16 ***
## protein       23.0019     3.6636   6.279 6.97e-08 ***
## fat           24.4662     1.6885  14.490  < 2e-16 ***
## size          -0.8183     0.6035  -1.356    0.181    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## Residual standard error: 52.2 on 52 degrees of freedom
## Multiple R-squared:  0.9019,	Adjusted R-squared:  0.8962 
## F-statistic: 159.3 on 3 and 52 DF,  p-value: < 2.2e-16

# The predictor size is statistically insignificant, it is best to remove it.

##################################### k-Nearest Neighbors and Generalization #####################################

############### Does your model generalize? ###############
# world_bank_train, world_bank_test and lm_wb_log are pre-loaded

# Build the log-linear model
lm_wb_log <- lm(urb_pop ~ log(cgdp), data = world_bank_train)

# Calculate rmse_train
rmse_train <- sqrt(mean(lm_wb_log$residuals ^ 2))

# The real percentage of urban population in the test set, the ground truth
world_bank_test_truth <- world_bank_test$urb_pop

# The predictions of the percentage of urban population in the test set
world_bank_test_input <- data.frame(cgdp = world_bank_test$cgdp)
world_bank_test_output <- predict(lm_wb_log, world_bank_test_input)

# The residuals: the difference between the ground truth and the predictions
# Find the ground truth labels and then compare them with predictions that made with lm_wb_log.
res_test <- world_bank_test_output - world_bank_test_truth


# Use res_test to calculate rmse_test
rmse_test <- sqrt( mean(res_test ^ 2) )

# Print the ratio of the test RMSE over the training RMSE
rmse_test / rmse_train  # 1.08308

## The test's RMSE is only slightly larger than the training RMSE. 
## This means that the model generalizes well to unseen observations. 
## The logarithm transformation did improve your model. 
## It fits the data better and does a good job at generalizing!

############### Your own k-NN algorithm! ###############
###
# You don't have to change this!
# The algorithm is already coded for you; 
# inspect it and try to understand how it works!

# x_pred: predictor values of the new observations (this will be the cgdp column of world_bank_test),
# x: predictor values of the training set (the cgdp column of world_bank_train),
# y: response values of the training set (the urb_pop column of world_bank_train),
# k: the number of neighbors (this will be 30).
# predict_knn: returns the predicted values for the new observations

my_knn <- function(x_pred, x, y, k){
  m <- length(x_pred)
  predict_knn <- rep(0, m)
  for (i in 1:m) {
    
    # Calculate the absolute distance between x_pred[i] and x
    dist <- abs(x_pred[i] - x)
    
    # Apply order() to dist, sort_index will contain 
    # the indices of elements in the dist vector, in 
    # ascending order. This means sort_index[1:k] will
    # return the indices of the k-nearest neighbors.
    sort_index <- order(dist)    
    
    # Apply mean() to the responses of the k-nearest neighbors
    predict_knn[i] <- mean(y[sort_index[1:k]])    
    
  }
  return(predict_knn)
}
###

# world_bank_train and world_bank_test are pre-loaded

# Apply your algorithm on the test set: test_output
test_output <- my_knn(x_pred = world_bank_test$cgdp, x = world_bank_train$cgdp, y =world_bank_train$urb_pop, k = 30)

# Have a look at the plot of the output
plot(world_bank_train, 
     xlab = "GDP per Capita", 
     ylab = "Percentage Urban Population")
points(world_bank_test$cgdp, test_output, col = "green")

############### Parametric vs non-parametric! ###############




