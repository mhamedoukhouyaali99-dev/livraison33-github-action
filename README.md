# Homey - qualite et CI/CD

Ce depot regroupe les tests unitaires, API et IHM du projet. La suite valide les parcours critiques avant une livraison ou une publication de demonstration.

## Niveaux de test

- **Unitaire** : verifie les regles metier de `HomeyManager` en memoire, rapidement et sans dependance externe.
- **API** : verifie le contrat HTTP, les codes de statut, l'authentification, la pagination et la structure JSON.
- **IHM** : verifie les parcours utilisateur dans Chrome headless, notamment la connexion, le profil et les formulaires.

La suite [tests_ihm/06_cas_fonctionnels_istqb.robot](tests_ihm/06_cas_fonctionnels_istqb.robot) regroupe cinq cas fonctionnels IHM etiquetes ISTQB pour faciliter le suivi dans les rapports Robot. Les donnees, locators et mots-cles reutilisables sont centralises dans [ressources.resource](ressources.resource).

Chaque niveau doit rester lisible : le nom du test exprime le comportement attendu, les commentaires expliquent le risque couvert et les donnees sensibles restent dans les secrets CI.

## Techniques ISTQB appliquees

- **Partition d'equivalence** : prix valide, prix negatif et prix nul; recherche avec resultat et sans resultat.
- **Analyse des valeurs limites** : prix `0`, juste sous la regle `0` et valeur positive.
- **Tests de transition d'etat** : disponible vers reservee, puis reservee vers disponible.
- **Tests negatifs** : propriete inexistante, suppression impossible et operation interdite.
- **Tests de contrat** : codes HTTP, champs obligatoires et structure des reponses API.

Les cas unitaires sont les plus rapides et isolent les regles metier. Les cas API verifient l'integration HTTP. Les cas IHM couvrent les parcours critiques de l'utilisateur.

## Tests de performance

Les cas de performance sont dans [tests_performance/test_api_performance.py](tests_performance/test_api_performance.py) et [tests_performance/test_unitaire_performance.py](tests_performance/test_unitaire_performance.py). Ils couvrent :

- **Test de charge** : volume nominal de requetes concurrentes.
- **Test de stress** : volume superieur au nominal.
- **Test de pic** : arrivee simultanee et soudaine.
- **Test d'endurance** : repetitions sequentielles sur une duree courte.
- **Performance unitaire** : temps d'execution d'une regle metier en memoire.

Ils sont opt-in pour ne pas generer de charge pendant les tests fonctionnels :

```powershell
$env:RUN_PERFORMANCE = "1"
python -m pytest tests_performance -m performance -s -q
```

Les seuils sont configurables avec `PERFORMANCE_MAX_AVERAGE`, `PERFORMANCE_MAX_P95`, `PERFORMANCE_MAX_CONCURRENT`, `PERFORMANCE_MAX_STRESS`, `PERFORMANCE_MAX_SPIKE`, `PERFORMANCE_TIMEOUT`, `PERFORMANCE_CONCURRENCY`, `PERFORMANCE_STRESS_CONCURRENCY`, `PERFORMANCE_SPIKE_CONCURRENCY`, `PERFORMANCE_ENDURANCE_ITERATIONS` et `PERFORMANCE_UNIT_ITERATIONS`. Les tests de performance doivent etre executes sur un environnement de test autorise, jamais contre une production sans accord.

## Executer localement

```powershell
python -m pip install -r requirements.txt
./run_all_tests.bat
```

Les donnees utilisees localement sont des donnees de test. Elles ne doivent pas etre remplacees par des identifiants de production.

## Pipeline

GitHub Actions execute les tests sur chaque push et pull request. Jenkins execute la meme strategie sur un agent Windows. Les rapports sont conserves comme artefacts pour diagnostiquer un echec, apres masquage des valeurs sensibles.

Les etapes attendues sont :

1. Installer une version Python connue et les dependances verrouillees.
2. Executer les tests unitaires.
3. Executer les tests API.
4. Executer les tests IHM avec Chrome headless.
5. Archiver les rapports et bloquer la livraison si un test critique echoue.

## Metriques a suivre

- Taux de succes par type de test : unitaire, API, IHM.
- Duree moyenne et percentile 95 du pipeline.
- Taux d'echec recurrent par fonctionnalite.
- Temps moyen de resolution d'un incident et temps moyen de restauration.
- Nombre de secrets ou donnees personnelles detectes dans les artefacts.
- Taux de livraison reussie et taux de retour arriere.

Un seuil de qualite conseille est : tests unitaires et API a 100 %, tests IHM sans echec bloquant, aucun secret detecte dans les artefacts et un rapport publie pour chaque execution.

## Gestion d'un probleme

Un echec doit etre reproduit avec le test le plus proche, puis classe comme regression applicative, indisponibilite externe, probleme d'environnement ou donnees de test. Le ticket doit contenir le commit, l'environnement, le test, le rapport et la cause racine. Toute correction doit ajouter ou ajuster un test avant la remise en production.

La politique de masquage et la procedure d'exposition sont detaillees dans [SECURITY.md](SECURITY.md).
