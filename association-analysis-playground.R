library(arules)
library(arulesViz)
library(igraph)
library(visNetwork)


## example 1
# resource: http://www.rdatamining.com/examples/association-rules

str(titanic.raw)

## association rule mining
# find association rules with default settings
rules <- apriori(titanic.raw)
inspect(rules)

# rules with rhs containing "Survived" only
rulesSurvived <- apriori(titanic.raw,
                         parameter = list(minlen = 2, supp = 0.005, conf = 0.8),
                         appearance = list(rhs=c("Survived=No", "Survived=Yes"),
                                           default = "lhs"),
                         control = list(verbose = F))
rulesSurvived.sorted <- arules::sort(rulesSurvived, by = "lift")
inspect(rulesSurvived.sorted)

## pruning redundant rules
# when a rule (such as rule 2) is a super rule of another rule (such as `rules`)
# and the former has the same or a lower lift, the former rule (`rulesSurvived`)
# is considered to be redundant

# find redundant rules
subsetMat <- is.subset(rulesSurvived.sorted, rulesSurvived.sorted)
subsetMat[lower.tri(subsetMat, diag = T)] <- NA

redundant <- colSums(subsetMat, na.rm = T) >= 1
which(redundant)

rulesSurvived.pruned <- rulesSurvived.sorted[!redundant]

## visualizing association rules
plot(rulesSurvived)
plot(rulesSurvived, method = "graph", control = list(type = "items"))
plot(rulesSurvived, method = "paracoord", control = list(reorder = T))


## example 2 - Association Mining (Market Basket Analysis)
# resource: http://r-statistics.co/Association-Mining-With-R.html

data(Groceries)

# transactions data
class(Groceries)
inspect(head(Groceries, 3))
size(head(Groceries))
LIST(head(Groceries, 3))

# see the most frequent items
frequentItems <- eclat(Groceries, parameter = list(supp = 0.07, maxlen = 15))
inspect(frequentItems)

itemFrequencyPlot(Groceries, topN=10, type="absolute", main="Item Frequency")

# get the product recommendation rules
rules <- apriori (Groceries, parameter = list(supp = 0.001, conf = 0.5))

rulesConf <- sort (rules, by = "confidence", decreasing = T)
inspect(head(rulesConf))

rulesLift <- sort (rules, by = "lift", decreasing = T)
inspect(head(rulesLift))

# control the number of rules in output
rules3Outputs <- apriori(Groceries,
                         parameter = list(supp = 0.001, conf = 0.5, maxlen = 3))
# to get 'strong' rules, increase the value of 'conf' parameter
# to get 'longer' rules, increase 'maxlen'

# remove redundant rules
subsetRules <- which(colSums(is.subset(rules, rules)) > 1)
length(subsetRules)
rules <- rules[-subsetRules]

# find rules related to given item/s
# find what factors influenced purchase of product X
rulesWholeMilk <- apriori(data = Groceries,
                          parameter = list(supp = 0.001, conf = 0.08),
                          appearance = list(default = "lhs", rhs = "whole milk"),
                          control = list(verbose = F))

rulesWholeMilkConf <- sort(rulesWholeMilk, by = "confidence", decreasing = T)
inspect(head(rulesWholeMilkConf))

# find out what products were purchased after/along with product X
rulesAssociatedWholeMilk <-
  apriori(data = Groceries,
          parameter = list(supp = 0.001, conf = 0.15, minlen = 2),
          appearance = list(default = "rhs", lhs = "whole milk"),
          control = list(verbose = F))

rulesAssociatedWholeMilkConf <- sort(rulesAssociatedWholeMilk,
                                     by = "confidence",
                                     decreasing = T)
inspect(head(rulesAssociatedWholeMilkConf))

## example 3
# resource: https://rpubs.com/ajaydecis/rassociation

data("Groceries")
Groceries

head(Groceries)
Groceries[1:6]
inspect(Groceries[1:6])

itemFrequencyPlot(Groceries, topN = 20, type = "absolute")

rulesAll <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8))
rulesAll
inspect(rulesAll[1:5])

# convert the rules into a data frame
as(rulesAll, "data.frame")

plot(rulesAll[1:5])
plot(rulesAll[1:5], method = "graph", interactive = F)
# plot(rulesAll[1:15], method = "graph", interactive = T)

subrules <- head(sort(rulesAll, by = "lift"), 10)
plot(subrules, method = "graph")

graphDF <- get.data.frame(plot(subrules, method = "graph"), what = "both")

visNetwork(
  nodes <- data.frame(id = graphDF$vertices$name,
                      value = graphDF$vertices$support,
                      title = ifelse(graphDF$vertices$label == "",
                                     graphDF$vertices$name,
                                     graphDF$vertices$label),
                      graphDF$vertices),
  edges <- graphDF$edges
) %>%
  visOptions(highlightNearest = TRUE)

plot(subrules, method = "grouped")
plot(subrules, method = "matrix")

plot(rulesAll[1:15], method = "matrix3D")
plot(rulesAll[1:15], method = "matrix3D", measure = "lift")

plot(rulesAll, measure = c("support", "lift"), shading = "confidence")
plot(subrules, method = "paracoord")
