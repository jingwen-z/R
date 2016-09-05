# import dataset "mej"
mej <- read.delim("/Users/adlz/Documents/RRRRRRR/afd/MEJ.txt", header = TRUE, sep = ";", dec = ",")

# since I need only several fields of table "mej", I extract these columns and store them in a new table "mej_reg".
mej_col_nb <- c(73, 7, 5, 8, 10:13, 17, 19, 20, 21)
mej_reg <- mej[,mej_col_nb]

# because of French accent, some letters cannot be displayed, we need to firstly rename these columns.
# digits of columns in `mej` that need to be renamed
rename_col_mej <- c(4:9,12)
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

# convert percentage(the field "pourcentage_garantie") into numeric
mej_reg$pourcentage_garantie <- as.numeric(sub("%", "", mej_reg$pourcentage_garantie))/100
str(mej_reg)

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

## linear model: lm_mej
# the independent variables are type_de_garantie, pays and beneficiaire_primaire, 
# autorisation_nette_montant_du_pret_en_euro, 
# autorisation_nette_montant_garanti_en_euro, pourcentage_garantie, cours
lm_mej <- lm(`total_indemnisation_en_euro(en_mille)` ~ factor(type_de_garantie) 
             + factor(pays) + factor(beneficiaire_primaire)
             + `autorisation_nette_montant_du_pret_en_euro(en_mille)`
             + `autorisation_nette_montant_garanti_en_euro(en_mille)`
             + pourcentage_garantie + cours, data = mej_reg)
summary(lm_mej)

# R-squared is 0.8989
# according to the summary, we get 6 variables are significant:
# country "MAURICE" is statictically significant at the 1% level.
# primary beneficiary "BOA Bénin" is statictically significant at the 1% level.
# primary beneficiary "Banque des MASCAREIGNES" is statictically significant at the 1% level.
# primary beneficiary "MCB Ltd" is statictically significant at the 1% level.
# primary beneficiary "ALIOS" is statictically significant at the 5% level.
# primary beneficiary "CREDIT DU SENEGAL" is statictically significant at the 10% level.

# among the variables which are significant,
# they have different effects on `total_indemnisation_en_euro(en_mille)`:
# ceteris paribus, signing one contract with "BOA Bénin" increases 174.3 thousands euros of total compensation
# ceteris paribus, signing one contract with "Banque des MASCAREIGNES" guarantee increases 708.3 thousands euros of total compensation
# ceteris paribus, signing one contract with "MCB Ltd" guarantee increases 638.1 thousands euros of total compensation
# ceteris paribus, signing one contract with "CREDIT DU SENEGAL" guarantee increases 37.91 thousands euros of total compensation

# moreover, let's check whether the model "lm_mej" is really confidential
# we first check if the observations are independent (no pattern?):
plot(lm_mej$fitted.values, lm_mej$residuals)
# second, check if all errors are normally distributed with the same variance and mean = 0
qqnorm(lm_mej$residuals) # approximately a line?
# this graph compares the quantiles of the residuals to the quantiles of the normal distribution
