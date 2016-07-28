##################################### Importing data from other statistical software & haven #####################################

#################### Import SAS data with haven ####################
# Load the haven package
library(haven)

# Import sales.sas7bdat: sales
sales <- read_sas("sales.sas7bdat")

# Display the structure of sales
str(sales)

#################### Import STATA data with haven ####################
# Import the data from the URL: sugar
sugar <- read_dta("http://assets.datacamp.com/course/importing_data_into_r/trade.dta")
  
# Structure of sugar
str(sugar)

# Convert values in Date column to dates
sugar$Date <- as.Date(as_factor(sugar$Date))

# Structure of sugar again
str(sugar)

#################### Import SPSS data with haven ####################
# Import person.sav: traits
traits <- read_sav("person.sav")

# Summarize traits
summary(traits)

# Print out a subset of those individuals that scored high on Extroversion and on Agreeableness
# i.e. scoring higher than 40 on each of these two categories. 
subset(traits, Extroversion > 40 & Agreeableness > 40)

#################### Factorize, round two ####################
# Import SPSS data from the URL: work
work <- read_sav("http://assets.datacamp.com/course/importing_data_into_r/employee.sav")

# Display summary of work$GENDER
summary(work$GENDER)

# Convert work$GENDER to a factor 
work$GENDER <- as_factor(work$GENDER)

# Display summary of work$GENDER again
summary(work$GENDER)

##################################### The foreign package #####################################

####################  ####################
