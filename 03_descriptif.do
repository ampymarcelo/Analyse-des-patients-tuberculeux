/*==============================================================================
  03_DESCRIPTIF.DO — Analyse descriptive et bivariée pondérée
  Dépendance : 00_config.do, 01_recodage.do, 02_labels.do

  Contenu :
    A. Taux de non-réponse (tab1 sur toutes les variables explicatives)
    B. Tableaux bivariés pondérés (row %) × OBS02, par groupe de facteurs
       → utilise le programme tabchi2 défini dans 00_config.do
         (produit tableau row ET chi² en une commande)
==============================================================================*/

di as result "--- Module 03 : Analyse descriptive et bivariée ---"

asdoc, text(ANALYSE DESCRIPTIVE ET BIVARIÉE) save($f_descr) replace

/*============================================================================
  A. TAUX DE NON-RÉPONSE
  tab1 sur la variable dépendante + toutes les variables explicatives
============================================================================*/
asdoc, text(Taux de non-réponse — variables dépendante et explicatives) ///
    save($f_descr) append

tab1 OBS02                                                      ///
    DEM01 DEM_09 PAT01 PAT03 PAT05 PAT06 PAT09 PAT13           ///
    SAN01 SAN03 SAN04 SOIN001 SOIN002 SOIN003                   ///
    FSOC01 FSOC02

/*============================================================================
  B. ANALYSE BIVARIÉE PONDÉRÉE
  Structure : tableau row [iw=pond] + chi² pour chaque variable explicative
  Organisé par groupe de facteurs
============================================================================*/

*---------- B1. Facteurs socio-démographiques ----------
asdoc, text(Facteurs socio-démographiques) save($f_descr) append

tabchi2 TrancheAge,  save($f_descr) append
tabchi2 DEM_09,      save($f_descr) append
tabchi2 RevenuMens,  save($f_descr) append
tabchi2 DEM03,       save($f_descr) append
tabchi2 tailleMen,   save($f_descr) append
tabchi2 DEM01,       save($f_descr) append

*---------- B2. Facteurs liés au patient ----------
asdoc, text(Facteurs liés au patient) save($f_descr) append

tabchi2 PAT01, save($f_descr) append    // Habitudes toxiques
tabchi2 PAT03, save($f_descr) append    // Connaissance TB
tabchi2 PAT05, save($f_descr) append    // TDO vs activités quotidiennes
tabchi2 PAT06, save($f_descr) append    // Effets secondaires médicaments
tabchi2 PAT09, save($f_descr) append    // Perception état de santé
tabchi2 PAT13, save($f_descr) append    // Moyen de locomotion et coût

*---------- B3. Facteurs liés au système de santé ----------
asdoc, text(Facteurs liés au système de santé) save($f_descr) append

tabchi2 SAN01,   save($f_descr) append  // Confidentialité lieu TDO
tabchi2 SAN03,   save($f_descr) append  // Durée d'attente TDO
tabchi2 SAN04,   save($f_descr) append  // Attitude dispensateur / absence
tabchi2 SOIN001, save($f_descr) append  // Compréhension instructions
tabchi2 SOIN002, save($f_descr) append  // Qualité accueil centre TDO
tabchi2 SOIN003, save($f_descr) append  // Relation avec dispensateur

*---------- B4. Facteurs familiaux et sociaux ----------
asdoc, text(Facteurs familiaux et sociaux) save($f_descr) append

tabchi2 FSOC01, save($f_descr) append   // Connaissance statut (société/famille)
tabchi2 FSOC02, save($f_descr) append   // Attitude société/famille

di as result "--- 03_descriptif terminé — fichier : $f_descr ---"
