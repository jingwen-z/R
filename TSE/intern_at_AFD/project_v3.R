# import dataset "mej"
mej <- read.delim("/Users/adlz/Documents/RRRRRRR/afd/MEJ.txt", header = TRUE, sep = ";", dec = ",")

# since I need only several fields of table "mej", I extract these columns and store them in a new table "mej_reg".
mej_col_nb <- c(73, 7, 5, 8, 10:13, 17, 19, 21)
mej_reg <- mej[,mej_col_nb]

# because of French accent, some letters cannot be displayed, we need to firstly rename these columns.
# digits of columns in `mej` that need to be renamed
rename_col_mej <- c(4:9,11)
colnames(mej_reg)[rename_col_mej] <- c("pays", "beneficiaire_primaire", 
                                   "n_tiers_beneficiaire_primaire", 
                                   "beneficiaire_final", 
                                   "n_tiers_beneficiaire_final", 
                                   "autorisation_nette_montant_du_pret_en_euro", 
                                   "cours")

View(mej_reg)
str(mej_reg)
summary(mej_reg)

# convert data.frame columns from factors to characters
f_m <- sapply(mej_reg, is.factor)
mej_reg[f_m] <- lapply(mej_reg[f_m], as.character)

## in this new table "mej_reg", there are some missing values.
# with the supplementary information, I can supplement some of them.

# for the field "total_indemnisation_en_euro"
# check if there are missing values among "mej_reg$total_indemnisation_en_euro"
any(is.na(mej_reg$total_indemnisation_en_euro))  # TRUE

# count number of NAs among "mej_reg$total_indemnisation_en_euro"
sum(is.na(mej_reg$total_indemnisation_en_euro))  # 36

# find rows withno NAs in "mej_reg$total_indemnisation_en_euro"
complete.cases(mej_reg$total_indemnisation_en_euro)

# subset data, keeping only complete cases in "mej_reg$total_indemnisation_en_euro"
mej_reg <- mej_reg[complete.cases(mej_reg$total_indemnisation_en_euro),]  # 260 obs.

# for the field "n_tiers_beneficiaire_primaire"
# supplement some missing values in "n_tiers_beneficiaire_primaire"
mej_reg$n_tiers_beneficiaire_primaire <- ifelse(mej_reg$beneficiaire_primaire == "BOA Madagascar", 
                                                "500750", mej_reg$n_tiers_beneficiaire_primaire)
mej_reg$n_tiers_beneficiaire_primaire <- ifelse(mej_reg$beneficiaire_primaire == "GARRIGUE", 
                                                "504847", mej_reg$n_tiers_beneficiaire_primaire)
mej_reg$n_tiers_beneficiaire_primaire <- ifelse(mej_reg$beneficiaire_primaire == "PROPARCO (ARIA)", 
                                                "NA", mej_reg$n_tiers_beneficiaire_primaire)
mej_reg$n_tiers_beneficiaire_primaire <- ifelse(mej_reg$beneficiaire_primaire == "SGB", 
                                                "500838", mej_reg$n_tiers_beneficiaire_primaire)
mej_reg$n_tiers_beneficiaire_primaire <- ifelse(mej_reg$beneficiaire_primaire == "SGBS", 
                                                "6511", mej_reg$n_tiers_beneficiaire_primaire)

# since the values of "total_indemnisation_en_euro", 
# "autorisation_nette_montant_du_pret_en_euro" and 
# "autorisation_nette_montant_garanti_en_euro" are large, 
# I will change the value into the thousands.
mej_reg$total_indemnisation_en_euro <- mej_reg$total_indemnisation_en_euro/1000
colnames(mej_reg)[1] <- "total_indemnisation_en_euro(en_mille)"

mej_reg$autorisation_nette_montant_du_pret_en_euro <- mej_reg$autorisation_nette_montant_du_pret_en_euro/1000
colnames(mej_reg)[9] <- "autorisation_nette_montant_du_pret_en_euro(en_mille)"

mej_reg$autorisation_nette_montant_garanti_en_euro <- mej_reg$autorisation_nette_montant_garanti_en_euro/1000
colnames(mej_reg)[10] <- "autorisation_nette_montant_garanti_en_euro(en_mille)"

