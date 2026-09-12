# Cas de test - Creer une annonce

## 1. Informations generales

- Application : Livraison 3
- URL de test : `http://livraison3.testacademy.fr`
- Source analysee : `cree annacer.side`
- Parcours : inscription hote, connexion, creation d'une annonce et gestion du calendrier
- Navigateur releve : Chrome

Le fichier `.side` contient principalement des actions Selenium. Il ne contient pas d'assertions fonctionnelles suffisantes pour confirmer qu'une annonce est creee. Les cas ci-dessous ajoutent les resultats attendus.

## 2. Preconditions et donnees

### Preconditions

- L'application est disponible.
- Un compte hote de test existe et peut se connecter.
- Le compte utilise pour un test d'inscription n'existe pas encore.
- Les annonces creees sont identifiables et supprimables dans l'environnement de test.

### Donnees nominales relevees

| Donnee | Valeur du scenario | Champ ou controle |
|---|---|---|
| Nom utilisateur | `3di` | `username` |
| Email | `3di@3di.com` | `useremail` |
| Mot de passe | `3di` | `register_pass` |
| Confirmation | `3di` | `register_pass_retype` |
| Titre | `tigmimi mqorn` | `listing_title` |
| Description | `tigmi mqorn yan tnsryt isbrak les imssafri ad affnse asfofnfo` | Editeur `description` |
| Type de bien | `Appartment` | `listing_type` |
| Chambres | `5` | `listing_bedrooms` |
| Voyageurs | `10` | `guests` |
| Lits | `12` | `beds` |
| Salles de bain | `3` | `baths` |
| Pieces | `3` | `listing_rooms` |
| Surface | `140 m2` | `listing_size`, `listing_size_unit` |
| Prix par nuit | `500` | `night_price` |
| Surcharge | `50` | `price_postfix` |
| Frais de menage | `100` | `cleaning_fee` |
| Depot de garantie | `144` | `security_deposit` |
| Adresse | `ahbarir tamrocht` | `listing_address` |
| Appartement | `1` | `aptSuit` |
| Ville | `agadir` | `city` |
| Region | `ghriwig` | `countyState` |
| Code postal | `2134` | `zip` |
| Quartier | `TAGHJIJT` | `area` |
| Pays | `MORRIS` | `homey_country` |

> Les valeurs relevees sont conservees pour la tracabilite. Elles doivent etre remplacees par des donnees metier realistes avant un test d'acceptation.

## 3. Cas de test

| ID | Cas de test | Preconditions | Resultat attendu | Priorite |
|---|---|---|---|---|
| ANN-001 | Ouvrir le formulaire de creation d'annonce | Hote connecte | Le lien `Creer annonce` ouvre `/index.php/add-listing/` et le formulaire est visible | Haute |
| ANN-002 | Verifier les champs obligatoires de l'annonce | Formulaire ouvert | Le titre, la description, le type de bien et les champs requis sont visibles et identifiables par `id` ou `name` | Haute |
| ANN-003 | Creer une annonce avec les donnees nominales | Hote connecte, donnees valides | Chaque etape accepte les donnees et le bouton `Continuer` passe a l'etape suivante | Critique |
| ANN-004 | Refuser une annonce sans titre | Formulaire ouvert, titre vide | La progression est bloquee et un message indique que le titre est obligatoire | Haute |
| ANN-005 | Refuser une annonce sans description | Formulaire ouvert, description vide | La progression est bloquee et une erreur de description est visible | Haute |
| ANN-006 | Refuser des valeurs numeriques invalides | Formulaire ouvert | Les champs chambres, voyageurs, lits, prix et surface refusent du texte, une valeur negative ou une valeur hors limite | Haute |
| ANN-007 | Accepter les details du logement | Etape informations remplie | Type `Appartment`, chambres `5`, voyageurs `10`, lits `12`, salles de bain `3`, pieces `3` et surface `140 m2` sont conserves apres changement d'etape | Haute |
| ANN-008 | Enregistrer une annonce en brouillon | Donnees minimales valides | `Enregistrer comme brouillon` affiche une confirmation et l'annonce est retrouvable dans les annonces de l'hote | Critique |
| ANN-009 | Reprendre un brouillon | Brouillon existant | Les valeurs saisies precedemment sont restituees et le brouillon peut etre modifie | Haute |
| ANN-010 | Saisir un prix et les frais | Etape tarification ouverte | Le prix par nuit, la surcharge, les frais de menage et le depot de garantie sont acceptes et sauvegardes | Haute |
| ANN-011 | Refuser un prix invalide | Etape tarification ouverte | Un prix vide, nul, negatif ou non numerique empeche la progression avec une erreur explicite | Haute |
| ANN-012 | Ajouter une photo valide | Etape galerie ouverte, fichier image disponible | L'image est chargee, une miniature est visible et elle reste associee au brouillon | Haute |
| ANN-013 | Refuser un fichier non image ou trop volumineux | Etape galerie ouverte | Le fichier est refuse avec un message explicite et le formulaire reste utilisable | Moyenne |
| ANN-014 | Enregistrer une adresse valide | Etape adresse ouverte | Adresse, ville, region, code postal, quartier et pays sont sauvegardes et restitues apres rechargement | Haute |
| ANN-015 | Refuser une adresse incomplete ou invalide | Etape adresse ouverte | Les champs obligatoires manquants ou le code postal invalide bloquent la progression | Haute |
| ANN-016 | Definir une periode indisponible dans le calendrier | Annonce brouillon existante | Une date de debut et une date de fin valides sont selectionnees, puis la periode est marquee reservee | Haute |
| ANN-017 | Refuser une periode incoherente | Calendrier ouvert | Une date de fin anterieure a la date de debut, une date vide ou une periode deja reservee est refusee | Haute |
| ANN-018 | Publier une annonce complete | Toutes les etapes valides, au moins une photo si obligatoire | Un message de succes confirme la soumission et l'annonce apparait avec le statut attendu | Critique |
| ANN-019 | Ne pas perdre les donnees lors du retour entre etapes | Donnees saisies dans plusieurs etapes | Retour puis retour en avant conserve les valeurs deja saisies | Moyenne |
| ANN-020 | Refuser la creation pour un utilisateur non connecte | Session fermee | L'acces redirige vers la connexion ou affiche un refus d'acces; aucune annonce n'est creee | Haute |

