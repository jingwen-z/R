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

#################### Import STATA data with foreign ####################
# Load the foreign package
library(foreign)

# Import florida.dta and name the resulting data frame florida
florida <- read.dta("florida.dta")

# Check tail() of florida
tail(florida, 6)

# Specify the file path using file.path(): path
path <- file.path("worldbank/edequality.dta")


# Create and print structure of edu_equal_1
# The "edequality.dta" file is located in the "worldbank" folder.
edu_equal_1 <- read.dta(path)
str(edu_equal_1)

# Create and print structure of edu_equal_2
edu_equal_2 <- read.dta(path, convert.factors = FALSE)
str(edu_equal_2)

# Create and print structure of edu_equal_3
edu_equal_3 <- read.dta(path, convert.underscore = TRUE)  
str(edu_equal_3)

#################### Do you know your data? ####################
# How many observations/individuals from Bulgaria have an income above 1000?
nrow(subset(edu_equal_1, ethnicity_head == "Bulgaria" & income > 1000)) # 8997

#################### Import SPSS data with foreign ####################
# foreign is already loaded

# Import international.sav as a data frame: demo
demo <- read.spss("international.sav", to.data.frame = TRUE)

# Create boxplot of gdp variable of demo
boxplot(demo$gdp)

# Import international.sav as a data frame, demo_1
demo_1 <- read.spss("international.sav", to.data.frame = TRUE)
  
# Print out the head of demo_1
head(demo_1)

# Import international.sav as demo_2
# but this time in a way such that variables with value labels are not converted to R factors
demo_2 <- read.spss("international.sav", use.value.labels = FALSE, to.data.frame = TRUE)

# Print out the head of demo_2
head(demo_2)

#################### Excursion: Correlation ####################
# What is the correlation coefficient for the two numerical variables gdp and f_illit (female illiteracy rate)?
cor(demo$gdp, demo$f_illit) # -0.4476856
