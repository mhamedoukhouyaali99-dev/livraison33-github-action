# Homey - qualite et CI/CD

Ce depot regroupe les tests unitaires, API et IHM du projet. La suite valide les parcours critiques avant une livraison ou une publication de demonstration.

## Executer localement

```powershell
python -m pip install -r requirements.txt
$env:API_KEY = "votre-cle-de-test"
./run_all_tests.bat
```

La cle API doit venir d'une variable d'environnement. Elle ne doit jamais etre ajoutee dans un fichier Robot ou dans un commit.

## Pipeline

GitHub Actions execute les tests sur chaque push et pull request. Jenkins execute la meme strategie sur un agent Windows. Les rapports sont conserves comme artefacts pour diagnostiquer un echec, apres masquage des valeurs sensibles.

Les etapes attendues sont :

1. Installer une version Python connue et les dependances verrouillees.
2. Executer les tests unitaires.
3. Executer les tests API.
4. Executer les tests IHM avec Chrome headless.
5. Masquer les secrets dans les rapports.
6. Archiver les rapports et bloquer la livraison si un test critique echoue.

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
