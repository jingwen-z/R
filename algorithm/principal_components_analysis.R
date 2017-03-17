library('FactoMineR')

filepath <- "Documents/R/TSE/multi data analysis/PRINCIPAL COMPONENTS ANALYSIS/REGPCA.ASC.txt"
regions <- read.table(filepath,
                      header = FALSE,
                      sep = "",
                      quote = "",
                      row.names = 1)

colnames(regions) <- c("region",
                       "popul",
                       "tact",
                       "superf",
                       "nbentr",
                       "nbbrev",
                       "chom",
                       "teleph")

# PCA with FactoMineR
regions.pca <- princomp(regions[ , 2:ncol(regions)], cor = TRUE)
summary(regions.pca, loadings = TRUE)

screeplot(regions.pca, type = "line")
biplot(regions.pca, choices = 1:2)
