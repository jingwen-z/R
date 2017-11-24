# Load the ggplot2 package
library(ggplot2)

###### Introduction ######

##### Exploring ggplot2, part 1
# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(x = cyl, y = mpg)) +
  geom_point()

##### Exploring ggplot2, part 2
# Change the command below so that cyl is treated as factor
ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
  geom_point()

###### Grammar of Graphics ######

##### Exploring ggplot2, part 3
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

ggplot(mtcars, aes(x = wt, y = mpg, col = disp)) +
  geom_point()

ggplot(mtcars, aes(x = wt, y = mpg, size = disp)) +
  geom_point()

###### ggplot2 ######

##### Exploring ggplot2, part 4
# Explore the diamonds data frame with str()
str(diamonds)

# Add geom_point() with +
ggplot(diamonds, aes(x = carat, y = price)) +
    geom_point()

# Add geom_point() and geom_smooth() with +
ggplot(diamonds, aes(x = carat, y = price)) +
    geom_point() +
    geom_smooth()

##### Exploring ggplot2, part 5
# The plot you created in the previous exercise
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth()

# Copy the above command but show only the smooth line
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_smooth()

# Copy the above command and assign the correct value to col in aes()
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
  geom_smooth()

# alpha = 0.4 makes the points 40% transparent
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
  geom_point(alpha = 0.4)

##### Understanding the grammar, part 1
# Create the object containing the data and aes layers: dia_plot
dia_plot <- ggplot(diamonds, aes(x = carat, y = price))

# Add a geom layer with + and geom_point()
dia_plot + geom_point()

# Add the same geom layer, but with aes() inside
dia_plot + geom_point(aes(col = clarity))

##### Understanding the grammar, part 2
set.seed(1)

# The dia_plot object has been created for you
dia_plot <- ggplot(diamonds, aes(x = carat, y = price))

# Expand dia_plot by adding geom_point() with alpha set to 0.2
dia_plot <- dia_plot + geom_point(alpha = 0.2)

# Plot dia_plot with additional geom_smooth() with se set to FALSE
dia_plot + geom_smooth(se = FALSE)
dia_plot + geom_smooth(aes(col = clarity), se = FALSE)
