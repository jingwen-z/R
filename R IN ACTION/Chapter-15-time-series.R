### Chapter 15: Time series

library(forecast)
library(stats)

## 15.1 creating a time-series object in R
sales <- c(18, 33, 41, 7, 34, 35, 24, 25, 24, 21, 25, 20,
           22, 31, 40, 29, 25, 21, 22, 54, 31, 25, 26, 35)

tsales <- ts(sales, start = c(2003, 1), frequency = 12)

plot(tsales)

start(tsales)
end(tsales)
frequency(tsales)

tsalesSubset <- window(tsales, start = c(2003, 5), end = c(2004, 6))

# 15.2 smoothing and seasonal decomposition
# 15.2.1 smoothing with simple moving averages
opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
ylim <- c(min(Nile), max(Nile))
plot(Nile, main = "Raw time series")
plot(ma(Nile, 3), main = "Simple Moving Averages (k=3)", ylim = ylim)
plot(ma(Nile, 7), main = "Simple Moving Averages (k=7)", ylim = ylim)
plot(ma(Nile, 15), main = "Simple Moving Averages (k=15)", ylim = ylim)
par(opar)

# 15.2.2 Seasonal decomposition
# seasonal decompositon using stl()
plot(AirPassengers)
lAirPassengers <- log(AirPassengers)
plot(lAirPassengers, ylab = "log(AirPassengers)")

fit <- stl(lAirPassengers, s.window = "period")
plot(fit)

fit$time.series
exp(fit$time.series)

# month plot & season plot
par(mfrow = c(2, 1))
monthplot(AirPassengers, xlab = "", ylab = "")
seasonplot(AirPassengers, year.labels = T, main = "")
par(mfrow = c(1, 1))

# 15.3 Exponential forecasting models
# 15.3.1 Simple exponential smoothing
fit <- ets(nhtemp, model = "ANN")
fit

forecast(fit, 1)

plot(forecast(fit, 1), xlab = "Year",
     ylab = expression(paste("Temperature (", degree*F, ")")),
     main = "New Haven Annual Mean Temperature")

accuracy(fit)

# 15.3.2 Holt and Holt-Winters exponential smoothing
fit <- ets(log(AirPassengers), model = "AAA")
fit

accuracy(fit)

pred <- forecast(fit, 5)
pred

plot(pred, main = "Forecast for Air Travel",
     xlab = "Time", ylab = "Log(AirPassengers)")

pred$mean <- exp(pred$mean)
pred$lower <- exp(pred$lower)
pred$upper <- exp(pred$upper)

predTable <- cbind(pred$mean, pred$lower, pred$upper)
dimnames(predTable)[[2]] <- c("mean", "Lo 80", "Lo 95", "Hi 80", "Hi 95")
predTable

# 15.3.3 The ets() function and automated forecasting
fit <- ets(JohnsonJohnson)
fit

plot(forecast(fit), main = "Johnson & Johnson Forecasts",
     xlab = "Time", ylab = "Quarterly Earnings (Dollars)", flty = 2)
