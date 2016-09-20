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

### Histograms ###
# Make a univariate histogram
ggplot(mtcars, aes(x = mpg)) + 
geom_histogram()

# Change the bin width to 1
ggplot(mtcars, aes(x = mpg)) + 
geom_histogram(binwidth = 1)

# Change the y aesthetic to density
ggplot(mtcars, aes(x = mpg)) + 
geom_histogram(aes(y = ..density..), binwidth = 1)

# Custom color code
myBlue <- "#377EB8"

# Change the fill color to myBlue
ggplot(mtcars, aes(x = mpg)) + 
geom_histogram(aes(y = ..density..), binwidth = 1, fill = myBlue)

### Position ###
# stack: place the bars on top of each other. Counts are used.
# fill: place the bars on top of each other, but this time use proportions. 
# dodge: place the bars next to each other. Counts are used.

# Draw a bar plot of cyl, filled according to am
ggplot(mtcars, aes(x = cyl, fill = am)) +
geom_bar()

# Change the position argument to stack
ggplot(mtcars, aes(x = cyl, fill = am)) +
geom_bar(position = "stack")

# Change the position argument to fill
ggplot(mtcars, aes(x = cyl, fill = am)) +
geom_bar(position = "fill")

# Change the position argument to dodge
ggplot(mtcars, aes(x = cyl, fill = am)) +
geom_bar(position = "dodge")

### Overlapping bar plots ###
# Draw a bar plot of cyl, filled according to am
ggplot(mtcars, aes(x = cyl, fill = am)) + 
geom_bar()

# Change the position argument to "dodge"
ggplot(mtcars, aes(x = cyl, fill = am)) + 
geom_bar(position = "dodge")

# Define posn_d with position_dodge()
posn_d <- position_dodge(width = 0.2)

# Change the position argument to posn_d
ggplot(mtcars, aes(x = cyl, fill = am)) + 
geom_bar(position = posn_d)

# Use posn_d as position and adjust alpha to 0.6
ggplot(mtcars, aes(x = cyl, fill = am)) + 
geom_bar(position = posn_d, alpha = 0.6)

### Overlapping histograms (1) ###
# A basic histogram, add coloring defined by cyl 
ggplot(mtcars, aes(mpg, fill = cyl)) +
  geom_histogram(binwidth = 1)

# Change position to identity 
ggplot(mtcars, aes(mpg, fill = cyl)) +
  geom_histogram(binwidth = 1, position = "identity")

# Change geom to freqpoly (position is identity by default) 
ggplot(mtcars, aes(mpg, col = cyl)) +
  geom_histogram(binwidth = 1, position = "identity") +
  geom_freqpoly(binwidth = 1)

### Bar plots with color ramp ###

## part 1
# Example of how to use a brewed color palette
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1")

# Use str() on Vocab to check out the structure
str(Vocab)

# Plot education on x and vocabulary on fill
# Use the default brewed color palette
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
geom_bar(position = "fill") +
scale_fill_brewer()

## part 2
# Final plot of last exercise
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
  geom_bar(position = "fill") +
  scale_fill_brewer()
  
# Definition of a set of blue colors
blues <- brewer.pal(9, "Blues")

# Make a color range using colorRampPalette() and the set of blues
blue_range <- colorRampPalette(blues)

# Use blue_range to adjust the color of the bars, use scale_fill_manual()
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
geom_bar(position = "fill") +
scale_fill_manual(values = blue_range(11))

### Overlapping histograms (2) ###
# Basic histogram plot command
ggplot(mtcars, aes(mpg)) + 
  geom_histogram(binwidth = 1)

# Expand the histogram to fill using am
ggplot(mtcars, aes(mpg, fill = am)) + 
  geom_histogram(binwidth = 1)

# Change the position argument to "dodge"
ggplot(mtcars, aes(mpg, fill = am)) + 
  geom_histogram(binwidth = 1, position = "dodge")

# Change the position argument to "fill"
ggplot(mtcars, aes(mpg, fill = am)) + 
  geom_histogram(binwidth = 1, position = "fill")

# Change the position argument to "identity" and set alpha to 0.4
ggplot(mtcars, aes(mpg, fill = am)) + 
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)

# Change fill to cyl
ggplot(mtcars, aes(mpg, fill = cyl)) + 
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)

##### Line Plots - Time Series #####

### Line plots ###
# Print out head of economics
head(economics)

# Plot unemploy as a function of date using a line plot
ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line()
  
# Adjust plot to represent the fraction of total population that is unemployed
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_line()

### Periods of recession ###
# Expand the following command with geom_rect() to draw the recess periods
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_line() +
  geom_rect(data = recess, inherit.aes = FALSE, 
  aes(xmin = begin, xmax = end, ymin = -Inf, ymax = +Inf), 
  fill = "red", alpha = 0.2)

### Multiple time series ###

## part 1
# Check the structure as a starting point
str(fish.species)

# Use gather to go from fish.species to fish.tidy
fish.tidy <- gather(fish.species, Species, Capture, -Year)

## part 2
# Recreate the plot shown on the right
ggplot(fish.tidy, aes(x = Year, y = Capture, col = Species)) + 
  geom_line()
# group = Species
