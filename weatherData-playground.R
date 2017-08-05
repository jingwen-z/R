# ----------------------------------------------
# Reference: https://ram-n.github.io/weatherData
# ----------------------------------------------

library(ggplot2)
library(plyr)
library(reshape2)
library(weatherData)

## Basic Usage: Quickstart
# Quickstart Example 0
getStationCode("Paris", region = "FR")

getCurrentTemperature("LFPB")
getCurrentTemperature("LFPO")

getDetailedWeather("LFPB", date = "2017-08-05", opt_all_columns = T)

# Quickstart Example 1
getWeatherForDate(station_id = "LFPB", start_date = "2017-08-04")
getWeatherForDate("LFPB", "2017-08-04", opt_detailed = TRUE)
getWeatherForDate(station_id = "LFPB",
                  start_date = "2017-08-01",
                  end_date = "2017-08-04")

# Quickstart Example 2
getWeatherForYear("LFPB", 2017)

## Detailed Examples
# Example 1: Using getWeatherForYear() to compare the daily temperature
# differences for two cities
city1 <- "ORD"
city2 <- "SFO"

df1 <- getWeatherForYear(city1, 2013)
df2 <- getWeatherForYear(city2, 2013)

getDailyDifferences <- function(df1, df2) {
    deltaMeans <- df1$Mean_TemperatureC - df2$Mean_TemperatureC
    deltaMax <- df1$Max_TemperatureC - df2$Max_TemperatureC
    deltaMin <- df1$Min_TemperatureC - df2$Min_TemperatureC
    
    diff_df <- data.frame(Date = df1$Date, deltaMeans, deltaMax, deltaMin)
    return(diff_df)
}

plotDifferences <- function (differences, city1, city2) {
    m.diff <- melt(differences, id.vars = c("Date"))
    p <- ggplot(m.diff, aes(x = Date, y = value)) +
        geom_point(aes(color = variable)) +
        facet_grid(variable ~ .) +
        geom_hline(yintercept = 0) +
        labs(title = paste0("Daily Temperature Differences: ",
                            city1, " minus ", city2))
    print(p)
}

differences <- getDailyDifferences(df1, df2)
plotDifferences(differences, city1, city2)

# Example 2: Getting Wind Data for a City
getSummarizedWeather("KFLMIAMI88", start_date = "2014-02-02",
                     end_date = "2014-02-20", station_type = "id") 

getSummarizedWeather("KFLMIAMI88", start_date = "2014-02-02",
                     end_date = "2014-02-20", station_type = "id",
                     opt_custom_columns = T, custom_columns = c(5, 16))

# Example 3: Comparing Intra-day Humidity
getStationCode("Calcutta")
getStationCode("Cochin")
getStationCode("Bombay")

# build cities' vector
citiesToCompare <- c("VECC", "VABB", "VOCI", "BKK")
showAvailableColumns("VOCI", "2014-05-01", opt_detailed=T)

# Fetch the Data
getHumidity <- function (cityCode, dateString) {
    weatherForDate <- getWeatherForDate(cityCode, dateString,
                                        opt_detailed = T,
                                        opt_custom_columns = T,
                                        custom_columns = 4)
    weatherForDate$Station <- cityCode
    return(weatherForDate)
}

humidityDF <- ldply(citiesToCompare, getHumidity, "2014-05-01")
dim(humidityDF)

ggplot(humidityDF, aes(x = Time, y = Humidity)) + 
    geom_line( aes(color = Station) ) +
    labs(title="Humidity Values for May 1, 2014 (South & South East Asian Cities) ")

# Example 4: Getting Data from Personal Weather Stations
getSummarizedWeather("KFLMIAMI88", start_date = "2014-02-02",
                     end_date = "2014-02-20", station_type = "id") 

getSummarizedWeather("KFLMIAMI88", start_date = "2014-02-02",
                     end_date = "2014-02-20", station_type = "id",
                     opt_custom_columns = T,
                     custom_columns = c(5, 16))
