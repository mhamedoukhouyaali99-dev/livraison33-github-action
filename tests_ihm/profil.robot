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

La Page Profil Est Accessible Apres Connexion
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Page Should Contain Element    ${PAGE PROFIL}

Les Champs Personnels Sont Visibles Et Uniques
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP PROFIL PRENOM}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP PROFIL NOM}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP PROFIL BIO}
    Element Should Be Visible    ${CHAMP PROFIL PRENOM}
    Element Should Be Visible    ${CHAMP PROFIL NOM}
    Element Should Be Visible    ${CHAMP PROFIL BIO}

Les Champs Adresse Sont Visibles Et Uniques
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP ADRESSE RUE}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP ADRESSE VILLE}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP ADRESSE CODE POSTAL}
    Element Should Be Visible    ${CHAMP ADRESSE RUE}
    Element Should Be Visible    ${CHAMP ADRESSE VILLE}
    Element Should Be Visible    ${CHAMP ADRESSE CODE POSTAL}

Les Boutons D'Enregistrement Du Profil Sont Disponibles
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    ${nombre}=    Get Element Count    css=button.homey_profile_save
    Should Be Equal As Integers    ${nombre}    4

Le Contact D'Urgence Est Disponible
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Element Should Be Visible    ${CHAMP CONTACT URGENCE NOM}
    Element Should Be Visible    ${CHAMP CONTACT URGENCE LIEN}
    Element Should Be Visible    ${CHAMP CONTACT URGENCE EMAIL}
    Element Should Be Visible    ${CHAMP CONTACT URGENCE TELEPHONE}

Enregistrer Un Contact D'Urgence
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Input Text    ${CHAMP CONTACT URGENCE NOM}    Contact Test
    Input Text    ${CHAMP CONTACT URGENCE LIEN}    Ami
    Input Text    ${CHAMP CONTACT URGENCE EMAIL}    contact.test@testacademy.fr
    Input Text    ${CHAMP CONTACT URGENCE TELEPHONE}    0600000000
    Scroll Element Into View    ${BOUTON ENREGISTRER CONTACT}
    Click Button    ${BOUTON ENREGISTRER CONTACT}
    Accéder Au Profil
    La Valeur Du Champ Doit Etre    ${CHAMP CONTACT URGENCE NOM}    Contact Test
    La Valeur Du Champ Doit Etre    ${CHAMP CONTACT URGENCE EMAIL}    contact.test@testacademy.fr

Le Lien Du Profil Public Est Disponible
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Le Locator Doit Pointer Vers Un Seul Element    ${LIEN VOIR PROFIL}
    ${href}=    Get Element Attribute    ${LIEN VOIR PROFIL}    href
    Should Contain    ${href}    /author/

Ouvrir Puis Annuler La Suppression Du Compte
    Se Connecter Avec Le Compte Valide
    Accéder Au Profil
    Click Button    ${BOUTON SUPPRIMER COMPTE}
    Wait Until Element Is Visible    ${ALERTE SUPPRESSION COMPTE}    timeout=10s
    Click Button    ${BOUTON ANNULER SUPPRESSION}
    Wait Until Element Is Not Visible    ${ALERTE SUPPRESSION COMPTE}    timeout=10s

Le Profil Demande Une Session Authentifiee
    Go To    ${URL APPLICATION}/index.php/profile/
    Wait Until Location Does Not Contain    /profile/    timeout=30s

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

Le Locator Doit Pointer Vers Un Seul Element
    [Arguments]    ${locator}
    ${nombre}=    Get Element Count    ${locator}
    Should Be Equal As Integers    ${nombre}    1