# remove outlier 0 in "total_indemnisation_en_euro"
mej_reg <- mej_reg[!(mej_reg$`total_indemnisation_en_euro(en_mille)`) == 0,]  # 166 obs.

### linear model: lm_mej
# the independent variables are type_de_garantie, pays and beneficiaire_primaire, 
# autorisation_nette_montant_du_pret_en_euro, 
# autorisation_nette_montant_garanti_en_euro, pourcentage_garantie, cours
lm_mej <- lm(`total_indemnisation_en_euro(en_mille)` ~ factor(type_de_garantie) 
             + factor(pays) + factor(beneficiaire_primaire)
             + `autorisation_nette_montant_du_pret_en_euro(en_mille)`
             + `autorisation_nette_montant_garanti_en_euro(en_mille)`
             + cours, data = mej_reg)
summary(lm_mej)

# R-squared is 0.8982
# according to the summary, we get 6 variables are significant:
# country "MAURICE" is statictically significant at the 1% level.
# primary beneficiary "BOA Bénin" is statictically significant at the 1% level.
# primary beneficiary "Banque des MASCAREIGNES" is statictically significant at the 1% level.
# primary beneficiary "MCB Ltd" is statictically significant at the 1% level.
# primary beneficiary "ALIOS" is statictically significant at the 5% level.
# primary beneficiary "CREDIT DU SENEGAL" is statictically significant at the 10% level.
# "autorisation_nette_montant_du_pret_en_euro(en_mille)" is statictically significant at the 10% level.

# moreover, let's check whether the model "lm_mej" is really confidential
# we first check if the observations are independent (no pattern?):
plot(lm_mej$fitted.values, lm_mej$residuals)
# second, check if all errors are normally distributed with the same variance and mean = 0
qqnorm(lm_mej$residuals) # approximately a line?
# this graph compares the quantiles of the residuals to the quantiles of the normal distribution


### Decision trees (CART)
str(mej_reg)
summary(mej_reg)

group_indemnisation <- matrix(0, 166, 1)
group_indemnisation[which(mej_reg$`total_indemnisation_en_euro(en_mille)` < 53)] <- "A"
group_indemnisation[which(mej_reg$`total_indemnisation_en_euro(en_mille)` >= 200)] <- "C"
group_indemnisation[which(group_indemnisation == 0)] <- "B"

mej_reg$group_indemnisation <- group_indemnisation  # add "group_indemnisation" into dataset "mej_reg"
mej_reg[1:10, c(1, 12)]

# for each group, calculate number of observations in test set
a <- round(1/4*sum(mej_reg$group_indemnisation=="A"))
b <- round(1/4*sum(mej_reg$group_indemnisation=="B"))
c <- round(1/4*sum(mej_reg$group_indemnisation=="C"))

a;b;c

install.packages("sampling")
library(sampling)

# stratified sampling
sub <- strata(mej_reg, stratanames = "group_indemnisation", size = c(a,b,c), method = "srswor")
sub[1:10,]

# create training set and test set
train_mej <- mej_reg[-sub$ID_unit,]
test_mej <- mej_reg[sub$ID_unit,]

# rows' number in training set and test set
nrow(train_mej)  # 125
nrow(test_mej)  # 41

## Regression Tree
install.packages("rpart")
install.packages("rpart.plot")
library(rpart)
library(rpart.plot)

rp_mej_reg <- rpart(`total_indemnisation_en_euro(en_mille)` ~ type_de_garantie
                    + pays + beneficiaire_primaire 
                    + `autorisation_nette_montant_du_pret_en_euro(en_mille)`,
                    train_mej, method = "anova")
rp_mej_reg
rpart.plot(rp_mej_reg, type = 4, branch = 1)


### Principal Components Analysis (PCA)
install.packages("FactoMineR")
library("FactoMineR")

pca_col <- c(1,9,10,11)
mej_pca <- princomp(mej_reg[, pca_col], cor = TRUE)

summary(mej_pca, loadings = TRUE)
# since the cumulative proportion is larger than 0.8 for "Comp.2", there are 2 Principle Components.
# according to the result of "Loadings", we can get the following analysis:
# F1 = 0.537*X1 + 0.593*X2 + 0.585 * X3 - 0.132 * X4
# F2 = 0.991 * X4

screeplot(mej_pca, type = "line")
biplot(mej_pca, choices = 1:2)
