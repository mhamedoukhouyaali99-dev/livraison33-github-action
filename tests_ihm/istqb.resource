*** Settings ***
Resource        commun.resource

*** Keywords ***
Verifier La Connexion Avec Des Identifiants Valides
    Se Connecter Avec Le Compte Valide
    Title Should Be    ${TITRE TABLEAU DE BORD}

Verifier Le Refus D'Une Connexion Avec Des Identifiants Invalides
    Accéder A La Page De Connexion
    Saisir Le Nom D'Utilisateur    utilisateur-inconnu
    Saisir Le Mot De Passe         mot-de-passe-invalide
    Soumette Le Formulaire De Connexion
    Wait Until Element Is Visible    ${ESPACE POUR AFFICHER LES ERREURS}    timeout=10s

Verifier Le Retour Du Formulaire Contact Avec Un Email Vide
    Accéder A Une Page Annonce
    Ouvrir Le Formulaire De Contact Hôte
    Remplir Le Formulaire De Contact    ${NOM CONTACT}    ${EMPTY}    ${TELEPHONE CONTACT}    ${MESSAGE CONTACT}
    Soumettre Le Formulaire De Contact
    Vérifier Que Le Message De Retour Est Visible

Verifier Que Le Consentement Est Obligatoire Pour Une Inscription Hote
    Accéder Au Formulaire D'Inscription Hote
    ${required}=    Get Element Attribute    ${CASE CONDITIONS INSCRIPTION}    required
    Should Be Equal As Strings    ${required}    true

Verifier Que Le Profil Est Protege Sans Authentification
    Go To    ${URL APPLICATION}/index.php/profile/
    Wait Until Location Does Not Contain    /profile/    timeout=30s
