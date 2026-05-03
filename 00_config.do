/*==============================================================================
  00_CONFIG.DO — Paramètres globaux de l'analyse TB observance
  Seul fichier à modifier selon la machine et le contexte

  Contient aussi le programme utilitaire tabchi2 :
    → produit en une seule commande le tableau row pondéré ET le chi² non pondéré
==============================================================================*/

*==============================================================================
* 1. CHEMINS — modifier uniquement ces lignes
*==============================================================================
global dir_project  "C:/data_stata - TB"
global dir_data     "${dir_project}/data"
global dir_output   "${dir_project}/output"
global dir_modules  "${dir_project}/modules"

*==============================================================================
* 2. BASE ET VARIABLES CLÉS
*==============================================================================
global base_source  "BaseCible1.dta"
global dep_var      "OBS02"          // Variable dépendante : observance
global poids        "pond"           // Variable de pondération
global psu          "v021"           // Unité primaire de sondage
global strate       "v022"           // Strate de sondage

*==============================================================================
* 3. FICHIERS DE SORTIE
*==============================================================================
global f_descr   "${dir_output}/01_Descriptif_Bivarie.doc"
global f_khi2    "${dir_output}/02_Tests_Khi2.doc"
global f_logit   "${dir_output}/03_Logistique_Districts.doc"
global f_modeles "${dir_output}/04_Modeles_Final.rtf"
global f_log     "${dir_output}/log_TB_Observance.log"

*==============================================================================
* 4. OPTIONS STATA
*==============================================================================
set more off
set varabbrev off
version 15

*-- Log
capture log close
log using "${f_log}", replace text

*-- Chargement de la base
use "${dir_data}/${base_source}", clear

*-- Déclaration du plan de sondage (pour les analyses pondérées)
svyset [pweight=${poids}], psu(${psu}) strata(${strate}) singleunit(centered)

di as result "=== CONFIG chargée — base : ${base_source} ==="

/*==============================================================================
  PROGRAMME UTILITAIRE : tabchi2
  Produit en une seule commande :
    1. asdoc tab var $dep_var [iw=$poids], row  (tableau pondéré)
    2. asdoc tab var $dep_var, chi2             (test chi² non pondéré)

  Usage :
    tabchi2 NomVar, save(fichier.doc) [append|replace]

  Exemple :
    tabchi2 TrancheAge, save($f_descr) replace
    tabchi2 PAT01,      save($f_descr) append
==============================================================================*/
capture program drop tabchi2
program define tabchi2
    syntax varname, SAVe(string) [APPEND REPLACE]
    local opt1 = cond("`replace'" != "", "replace", "append")

    asdoc tab `varlist' ${dep_var} [iw=${poids}], row  save(`save') `opt1'
    asdoc tab `varlist' ${dep_var},               chi2 save(`save') append
end
