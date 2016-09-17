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
# Map mpg onto x, qsec onto y and factor(cyl) onto col
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl))) +
geom_point()

# Add mapping: factor(am) onto shape
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl), shape = factor(am))) +
geom_point()

# Add mapping: (hp/wt) onto size
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl), shape = factor(am), size = (hp/wt))) +
geom_point()

## label and shape are only applicable to categorical data

####### Modifying Aesthetics #######

### Position ###
# The base layer, cyl.am, is available for you
# Add geom (position = "stack" by default)
cyl.am + 
  geom_bar(position = "stack")

# Fill - show proportion
cyl.am + 
  geom_bar(position = "fill")

# Dodging - principles of similarity and proximity
cyl.am +
  geom_bar(position = "dodge") 

# Clean up the axes with scale_ functions
val = c("#E41A1C", "#377EB8")
lab = c("Manual", "Automatic")
cyl.am +
  geom_bar(position = "dodge") +
  scale_x_discrete("Cylinders") + 
  scale_y_continuous("Number") +
  scale_fill_manual("Transmission", 
                    values = val,
                    labels = lab) 

# scale_x_discrete() takes as only argument the x-axis label: "Cylinders"
# scale_y_continuous() takes as only argument the y-axis label: "Number"
# scale_fill_manual() fixes the legend. 
# The first argument is the title of the legend: "Transmission". 
# Next, values and labels are set to predefined values for you. 
# These are the colors and the labels in the legend.

### Setting a dummy aesthetic ###
# Add a new column called group
mtcars$group <- 0

# Create jittered plot of mtcars: mpg onto x, group onto y
ggplot(mtcars, aes(x = mpg, y = group)) + 
geom_jitter()

# Change the y aesthetic limits
ggplot(mtcars, aes(x = mpg, y = group)) + 
geom_jitter() + 
scale_y_continuous(limits = c(-2, 2))

####### Aesthetics Best Practices #######

### Overplotting 1 - Point shape and transparency ###

## You'll have to deal with overplotting when you have:
# 1. Large datasets
# 2. Imprecise data and so points are not clearly separated on your plot
# 3. Interval data (i.e. data appears at fixed values) or
# 4. Aligned data values on a single axis

# Basic scatter plot: wt on x-axis and mpg on y-axis; map cyl to col
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
geom_point(size = 4)

# Hollow circles - an improvement
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
geom_point(size = 4, shape = 1)

# Add transparency - very nice
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
geom_point(size = 4, alpha = 0.6)

### Overplotting 2 - alpha with large datasets ###
# Scatter plot: carat (x), price (y), clarity (col)
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
geom_point()

# Adjust for overplotting
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
geom_point(alpha = 0.5)

# Scatter plot: clarity (x), carat (y), price (col)
ggplot(diamonds, aes(x = clarity, y = carat, col = price)) +
geom_point(alpha = 0.5)

# Dot plot with jittering
ggplot(diamonds, aes(x = clarity, y = carat, col = price)) +
geom_point(alpha = 0.5, position = "jitter")

