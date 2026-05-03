/*==============================================================================
  01_RECODAGE.DO — Création des variables catégorielles
  Toutes les transformations de variables continues sont regroupées ici.
  Dépendance : 00_config.do
==============================================================================*/

di as result "--- Module 01 : Recodage ---"

/*----------------------------------------------------------------------------
  1. TRANCHE D'ÂGE (DEM02)
  Note : la tranche "35-44 ans" était libellée "35-34ans" dans l'original
         → corrigé en "35-44 ans"
----------------------------------------------------------------------------*/
capture drop TrancheAge
recode DEM02                              ///
    (0/14   = 1 "Moins de 15 ans")        ///
    (15/24  = 2 "15-24 ans")              ///
    (25/34  = 3 "25-34 ans")              ///
    (35/44  = 4 "35-44 ans")              ///
    (45/54  = 5 "45-54 ans")              ///
    (55/max = 6 "55 ans et plus"),        ///
    gen(TrancheAge)
label var TrancheAge "Tranche d'âge"
tab TrancheAge, missing

/*----------------------------------------------------------------------------
  2. REVENU MENSUEL (DEM11)
  Seuils : < 250 000 Ar | 250 000–400 000 Ar | > 400 000 Ar
----------------------------------------------------------------------------*/
capture drop RevenuMens
gen RevenuMens = .
replace RevenuMens = 1 if DEM11 <  250000
replace RevenuMens = 2 if DEM11 >= 250000 & DEM11 <= 400000
replace RevenuMens = 3 if DEM11 >  400000 & !missing(DEM11)

label define lbl_revenu               ///
    1 "Moins du SMIG (< 250 000 Ar)"  ///
    2 "250 000 – 400 000 Ar"          ///
    3 "Plus de 400 000 Ar", replace
label values RevenuMens lbl_revenu
label var RevenuMens "Revenu mensuel"
tab RevenuMens, missing

/*----------------------------------------------------------------------------
  3. TAILLE DE MÉNAGE (DEM05)
  Seuil : ≤ 5 personnes | > 5 personnes
----------------------------------------------------------------------------*/
capture drop tailleMen
gen tailleMen = .
replace tailleMen = 1 if DEM05 <= 5
replace tailleMen = 2 if DEM05 >  5 & !missing(DEM05)

label define lbl_taille               ///
    1 "5 personnes ou moins"          ///
    2 "Plus de 5 personnes", replace
label values tailleMen lbl_taille
label var tailleMen "Taille du ménage"
tab tailleMen, missing

/*----------------------------------------------------------------------------
  4. VARIABLE DÉPENDANTE BINAIRE (0/1) : mauvaise observance
  OBS02 : 1 = mauvaise observance | 2 = bonne observance
  → recoder en 1/0 pour la régression logistique
----------------------------------------------------------------------------*/
capture drop mauvaisObs
gen mauvaisObs = .
replace mauvaisObs = 1 if OBS02 == 1
replace mauvaisObs = 0 if OBS02 == 2
label define lbl_obs 0 "Bonne observance" 1 "Mauvaise observance", replace
label values mauvaisObs lbl_obs
label var mauvaisObs "Mauvaise observance thérapeutique (0/1)"
tab mauvaisObs, missing

di as result "--- 01_recodage terminé ---"
