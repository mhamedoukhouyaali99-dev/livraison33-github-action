# Processus d'une nouvelle mission de test

Ce processus s'applique lorsqu'une nouvelle fonctionnalite `X` doit etre testee.

## Entree de mission

Avant de commencer, enregistrer :

- nom de la fonctionnalite ;
- URL, endpoint ou ecran concerne ;
- regles metier connues ;
- utilisateurs et droits necessaires ;
- donnees de test disponibles ;
- resultat attendu ;
- risque principal ;
- suite de test ciblee ;
- responsable de la validation.

## 1. Analyse

Objectif : comprendre ce qui doit etre verifie.

Actions :

1. Lire la demande, la documentation et le code directement lies a `X`.
2. Identifier le parcours nominal, les erreurs attendues et les dependances.
3. Definir les classes d'equivalence, valeurs limites et regles de decision.
4. Identifier les risques : donnees, authentification, droits, localisation, format, persistance et regression.
5. Choisir le perimetre de retest sans lire ni executer tout le projet.

Livrable : fiche d'analyse avec preconditions, donnees, cas nominaux, cas negatifs et priorites.

Critere de sortie : chaque exigence de `X` est reliee a au moins un cas de test.

## 2. Conception

Objectif : transformer l'analyse en cas executables.

Pour chaque cas, definir :

- identifiant unique ;
- titre explicite ;
- preconditions ;
- donnees d'entree ;
- etapes ;
- resultat attendu ;
- priorite ;
- risque couvert ;
- nettoyage necessaire.

Regles :

- au moins un cas nominal ;
- au moins un cas par classe invalide importante ;
- un cas par decision metier critique ;
- assertions apres chaque soumission ;
- donnees placees dans `donnees.resource` ;
- locators fonctionnels et stables pour l'IHM ;
- statut HTTP, schema et donnees verifiees pour l'API.

Livrable : tableau de cas de test et matrice exigence-vers-test.

## 3. Implementation

Objectif : automatiser uniquement `X`.

Ordre recommande :

1. Ajouter ou mettre a jour les donnees dans la ressource de la fonctionnalite.
2. Ajouter les locators dans `commun.resource` si le parcours est IHM.
3. Creer une suite dediee, par exemple `tests_ihm/fonction-x.robot` ou `tests_api/fonction-x.robot`.
4. Utiliser des mots-cles reutilisables.
5. Ajouter une assertion fonctionnelle et une verification de persistance si necessaire.
6. Ajouter un test de contrat pour les locators critiques.
7. Eviter les XPath de position, les donnees en dur et les actions sans resultat attendu.

Livrable : suite Robot ou pytest lisible, independante et deterministe.

## 4. Execution ciblee

Objectif : confirmer `X` sans executer tout le projet.

Commandes types :

```text
python -m robot --outputdir reports/fonction-x tests_ihm/fonction-x.robot
python -m robot --outputdir reports/fonction-x tests_api/fonction-x.robot
python -m pytest tests/test_api/test_fonction_x.py -q
```

En cas d'echec :

1. lire le premier message reel ;
2. corriger uniquement le perimetre de `X` ;
3. relancer la meme commande ;
4. confirmer le resultat ;
5. elargir seulement si un composant partage a ete modifie.

Critere de sortie : tous les cas prioritaires de `X` passent, sans test instable ni erreur de locator connue.

## 5. Cloture

Objectif : rendre la mission traçable et reproductible.

Checklist :

- [ ] cas de test documentes ;
- [ ] donnees centralisees ;
- [ ] locators stables ;
- [ ] assertions presentes ;
- [ ] suite ciblee executee ;
- [ ] rapport conserve si necessaire ;
- [ ] anomalies et limites documentees ;
- [ ] aucune donnee destructive executee sans environnement dedie ;
- [ ] fichiers temporaires exclus de Git ;
- [ ] `git diff --check` reussi ;
- [ ] commit explicite cree ;
- [ ] push effectue sur la branche attendue ;
- [ ] hash du commit communique.

Commandes de cloture :

```text
git status --short
git diff --check
git add <fichiers-de-la-mission>
git commit -m "Ajouter les tests de la fonctionnalite X"
git push origin main
git log -1 --oneline --decorate
```

## Format de compte rendu

- Fonctionnalite : `X`
- Cas ajoutes : nombre et identifiants
- Donnees : fichier resource utilise
- Commande executee : commande ciblee
- Resultat : `N/N` reussis
- Anomalies : liste ou `aucune`
- Commit : hash Git
- Push : branche et statut
- Tests non executes : perimetre volontairement exclu
