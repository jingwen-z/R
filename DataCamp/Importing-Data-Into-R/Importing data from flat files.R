######################################## Introduction & Flat Files ########################################

############# read.csv #############
# Import swimming_pools.csv: pools
pools <- read.csv("swimming_pools.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = TRUE)

# Print the structure of pools
str(pools)

############# read.delim #############
# Import hotdogs.txt: hotdogs
hotdogs <- read.delim("hotdogs.txt", header = FALSE, sep = "\t", stringsAsFactors = TRUE)

# Summarize hotdogs
summary(hotdogs)

############# read.table #############
# Path to the hotdogs.txt file: path
path <- file.path("data", "hotdogs.txt")

# Import the hotdogs.txt file: hotdogs
hotdogs <- read.table(path, 
                      sep = "\t", 
                      col.names = c("type", "calories", "sodium"))

# Call head() on hotdogs
head(hotdogs)

############# stringsAsFactors #############
# Import swimming_pools.csv correctly: pools
pools <- read.csv("swimming_pools.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)

# Check the structure of pools
str(pools)

############# Arguments #############
# Finish the read.delim() call
hotdogs <- read.delim("hotdogs.txt", header = FALSE, col.names = c("type", "calories", "sodium"))

# Select the hot dog with the least calories: lily
lily <- hotdogs[which.min(hotdogs$calories), ]

# Select the observation with the most sodium: tom
tom <- hotdogs[which.max(hotdogs$sodium),]

# Print lily and tom
lily
tom

############# Column classes #############
# Previous call to import hotdogs.txt
hotdogs <- read.delim("hotdogs.txt", header = FALSE, col.names = c("type", "calories", "sodium"))

# Display structure of hotdogs
str(hotdogs)

# Edit the colClasses argument to import the data correctly: hotdogs2
hotdogs2 <- read.delim("hotdogs.txt", header = FALSE, 
                       col.names = c("type", "calories", "sodium"),
                       colClasses = c("factor", "NULL", "numeric") )


# Display structure of hotdogs2
str(hotdogs2)

######################################## readr & data.table ########################################

############# read_delim #############
# Just as read.table() was the main utils function, read_delim() is the main readr function.
# Load the readr package
library(readr)

# Import potatoes.txt using read_delim(): potatoes
potatoes <- read_delim("potatoes.txt", delim = "\t")
# potatoes <- read_tsv("potatoes.txt", col_types = "iiiiiddd")

# Print out potatoes
potatoes

############# read_csv #############
# readr is already loaded

# Column names
properties <- c("area", "temp", "size", "storage", "method", 
                "texture", "flavor", "moistness")

# Import potatoes.csv with read_csv(): potatoes
potatoes <- read_csv("potatoes.csv", col_names = properties)

############# col_types, skip and n_max #############
# readr is already loaded

# Column names
properties <- c("area", "temp", "size", "storage", "method", 
                "texture", "flavor", "moistness")

# Finish the first read_tsv() call to import observations 7, 8, 9, 10 and 11 from potatoes.txt.
# Import 5 observations from potatoes.txt: potatoes_fragment
potatoes_fragment <- read_tsv("potatoes.txt", skip = 7, n_max = 5, col_names = properties)

# Import all data, but force all columns to be character: potatoes_char
potatoes_char <- read_tsv("potatoes.txt", col_types = "cccccccc")

############# col_types with collectors #############
# readr is already loaded

# Import without col_types
hotdogs <- read_tsv("hotdogs.txt", col_names = c("type", "calories", "sodium"))

# Display the summary of hotdogs
summary(hotdogs)

# The collectors you will need to import the data
fac <- col_factor(levels = c("Beef", "Meat", "Poultry"))
int <- col_integer()

# Edit the col_types argument: Pass a list() with the elements fac, int and int, so the first column is importead as a factor, and the second and third column as integers.
# Edit the col_types argument to import the data correctly: hotdogs_factor
hotdogs_factor <- read_tsv("hotdogs.txt", 
                           col_names = c("type", "calories", "sodium"),
                           col_types = list(fac, int, int))

# Display the summary of hotdogs_factor
summary(hotdogs_factor)

############# fread #############
# load the data.table package
library(data.table)

# Import potatoes.txt with fread(): potatoes
potatoes <- fread("potatoes.txt")

# Print out potatoes
potatoes

# fread is already loaded

# Import columns 6 and 8 of potatoes.txt: potatoes
potatoes <- fread("potatoes.txt", select = c(6, 8))

# Plot texture (x) and moistness (y) of potatoes
plot(potatoes$texture, potatoes$moistness, xlab = "texture", ylab = "moistness")
