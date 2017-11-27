library(data.table)
library(readr)

##### Introduction & Flat Files #####

### read.csv ###
pools <- read.csv("swimming_pools.csv", header = TRUE,
                  sep = ",", dec = ".",
                  stringsAsFactors = TRUE)
str(pools)

### read.delim ###
# Import hotdogs.txt: hotdogs
hotdogs <- read.delim("hotdogs.txt", header = FALSE,
                      sep = "\t", stringsAsFactors = TRUE)
summary(hotdogs)

### read.table ###
# Path to the hotdogs.txt file: path
path <- file.path("data", "hotdogs.txt")

# Import the hotdogs.txt file: hotdogs
hotdogs <- read.table(path,
                      sep = "\t",
                      col.names = c("type", "calories", "sodium"))
head(hotdogs)

### stringsAsFactors ###
# Import swimming_pools.csv correctly: pools
pools <- read.csv("swimming_pools.csv", header = TRUE,
                  sep = ",", dec = ".",
                  stringsAsFactors = FALSE)
str(pools)

### Arguments ###
# Finish the read.delim() call
hotdogs <- read.delim("hotdogs.txt", header = FALSE,
                      col.names = c("type", "calories", "sodium"))

# Select the hot dog with the least calories: lily
lily <- hotdogs[which.min(hotdogs$calories), ]

# Select the observation with the most sodium: tom
tom <- hotdogs[which.max(hotdogs$sodium),]

### Column classes ###
# Previous call to import hotdogs.txt
hotdogs <- read.delim("hotdogs.txt", header = FALSE,
                      col.names = c("type", "calories", "sodium"))
str(hotdogs)

# Edit the colClasses argument to import the data correctly: hotdogs2
hotdogs2 <- read.delim("hotdogs.txt", header = FALSE,
                       col.names = c("type", "calories", "sodium"),
                       colClasses = c("factor", "NULL", "numeric") )

##### readr & data.table #####

### read_delim ###
# Import potatoes.txt using read_delim(): potatoes
potatoes <- read_delim("potatoes.txt", delim = "\t")

### read_csv ###
# Column names
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import potatoes.csv with read_csv(): potatoes
potatoes <- read_csv("potatoes.csv", col_names = properties)

### col_types, skip and n_max ###
# Column names
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import 5 observations from potatoes.txt: potatoes_fragment
potatoes_fragment <- read_tsv("potatoes.txt", skip = 7,
                              n_max = 5, col_names = properties)

# Import all data, but force all columns to be character: potatoes_char
potatoes_char <- read_tsv("potatoes.txt", col_types = "cccccccc")

### col_types with collectors ###
# Import without col_types
hotdogs <- read_tsv("hotdogs.txt", col_names = c("type", "calories", "sodium"))

# The collectors you will need to import the data
fac <- col_factor(levels = c("Beef", "Meat", "Poultry"))
int <- col_integer()

hotdogs_factor <- read_tsv("hotdogs.txt",
                           col_names = c("type", "calories", "sodium"),
                           col_types = list(fac, int, int))

# Display the summary of hotdogs_factor
summary(hotdogs_factor)

### fread ###
# Import potatoes.txt with fread(): potatoes
potatoes <- fread("potatoes.txt")

# Import columns 6 and 8 of potatoes.txt: potatoes
potatoes <- fread("potatoes.txt", select = c(6, 8))

# Plot texture (x) and moistness (y) of potatoes
plot(potatoes$texture, potatoes$moistness, xlab = "texture", ylab = "moistness")
