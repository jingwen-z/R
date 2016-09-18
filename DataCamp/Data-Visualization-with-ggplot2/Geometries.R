##### Scatter Plots #####

### Scatter plots and jittering ###

## Part 1
# Plot the cyl on the x-axis and wt on the y-axis
ggplot(mtcars, aes(x = cyl, y = wt)) +
geom_point()

# Use geom_jitter() instead of geom_point()
ggplot(mtcars, aes(x = cyl, y = wt)) +
geom_jitter()

# Define the position object using position_jitter(): posn.j
posn.j <- position_jitter(width = 0.1)
  
# Use posn.j in geom_point()
ggplot(mtcars, aes(x = cyl, y = wt)) +
geom_point(position = posn.j)

# Saving the position as it's own object is a convenient way of 
# making sure all our plots have the same settings.

## Part 2
# Examine the structure of Vocab
str(Vocab)

# Basic scatter plot of vocabulary (y) against education (x). Use geom_point()
ggplot(Vocab, aes(x = education, y = vocabulary)) +
geom_point()

# Use geom_jitter() instead of geom_point()
ggplot(Vocab, aes(x = education, y = vocabulary)) +
geom_jitter()
  
# Using the above plotting command, set alpha to a very low 0.2
ggplot(Vocab, aes(x = education, y = vocabulary)) +
geom_jitter(alpha = 0.2)
  
# Using the above plotting command, set the shape to 1
ggplot(Vocab, aes(x = education, y = vocabulary)) +
geom_jitter(shape = 1)

## Notice how jittering and alpha blending serves as 
## a great solution to the overplotting problem here

##### Bar Plots #####

###  ###





###  ###





###  ###




###  ###




###  ###
