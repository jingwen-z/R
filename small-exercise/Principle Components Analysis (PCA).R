############################## small exercise - PCA ################################

install.packages('FactoMineR')
library('FactoMineR')

regions <- read.table("/Users/adlz/Documents/RRRRRRR/multi data analysis/PRINCIPAL COMPONENTS ANALYSIS (PCA)/REGPCA.ASC.txt",
                      header=FALSE,sep = "",quote="",row.names = 1)
colnames(regions) <- c('region','popul','tact','superf','nbentr','nbbrev','chom','teleph') # 'initial',
attach(regions)
head(regions)
View(regions)
summary(regions)

####### PCA with FactoMineR #######
regions.pca <- princomp(regions[,2:ncol(regions)],cor = TRUE) 
# princomp(x, cor=FALSE, scores = TRUE, covmat = NULL, subset = rep(TRUE, nrow(as.matrix(x))), ...)
# cor = TRUE means the calculation use the correlation matrix.
# The correlation matrix can only be used if there are no constant variable.

summary(regions.pca,loadings=TRUE)
# Since the Cumulative Proportion is larger than 0.8 for "Comp.2", there are 2 Principle Composants.
# According the result of "Loadings", we can get the following analysis:
# F1 = - 0.46*X1 - 0.214*X2 - 0.208*X4 - 0.233*X5 + 0.704*X6 - 0.384*X7
# F2 = - 0.349*X1 + 0.496*X2 + 0.148*X3 + 0.72*X4 - 0.301*X5

screeplot(regions.pca,type = "line")
biplot(regions.pca,choices=1:2)
