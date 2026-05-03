/*==============================================================================
  06_MODELES_PAS_A_PAS.DO — Modèles logistiques pas-à-pas M0–M5
  Dépendance : 00_config.do, 01_recodage.do

  Approche : introduction progressive des groupes de facteurs
    M0  Modèle vide (constante seule)
    M1  + Facteurs socio-démographiques (DEM_09)
    M2  + Facteurs patient individuels (PAT05)
    M3  + Facteurs familiaux/sociaux (FSOC02)
    M4  Facteurs socio-démo + patient + santé + soins (sans FSOC)
    M5  Modèle complet (tous les groupes)

  Sortie :
    - Tableau comparatif esttab → $f_modeles (.rtf)
    - Test de classification (estat classif)
    - Courbe ROC (lroc)

  NOTE : les modèles utilisent ib(freq). pour référence à la modalité
         la plus fréquente, conformément à l'original.
==============================================================================*/

di as result "--- Module 06 : Modèles pas-à-pas M0–M5 ---"

*-- Nettoyage des estimations stockées précédentes
eststo clear

/*============================================================================
  MACRO : liste complète des variables par groupe
  → facilite la lecture et la modification future
============================================================================*/
local vars_demo  "DEM01 DEM_09"
local vars_pat   "PAT01 PAT03 PAT05 PAT06 PAT09 PAT13"
local vars_san   "SAN01 SAN03 SAN04"
local vars_soin  "SOIN001 SOIN002 SOIN003"
local vars_fsoc  "FSOC01 FSOC02"

/*============================================================================
  MODÈLES
============================================================================*/

*-- M0 : modèle vide
logit OBS02 [iw=${poids}]
eststo M0

*-- M1 : + niveau de scolarisation
logit OBS02 ib(freq).(DEM_09) [iw=${poids}]
eststo M1

*-- M2 : + relation TDO / activités quotidiennes
logit OBS02 ib(freq).(DEM_09 PAT05) [iw=${poids}]
eststo M2

*-- M3 : + attitude société/famille
*    NOTE : la pondération était absente dans l'original pour M3 → ajoutée
*           pour cohérence. Commenter [iw=${poids}] si l'omission était intentionnelle.
logit OBS02 ib(freq).(DEM_09 PAT05 FSOC02) [iw=${poids}]
eststo M3

*-- M4 : facteurs socio-démo + patient + santé + soins (sans FSOC)
logit OBS02 ib(freq).(`vars_demo' `vars_pat' `vars_san' `vars_soin') [iw=${poids}]
eststo M4

*-- M5 : modèle complet (tous les groupes)
logit OBS02 ib(freq).(`vars_demo' `vars_pat' `vars_san' `vars_soin' `vars_fsoc') [iw=${poids}]
eststo M5

/*============================================================================
  DIAGNOSTICS DU MODÈLE COMPLET (M5)
============================================================================*/
lroc

*-- Test de classification
logistic OBS02 ib(freq).(`vars_demo' `vars_pat' `vars_san' `vars_soin' `vars_fsoc')
estat classif

/*============================================================================
  TABLEAU COMPARATIF M0–M5
  Options :
    star(ns 1 * 0.10 ** 0.05 *** 0.01)  seuils de significativité
    label                                utilise les labels de variables
    stat(chi2 wald)                      statistiques de modèle
    not                                  ne pas afficher les OR (logit)
    eform                                ne pas exponentier
    b(2)                                 2 décimales
============================================================================*/
esttab M0 M1 M2 M3 M4 M5                                          ///
    using "${f_modeles}",                                          ///
    star(ns 1 * 0.10 ** 0.05 *** 0.01)                            ///
    label                                                          ///
    stat(chi2 wald)                                                ///
    not eform                                                      ///
    replace b(2)                                                   ///
    title("Modèles logistiques pas-à-pas — Mauvaise observance TB")

di as result "--- 06_modeles_pas_a_pas terminé — fichier : ${f_modeles} ---"
