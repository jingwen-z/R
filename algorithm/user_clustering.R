library(FactoMineR)
library(ggplot2)
library(gridExtra)
library(lubridate)

filePath <- "Documents/R/FABERNOVEL/fdm-user-data.csv"

datasetRaw <- read.csv(filePath, header = TRUE, sep = ",", dec = ".")

View(datasetRaw)
str(datasetRaw)
summary(datasetRaw)

#--------------------------------------
# data preprocessing
#--------------------------------------

datasetRaw$date <- ymd(datasetRaw$date)

# convert data.frame columns from factors to characters
factorCols <- sapply(datasetRaw, is.factor)
datasetRaw[factorCols] <- lapply(datasetRaw[factorCols], as.character)

datasetRaw$medium[datasetRaw$medium == "(none)" | datasetRaw$medium == "(not set)"] <- NA
datasetRaw$regionId[datasetRaw$regionId == "(not set)"] <- NA

# check missing values
any(is.na(datasetRaw))
sum(is.na(datasetRaw))

dataset <- datasetRaw[complete.cases(datasetRaw), ] 
View(dataset)
str(dataset)
summary(dataset)

outlierCheck <- function(dt, var) {
  varName <- eval(substitute(var), eval(dt))
  na1 <- sum(is.na(varName))
  mean1 <- mean(varName, na.rm = T)
  
  par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
  boxplot(varName, main = "With outliers")
  hist(varName, main = "With outliers", xlab = NA, ylab = NA)
  outlier <- boxplot.stats(varName)$out
  meanOutlier <- mean(outlier)
  varName <- ifelse(varName %in% outlier, NA, varName)
  boxplot(varName, main="Without outliers")
  hist(varName, main="Without outliers", xlab = NA, ylab = NA)
  title("Outlier Check", outer = TRUE)
  
  na2 <- sum(is.na(varName))
  cat("Outliers identified:", na2 - na1, "\n")
  proportion <- round((na2 - na1) / sum(!is.na(varName))*100, 1)
  cat("Proportion (%) of outliers:", proportion, "\n")
  cat("Mean of the outliers:", round(meanOutlier, 2), "\n")
  mean2 <- mean(varName, na.rm = T)
  cat("Mean without removing outliers:", round(mean1, 2), "\n")
  cat("Mean if we removing outliers:", round(mean2, 2), "\n")
  prompt <- "Do you want to remove outliers and to replace with NA? [yes/no]: "
  response <- readline(prompt = prompt)
  
  if(response == "y" | response == "yes") {
    dt[as.character(substitute(var))] <- invisible(varName)
    assign(as.character(as.list(match.call())$dt),
           dt,
           envir = .GlobalEnv)
    cat("Outliers successfully removed", "\n")
    return(invisible(dt))
  } else {
    cat("Nothing changed", "\n")
    return(invisible(varName))
  }
}

outlierCheck(dataset, pageviews)
par(mfrow = c(1, 1))

#--------------------------------------
# data visualisation
#--------------------------------------

deviceCategoryColors <- c("#32B1EF", "#096EB0", "#013F67")

ggplot(dataset, aes(x = timeOnPage, fill = deviceCategory)) +
  geom_histogram(position = "dodge", bins = 24) +
  xlab("Time on page") +
  ylab("Count") +
  xlim(-90, 4000) +
  scale_fill_manual(name = "Device category", 
                    values = deviceCategoryColors)

ggplot(dataset, aes(x = hour, y = pageviews, colour = hour, fill = hour)) +
  stat_summary(fun.y = "sum", geom = "bar", aes(colour = pageviews)) +
  xlab("Hour") +
  ylab("Page views") +
  scale_fill_gradient(name = "Hour", trans = "reverse")

generalPlot <- ggplot(dataset, 
                      aes(x = date, y = pageviews, fill = deviceCategory)) +
  stat_summary(fun.y = sum, geom = "bar") +
  theme(legend.position = c(0.1, 0.7)) +
  xlab("Date") +
  ylab("Page views") +
  scale_fill_manual(name = "Device", values = deviceCategoryColors)

detailPlot <- ggplot(dataset, aes(x = date, y = pageviews, fill = deviceCategory)) +
  stat_summary(fun.y = sum, geom = "bar") +
  facet_grid(. ~ deviceCategory) +
  theme(legend.position = "none") +
  xlab("Date") +
  ylab("Page views") +
  scale_fill_manual(values = deviceCategoryColors)

grid.arrange(generalPlot, detailPlot, ncol=1)

#--------------------------------------
# Principal Components Analysis
#--------------------------------------

colPCA <- c(2, 7:ncol(dataset))
dataPCA <- dataset[ , colPCA]
colnames(dataPCA)<- c("Hour",
                      "Sessions",
                      "Goals Completions",
                      "Page Views",
                      "Time on Page",
                      "Transactions",
                      "Transaction Revenue")

userPCA <- princomp(dataPCA, cor = TRUE)
summary(userPCA, loadings = TRUE)

screeplot(userPCA,type = "line")
resultPCA <- PCA(dataPCA)

#--------------------------------------
# Clustering
#--------------------------------------

colCL <- c(2, 7:ncol(dataset))
dataCL <- dataset[ , colCL]

userKMeans <- kmeans(dataCL, centers = 4)
userKMeans

ggplot(dataCL, aes(x = pageviews, y = timeOnPage, color = userKMeans$cluster)) +
  geom_point() +
  xlab("Page Views") +
  ylab("Time on Page") +
  scale_color_gradient(name = "Cluster")
