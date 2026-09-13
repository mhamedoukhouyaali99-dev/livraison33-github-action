*** Settings ***
Library         SeleniumLibrary
Resource        commun.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Teardown   Close Browser

*** Test Cases ***
# Partition d'equivalence nominale: un compte valide ouvre le tableau de bord.
Connexion Avec Identifiants Valides
    [Tags]    ISTQB    partition-equivalence    nominal
    Se Connecter Avec Le Compte Valide
    Title Should Be    ${TITRE TABLEAU DE BORD}

# Partition d'equivalence negative: des identifiants inconnus doivent etre refuses.
Connexion Avec Identifiants Invalides
    [Tags]    ISTQB    partition-equivalence    negatif
    Accéder A La Page De Connexion
    Saisir Le Nom D'Utilisateur    utilisateur-inconnu
    Saisir Le Mot De Passe         mot-de-passe-invalide
    Soumette Le Formulaire De Connexion
    Wait Until Element Is Visible    ${ESPACE POUR AFFICHER LES ERREURS}    timeout=10s

# Valeur limite: un champ obligatoire vide ne doit pas permettre une soumission valide.
Formulaire Contact Avec Email Vide
    [Tags]    ISTQB    valeur-limite    negatif
    Accéder A Une Page Annonce
    Ouvrir Le Formulaire De Contact Hôte
    Remplir Le Formulaire De Contact    ${NOM CONTACT}    ${EMPTY}    ${TELEPHONE CONTACT}    ${MESSAGE CONTACT}
    Soumettre Le Formulaire De Contact
    Vérifier Que Le Message De Retour Est Visible

# Regle fonctionnelle: l'inscription d'un hote exige le consentement aux conditions.
Inscription Hote Avec Consentement Obligatoire
    [Tags]    ISTQB    regle-metier    champ-obligatoire
    Accéder Au Formulaire D'Inscription Hote
    ${required}=    Get Element Attribute    ${CASE CONDITIONS INSCRIPTION}    required
    Should Be Equal As Strings    ${required}    true

# Test d'acces negatif: un visiteur non authentifie ne peut pas consulter son profil.
Acces Profil Sans Authentification
    [Tags]    ISTQB    controle-acces    negatif
    Go To    ${URL APPLICATION}/index.php/profile/
    Wait Until Location Does Not Contain    /profile/    timeout=30s
