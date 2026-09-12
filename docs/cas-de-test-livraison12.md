# Cas de test professionnels - Livraison 12

## 1. Informations generales

- Application : Livraison 3
- URL de test : `http://livraison3.testacademy.fr`
- Source : `livraison12.side`
- Navigateur utilise dans le scenario source : Chrome
- Parcours couvert : inscription, connexion, profil, profil public, contact d'un hote et suppression du compte

> Les resultats attendus ci-dessous sont les comportements fonctionnels a valider. Le fichier Selenium source contient des interactions, mais aucune assertion fonctionnelle.

## 2. Jeu de donnees

### Compte utilisateur

| Champ | Valeur nominale | Valeur invalide ou limite |
|---|---|---|
| Nom utilisateur | `ALI` | `ALIA`, vide, deja utilise |
| Email | `ALI@test.com` | `KJHG@TEST;COM`, vide |
| Mot de passe | `ALI` | vide |
| Confirmation | `ALI` | valeur differente |
| Conditions | cochees | non cochees |

### Profil

| Champ | Valeur relevee |
|---|---|
| Prenom | `gfytr` |
| Nom | `kjhk` |
| Langue native | `kjh` |
| Autre langue | `jhgf` |
| Biographie | `gfdeh` |
| Rue | `hgf` |
| Appartement | `124` |
| Ville | `gfd` |
| Etat ou region | `hgf` |
| Code postal | `123456` |
| Quartier | `GFHHT` |
| Pays | `HGFRTD` |

### Contact et reseaux sociaux

| Fonction | Donnees relevees |
|---|---|
| Contact urgence | `GFDT`, `GHFTR`, `0879809876` |
| Email contact urgence | `KJHG@TEST;COM` (format invalide a verifier) |
| Facebook | `GFFJT` |
| Twitter | `HGFYTR` |
| LinkedIn | `JHGT` |
| Google Plus | `KJHGF` |
| Instagram | `JHGYTF` |
| Pinterest | `KJHIUY` |
| YouTube | `KJHIUG` |
| Vimeo | `KJ?NHG` |
| Airbnb | `LKOI?J` |
| TripAdvisor | `HGFYTRB` |

### Formulaire de contact hote

- Nom : `JHGUYT`
- Email : `HG@TEST.com`
- Telephone : `0987654321`
- Message : `GFDEFBN`
- Annonce de reference : `Beautiful Cove`

## 3. Cas de test

| ID | Cas de test | Preconditions | Resultat attendu | Priorite |
|---|---|---|---|---|
| TC-001 | Afficher la page d'accueil | Application disponible | La page d'accueil est accessible et les controles principaux sont visibles | Haute |
| TC-002 | Ouvrir l'inscription hote | Page d'accueil affichee | Le formulaire d'inscription est visible | Haute |
| TC-003 | Creer un compte avec des donnees valides | Identifiant et email non utilises | Le compte est cree et un message de confirmation est affiche | Critique |
| TC-004 | Refuser un identifiant deja utilise | Le compte `ALI` existe | L'inscription est refusee avec un message explicite | Haute |
| TC-005 | Refuser une inscription sans conditions acceptees | Formulaire rempli, case non cochee | L'inscription est bloquee | Haute |
| TC-006 | Refuser une confirmation de mot de passe differente | Deux mots de passe differents | Une erreur de confirmation est affichee | Haute |
| TC-007 | Refuser un email d'inscription invalide | Email mal forme | Une erreur de format est affichee | Haute |
| TC-008 | Se connecter avec un compte valide | Compte cree | Le tableau de bord est accessible et la session est ouverte | Critique |
| TC-009 | Refuser une connexion invalide | Identifiants incorrects | Un message d'erreur est affiche et l'utilisateur reste deconnecte | Haute |
| TC-010 | Modifier les informations personnelles | Utilisateur connecte | Les informations sont enregistrees et conservees apres rechargement | Haute |
| TC-011 | Modifier l'adresse du profil | Utilisateur connecte | L'adresse est enregistree avec les valeurs saisies | Moyenne |
| TC-012 | Enregistrer un contact d'urgence valide | Utilisateur connecte | Le contact est enregistre | Moyenne |
| TC-013 | Refuser un email de contact urgence invalide | Email `KJHG@TEST;COM` | L'erreur de format est affichee et la sauvegarde est bloquee | Haute |
| TC-014 | Enregistrer les reseaux sociaux | Utilisateur connecte | Les valeurs conformes sont sauvegardees; les formats non conformes sont refuses | Moyenne |
| TC-015 | Consulter le profil public | Profil sauvegarde | Le profil public affiche les donnees autorisees | Haute |
| TC-016 | Ouvrir le formulaire de contact hote | Annonce `Beautiful Cove` accessible | Le formulaire de contact est visible | Haute |
| TC-017 | Envoyer un message valide a l'hote | Formulaire de contact ouvert | Le message est envoye et une confirmation est affichee | Haute |
| TC-018 | Refuser un formulaire de contact incomplet | Un champ obligatoire est vide | L'envoi est bloque et l'erreur correspondante est visible | Haute |
| TC-019 | Refuser un email de contact invalide | Email mal forme | L'envoi est bloque avec un message explicite | Haute |
| TC-020 | Demander la suppression du compte | Utilisateur connecte | Une fenetre de confirmation est affichee | Critique |
| TC-021 | Annuler la suppression du compte | Confirmation ouverte | Le compte reste actif | Haute |
| TC-022 | Confirmer la suppression du compte | Confirmation ouverte | Le compte est supprime et la session est fermee | Critique |
| TC-023 | Verifier l'acces apres suppression | Compte supprime | La connexion avec l'ancien compte est impossible | Critique |

## 4. Anomalies et points a clarifier

1. Le scenario cree le compte avec `ALI`, puis tente une connexion avec `ALIA`. Il faut utiliser le meme identifiant ou documenter une modification intermediaire validee.
2. Le test est nomme `Untitled` et ne contient aucune assertion.
3. Les donnees de profil sont des valeurs aleatoires et ne permettent pas de verifier clairement les regles metier.
4. `KJHG@TEST;COM` est un email invalide. Il doit etre conserve pour un cas negatif et non pour un parcours nominal.
5. Les valeurs des reseaux sociaux ne sont pas des URL. Il faut confirmer si l'application accepte du texte libre ou exige des liens valides.
6. Aucun fichier image n'est fourni pour valider l'import de la photo de profil.
7. Les clics, survols et doubles clics sans resultat attendu doivent etre remplaces par des verifications fonctionnelles.
8. La suppression du compte doit etre executee uniquement dans un environnement de test et avec un compte dedie.

## 5. Regles de qualite pour l'automatisation

- Donner un nom explicite a chaque test.
- Isoler chaque cas de test et preparer ses propres donnees.
- Ajouter une assertion apres chaque soumission.
- Verifier le message, l'URL, le titre ou la valeur sauvegardee selon le cas.
- Ne pas utiliser de mots de passe ou de comptes reutilises en production.
- Remplacer les selecteurs XPath de position par des attributs stables (`id`, `name`, `data-*`).
- Nettoyer les comptes de test apres execution, sauf pour les tests de suppression.
