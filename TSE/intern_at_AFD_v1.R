mej <- read.delim("/Users/adlz/Documents/RRRRRRR/afd/MEJ.txt", header = TRUE, sep = ";", dec = ",")

# because of French accent, some letters cannot be displayed, we need to firstly rename these columns.
# digits of columns in `mej` that need to be renamed
dig_col_mej <- c(1:3,8,10:13,15:17,21:24,26:29,31:33,39:45,55,58:60,63:65,70,74:79)
colnames(mej)[dig_col_mej] <- c("index", "annee_d'autorisation", "date_d'autorisation", "pays", 
                                "beneficiaire_primaire", "n_tiers_beneficiaire_primaire", 
                                "beneficiaire_final", "n_tiers_beneficiaire_final", "devise", 
                                "autorisation_nette_montant_du_pret_en_devise", 
                                "autorisation_nette_montant_du_pret_en_euro", "cours", "n_pret", 
                                "imp_1er_impaye_survenu", "imp_1er_impaye_non_regularise", "imp_delai_respecte", 
                                "eg_decheance_du_terme", "eg_date_de_l'info_du_fait_generateur", 
                                "eg_delai_respecte", "nb_d'annees_entre_signture_et_demande_d'avance", 
                                "mej_delai_respecte", "mej_reception_siege", "mej_date_decision_GAR", 
                                "nb_de_jours_entre_visa_JUR_et_decision_GAR", 
                                "di_perte_provisoire_calculee_par_la_banque_en_devise", 
                                "di_perte_provisoire_accordee_en_devise", "di_perte_provisoire_accordee_en_euro", 
                                "di_difference_sur_l'assiette_de_garantie", "di_evaluation_des_suretes", 
                                "dbo_ecart_GAR_DBO", "dbo_controle_1er_niveau_statu", 
                                "dbo_controle_1er_niveau_controleur", "dbo_controle_1er_niveau_date", 
                                "sld_delai_respecte", "sld_montant_du_solde_demande_en_devise", 
                                "sld_montant_du_solde_accorde_en_devise", "sld_date_decision_GAR", 
                                "retour_a_meilleure_fortune", "etape", "statut", "statut_detaille", 
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
f <- sapply(mej_reg, is.factor)
mej_reg[f] <- lapply(mej_reg[f], as.character)

## in this new table "mej_reg", there are some missing values.
# with the supplementary information, I can supplement some of them.

# for the field "total_indemnisation_en_euro"
# check if there are missing values among "total_indemnisation_en_euro"
any(is.na(mej_reg$total_indemnisation_en_euro))  # TRUE

# count number of NAs among "total_indemnisation_en_euro"
sum(is.na(mej_reg$total_indemnisation_en_euro))  # 36

# find rows withno NAs in "total_indemnisation_en_euro"
complete.cases(mej_reg$total_indemnisation_en_euro)

# subset data, keeping only complete cases in "total_indemnisation_en_euro"
mej_reg <- mej_reg[complete.cases(mej_reg$total_indemnisation_en_euro),]  # 260 obs.

# remove outlier 0 in "total_indemnisation_en_euro"
mej_reg <- mej_reg[!(mej_reg$total_indemnisation_en_euro) == 0,]  # 166 obs.

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

# create dummy variables for each category of the following variable:
# type_de_garantie, pays, beneficiaire_primaire

# dummy variables for each type_de_garantie
AG <- rep(0,length(mej_reg$type_de_garantie))
for (i in 1:length(mej_reg$type_de_garantie)){
  if (mej_reg$type_de_garantie[i] == "AG"){
    AG[i]<-1
  }
}

AI <- rep(0,length(mej_reg$type_de_garantie))
for (i in 1:length(mej_reg$type_de_garantie)){
  if (mej_reg$type_de_garantie[i] == "AI"){
    AI[i]<-1
  }
}

SP <- rep(0,length(mej_reg$type_de_garantie))
for (i in 1:length(mej_reg$type_de_garantie)){
  if (mej_reg$type_de_garantie[i] == "SP"){
    SP[i]<-1
  }
}

# dummy variables for each pays
AFRIQUE_DU_SUD <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "AFRIQUE DU SUD"){
    AFRIQUE_DU_SUD[i]<-1
  }
}

