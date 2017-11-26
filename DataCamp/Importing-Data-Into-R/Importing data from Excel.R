library(readxl)
library(XLConnect)

###### The readxl package ######

### List the sheets of an Excel file ###
# Print out the names of both spreadsheets
excel_sheets("latitude.xlsx")

### Import an Excel sheet ###
# Read the first sheet of latitude.xlsx: latitude_1
latitude_1 <- read_excel("latitude.xlsx", sheet = 1)

# Read the second sheet of latitude.xlsx: latitude_2
latitude_2 <- read_excel("latitude.xlsx", sheet = "1900")

# Put latitude_1 and latitude_2 in a list: lat_list
lat_list <- list(latitude_1, latitude_2)

# Display the structure of lat_list
str(lat_list)

### Reading a workbook ###
# Read all Excel sheets with lapply(): lat_list
lat_list <- lapply(excel_sheets("latitude.xlsx"), read_excel, path = "latitude.xlsx")

# Display the structure of lat_list
str(lat_list)

### The col_names argument ###
latitude_3 <- read_excel("latitude_nonames.xlsx", sheet = 1, col_names = FALSE)

latitude_4 <- read_excel("latitude_nonames.xlsx", sheet = 1,
                         col_names = c("country", "latitude"))

summary(latitude_3)
summary(latitude_4)

### The skip argument ###
# Import the second sheet of latitude.xlsx, skipping the first 21 rows: latitude_sel
latitude_sel <- read_excel("latitude.xlsx", sheet = 2, col_names = FALSE, skip = 21)

# Print out the first observation from latitude_sel
latitude_sel[1, ]

###### The gdata package ######

### Import a local file ###
# Load the gdata package
library(gdata)

# Import the second sheet of urbanpop.xls: urban_pop
urban_pop <- read.xls("urbanpop.xls", sheet = "1967-1974")

# Print the first 11 observations using head()
head(urban_pop, 11)

### read.xls() wraps around read.table() ###
columns <- c("country", paste0("year_", 1967:1974))

# Finish the read.xls call: skip the first 50 rows of the sheet.
urban_pop <- read.xls("urbanpop.xls", sheet = 2,
                      skip = 50, header = FALSE,
                      stringsAsFactors = FALSE,
                      col.names = columns)
head(urban_pop, 10)

### Work that Excel data! ###
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

###### The XLConnect package ######

### Import a workbook ###
# Build connection to latitude.xlsx: my_book
my_book <- loadWorkbook("latitude.xlsx")

# Print out the class of my_book
class(my_book)

### List and read Excel sheets ###
# List the sheets in my_book
getSheets(my_book)

# Import the second sheet in my_book
readWorksheet(my_book, sheet = 2)

### Add and populate worksheets ###
# Build connection to latitude.xlsx
my_book <- loadWorkbook("latitude.xlsx")

# Create data frame: summ
dims1 <- dim(readWorksheet(my_book, 1))
dims2 <- dim(readWorksheet(my_book, 2))
summ <- data.frame(sheets = getSheets(my_book),
                   nrows = c(dims1[1], dims2[1]),
                   ncols = c(dims1[2], dims2[2]))

# Add a worksheet to my_book, named "data_summary"
createSheet(my_book, name = "data_summary")

# Populate "data_summary" with summ
writeWorksheet(my_book, summ, sheet = "data_summary")

# Save workbook as latitude_with_summ.xlsx
saveWorkbook(my_book, "latitude_with_summ.xlsx")
