/*==============================================================================
  05_LOGISTIQUE.DO — Régressions logistiques par district
  Dépendance : 00_config.do, 01_recodage.do

  Trois analyses distinctes selon le district :
    1. Tana Renivohitra  — facteurs : PAT01, FSOC01
    2. Tana Avaradrano   — facteurs : DEM_09, PAT01, PAT05, FSOC02, SAN03
    3. Mahajanga I       — facteurs complets (12 variables)

  Pour chaque district :
    a) Régression OLS préalable + test VIF (multicolinéarité)
    b) Dichotomisation des variables retenues (tab → gen dummies)
    c) Régression logistique sur mauvaisObs
    d) Courbe ROC (lroc)

  NOTE : mauvaisObs est créée dans 01_recodage.do
         Les dummies sont recréées localement dans chaque bloc car les
         noms peuvent se chevaucher entre districts.
==============================================================================*/

di as result "--- Module 05 : Régressions logistiques par district ---"

asdoc, text(RÉGRESSIONS LOGISTIQUES PAR DISTRICT) save($f_logit) replace

/*==============================================================================
  PROGRAMME UTILITAIRE : make_dummies
  Dichotomise une liste de variables (tab → gen) en une seule commande.

  Syntaxe :
    make_dummies varlist, prefix(préfixe_optionnel)
  
  Exemple :
    make_dummies DEM_09 PAT01 PAT05, prefix()
    → génère nivSco1 nivSco2… habit1 habit2… PriseTDOquot1…
==============================================================================*/
capture program drop make_dummies
program define make_dummies
    syntax varlist, Stem(namelist)
    local n = 1
    foreach v of local varlist {
        local s : word `n' of `stem'
        capture drop `s'*
        tab `v', gen(`s')
        local ++n
    }
end

/*==============================================================================
  1. TANA RENIVOHITRA
  Facteurs retenus : habitudes toxiques (PAT01), connaissance statut (FSOC01)
==============================================================================*/
di as result "--- District : Tana Renivohitra ---"
asdoc, text(District : Tana Renivohitra) save($f_logit) append

*-- Test de multicolinéarité
regress OBS02 PAT01 FSOC01
estat vif

*-- Dichotomisation
make_dummies PAT01 FSOC01, stem(habit consceSte)

*-- Régression logistique
logistic mauvaisObs habit1 consceSte2
lroc

/*==============================================================================
  2. TANA AVARADRANO
  Facteurs retenus : DEM_09, PAT01, PAT05, FSOC02, SAN03
==============================================================================*/
di as result "--- District : Tana Avaradrano ---"
asdoc, text(District : Tana Avaradrano) save($f_logit) append

*-- Test de multicolinéarité
regress OBS02 DEM_09 PAT01 PAT05 FSOC02 SAN03
estat vif

*-- Dichotomisation
make_dummies DEM_09 PAT01 PAT05 FSOC02 SAN03, ///
    stem(nivSco habit PriseTDOquot attitudeSoc dureeAttente)

*-- Régression logistique
logistic mauvaisObs                                         ///
    nivSco1 nivSco2 nivSco4                                 ///
    habit2                                                  ///
    PriseTDOquot2 PriseTDOquot3                             ///
    attitudeSoc1 attitudeSoc2                               ///
    dureeAttente1
lroc

/*==============================================================================
  3. MAHAJANGA I
  Facteurs retenus : DEM_09, RevenuMens, tailleMen, PAT01, PAT03,
                     PAT05, PAT09, SAN03, SOIN002, SAN04, FSOC01, FSOC02
==============================================================================*/
di as result "--- District : Mahajanga I ---"
asdoc, text(District : Mahajanga I) save($f_logit) append

*-- Test de multicolinéarité
regress OBS02 DEM_09 RevenuMens tailleMen PAT01 PAT03     ///
    PAT05 PAT09 SAN03 SOIN002 SAN04 FSOC01 FSOC02
estat vif

*-- Dichotomisation
make_dummies DEM_09 RevenuMens tailleMen PAT01 PAT03       ///
    PAT05 PAT09 SAN03 SOIN002 SAN04 FSOC01 FSOC02,         ///
    stem(nivSco Revenu taille habit ConnaissanceTB          ///
         PriseTDOquot Perception dureeAttente               ///
         QualiteAcc AttidDispens ConnaisSociete attitudeSoc)

*-- Régression logistique
logistic mauvaisObs                                         ///
    nivSco1 nivSco2 nivSco4                                 ///
    Revenu2 Revenu3                                         ///
    taille2                                                 ///
    habit1                                                  ///
    ConnaissanceTB2                                         ///
    PriseTDOquot2 PriseTDOquot3                             ///
    Perception2                                             ///
    dureeAttente2                                           ///
    QualiteAcc1 QualiteAcc3                                 ///
    AttidDispens2                                           ///
    ConnaisSociete2                                         ///
    attitudeSoc1 attitudeSoc2
lroc

di as result "--- 05_logistique terminé — fichier : $f_logit ---"
