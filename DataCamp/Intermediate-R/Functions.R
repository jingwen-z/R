library(ggplot2)

####### Introduction to Functions #######

### Function documentation ###
# Consult the documentation on the mean() function
?mean
help(mean)

# Inspect the arguments of the mean() function
args(mean)

linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)

### Use a function ###
# Calculate average number of views
avg_li <- mean(linkedin)
avg_fb <- mean(facebook)

# Inspect avg_li and avg_fb
avg_li
avg_fb

# Calculate the mean of the sum
avg_sum <- mean(linkedin + facebook)

# Calculate the trimmed mean of the sum
avg_sum_trimmed <-mean(linkedin + facebook, trim = 0.2)

avg_sum
avg_sum_trimmed

# Basic average of linkedin
mean(linkedin)

# Advanced average of linkedin
mean(linkedin, na.rm = TRUE)

### Functions inside functions ###
# Calculate the mean absolute deviation
mean(abs(linkedin - facebook), na.rm = TRUE)

####### Writing Functions #######

### Write your own function ###
# Create a function pow_two()
pow_two <- function(x) {
    x^2
}

# Use the function
pow_two(12)

# Create a function sum_abs()
sum_abs <- function(a, b) {
    abs(a) + abs(b)
}

# Use the function
sum_abs(-2, 3)

# Define the function hello()
hello <- function() {
    print("Hi there!")
    return(TRUE)
}

# Call the function hello()
hello()

# Finish the pow_two() function
pow_two <- function(x, print_info = TRUE) {
  y <- x ^ 2
  if (print_info == TRUE) {
    print(paste(x, "to the power two equals", y))
  }
  return(y)
}

### R you functional? ###
# Define the interpret function
interpret <- function(num_views) {
  if (num_views > 15) {
    print("You're popular!")
    return(num_views)
  } else {
    print("Try to be more visible!")
    return(0)
  }
}

interpret(linkedin[1])
interpret(facebook[2])

# The interpret() can be used inside interpret_all()
interpret <- function(num_views) {
  if (num_views > 15) {
    print("You're popular!")
    return(num_views)
  } else {
    print("Try to be more visible!")
    return(0)
  }
}

# Define the interpret_all() function
# views: vector with data to interpret
# return_sum: return total number of views on popular days?
interpret_all <- function(views, return_sum = TRUE) {
  count <- 0

  for (v in views) {
    count <- count + interpret(v)
  }

  if (return_sum == TRUE) {
    return(count)
  } else {
    return(NULL)
  }
}

# Call the interpret_all() function on both linkedin and facebook
interpret_all(linkedin)
interpret_all(facebook)

####### R Packages #######

### Load an R Package ###
# The mtcars vectors have already been prepared for you
wt <- mtcars$wt
hp <- mtcars$hp

# Request the currently attached packages
search()

# Try the qplot() function with wt and hp
qplot(wt, hp)

# Check out the currently attached packages again
search()
