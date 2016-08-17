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






###############  ###############





###############  ###############
