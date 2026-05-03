/*==============================================================================
  MAUVAISE OBSERVANCE THÉRAPEUTIQUE CHEZ LES PATIENTS TUBERCULEUX
  FICHIER MAÎTRE

  Structure :
  ├── MASTER.do
  ├── config/
  │   └── 00_config.do          ← chemins, macros, programme utilitaire tabchi2
  ├── modules/
  │   ├── 01_recodage.do        ← création des variables catégorielles
  │   ├── 02_labels.do          ← label var + label values
  │   ├── 03_descriptif.do      ← taux de non-réponse + bivariée pondérée
  │   ├── 04_tests_khi2.do      ← tests du chi² par groupe de facteurs
  │   ├── 05_logistique.do      ← régressions logistiques par district
  │   └── 06_modeles_pas_a_pas.do ← modèles M0–M5 + tableau esttab
  └── output/                   ← fichiers Word/RTF/log générés

  UTILISATION : exécuter ce fichier uniquement.
  Pour un module seul : do "config/00_config.do" puis do "modules/0X_nom.do"
  Version : 1.0 | Date : 2024
==============================================================================*/

clear all
set more off
capture log close

* Adapter ce chemin avant toute chose
global dir_project "C:/data_stata - TB"
do "${dir_project}/config/00_config.do"

do "${dir_project}/modules/01_recodage.do"
do "${dir_project}/modules/02_labels.do"
do "${dir_project}/modules/03_descriptif.do"
do "${dir_project}/modules/04_tests_khi2.do"
do "${dir_project}/modules/05_logistique.do"
do "${dir_project}/modules/06_modeles_pas_a_pas.do"

di as result "=== ANALYSE TB OBSERVANCE TERMINÉE ==="
