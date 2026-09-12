# Cours pratique : collaborer avec une IA pour un projet QA professionnel

## Objectif du cours

Apprendre a utiliser une IA comme collaborateur QA pour analyser une fonctionnalite, concevoir les cas de test, automatiser les scenarios, diagnostiquer les echecs et publier un travail reproductible.

L'IA aide a produire et verifier le travail. Elle ne remplace pas la validation humaine du besoin, du risque et du resultat attendu.

## 1. Les roles dans la collaboration

### Le QA humain

Le QA decide :

- ce que le produit doit faire ;
- ce qui est prioritaire pour l'utilisateur ;
- quel risque est acceptable ;
- si le resultat observe est correct ;
- si les donnees peuvent etre utilisees ;
- si le code peut etre publie.

### L'IA

L'IA peut aider a :

- analyser une specification ou un scenario ;
- proposer des classes d'equivalence et valeurs limites ;
- transformer des cas en Robot Framework ou pytest ;
- rechercher des locators stables ;
- expliquer une erreur de test ;
- proposer des assertions ;
- documenter le processus ;
- preparer un resume de commit.

L'IA ne doit pas inventer une regle metier sans confirmation.

## 2. Bien formuler une demande a l'IA

Une bonne demande contient six informations :

1. Contexte : application, module et environnement.
2. Fonctionnalite : ce qui doit etre teste.
3. Regles : comportement attendu et contraintes.
4. Fichiers : suite existante, ressource de donnees ou rapport d'erreur.
5. Limites : ne pas supprimer de donnees, ne pas lancer toute la suite, ne pas modifier une autre fonctionnalite.
6. Livrable : cas de test, code, documentation ou diagnostic.

### Exemple de demande faible

```text
Ajoute des tests au profil.
```

### Exemple de demande professionnelle

```text
Fonctionnalite : profil utilisateur.
Objectif : ajouter 5 cas Robot Framework pour modifier les informations personnelles.
Donnees : utiliser tests_ihm/donnees.resource.
Contraintes : ne pas supprimer le compte et ne pas executer toute la suite.
Attendus : locators par id, assertions apres rechargement et retest uniquement de tests_ihm/profil.robot.
Livrable : code, resultat d'execution et resume des risques restants.
```

## 3. Cycle QA avec l'IA

### Etape A - Analyse

Demander a l'IA de :

- resumer la fonctionnalite ;
- identifier les acteurs et preconditions ;
- lister les parcours nominaux et alternatifs ;
- identifier les risques ;
- signaler les informations manquantes.

Techniques ISTQB a utiliser :

- partition d'equivalence ;
- analyse des valeurs limites ;
- table de decision ;
- transitions d'etat ;
- tests bases sur les risques.

Livrable attendu : une liste d'exigences testables et une matrice exigence/cas.

### Etape B - Conception

Demander a l'IA de produire un tableau avec :

| Champ | Description |
|---|---|
| ID | Identifiant unique, par exemple `TC-PROFIL-001` |
| Priorite | Critique, haute, moyenne ou basse |
| Risque | Probleme couvert |
| Preconditions | Etat necessaire avant execution |
| Donnees | Valeurs nominales et invalides |
| Etapes | Actions utilisateur ou requetes |
| Resultat attendu | Assertion observable |
| Nettoyage | Donnees a supprimer ou restaurer |

Regle importante : un cas doit verifier un comportement principal. Eviter les scenarios qui testent trop de fonctions en meme temps.

### Etape C - Implementation

Dans ce projet :

- Robot Framework est utilise pour les parcours IHM et API ;
- pytest est utilise pour les tests API Python ;
- les donnees reutilisables sont dans `tests_ihm/donnees.resource` et `tests_api/donnees.resource` ;
- les locators communs sont dans `tests_ihm/commun.resource` ;
- les suites doivent etre nommees par fonctionnalite.

Demander a l'IA de :

- respecter la structure existante ;
- reutiliser les ressources ;
- ajouter des assertions ;
- eviter les XPath de position ;
- verifier l'unicite des locators critiques ;
- ne pas ajouter de donnees sensibles.

### Etape D - Execution ciblee

Ne pas lancer toute la suite apres chaque modification.

Exemples :

