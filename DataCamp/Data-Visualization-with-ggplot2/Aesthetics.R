####### Visible Aesthetics #######

### All about aesthetics ###
## These are the aesthetics we can consider within aes() in this chapter: 
## x, y, color, fill, size, alpha, labels and shape.

## part 1
# Map cyl to y
ggplot(mtcars, aes(x = mpg, y = cyl)) + 
geom_point()
  
# Map cyl to x
ggplot(mtcars, aes(x = cyl, y = mpg)) + 
geom_point()

# Map cyl to col
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
geom_point()

# Change shape and size of the points in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
geom_point(shape = 1, size = 4)

## part 2
# Given from the previous exercise
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point(shape = 1, size = 4)

# Map cyl to fill
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point()

# Change shape, size and alpha of the points in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(shape = 16, size = 6, alpha = 0.6)

## Notice that mapping a categorical variable onto fill doesn't change the colors, 
## although a legend is generated! This is because the default shape for points 
## only has a color attribute and not a fill attribute. 
## Use fill when you have another shape (such as a bar), or when using a point 
## that does have a fill and a color attribute, such as shape = 21, which is 
## a circle with an outline. 
## Any time you use a solid color, make sure to use alpha blending to account for over plotting.

## part 3
# Map cyl to size
ggplot(mtcars, aes(x = wt, y = mpg, size = cyl)) + 
geom_point()

# Map cyl to alpha
ggplot(mtcars, aes(x = wt, y = mpg, alpha = cyl)) + 
geom_point()

# Map cyl to shape 
ggplot(mtcars, aes(x = wt, y = mpg, shape = cyl)) + 
geom_point()

# Map cyl to labels
ggplot(mtcars, aes(x = wt, y = mpg, label = cyl)) + 
geom_text()

### All about attributes ###

## part 1
# Define a hexadecimal color
my_color <- "#123456"

# Set the color aesthetic 
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
geom_point()

# Set the color aesthetic and attribute 
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
geom_point(col = my_color)
##  if an aesthetic and an attribute are set with the same argument, 
## the attribute takes precedence

# Set the fill aesthetic and color, size and shape attributes
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
geom_point(size = 10, shape = 23, col = my_color)
## the attribute needs to match the shape and geom, 
## the fill aesthetic (or attribute) will only work with certain shapes

## part 2
# Expand to draw points with alpha 0.5
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
geom_point(alpha = 0.5)

  
# Expand to draw points with shape 24 and color yellow
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
geom_point(shape = 24, col = "yellow")

  
# Expand to draw text with label x, color red and size 10
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
geom_text(label = "x", col = "red", size = 10)

### Going all out ###





###  ###






###  ###
