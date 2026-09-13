*** Settings ***
Library         SeleniumLibrary
Resource        ../ressources.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Teardown   Close Browser

*** Test Cases ***
# Partition d'equivalence nominale: un compte valide ouvre le tableau de bord.
Connexion Avec Identifiants Valides
    [Tags]    ISTQB    partition-equivalence    nominal
    Verifier La Connexion Avec Des Identifiants Valides

# Partition d'equivalence negative: des identifiants inconnus doivent etre refuses.
Connexion Avec Identifiants Invalides
    [Tags]    ISTQB    partition-equivalence    negatif
    Verifier Le Refus D'Une Connexion Avec Des Identifiants Invalides

# Valeur limite: un champ obligatoire vide ne doit pas permettre une soumission valide.
Formulaire Contact Avec Email Vide
    [Tags]    ISTQB    valeur-limite    negatif
    Verifier Le Retour Du Formulaire Contact Avec Un Email Vide

# Regle fonctionnelle: l'inscription d'un hote exige le consentement aux conditions.
Inscription Hote Avec Consentement Obligatoire
    [Tags]    ISTQB    regle-metier    champ-obligatoire
    Verifier Que Le Consentement Est Obligatoire Pour Une Inscription Hote

# Test d'acces negatif: un visiteur non authentifie ne peut pas consulter son profil.
Acces Profil Sans Authentification
    [Tags]    ISTQB    controle-acces    negatif
    Verifier Que Le Profil Est Protege Sans Authentification