```text
python -m robot --outputdir reports/profil tests_ihm/profil.robot
python -m robot --outputdir reports/api tests_api/test-api.robot
python -m pytest tests/test_api/test_site_routes.py -q
```

Apres un echec :

1. lire le premier message d'erreur ;
2. identifier le fichier, le keyword et l'etape ;
3. demander a l'IA une hypothese verifiable ;
4. modifier le perimetre minimal ;
5. relancer la meme commande ;
6. conserver la preuve du resultat.

### Etape E - Revue humaine

Avant d'accepter un test, verifier :

- le cas correspond-il a une exigence reelle ?
- le resultat attendu est-il observable ?
- l'assertion peut-elle passer par erreur ?
- les donnees sont-elles isolees ?
- le test est-il repetable ?
- le locator vise-t-il le bon element visible ?
- le test modifie-t-il une donnee partagee ?
- le nom explique-t-il le comportement teste ?

### Etape F - Cloture

La mission est terminee lorsque :

- les cas sont documentes ;
- le code est lisible ;
- le retest cible passe ;
- les anomalies sont documentees ;
- les sorties generees ne sont pas commitees ;
- `git diff --check` passe ;
- un commit explicite est cree ;
- le push GitHub est confirme ;
- le hash du commit est communique.

## 4. Prompts QA reutilisables

### Analyse d'une fonctionnalite

```text
Analyse uniquement la fonctionnalite X dans le fichier Y.
Identifie les preconditions, parcours nominaux, erreurs, risques,
classes d'equivalence, valeurs limites et informations manquantes.
Ne modifie aucun fichier.
```

### Creation de cas ISTQB

```text
Cree des cas de test professionnels pour X.
Utilise partition d'equivalence, valeurs limites, table de decision
et tests bases sur les risques. Donne ID, priorite, donnees,
et resultat attendu. Ne cree pas de doublons.
```

### Automatisation Robot

```text
Automatise uniquement les cas TC-X avec Robot Framework.
Reutilise les ressources de donnees existantes.
Utilise des locators id/name/data-* stables, attends la page cible,
ajoute des assertions et ne lance pas la suite complete.
```

### Diagnostic d'un echec

```text
Voici le premier message d'erreur : [copier l'erreur].
Analyse uniquement la fonctionnalite X.
Donne une hypothese falsifiable, une correction minimale
et la commande de retest ciblee.
```

### Revue de test

```text
Fais une revue QA de cette suite.
Cherche d'abord les faux positifs, assertions faibles, donnees partagees,
locators instables, tests non independants et couverture manquante.
Ne modifie pas le code avant de lister les risques.
```

## 5. Exemple de mission complete

Mission : automatiser la modification du profil.

1. Analyse : identifier informations personnelles, adresse et persistance.
2. Conception : creer `TC-PROFIL-001` a `TC-PROFIL-011` avec priorites.
3. Donnees : ajouter les valeurs dans `tests_ihm/donnees.resource`.
4. Locators : ajouter les locators stables dans `commun.resource`.
5. Implementation : creer `tests_ihm/profil.robot`.
6. Execution : lancer uniquement `python -m robot tests_ihm/profil.robot`.
7. Correction : traiter les erreurs et relancer la meme suite.
8. Revue : verifier qu'aucune suppression de compte n'est confirmee.
9. Cloture : documenter, commit, push et communiquer le resultat.

## 6. Erreurs a eviter

- demander a l'IA de tester sans donner le comportement attendu ;
- accepter un locator invente sans verifier le DOM ;
- utiliser des donnees en dur dans plusieurs fichiers ;
- lancer toute la suite pour une modification locale ;
- confondre un test qui s'execute avec un test qui verifie vraiment ;
- supprimer une donnee distante partagee ;
- committer des rapports, captures ou caches ;
- accepter un test sans assertion fonctionnelle ;
- publier une cle ou un mot de passe reel ;
- laisser l'IA decider seule qu'un resultat est correct.

## 7. Modele de compte rendu

```text
Fonctionnalite : X
Exigences couvertes : TC-X-001 a TC-X-00N
Fichiers modifies : ...
Donnees utilisees : ...
Commande ciblee : ...
Resultat : N/N reussis
Anomalies : ...
Tests non executes : ...
Commit : ...
Push : branche ... confirme
```
