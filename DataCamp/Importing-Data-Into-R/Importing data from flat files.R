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

#############  #############