BENIN <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "BENIN"){
    BENIN[i]<-1
  }
}

BURKINA_FASO <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "BURKINA FASO"){
    BURKINA_FASO[i]<-1
  }
}

CAMEROUN <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "CAMEROUN"){
    CAMEROUN[i]<-1
  }
}

COTE_D.IVOIRE<- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "COTE D'IVOIRE"){
    COTE_D.IVOIRE[i]<-1
  }
}

DJIBOUTI <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "DJIBOUTI"){
    DJIBOUTI[i]<-1
  }
}

GABON <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "GABON"){
    GABON[i]<-1
  }
}

GHANA <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "GHANA"){
    GHANA[i]<-1
  }
}

MADAGASCAR <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "MADAGASCAR"){
    MADAGASCAR[i]<-1
  }
}

MALI<- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "MALI"){
    MALI[i]<-1
  }
}

MAURICE <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "MAURICE"){
    MAURICE[i]<-1
  }
}

MAURITANIE <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "MAURITANIE"){
    MAURITANIE[i]<-1
  }
}

MOZAMBIQUE <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "MOZAMBIQUE"){
    MOZAMBIQUE[i]<-1
  }
}

MULTIPAYS <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "MULTIPAYS"){
    MULTIPAYS[i]<-1
  }
}

NAMIBIE <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "NAMIBIE"){
    NAMIBIE[i]<-1
  }
}

OUGANDA <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "OUGANDA"){
    OUGANDA[i]<-1
  }
}

SENEGAL <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "SENEGAL"){
    SENEGAL[i]<-1
  }
}

TAP <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "TAP"){
    TAP [i]<-1
  }
}

TCHAD <- rep(0,length(mej_reg$pays))
for (i in 1:length(mej_reg$pays)){
  if (mej_reg$pays[i] == "TCHAD"){
    TCHAD[i]<-1
  }
}

# dummy variables for each beneficiaire_primaire
ADVANS_CAMEROUN <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "ADVANS CAMEROUN"){
    ADVANS_CAMEROUN[i]<-1
  }
}

ALIOS <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "ALIOS"){
    ALIOS[i]<-1
  }
}

ALIOS_FINANCE_SAFCA <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "ALIOS FINANCE / SAFCA"){
    ALIOS_FINANCE_SAFCA[i]<-1
  }
}

BANK_OF_PALESTINE <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BANK OF PALESTINE"){
    BANK_OF_PALESTINE[i]<-1
  }
}

BCI_MOZAMBIQUE <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BCI MOZAMBIQUE"){
    BCI_MOZAMBIQUE[i]<-1
  }
}

BCIMR <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BCIMR"){
    BCIMR[i]<-1
  }
}

BFV_SG <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BFV-SG"){
    BFV_SG[i]<-1
  }
}

BGFIBank_Gabon <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BGFIBank Gabon"){
    BGFIBank_Gabon[i]<-1
  }
}

BICEC <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BICEC"){
    BICEC[i]<-1
  }
}

BICIM <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BICIM"){
    BICIM[i]<-1
  }
}

BICIS <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BICIS"){
    BICIS[i]<-1
  }
}

BOA_Benin <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BOA B<c3><a9>nin"){
    BOA_Benin[i]<-1
  }
}

BOA_Madagascar <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BOA Madagascar"){
    BOA_Madagascar[i]<-1
  }
}

BOA_Ouganda <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BOA Ouganda"){
    BOA_Ouganda[i]<-1
  }
}

BOA_Senegal <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "BOA S<c3><a9>n<c3><a9>gal"){
    BOA_Senegal[i]<-1
  }
}

Banque_des_MASCAREIGNES <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "Banque des MASCAREIGNES"){
    Banque_des_MASCAREIGNES[i]<-1
  }
}

CBAO <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "CBAO"){
    CBAO[i]<-1
  }
}

CREDIT_DU_SENEGAL<- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "CREDIT DU SENEGAL"){
    CREDIT_DU_SENEGAL[i]<-1
  }
}

FNB <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "FNB"){
    FNB[i]<-1
  }
}

Fondation_Grameen <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "Fondation Grameen"){
    Fondation_Grameen[i]<-1
  }
}

GARRIGUE <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "GARRIGUE"){
    GARRIGUE[i]<-1
  }
}

