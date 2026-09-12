*** Settings ***
Library         SeleniumLibrary
Resource        commun.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Teardown   Close Browser

*** Test Cases ***
Les Champs D'Inscription Sont Uniques Et Accessibles
    Accéder Au Formulaire D'Inscription Hote
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP NOM INSCRIPTION}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP EMAIL INSCRIPTION}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP MOT DE PASSE INSCRIPTION}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP CONFIRMATION INSCRIPTION}
    Element Should Be Visible    ${CHAMP NOM INSCRIPTION}
    Element Should Be Visible    ${CHAMP EMAIL INSCRIPTION}
    Element Should Be Visible    ${CHAMP MOT DE PASSE INSCRIPTION}
    Element Should Be Visible    ${CHAMP CONFIRMATION INSCRIPTION}

Le Consentement Est Un Champ Obligatoire
    Accéder Au Formulaire D'Inscription Hote
    Le Locator Doit Pointer Vers Un Seul Element    ${CASE CONDITIONS INSCRIPTION}
    ${required}=    Get Element Attribute    ${CASE CONDITIONS INSCRIPTION}    required
    Should Be Equal As Strings    ${required}    true

Les Champs De Contact Ont Les Types Attendus
    Accéder A Une Page Annonce
    Ouvrir Le Formulaire De Contact Hôte
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP NOM CONTACT}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP EMAIL CONTACT}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP TELEPHONE CONTACT}
    Le Locator Doit Pointer Vers Un Seul Element    ${CHAMP MESSAGE CONTACT}
    ${type email}=    Get Element Attribute    ${CHAMP EMAIL CONTACT}    type
    Should Be Equal As Strings    ${type email}    email

*** Keywords ***
Le Locator Doit Pointer Vers Un Seul Element
    [Arguments]    ${locator}
    ${nombre}=    Get Element Count    ${locator}
    Should Be Equal As Integers    ${nombre}    1