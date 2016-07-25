######################################## The readxl package ########################################

################# List the sheets of an Excel file #################
# Load the readxl package
library(readxl)

# "latitude.xlsx" gives information on the latitude of different countries for two different points in time (Source: Gapminder).

# Print out the names of both spreadsheets
excel_sheets("latitude.xlsx")

################# Import an Excel sheet #################
# The readxl package is already loaded

# Read the first sheet of latitude.xlsx: latitude_1
latitude_1 <- read_excel("latitude.xlsx", sheet = 1)

# Read the second sheet of latitude.xlsx: latitude_2
latitude_2 <- read_excel("latitude.xlsx", sheet = "1900")

# Put latitude_1 and latitude_2 in a list: lat_list
lat_list <- list(latitude_1, latitude_2)

# Display the structure of lat_list
str(lat_list)

################# Reading a workbook #################
# Read all Excel sheets with lapply(): lat_list
lat_list <- lapply(excel_sheets("latitude.xlsx"), read_excel, path = "latitude.xlsx")

# Display the structure of lat_list
str(lat_list)

################# The col_names argument #################
# Import the the first Excel sheet of latitude_nonames.xlsx (R gives names): latitude_3
latitude_3 <- read_excel("latitude_nonames.xlsx", sheet = 1, col_names = FALSE)

# Import the the first Excel sheet of latitude_nonames.xlsx (specify col_names): latitude_4
latitude_4 <- read_excel("latitude_nonames.xlsx", sheet = 1, col_names = c("country", "latitude"))

# Print the summary of latitude_3
summary(latitude_3)

# Print the summary of latitude_4
summary(latitude_4)

################# The skip argument #################
# Import the second sheet of latitude.xlsx, skipping the first 21 rows: latitude_sel
latitude_sel <- read_excel("latitude.xlsx", sheet = 2, col_names = FALSE, skip = 21)

# Print out the first observation from latitude_sel
latitude_sel[1, ]

######################################## The gdata package ########################################

################# Import a local file #################
# Load the gdata package 
library(gdata)

# Import the second sheet of urbanpop.xls: urban_pop
urban_pop <- read.xls("urbanpop.xls", sheet = "1967-1974")

# Print the first 11 observations using head()
head(urban_pop, 11)

################# read.xls() wraps around read.table() #################
# Column names for urban_pop
columns <- c("country", paste0("year_", 1967:1974))

# Finish the read.xls call: skip the first 50 rows of the sheet.
urban_pop <- read.xls("urbanpop.xls", sheet = 2, 
                      skip = 50, header = FALSE, stringsAsFactors = FALSE,
                      col.names = columns)

# Print first 10 observation of urban_pop
head(urban_pop, 10)

################# Work that Excel data! #################
# Add code to import data from all three sheets in urbanpop.xls
path <- "urbanpop.xls"
urban_sheet1 <- read.xls(path, sheet = 1, stringsAsFactors = FALSE)
urban_sheet2 <- read.xls(path, sheet = 2, stringsAsFactors = FALSE)
urban_sheet3 <- read.xls(path, sheet = 3, stringsAsFactors = FALSE)

# Extend the cbind() call to include urban_sheet3: urban
urban <- cbind(urban_sheet1, urban_sheet2[-1], urban_sheet3[-1])

# Remove all rows with NAs from urban: urban_clean
urban_clean <- na.omit(urban)

# Print out a summary of urban_clean
summary(urban_clean)

######################################## The XLConnect package ########################################

#################  #################
