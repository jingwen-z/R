####################################### Importing data from the web #######################################

################# Import flat files from the web #################
# Load the readr package
library(readr)

# Import the csv file: pools
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/swimming_pools.csv"
pools <- read_csv(url_csv)

# Import the txt file: potatoes
url_delim <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/potatoes.txt"
potatoes <- read_tsv(url_delim)

# Print pools and potatoes
pools
potatoes

################# Secure importing #################
# https URL to the swimming_pools csv file.
url_csv <- "https://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/swimming_pools.csv"

# Import the file using read.csv(): pools1
pools1 <- read.csv(url_csv)

# Load the readr package
library(readr)

# Import the file using read_csv(): pools2
pools2 <- read_csv(url_csv)

# Print the structure of pools1 and pools2
str(pools1)
# 'data.frame':	20 obs. of  4 variables:
#  $ Name     : Factor w/ 20 levels "Acacia Ridge Leisure Centre",..: 1 2 3 4 5 6 19 7 8 9 ...
#  $ Address  : Factor w/ 20 levels "1 Fairlead Crescent, Manly",..: 5 20 18 10 9 11 6 15 12 17 ...
#  $ Latitude : num  -27.6 -27.6 -27.6 -27.5 -27.4 ...
#  $ Longitude: num  153 153 153 153 153 ...
 
str(pools2)
# Classes 'tbl_df', 'tbl' and 'data.frame':	20 obs. of  4 variables:
#  $ Name     : chr  "Acacia Ridge Leisure Centre" "Bellbowrie Pool" "Carole Park" "Centenary Pool (inner City)" ...
#  $ Address  : chr  "1391 Beaudesert Road, Acacia Ridge" "Sugarwood Street, Bellbowrie" "Cnr Boundary Road and Waterford Road Wacol" "400 Gregory Terrace, Spring Hill" ...
#  $ Latitude : num  -27.6 -27.6 -27.6 -27.5 -27.4 ...
#  $ Longitude: num  153 153 153 153 153 ...
 
################# Import Excel files from the web #################
# Load the readxl and gdata package
library(readxl)
library(gdata)

# Specification of url: url_xls
url_xls <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/latitude.xls"

# Import the .xls file with gdata: excel_gdata
excel_gdata <- read.xls(url_xls)

# You can not use read_excel() directly with a URL.
# Complete the following instructions to work around this problem:
# Download file behind URL, name it local_latitude.xls
download.file(url_xls, "./local_latitude.xls")

# Import the local .xls file with readxl: excel_readxl
excel_readxl <- read_excel("local_latitude.xls")

# It appears that readxl is not (yet?) able to deal with Excel files that are on the web.
# However, a simply workaround with download.file() fixes this.

################# Downloading any file, secure or not #################
# https URL to the wine RData file.
url_rdata <- "https://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/wine.RData"

# Download the wine file to your working directory
download.file(url_rdata, "./wine_local.RData")

# Load the wine data into your workspace using load()
# It takes one argument, the path to the file, which is just the filename in our case.
load("wine_local.RData")

# Print out the summary of the wine data
summary(wine)

# Another way to load remote RData files is to use the url() function inside load().
# However, this will not save the RData file to a local file.

# CAN NOT directly use a URL string inside load() to load remote RData files.
# Should use url() or download the file first using download.file().

################# HTTP? httr! #################
# Load the httr package
library(httr)

## exo 1

# Get the url, save response to resp
url <- "http://www.example.com/"
resp <- GET(url)

# Print resp
resp

# Get the raw content of resp
# Set the `as` argument to raw
raw_content <- content(resp, as = "raw")

# Print the head of content
head(raw_content)

## exo 2
# Get the url
url <- "https://www.omdbapi.com/?t=Annie+Hall&y=&plot=short&r=json"
resp <- GET(url)

# Print resp
resp

# Print content of resp as text
content(resp, as = "text")

# Print content of resp
content(resp)

# `httr` converts the JSON response body automatically to an R list is very convenient.

####################################### Importing data from the web: jsonlite #######################################

################# From JSON to R #################
# Load the jsonlite package
library(jsonlite)

# exo 1

# Convert wine_json to a list: wine
wine_json <- '{"name":"Chateau Migraine", "year":1997, "alcohol_pct":12.4, "color":"red", "awarded":false}'
wine <- fromJSON(wine_json)

# Import Quandl data: quandl_data
quandl_url <- "http://www.quandl.com/api/v1/datasets/IWS/INTERNET_INDIA.json?auth_token=i83asDsiWUUyfoypkgMz"
quandl_data <- fromJSON(quandl_url)

# Print structure of wine and quandl_data
str(wine)
str(quandl_data)

# exo 2

# Experiment 1
# Change the assignment of json1 such that the R vector after conversion contains the numbers 1 up to 6, in ascending order.
# json1 <- '[1, 2, 4, 6]'
json1 <- '[1, 2, 3, 4, 5, 6]'
fromJSON(json1)
#  [1] 1 2 3 4 5 6


# Experiment 2
# json2 is converted to a named list with two elements: 
# a, containing the numbers 1, 2 and 3; b, containing the numbers 4, 5 and 6. 
# json2 <- '{"a": [1, 2, 3]}'
json2 <- '{"a": [1, 2, 3], "b":[4, 5, 6]}'
fromJSON(json2)
#  $a
#  [1] 1 2 3

#  $b
#  [1] 4 5 6


# Experiment 3
# Remove characters from json3 to build a 2 by 2 matrix containing only 1, 2, 3 and 4.
# json3 <- '[[1, 2], [3, 4], [5, 6]]'
json3 <- '[[1, 2], [3, 4]]'
fromJSON(json3)
#       [,1] [,2]
#  [1,]    1    2
#  [2,]    3    4


# Experiment 4
# Add characters to json4 such that the data frame in which the json is converted contains an additional observation in the last row.
# For this observations, a equals 5 and b equals 6. 
# json4 <- '[{"a": 1, "b": 2}, {"a": 3, "b": 4}]'
json4 <- '[{"a": 1, "b": 2}, {"a": 3, "b": 4}, {"a": 5, "b": 6}]'
fromJSON(json4)
#    a b
#  1 1 2
#  2 3 4
#  3 5 6

## Different JSON data structures will lead to different data structures in R.

################# Ask OMDb #################
# The package jsonlite is already loaded

# Definition of the URLs
url_sw4 <- "http://www.omdbapi.com/?i=tt0076759&r=json"
url_sw3 <- "http://www.omdbapi.com/?i=tt0121766&r=json"

# Import two URLs with fromJSON(): sw4 and sw3
sw4 <- fromJSON(url_sw4)
sw3 <- fromJSON(url_sw3)

# Print out the Title element of both lists
sw4$Title
sw3$Title

# Is the release year of sw4 later than sw3?
sw4$Year > sw3$Year

# The fourth episode of the Star Wars saga was released before the third one!

################# From R to JSON #################
# jsonlite is already loaded

# URL pointing to the .csv file
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/water.csv"

# Import the .csv file located at url_csv
water <- read.csv(url_csv, stringsAsFactors = FALSE)

# Convert the data file according to the requirements
water_json <- toJSON(water)
   
# Print out water_json
water_json

################# Minify and prettify #################
# jsonlite is already loaded

# Convert mtcars to a pretty JSON: pretty_json
pretty_json <- toJSON(mtcars, pretty = TRUE)

# Print pretty_json
pretty_json

# Minify pretty_json: mini_json
mini_json <- minify(pretty_json)

# Print mini_json
mini_json
