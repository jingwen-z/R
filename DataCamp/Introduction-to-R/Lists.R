### Creating a list ###
# Vector with numerics from 1 up to 10
my_vector <- 1:10

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10, ]

# Construct list with these different elements:
my_list <- list(my_vector, my_matrix, my_df)

### Creating a named list ###
# Vector with numerics from 1 up to 10
my_vector <- 1:10

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10, ]

# Adapt list() call to give the components names
my_list <- list(my_vector, my_matrix, my_df)

# Print out my_list
names(my_list) <- c("vec", "mat", "df")
my_list

# The variables mov, act and rev are available

# Finish the code to build shining_list
shining_list <- list(moviename = mov, actors = act, reviews = rev)

### Selecting elements from a list ###
# shining_list is already pre-loaded in the workspace
shining_list

# Print out the vector representing the actors
shining_list[[2]]
shining_list[["actors"]]

# Print the second element of the vector representing the actors
shining_list[[2]][2]

### Adding more movie information to the list ###
# add the year to shining_list
shining_list_full <- c(shining_list, year = 1980)

# Have a look at shining_list_full
str(shining_list_full)
