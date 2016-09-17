####### Visible Aesthetics #######

### All about aesthetics ###

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

###  ###





###  ###





###  ###






###  ###