MCB_Ltd <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "MCB Ltd"){
    MCB_Ltd[i]<-1
  }
}

MCB_Madagascar <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "MCB Madagascar (ex UCB)"){
    MCB_Madagascar[i]<-1
  }
}

PROPARCO_ARIA <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "PROPARCO (ARIA)"){
    PROPARCO_ARIA[i]<-1
  }
}

SGB <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGB"){
    SGB[i]<-1
  }
}

SGBB <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGBB"){
    SGBB[i]<-1
  }
}

SGBC <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGBC"){
    SGBC[i]<-1
  }
}

SGBCI <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGBCI"){
    SGBCI[i]<-1
  }
}

SGBS <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGBS"){
    SGBS[i]<-1
  }
}

SGM <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGM"){
    SGM[i]<-1
  }
}

SGT <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "SGT"){
    SGT[i]<-1
  }
}

STANDARD_BANK <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "STANDARD BANK"){
    STANDARD_BANK[i]<-1
  }
}

STANDARD_BANK_Mauritius_Ltd <- rep(0,length(mej_reg$beneficiaire_primaire))
for (i in 1:length(mej_reg$beneficiaire_primaire)){
  if (mej_reg$beneficiaire_primaire[i] == "STANDARD BANK Mauritius Ltd"){
    STANDARD_BANK_Mauritius_Ltd[i]<-1
  }
}


## linear model: lm_all
# the independent variables are type_de_garantie, pays and beneficiaire_primaire, 
# autorisation_nette_montant_du_pret_en_euro, 
# autorisation_nette_montant_garanti_en_euro, pourcentage_garantie, cours
lm_all <- lm(log(total_indemnisation_en_euro) ~ AG + AI + SP 
                           + AFRIQUE_DU_SUD + BENIN + BURKINA_FASO + CAMEROUN 
                           + COTE_D.IVOIRE + DJIBOUTI + GABON + GHANA 
                           + MADAGASCAR + MALI + MAURICE + MAURITANIE 
                           + MOZAMBIQUE + MULTIPAYS + NAMIBIE + OUGANDA 
                           + SENEGAL + TAP + TCHAD + ADVANS_CAMEROUN + ALIOS 
                           + ALIOS_FINANCE_SAFCA + BANK_OF_PALESTINE 
                           + BCI_MOZAMBIQUE + BCIMR + BFV_SG + BGFIBank_Gabon 
                           + BICEC + BICIM + BICIS + BOA_Benin + BOA_Madagascar 
                           + BOA_Ouganda + BOA_Senegal 
                           + Banque_des_MASCAREIGNES + CBAO + CREDIT_DU_SENEGAL 
                           + FNB + Fondation_Grameen + GARRIGUE + MCB_Ltd 
                           + MCB_Madagascar + PROPARCO_ARIA + SGB + SGBB + SGBC 
                           + SGBCI + SGBS + SGM + SGT + STANDARD_BANK 
                           + STANDARD_BANK_Mauritius_Ltd 
                           + autorisation_nette_montant_du_pret_en_euro 
                           + autorisation_nette_montant_garanti_en_euro 
                           + pourcentage_garantie + cours, data = mej_reg)
summary(lm_all)
# R-square is 0.7959
# there are some significant variables:
# "GHANA" has significant effects on "total_indemnisation" at 1%
# "MAURICE" has significant effects on "total_indemnisation" at 1%
# "ADVANS_CAMEROUN" has significant effects on "total_indemnisation" at 1%
# "ALIOS_FINANCE_SAFCA" has significant effects on "total_indemnisation" at 1%
# "Banque_des_MASCAREIGNES" has significant effects on "total_indemnisation" at 1%
# "MCB_Ltd" has significant effects on "total_indemnisation" at 1%
# "PROPARCO_ARIA" has significant effects on "total_indemnisation" at 1%
# "autorisation_nette_montant_du_pret_en_euro" has significant effects on "total_indemnisation" at 1%
# "autorisation_nette_montant_garanti_en_euro" has significant effects on "total_indemnisation" at 1%
# "pourcentage_garantie" has significant effects on "total_indemnisation" at 1%

# "NAMIBIE" has significant effects on "total_indemnisation" at 10%
# "Fondation_Grameen" has significant effects on "total_indemnisation" at 10%
