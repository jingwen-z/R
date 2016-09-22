####### qplot #######

### Using qplot ###
# The old way (shown)
plot(mpg ~ wt, data = mtcars)

# Using ggplot:
ggplot(mtcars, aes(x = wt, y = mpg)) +
geom_point()

# Using qplot:
qplot(wt, mpg, data = mtcars)

### Using aesthetics ###
# basic scatter plot:
qplot(x = wt, y = mpg, data = mtcars)

# Categorical:
# cyl
qplot(x = wt, y = mpg, data = mtcars, size = cyl)

# gear
qplot(x = wt, y = mpg, data = mtcars, size = gear)

# Continuous
# hp
qplot(x = wt, y = mpg, data = mtcars, col = hp)

# qsec
qplot(x = wt, y = mpg, data = mtcars, col = qsec)

### Choosing geoms ###
## part 1
# qplot() with x only
qplot(x = factor(cyl), data = mtcars)

# qplot() with x and y
qplot(x = factor(cyl), y = factor(vs), data = mtcars)

# qplot() with geom set to jitter manually
qplot(x = factor(cyl), y = factor(vs), data = mtcars, geom = "jitter")

## part 2 - dotplot
# Make a dot plot with ggplot
ggplot(mtcars, aes(cyl, wt, fill = factor(am))) +
geom_dotplot(stackdir = "center", binaxis = "y")

# qplot with geom "dotplot", binaxis = "y" and stackdir = "center"
qplot(x = cyl, y = wt, data = mtcars, fill = factor(am), 
      geom = "dotplot", stackdir = "center", binaxis = "y") 

####### Wrap-up #######

### Chicken weight ###
# ChickWeight is available in your workspace

# Check out the head of ChickWeight
head(ChickWeight)

# Use ggplot() for the second instruction
ggplot(ChickWeight, aes(x = Time, y = weight)) +
geom_line(aes(group = Chick))

# Use ggplot() for the third instruction
ggplot(ChickWeight, aes(x = Time, y = weight, col = Diet)) +
geom_line(aes(group = Chick))

# Use ggplot() for the last instruction
ggplot(ChickWeight, aes(x = Time, y = weight, col = Diet)) +
geom_line(aes(group = Chick), alpha = 0.3) +
geom_smooth(lwd = 2, se = FALSE)

### Titanic ###
# titanic is avaliable in your workspace

# Check out the structure of titanic
str(titanic)

# Use ggplot() for the first instruction
ggplot(titanic, aes(x = factor(Pclass), fill = factor(Sex))) +
geom_bar(position = "dodge")

# Use ggplot() for the second instruction
ggplot(titanic, aes(x = factor(Pclass), fill = factor(Sex))) +
geom_bar(position = "dodge") +
facet_grid(. ~ Survived)

# Position jitter (use below)
posn.j <- position_jitter(0.5, 0)

# Use ggplot() for the last instruction
ggplot(titanic, aes(x = factor(Pclass), y = Age, col = factor(Sex))) +
geom_jitter(size = 3, alpha = 0.5, position = posn.j) +
facet_grid(. ~ Survived)
