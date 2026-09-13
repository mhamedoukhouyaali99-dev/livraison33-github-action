# Securite et donnees sensibles

## Regles obligatoires

- Ne jamais commiter de cle API, mot de passe, cookie, token ou donnees personnelles reelles.
- Utiliser des secrets GitHub Actions ou des credentials Jenkins pour la CI/CD.
- Utiliser des comptes et donnees de test dedies, avec une duree de vie limitee.
- Ne pas publier `reports/`, captures d'ecran ou logs contenant des donnees personnelles sur les reseaux sociaux.
- Verifier les rapports avant partage; le script `scripts/mask_sensitive_reports.py` remplace les valeurs sensibles connues par `[MASKED]`.

## Configuration CI/CD

GitHub Actions doit disposer d'un secret de depot nommé `API_KEY`. Jenkins doit disposer d'un credential secret-text nommé `api-key`. Une rotation de la cle est necessaire si elle a deja ete publiee dans l'historique Git ou un rapport.

## Procedure en cas d'exposition

1. Revoquer et regenerer immediatement le secret chez le fournisseur.
2. Supprimer ou restreindre les artefacts et publications qui le contiennent.
3. Rechercher la valeur dans le depot, les logs CI et les rapports.
4. Documenter l'incident, son impact et la correction.
5. Ajouter un test ou une regle de prevention pour eviter la recurrence.

## Avant une publication sur les reseaux sociaux

- Publier uniquement des captures anonymisees.
- Masquer emails, noms, telephones, URLs privees, tokens et identifiants.
- Utiliser un environnement de demonstration distinct de la production.
- Faire relire le contenu par une personne autorisee avant publication.
