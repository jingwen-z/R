library(data.table)
library(dplyr)

## group_by
# Unite and conquer using group_by
hflights %>%
  group_by(UniqueCarrier) %>%
  summarise(p_canc = mean(Cancelled == 1) * 100,
            avg_delay = mean(ArrDelay, na.rm = T)) %>%
  arrange(avg_delay, p_canc)

# Ordered overview of average arrival delays per carrier
filter(hflights, !is.na(ArrDelay), ArrDelay > 0) %>%
  group_by(UniqueCarrier) %>%
  summarise(avg = mean(ArrDelay)) %>%
  mutate(rank = rank(avg)) %>%
  arrange(rank)

# How many airplanes only flew to one destination?
hflights %>%
  group_by(TailNum) %>%
  summarise(ndest = n_distinct(Dest)) %>%
  filter(ndest == 1) %>%
  summarise(nplanes = n())

# Find the most visited destination for each carrier
hflights %>%
  group_by(UniqueCarrier, Dest) %>%
  summarise(n = n()) %>%
  mutate(rank = rank(desc(n))) %>%
  filter(rank == 1)

## dplyr and databases
# dplyr deals with different types
hflights2 <- as.data.table(hflights)
summarise(hflights2, n_carrier = n_distinct(UniqueCarrier))

# dplyr and mySQL databases
# Set up a connection to the mysql database
my_db <- src_mysql(dbname = "dplyr",
                   host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com",
                   port = 3306,
                   user = "student",
                   password = "datacamp")

# Reference a table within that source: nycflights
nycflights <- tbl(my_db, "dplyr")

# glimpse at nycflights
glimpse(nycflights)

# Ordered, grouped summary of nycflights
nycflights %>%
  group_by(carrier) %>%
  summarise(n_flights = n(), avg_delay = mean(arr_delay)) %>%
  arrange(avg_delay)
