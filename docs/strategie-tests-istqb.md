# Strategie de couverture ISTQB

## Objectif

Les tests combinent les parcours fonctionnels, les controles de contrat HTML et les cas negatifs. L'objectif est de couvrir les regles metier sans multiplier les tests redondants.

## Techniques appliquees

| Technique ISTQB | Application dans le projet |
|---|---|
| Partition d'equivalence | Identifiants valides, vides et inconnus dans les tests de connexion |
| Valeurs limites | Champs vides, mot de passe vide, confirmation differente et formulaire incomplet |
| Table de decision | Combinaisons utilisateur/mot de passe dans `se-connecter-invalides.robot` |
| Test de transition d'etat | Connexion, tableau de bord, deconnexion et retour au lien de connexion |
| Test base sur les risques | Priorite aux connexions, inscription, contact hote et locators de formulaire |
| Tests de contrat | Unicite des locators, visibilite des champs, champ obligatoire et type email |

## Regles de couverture

- Chaque formulaire doit avoir au moins un cas nominal et un cas par classe invalide importante.
- Chaque soumission doit etre suivie d'une verification fonctionnelle : message, URL, titre ou etat de session.
- Les champs vides et les valeurs invalides ne doivent pas etre melanges dans un meme cas quand le resultat attendu differe.
- Les locators doivent etre ancres sur un conteneur fonctionnel, un `id`, un `name` ou un attribut `data-*` stable.
- Un test de contrat verifie qu'un locator retourne exactement un element, afin d'eviter qu'un element cache soit utilise.
- Les limites metier non documentees doivent etre confirmees avant d'ajouter des longueurs arbitraires.

## Regle de retest cible

Lorsqu'une fonctionnalite est modifiee ou qu'un test echoue, on ne relance pas tout le projet immediatement.

1. Identifier la fonctionnalite et le fichier de test concernes.
2. Executer uniquement la suite de cette fonctionnalite.
3. Corriger le probleme dans le meme perimetre.
4. Relancer la meme suite jusqu'a obtention d'un resultat confirme.
5. Elargir les tests uniquement si la modification touche un composant partage ou un contrat commun.

Exemples :

- Modification d'un locator IHM : `python -m robot tests_ihm/contrats-formulaires.robot` puis la suite IHM concernee.
- Modification de l'inscription : `python -m robot tests_ihm/inscription-hote.robot`.
- Modification de l'API : `python -m robot tests_api/test-api.robot`.
- Modification d'un test Python API : `python -m pytest tests/test_api/test_site_routes.py -q`.

Cette regle reduit le temps de validation et evite de confondre une erreur de fonctionnalite avec une erreur provenant d'un autre module.

## Ressources de donnees

Les donnees reutilisables sont stockees dans des fichiers `resource` dedies :

- `tests_api/donnees.resource` : URL API, cle d'authentification, identifiants et donnees utilisateur API ;
- `tests_ihm/donnees.resource` : URL application, compte de connexion, annonce et donnees des formulaires IHM.

Les fichiers de test ne doivent pas recopier ces valeurs. Pour modifier un jeu de donnees, modifier uniquement la ressource correspondant a la fonctionnalite, puis executer le retest cible associe.

Le processus complet d'une nouvelle mission est decrit dans [processus-nouvelle-mission-tests.md](processus-nouvelle-mission-tests.md) : analyse, conception, implementation, execution ciblee et cloture avec push GitHub.

## Lecture de la couverture actuelle

- Connexion : cas nominal, vide, identifiant inconnu, mot de passe incorrect et combinaisons des deux.
- Inscription : champs obligatoires, confirmation differente et consentement absent.
- Contact hote : formulaire complet et champs obligatoires absents.
- Contrats UI : unicite des locators, champs visibles, consentement obligatoire et type email.
- API : GET, POST et PUT avec controles de statut, structure et donnees principales.

### Couverture API

La suite `tests_api/test-api.robot` contient 11 cas :

- GET d'un utilisateur existant et verification des donnees principales ;
- GET de la collection et verification de la pagination ;
- GET d'une ressource inexistante (`404`) ;
- GET sans authentification (`401`) ;
- POST valide (`201`) et POST sans champs obligatoires (`422`) ;
- PUT valide sur un utilisateur cree pour le test ;
- PUT sur une ressource inexistante (`404`) ;
- PATCH non autorisee (`405`) ;
- verification de la structure JSON retournee.

La suppression (`DELETE`) n'est pas executee automatiquement car elle detruit une donnee distante partagee. Elle doit etre testee avec un environnement et des donnees dedies.

## Garde-fous contre les erreurs de locator

1. Scoper les champs au formulaire ou a la modale concernee.
2. Eviter les XPath de position et les selecteurs bases sur `nth-child`.
3. Attendre l'URL cible avant de chercher les champs de la page.
4. Attendre la visibilite avant toute saisie ou soumission.
5. Tester l'unicite des locators critiques dans `contrats-formulaires.robot`.