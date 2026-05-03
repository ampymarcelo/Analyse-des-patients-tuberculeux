/*==============================================================================
  04_TESTS_KHI2.DO — Tests du Khi-2 autonomes (sans pondération)
  Dépendance : 00_config.do, 01_recodage.do

  Note : Dans le code original, les tests chi² étaient répétés séparément
  des tableaux bivariés pondérés (deux blocs distincts de ~40 lignes chacun).
  Grâce au programme tabchi2 dans 03_descriptif.do, les chi² sont déjà
  produits en même temps que les tableaux row.

  Ce module est conservé séparément pour les tests chi² SANS pondération,
  qui peuvent être nécessaires pour vérifier la significativité brute ou
  pour un rapport spécifique.
  → Commenter/décommenter selon besoin.
==============================================================================*/

di as result "--- Module 04 : Tests Khi-2 (non pondérés) ---"

asdoc, text(TESTS DU KHI-2 — NON PONDÉRÉS) save($f_khi2) replace

/*-- Variables de la liste explicative complète --*/
local vars_demo  "TrancheAge DEM_09 RevenuMens DEM03 tailleMen DEM01"
local vars_pat   "PAT01 PAT03 PAT05 PAT06 PAT09 PAT13"
local vars_san   "SAN01 SAN03 SAN04 SOIN001 SOIN002 SOIN003"
local vars_fsoc  "FSOC01 FSOC02"

asdoc, text(Facteurs socio-démographiques) save($f_khi2) append
foreach v of local vars_demo {
    asdoc tab `v' $dep_var, chi2 save($f_khi2) append
}

asdoc, text(Facteurs liés au patient) save($f_khi2) append
foreach v of local vars_pat {
    asdoc tab `v' $dep_var, chi2 save($f_khi2) append
}

asdoc, text(Facteurs liés au système de santé) save($f_khi2) append
foreach v of local vars_san {
    asdoc tab `v' $dep_var, chi2 save($f_khi2) append
}

asdoc, text(Facteurs familiaux et sociaux) save($f_khi2) append
foreach v of local vars_fsoc {
    asdoc tab `v' $dep_var, chi2 save($f_khi2) append
}

di as result "--- 04_tests_khi2 terminé — fichier : $f_khi2 ---"
