## select
# Choosing is not losing! The select verb
# Print out a tbl with the four columns of hflights related to delay
select(hflights, ActualElapsedTime, AirTime, ArrDelay, DepDelay )

# Print out the columns Origin up to Cancelled of hflights
select(hflights, Origin:Cancelled)

# Answer to last question: be concise!
select(hflights, 1:4, 12:21)

# Helper functions for variable selection
select(hflights, contains("ArrDelay"), contains("DepDelay"))
select(hflights, contains("UniqueCarrier"),
       ends_with("Num"), starts_with("Cancell"))
select(hflights, ends_with("Time"), ends_with("Delay"))

# Comparison to base R
# Finish select call so that ex1d matches ex1r
ex1r <- hflights[c("TaxiIn", "TaxiOut", "Distance")]
ex1d <- select(hflights, starts_with("Taxi"), contains("Distance"))

# Finish select call so that ex2d matches ex2r
ex2r <- hflights[c("Year", "Month", "DayOfWeek", "DepTime", "ArrTime")]
ex2d <- select(hflights, Year:ArrTime, -DayofMonth)

# Finish select call so that ex3d matches ex3r
ex3r <- hflights[c("TailNum", "TaxiIn", "TaxiOut")]
ex3d <- select(hflights, contains("TailNum"), starts_with("Taxi"))


## mutate
# Mutating is creating
g1 <- mutate(hflights, ActualGroundTime = ActualElapsedTime - AirTime)
g2 <- mutate(g1, GroundTime = TaxiIn + TaxiOut)
g3 <- mutate(g2, AverageSpeed = Distance / AirTime * 60)


# Add multiple variables using mutate
m1 <- mutate(hflights, loss = ArrDelay - DepDelay, loss_ratio = loss / DepDelay)
m2 <- mutate(hflights,
             TotalTaxi = TaxiIn + TaxiOut,
             ActualGroundTime = ActualElapsedTime - AirTime,
             Diff = TotalTaxi - ActualGroundTime)
