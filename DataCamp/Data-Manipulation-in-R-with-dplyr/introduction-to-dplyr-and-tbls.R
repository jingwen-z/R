## Introduction to dplyr

library(dplyr)
library(hflights)

head(hflights)
summary(hflights)

## tbl, a special type of data.frame
hflights <- tbl_df(hflights)
hflights

# Create the object carriers
carriers <- hflights$UniqueCarrier

# Changing labels of hflights
# part1
lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue",
         "CO" = "Continental", "DL" = "Delta", "OO" = "SkyWest",
         "UA" = "United", "US" = "US_Airways", "WN" = "Southwest",
         "EV" = "Atlantic_Southeast", "F9" = "Frontier", "FL" = "AirTran",
         "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")

# Add the Carrier column to hflights
hflights$Carrier <- lut[hflights$UniqueCarrier]

# Glimpse at hflights
glimpse(hflights)

# part2
lut <- c("A" = "carrier", "B" = "weather", "C" = "FFA",
         "D" = "security", "E" = "not cancelled")

hflights$Code <- lut[hflights$CancellationCode]
glimpse(hflights)
