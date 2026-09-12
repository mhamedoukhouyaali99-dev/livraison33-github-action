*** Settings ***
Library         SeleniumLibrary
Resource        commun.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Teardown   Close Browser

*** Test Cases ***
Modifier Les Informations Personnelles Du Profil
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Remplir Les Informations Personnelles
    Click Button    ${BOUTON ENREGISTRER PROFIL}
    Accéder Au Profil
    La Valeur Du Champ Doit Etre    ${CHAMP PROFIL PRENOM}    ${PROFIL PRENOM}
    La Valeur Du Champ Doit Etre    ${CHAMP PROFIL NOM}    ${PROFIL NOM}
    La Valeur Du Champ Doit Etre    ${CHAMP PROFIL LANGUE NATIVE}    ${PROFIL LANGUE NATIVE}
    La Valeur Du Champ Doit Etre    ${CHAMP PROFIL AUTRE LANGUE}    ${PROFIL AUTRE LANGUE}
    La Valeur Du Champ Doit Etre    ${CHAMP PROFIL BIO}    ${PROFIL BIO}

Modifier L'Adresse Du Profil
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Remplir L'Adresse Du Profil
    Click Button    ${BOUTON ENREGISTRER ADRESSE}
    Accéder Au Profil
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE RUE}    ${PROFIL RUE}
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE APPARTEMENT}    ${PROFIL APPARTEMENT}
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE VILLE}    ${PROFIL VILLE}
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE ETAT}    ${PROFIL ETAT}
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE CODE POSTAL}    ${PROFIL CODE POSTAL}
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE QUARTIER}    ${PROFIL QUARTIER}
    La Valeur Du Champ Doit Etre    ${CHAMP ADRESSE PAYS}    ${PROFIL PAYS}

*** Keywords ***
Remplir Les Informations Personnelles
    Input Text    ${CHAMP PROFIL PRENOM}    ${PROFIL PRENOM}
    Input Text    ${CHAMP PROFIL NOM}    ${PROFIL NOM}
    Input Text    ${CHAMP PROFIL LANGUE NATIVE}    ${PROFIL LANGUE NATIVE}
    Input Text    ${CHAMP PROFIL AUTRE LANGUE}    ${PROFIL AUTRE LANGUE}
    Input Text    ${CHAMP PROFIL BIO}    ${PROFIL BIO}

Remplir L'Adresse Du Profil
    Input Text    ${CHAMP ADRESSE RUE}    ${PROFIL RUE}
    Input Text    ${CHAMP ADRESSE APPARTEMENT}    ${PROFIL APPARTEMENT}
    Input Text    ${CHAMP ADRESSE VILLE}    ${PROFIL VILLE}
    Input Text    ${CHAMP ADRESSE ETAT}    ${PROFIL ETAT}
    Input Text    ${CHAMP ADRESSE CODE POSTAL}    ${PROFIL CODE POSTAL}
    Input Text    ${CHAMP ADRESSE QUARTIER}    ${PROFIL QUARTIER}
    Input Text    ${CHAMP ADRESSE PAYS}    ${PROFIL PAYS}

La Valeur Du Champ Doit Etre
    [Arguments]    ${champ}    ${valeur attendue}
    ${valeur}=    Get Value    ${champ}
    Should Be Equal As Strings    ${valeur}    ${valeur attendue}