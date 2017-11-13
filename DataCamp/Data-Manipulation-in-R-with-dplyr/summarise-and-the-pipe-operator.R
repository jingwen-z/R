library(dplyr)

## summarise
# The syntax of summarise
# Print out a summary with variables min_dist and max_dist
summarise(hflights, min_dist = min(Distance), max_dist = max(Distance))

# Print out a summary with variable max_div
summarise(filter(hflights, Diverted == 1), max_div = max(Distance) )

# Aggregate functions
# Remove rows that have NA ArrDelay: temp1
temp1 <- hflights[!is.na(hflights$ArrDelay), ]

# Generate summary about ArrDelay column of temp1
summarise(temp1,
          earliest = min(ArrDelay),
          average = mean(ArrDelay),
          latest = max(ArrDelay),
          sd = sd(ArrDelay))

# Keep rows that have no NA TaxiIn and no NA TaxiOut: temp2
temp2 <- filter(hflights, !is.na(TaxiIn), !is.na(TaxiOut))

# Print the maximum taxiing difference of temp2 with summarise()
summarise(temp2, max_taxi_diff = max(abs(TaxiIn-TaxiOut)))

# dplyr aggregate functions
# Generate summarizing statistics for hflights
summarise(hflights,
          n_obs = n(),
          n_carrier = n_distinct(UniqueCarrier),
          n_dest = n_distinct(Dest))

# All American Airline flights
aa <- filter(hflights, UniqueCarrier == "American")

# Generate summarizing statistics for aa
summarise(aa,
          n_flights = n(),
          n_canc = sum(Cancelled == 1),
          avg_delay = mean(ArrDelay, na.rm = T))

## pipe operator
# Overview of syntax
hflights %>%
  mutate(diff = TaxiOut - TaxiIn) %>%
  filter(!is.na(diff)) %>%
  summarise(avg = mean(diff))

# Drive or fly?
# part1
hflights %>%
  mutate(RealTime = ActualElapsedTime + 100,
         mph = Distance / RealTime * 60) %>%
  filter(!is.na(mph), mph < 70) %>%
  summarise(n_less = n(),
            n_dest = n_distinct(Dest),
            min_dist = min(Distance),
            max_dist = max(Distance))

# part2
hflights %>%
  mutate(RealTime = ActualElapsedTime + 100,
         mph = Distance / RealTime * 60) %>%
  filter(mph < 105 | Cancelled == 1 | Diverted == 1) %>%
  summarise(n_non = n(),
            n_dest =n_distinct(Dest),
            min_dist = min(Distance),
            max_dist = max(Distance))

# Count the number of overnight flights
hflights %>%
  filter(!is.na(DepTime), !is.na(ArrTime), DepTime > ArrTime) %>%
  summarise(num = n())
