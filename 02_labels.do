/*==============================================================================
  02_LABELS.DO — Étiquettes des variables et des modalités
  Dépendance : 00_config.do, 01_recodage.do
==============================================================================*/

di as result "--- Module 02 : Labels ---"

/*============================================================================
  A. LABELS DE VARIABLES (label var)
  Organisés par groupe de facteurs (même structure que le questionnaire)
============================================================================*/

*-- Variable dépendante
label var OBS02 "Observance thérapeutique"

*-- Facteurs socio-démographiques
label var DEM01   "Distance habitation – centre TDO"
label var DEM02   "Âge du patient"
label var DEM03   "Sexe du patient"
label var DEM05   "Taille du ménage (nb personnes)"
label var DEM_09  "Niveau de scolarisation"
label var DEM11   "Revenu mensuel (Ariary)"

*-- Facteurs liés au patient
label var PAT01   "Habitudes toxiques (alcool, tabac, drogue)"
label var PAT03   "Connaissance de la tuberculose (croyance en la curabilité)"
label var PAT05   "Relation prise TDO et activités quotidiennes"
label var PAT06   "Effets secondaires des médicaments"
label var PAT09   "Perception de l'état de santé pendant le traitement"
label var PAT13   "Moyen de locomotion vers le centre et coût"

*-- Facteurs liés au système de santé
label var SAN01   "Confidentialité du lieu de prise TDO"
label var SAN03   "Durée d'attente à chaque prise TDO"
label var SAN04   "Attitude du dispensateur en cas de rendez-vous manqué"

*-- Facteurs liés aux soins
label var SOIN001 "Compréhension des instructions au début du traitement"
label var SOIN002 "Qualité de l'accueil au centre TDO"
label var SOIN003 "Relation avec le dispensateur TDO"

*-- Facteurs familiaux et sociaux
label var FSOC01  "Connaissance du statut par la société / famille"
label var FSOC02  "Attitude de la société / famille par rapport au statut"

/*============================================================================
  B. LABELS DE VALEURS (label define / label values)
  Oui/Non partagé pour les variables binaires
============================================================================*/

label define lbl_ouinon 1 "Oui" 2 "Non", replace

*-- Observance (variable dépendante principale)
label define lbl_obs_princ 1 "Mauvaise observance" 2 "Bonne observance", replace
label values OBS02 lbl_obs_princ

di as result "--- 02_labels terminé ---"
