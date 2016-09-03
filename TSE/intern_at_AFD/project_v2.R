# import dataset "mej"
mej <- read.delim("/Users/adlz/Documents/RRRRRRR/afd/MEJ.txt", header = TRUE, sep = ";", dec = ",")

# because of French accent, some letters cannot be displayed, we need to firstly rename these columns.
# digits of columns in `mej` that need to be renamed
rename_col_mej <- c(1:3,8,10:13,15:17,21:24,26:29,31:33,39:45,55,58:60,63:65,70,74:79)
colnames(mej)[rename_col_mej] <- c("index", "annee_d'autorisation", 
                                   "date_d'autorisation", "pays", 
                                   "beneficiaire_primaire", 
                                   "n_tiers_beneficiaire_primaire", 
                                   "beneficiaire_final", 
                                   "n_tiers_beneficiaire_final", "devise", 
                                   "autorisation_nette_montant_du_pret_en_devise", 
                                   "autorisation_nette_montant_du_pret_en_euro", 
                                   "cours", "n_pret", "imp_1er_impaye_survenu", 
                                   "imp_1er_impaye_non_regularise", 
                                   "imp_delai_respecte",  "eg_decheance_du_terme", 
                                   "eg_date_de_l'info_du_fait_generateur", 
                                   "eg_delai_respecte", 
                                   "nb_d'annees_entre_signture_et_demande_d'avance", 
                                   "mej_delai_respecte", "mej_reception_siege", 
                                   "mej_date_decision_GAR", 
                                   "nb_de_jours_entre_visa_JUR_et_decision_GAR", 
                                   "di_perte_provisoire_calculee_par_la_banque_en_devise", 
                                   "di_perte_provisoire_accordee_en_devise", 
                                   "di_perte_provisoire_accordee_en_euro", 
                                   "di_difference_sur_l'assiette_de_garantie", 
                                   "di_evaluation_des_suretes", 
                                   "dbo_ecart_GAR_DBO", 
                                   "dbo_controle_1er_niveau_statu", 
                                   "dbo_controle_1er_niveau_controleur", 
                                   "dbo_controle_1er_niveau_date", 
                                   "sld_delai_respecte", 
                                   "sld_montant_du_solde_demande_en_devise", 
                                   "sld_montant_du_solde_accorde_en_devise", 
                                   "sld_date_decision_GAR", 
                                   "retour_a_meilleure_fortune", "etape", 
                                   "statut", "statut_detaille", 
                                   "derniere_mise_a_jour_statut", "commentaires")

View(mej)
str(mej)
summary(mej)

# since I need only several fields of table "mej", I extract these columns and store them in a new table "mej_reg".
mej_col_nb <- c(73, 7, 5, 8, 10:13, 17, 19, 20, 21)
mej_reg <- mej[,mej_col_nb]

str(mej_reg)
View(mej_reg)
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

# import dataset "principal"
prin <- read.delim("/Users/adlz/Documents/RRRRRRR/afd/Table Principale.txt", header = TRUE, sep = ";", dec = ",")

str(prin)
View(prin)

# take the columns I need
prin_col_nb <- c(13,9,15,19:22,33,35:37)
prin_reg <- prin[,prin_col_nb]

str(prin_reg)
View(prin_reg)

# rename
rename_col_mej <- c(2,4:8)
colnames(prin_reg)[rename_col_mej] <- c("type_de_garantie", 
                                        "beneficiaire_primaire", 
                                        "n_tiers_beneficiaire_primaire", 
                                        "beneficiaire_final", 
                                        "n_tiers_beneficiaire_final", 
                                        "autorisation_nette_montant_du_pret_en_euro")

# create a new column "total_indemnisation_en_euro"
namevector <- "total_indemnisation_en_euro"
prin_reg[,namevector] <- 0

# change columns' order
prin_col_order <- c(12,1:11)
prin_reg <- prin_reg[, prin_col_order]

str(prin_reg)

# convert data.frame columns from factors to characters
f_p <- sapply(prin_reg, is.factor)
prin_reg[f_p] <- lapply(prin_reg[f_p], as.character)

# remove rows with the same "n_concours" as "mej_reg" in "prin_reg"
prin_reg <- prin_reg[!(prin_reg$n_concours %in% mej_reg$n_concours),]  # 1451 obs.

# check if there are missing values in "prin_reg"
any(is.na(prin_reg)) # TRUE

summary(prin_reg)

# count number of NAs among "prin_reg$autorisation_nette_montant_du_pret_en_euro"
sum(is.na(prin_reg$autorisation_nette_montant_du_pret_en_euro))  # 36

# find rows withno NAs in "prin_reg$autorisation_nette_montant_du_pret_en_euro"
complete.cases(prin_reg$autorisation_nette_montant_du_pret_en_euro)

# subset data, keeping only complete cases in "prin_reg$autorisation_nette_montant_du_pret_en_euro"
prin_reg <- prin_reg[complete.cases(prin_reg$autorisation_nette_montant_du_pret_en_euro),]
# 1415 obs.

# count number of NAs among "prin_reg$cours"
sum(is.na(prin_reg$cours))  #2

# find rows withno NAs in "prin_reg$cours"
complete.cases(prin_reg$cours)

# subset data, keeping only complete cases in "prin_reg$cours"
prin_reg <- prin_reg[complete.cases(prin_reg$cours),]  # 1413 obs.

# merge "mej_reg" and "prin_reg"
all_reg <- rbind(mej_reg, prin_reg)  # 1673 obs.


## linear model: lm_all
# the independent variables are type_de_garantie, pays and beneficiaire_primaire, 
# autorisation_nette_montant_du_pret_en_euro, 
# autorisation_nette_montant_garanti_en_euro, pourcentage_garantie, cours
lm_all <- lm(total_indemnisation_en_euro ~ factor(type_de_garantie) 
             + factor(pays) + factor(beneficiaire_primaire)
             + autorisation_nette_montant_du_pret_en_euro 
             + autorisation_nette_montant_garanti_en_euro 
             + pourcentage_garantie + cours, data = all_reg)
summary(lm_all)
