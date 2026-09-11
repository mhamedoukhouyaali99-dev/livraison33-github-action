---
name: diagnostic-environnement-tests
description: "Use when diagnosing development environment or automated test failures involving Python, Robot Framework, Selenium, ChromeDriver, GitHub Actions, Jenkins, Windows agents, PATH, dependencies, or test reports."
---

# Diagnostic environnement et tests

## Objectif

Diagnostiquer rapidement les erreurs d'environnement et de tests sans modifier les scénarios métier inutilement.

## Procedure

1. Identifier l'environnement d'execution : poste local, GitHub Actions ou agent Jenkins.
2. Lire le premier message d'erreur reel. Ne pas traiter les etapes `skipped` comme la cause initiale.
3. Verifier les executables et versions :
   - Python : `where python`, `python --version`, `py -3 --version`.
   - Chrome : `google-chrome --version` sur Linux ou `chrome.exe --version` sur Windows.
   - ChromeDriver : `chromedriver --version`.
4. Verifier que Chrome et ChromeDriver ont le meme numero majeur.
5. Verifier les dependances Python :
   - `robotframework`
   - `robotframework-seleniumlibrary`
   - `selenium`
   - `robotframework-requests`
6. Executer d'abord un test cible, puis la suite complete.
7. Lire le rapport Robot : `output.xml`, `log.html`, `report.html`.
8. Verifier le code de sortie : `0` signifie succes, toute autre valeur signifie echec.

## Jenkins Windows

- Ne pas supposer que le PATH de la session utilisateur est celui du service Jenkins.
- Preferer un chemin absolu vers Python ou une installation systeme pour tous les utilisateurs.
- Redemarrer le service Jenkins apres toute modification du PATH.
- Utiliser `bat` pour les commandes Windows.
- Ne pas utiliser `xvfb-run` sur un agent Windows.
- Pour les tests IHM, installer Chrome sur l'agent et utiliser les options headless dans Robot Framework.

Exemple de verification :

```groovy
stage('Verifier environnement') {
    steps {
        bat 'where python'
        bat 'python --version'
        bat 'where chrome'
        bat 'chrome.exe --version'
    }
}
```

## GitHub Actions Linux

- Utiliser `xvfb-run` pour les tests IHM si le navigateur n'est pas lance en mode headless complet.
- Eviter d'installer un ChromeDriver different du navigateur utilise.
- Preferer Selenium Manager ou une installation Chrome/driver explicitement coherente.
- Utiliser `sudo` pour supprimer ou remplacer un executable systeme.

## Robot Framework et Selenium

- Utiliser un viewport stable, par exemple `1920x1080`.
- Attendre les elements avec `Wait Until Element Is Visible`.
- Faire `Scroll Element Into View` avant les boutons hors viewport.
- Preferer les locators fonctionnels : `id`, `name`, `data-target`, classes stables.
- Eviter les XPath bases sur une position comme `(//a)[3]`.
- Si plusieurs elements identiques existent, selectionner explicitement l'element visible.
- Ne pas confondre un element present dans le DOM avec un element visible ou interactif.

## Regle de correction

Corriger d'abord la couche responsable :

- Python introuvable : agent, PATH ou installation Python.
- ChromeDriver incompatible : versions et binaire Chrome reellement utilise.
- Element introuvable : URL finale, chargement, viewport ou locator.
- Element non interactif : element cache, overlay, scroll ou locator trop large.
- Rapport absent : dossier de sortie ou archivage Jenkins/GitHub.

Apres chaque modification, executer une validation ciblee avant d'elargir la suite.