## 4. Analyse des anomalies du fichier `.side`

1. Le scenario est nomme `Untitled` et ne contient pas d'assertion de succes apres les soumissions.
2. Il alterne des clics, doubles clics, survols et actions souris sans resultat attendu. Ces actions ne constituent pas des tests a elles seules.
3. La commande `save_as_draft` est utilisee plusieurs fois. Le scenario valide donc surtout la sauvegarde d'un brouillon, pas la publication.
4. Le chargement d'image ne fournit pas de fichier exploitable : la valeur de l'input fichier est vide. Le cas photo doit etre rejoue avec un fichier reel.
5. Les clics sur `period_note` et `period_end_date` sont repetes sans valeur saisie. La periode du calendrier n'est donc pas demontrée.
6. Le lien du calendrier contient un identifiant d'annonce fixe (`edit_listing=8903`). Il faut utiliser un identifiant dynamique issu de l'annonce creee.
7. Le compte `3di` et l'annonce `tigmimi mqorn` peuvent deja exister. Les tests doivent utiliser des donnees uniques ou nettoyer les donnees apres execution.
8. Le nom `Appartment` semble provenir de l'application. Il faut verifier si l'intitule attendu est bien `Apartment` ou si cette orthographe est une valeur metier existante.
9. Les champs `countyState`, `homey_country` et `zip` contiennent des valeurs qui ne semblent pas correspondre a une adresse valide. Elles conviennent a un test de saisie, pas a un test d'acceptation.
10. Le scenario utilise `chooseCancelOnNextPrompt` pour l'insertion d'image, ce qui annule l'action au lieu de verifier un chargement reussi.

## 5. Regles d'automatisation

- Utiliser des selecteurs stables : `id`, `name` ou attributs `data-*`.
- Ajouter une assertion apres chaque bouton `Continuer`, `Enregistrer comme brouillon` et action de calendrier.
- Isoler l'inscription de la creation d'annonce : les tests de creation doivent reutiliser un compte hote de test prepare.
- Generer un titre unique par execution et supprimer le brouillon ou l'annonce a la fin du test.
- Ne pas coder en dur l'identifiant de l'annonce dans l'URL du calendrier.
- Tester separement la sauvegarde brouillon et la publication.

## 6. Priorite d'implementation

1. ANN-001, ANN-003 et ANN-008 : acces, parcours nominal et sauvegarde.
2. ANN-004, ANN-006, ANN-011 et ANN-015 : validations bloquantes.
3. ANN-010, ANN-012 et ANN-014 : donnees complementaires.
4. ANN-016 et ANN-017 : disponibilites du calendrier.
5. ANN-018, ANN-019 et ANN-020 : publication, persistance et securite d'acces.
