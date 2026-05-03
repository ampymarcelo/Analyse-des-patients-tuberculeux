# Analyse TB — Mauvaise observance thérapeutique chez les patients tuberculeux

## Structure du projet

```
TB_Observance/
├── MASTER.do                        ← Point d'entrée unique
├── README.md
├── config/
│   └── 00_config.do                 ← Chemins, macros, programme tabchi2
├── modules/
│   ├── 01_recodage.do               ← TrancheAge, RevenuMens, tailleMen, mauvaisObs
│   ├── 02_labels.do                 ← label var + label values
│   ├── 03_descriptif.do             ← Taux non-réponse + bivariée pondérée
│   ├── 04_tests_khi2.do             ← Chi² non pondérés (standalone)
│   ├── 05_logistique.do             ← Logistiques par district (VIF + dummies)
│   └── 06_modeles_pas_a_pas.do      ← Modèles M0–M5 + esttab RTF
├── data/
│   └── BaseCible1.dta               ← Base source (non versionnée)
└── output/
    ├── 01_Descriptif_Bivarie.doc
    ├── 02_Tests_Khi2.doc
    ├── 03_Logistique_Districts.doc
    ├── 04_Modeles_Final.rtf          ← Tableau comparatif M0–M5
    └── log_TB_Observance.log
```

---

## Utilisation

### Analyse complète
1. Ouvrir `config/00_config.do`
2. Modifier `global dir_project` avec le chemin local
3. Exécuter `MASTER.do`

### Module seul
```stata
do "config/00_config.do"
do "modules/06_modeles_pas_a_pas.do"
```

---

## Dépendances entre modules

```
00_config  (charge la base + déclare svyset + définit tabchi2)
    └── 01_recodage        (TrancheAge, RevenuMens, tailleMen, mauvaisObs)
    └── 02_labels
            └── 03_descriptif      → 01_Descriptif_Bivarie.doc
            └── 04_tests_khi2      → 02_Tests_Khi2.doc
            └── 05_logistique      → 03_Logistique_Districts.doc
            └── 06_modeles_pas_a_pas → 04_Modeles_Final.rtf
```

---

## Programmes utilitaires

### `tabchi2 varname, save() [append|replace]`  *(00_config.do)*
Remplace les deux blocs répétés de l'original (tableau row pondéré + chi²).
```stata
* Original (2 commandes séparées)
asdoc tab TrancheAge OBS02 [iw=pond], row
asdoc tab TrancheAge OBS02, chi2

* Refactorisé (1 commande)
tabchi2 TrancheAge, save($f_descr) append
```

### `make_dummies varlist, stem(noms)` *(05_logistique.do)*
Remplace les blocs de `tab X, gen(Y)` répétés à l'identique pour chaque district.
```stata
* Original (3 × 5–12 lignes identiques)
tab DEM_09, gen(nivSco)
tab PAT01,  gen(habit)
...

* Refactorisé
make_dummies DEM_09 PAT01 PAT05, stem(nivSco habit PriseTDOquot)
```

---

## Bugs et incohérences corrigés

| Fichier original | Problème | Correction |
|---|---|---|
| Ligne 44 | `lab val DEM02 TrancheAge` — mauvaise syntaxe (DEM02 au lieu de TrancheAge) | `label values TrancheAge lbl_tranche` |
| Ligne 43 | `(35/44=4 "35-34ans")` — libellé erroné | Corrigé en `"35-44 ans"` |
| Lignes 201, 226 | `gen mauvaisObs` recréée 3 fois sans `capture drop` → erreur à la 2e exécution | Centralisée dans `01_recodage.do` avec `capture drop` |
| Ligne 256 | Modèle M3 sans `[iw=pond]` alors que M1, M2, M4, M5 l'ont | Pondération ajoutée (voir note dans module 06) |
| Lignes 269+ | `logit` Tana Avaradrano après `esttab` sans `eststo` ni contexte clair | Déplacé dans `05_logistique.do` comme vérification de district |

---

## Structure des modèles (module 06)

| Modèle | Variables incluses | Note |
|---|---|---|
| M0 | — (constante seule) | Référence |
| M1 | DEM_09 | Scolarisation |
| M2 | DEM_09, PAT05 | + TDO/quotidien |
| M3 | DEM_09, PAT05, FSOC02 | + Attitude sociale |
| M4 | Démo + Patient + Santé + Soins | Sans FSOC |
| M5 | Tous les groupes | Modèle complet |

---

## Variables à compléter / vérifier

- `PAT13` (moyen de locomotion et coût) : présente dans la liste théorique mais absente des régressions par district → à intégrer si significative au chi²
- `SAN01`, `SOIN001`, `SOIN003` : idem
- `DEM01` (distance habitation–centre) : incluse dans M4/M5 mais pas dans les analyses par district
- Vérifier la codification exacte de `OBS02` (1 = mauvaise, 2 = bonne) avant de lancer `05_logistique.do`
