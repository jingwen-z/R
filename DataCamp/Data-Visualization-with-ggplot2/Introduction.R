# Load the ggplot2 package
library(ggplot2)

########## Introduction ##########

##### Exploring ggplot2, part 1 #####
# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(x = cyl, y = mpg)) +
  geom_point()

# The plot isn't really satisfying. 
# Although cyl (the number of cylinders) is categorical, it is classified as numeric in mtcars. 
# We have to explicitly tell ggplot2 that cyl is a categorical variable.

##### Exploring ggplot2, part 2 #####
# Change the command below so that cyl is treated as factor
ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
  geom_point()

########## Grammar of Graphics ##########

#####  #####







#####  #####






#####  #####







#####  #####







#####  #####







#####  #####








#####  #####







#####  #####
