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

#################  #################
