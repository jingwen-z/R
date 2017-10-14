library(arules)
library(arulesViz)

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
