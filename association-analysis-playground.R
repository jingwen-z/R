library(arules)
library(arulesViz)

## resource: http://www.rdatamining.com/examples/association-rules

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
