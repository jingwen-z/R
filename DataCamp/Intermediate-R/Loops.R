####### Write a while loop #######
# Initialize the speed variable
speed <- 64

# Code the while loop
while ( speed > 30 ) {
  print("Slow down!")
  speed <- speed - 7
}

speed

####### Throw in more conditionals #######
# Extend/adapt the while loop
while (speed > 30) {
  print(paste("Your speed is",speed))
  if (speed > 48) {
    print("Slow down big time!")
    speed <- speed - 11
  } else {
    print("Slow down!")
    speed <- speed - 6
  }
}

####### Stop the while loop: break #######
# Initialize the speed variable
speed <- 88

while (speed > 30) {
  print(paste("Your speed is", speed))

  # Break the while loop when speed exceeds 80
  if (speed > 80 ) {
    break
  }

  if (speed > 48) {
    print("Slow down big time!")
    speed <- speed - 11
  } else {
    print("Slow down!")
    speed <- speed - 6
  }
}

####### Build a while loop from scratch #######
i <- 1

# Code the while loop
while (i <= 10) {
  print(3 * i)
  if ( 3 * i %% 8 == 0 ) {
    break
  }
  i <- i + 1
}

####### Loop over a vector #######
linkedin <- c(16, 9, 13, 5, 2, 17, 14)

# Loop version 1
for (l in linkedin) {
    print(l)
}

# Loop version 2
for (k in 1:length(linkedin)) {
    print(linkedin[k])
}

####### Loop over a list #######
# The nyc list is already specified
nyc <- list(pop = 8405837,
            boroughs = c("Manhattan", "Bronx", "Brooklyn",
                         "Queens", "Staten Island"),
            capital = FALSE)

# Loop version 1
for (n in nyc) {
    print(n)
}

# Loop version 2
for (y in 1:length(nyc)) {
    print(nyc[[y]])
}

####### Loop over a matrix #######
# The tic-tac-toe matrix ttt has already been defined for you
ttt
# define the double for loop
for (i in 1:nrow(ttt)) {
  for (j in 1:ncol(ttt)) {
    print(paste("On row", i, "and column", j, "the board contains", ttt[i, j]))
  }
}

####### Mix it up with control flow #######
# Code the for loop with conditionals
for (li in linkedin) {
  if (li > 10) {
    print("You're popular!")
  } else {
    print("Be more visible!")
  }
  print(li)
}

####### Next, you break it #######
# Extend the for loop
for (li in linkedin) {
  if (li > 10) {
    print("You're popular!")
  } else {
    print("Be more visible!")
  }

  # Add if statement with break
  if (li > 16) {
    print("This is ridiculous, I'm outta here!")
    break
  }

  # Add if statement with next
  if (li < 5) {
    print("This is too embarrassing!")
    next
  }

  print(li)
}

####### Build a for loop from scratch #######
# Pre-defined variables
rquote <- "r's internals are irrefutably intriguing"
chars <- strsplit(rquote, split = "")[[1]]

# Initialize rcount
rcount <- 0

# Finish the for loop
for (char in chars) {
  if (char == "r") {
    rcount <- rcount + 1
  }
  if (char == "u") {
    break
  }
}

rcount
