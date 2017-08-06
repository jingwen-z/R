library(jsonlite)

# Call current weather data for one location
fromJSON("http://api.openweathermap.org/data/2.5/weather?q=Paris.fr&appid=9cb919800a3687ed2a575bf9b7be5563")

# Call 5 day / 3 hour forecast data
forecast5Days <- fromJSON("http://api.openweathermap.org/data/2.5/forecast?q=Paris.fr&appid=9cb919800a3687ed2a575bf9b7be5563")

forecast5Days$city
forecast5Days$list$weather
forecast5Days$list$main$temp_min - 273.15 # convert Kelvin to Celsius
forecast5Days$list$main$temp_kf
forecast5Days$list$dt_txt
