############# What's a data frame? #############
# Print out built-in R data frame
mtcars 

############# Quick, have a look at your data set #############
# Call head() on mtcars
head(mtcars)

############# Have a look at the structure #############
# Investigate the structure of mtcars
str(mtcars)

############# Creating a data frame #############
# Definition of vectors
name <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)

# Create a data frame from the vectors
planets_df <- data.frame(name, type, diameter, rotation, rings)

# Check the structure of planets_df
str(planets_df)

############# Selection of data frame elements #############
# Print out diameter of of Mercury (row 1, column 3)
planets_df[1, 3]

# Print out data for Mars (entire fourth row)
planets_df[4, ]

# Select first 5 values of diameter column
planets_df[1:5, "diameter"]

############# Only planets with rings #############
# Select the rings variable from planets_df
rings_vector <- planets_df$rings
  
# Print out rings_vector
rings_vector

# Adapt the code to select all columns for planets with rings
planets_df[rings_vector, ]

############# Only planets with rings but shorter #############
# Select planets with diameter < 1
subset(planets_df, subset = diameter < 1)

############# Sorting your data frame #############
# Use order() to create positions
positions <- order(planets_df$diameter)

# Use positions to sort planets_df
planets_df[positions, ]
