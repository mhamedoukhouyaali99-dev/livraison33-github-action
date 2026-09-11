*** Settings ***
Library        Selenium2Library
Resource       commun.resource
Test Setup     Ouvrir Le Navigateur Et Acceder A L'Application
Test Teardown  Close Browser

*** Variables ***
${UTILISATEUR CREATION}       test@testt.com
${MOT DE PASSE CREATION}      hmou123
${URL CREATION ANNONCE}       ${URL}/index.php/add-listing/
${URL TABLEAU DE BORD}        ${URL}/index.php/dashboard/
${FORMULAIRE ANNONCE}         id=submit_listing_form
${TITRE ANNONCE}              id=listing_title
${DESCRIPTION ANNONCE}        css=#submit_listing_form iframe
${TYPE ANNONCE}               id=listing_type
${CHAMP CHAMBRES}             id=listing_bedrooms
${CHAMP VOYAGEURS}            id=guests
${CHAMP LITS}                 id=beds
${CHAMP SALLES DE BAIN}       id=baths
${CHAMP PIECES}               id=listing_rooms
${CHAMP SURFACE}              id=listing_size
${CHAMP UNITE SURFACE}        id=listing_size_unit
${CHAMP PRIX NUIT}            xpath=(//input[@id='night_price'])[last()]
${CHAMP FRAIS MENAGE}         name=cleaning_fee
${CHAMP ADRESSE}              id=listing_address
${CHAMP VILLE}                id=city
${CHAMP ETAT}                 id=countyState
${CHAMP CODE POSTAL}          id=zip
${CHAMP QUARTIER}             id=area
${CHAMP PAYS}                 id=homey_country
${BOUTON CONTINUER}           css=.btn-step-next
${BOUTON BROUILLON}           id=save_as_draft
${MESSAGE ERREUR CHAMP}       xpath=//*[contains(normalize-space(.),'Erreur! Veuillez remplir les champs obligatoires.')]

*** Test Cases ***
Acces authentifie au formulaire de creation d'annonce
    Se Connecter Avec Le Compte De Creation
    Go To    ${URL CREATION ANNONCE}
    Wait Until Element Is Visible    ${FORMULAIRE ANNONCE}    15s
    Element Should Be Visible         ${TITRE ANNONCE}

Creation refusee sans titre d'annonce
    Se Connecter Avec Le Compte De Creation
    Go To    ${URL CREATION ANNONCE}
    Wait Until Element Is Visible    ${TITRE ANNONCE}    15s
    Click Element    ${BOUTON CONTINUER}
    Wait Until Element Is Visible    xpath=//*[@id='listing_title']/following::*[contains(@class,'error') or contains(@class,'help-block')][1]    5s

Remplissage des informations sans selection du type
    Se Connecter Avec Le Compte De Creation
    Go To    ${URL CREATION ANNONCE}
    Remplir Les Informations De Base De L'Annonce
    ${titre_saisi}=    Get Value    ${TITRE ANNONCE}
    Should Contain    ${titre_saisi}    Annonce test automatique
    Textfield Value Should Be    ${CHAMP CHAMBRES}      2
    Textfield Value Should Be    ${CHAMP VOYAGEURS}     4
    Textfield Value Should Be    ${CHAMP LITS}          2
    Textfield Value Should Be    ${CHAMP SALLES DE BAIN}  1
    Textfield Value Should Be    ${CHAMP PIECES}        3
    Textfield Value Should Be    ${CHAMP SURFACE}       40
    Textfield Value Should Be    ${CHAMP UNITE SURFACE}  m2
    Click Element                ${BOUTON BROUILLON}
    Wait Until Location Contains  add-listing    5s
    Location Should Contain       add-listing

Test template des champs numeriques de l'annonce
    [Template]    Un Champ D'Annonce Doit Conserver Sa Valeur
    ${CHAMP CHAMBRES}       2
    ${CHAMP VOYAGEURS}      4
    ${CHAMP LITS}           2
    ${CHAMP SALLES DE BAIN}  1
    ${CHAMP PIECES}         3
    ${CHAMP SURFACE}        40
    ${CHAMP UNITE SURFACE}  m2

Test titre annonce accepte une valeur valide
    Preparer Le Formulaire D'Annonce
    Input Text    ${TITRE ANNONCE}    Maison de test
    ${valeur}=    Get Value    ${TITRE ANNONCE}
    Should Contain    ${valeur}    Maison de test

Test description annonce accepte une valeur valide
    Preparer Le Formulaire D'Annonce
    Select Frame    ${DESCRIPTION ANNONCE}
    Input Text    xpath=//body[@id='tinymce']    Description de test du logement.
    ${description}=    Get Element Attribute    xpath=//body[@id='tinymce']    innerHTML
    Unselect Frame
    Should Contain    ${description}    Description de test du logement.

Test champ chambres accepte une valeur numerique
    Preparer Le Formulaire D'Annonce
    Input Text    ${CHAMP CHAMBRES}    3
    Textfield Value Should Be    ${CHAMP CHAMBRES}    3

Test champ voyageurs accepte une valeur numerique
    Preparer Le Formulaire D'Annonce
    Input Text    ${CHAMP VOYAGEURS}    6
    Textfield Value Should Be    ${CHAMP VOYAGEURS}    6

Test surface et unite sont correctement renseignees
    Preparer Le Formulaire D'Annonce
    Input Text    ${CHAMP SURFACE}       75
    Input Text    ${CHAMP UNITE SURFACE}  m2
    Textfield Value Should Be    ${CHAMP SURFACE}       75
    Textfield Value Should Be    ${CHAMP UNITE SURFACE}  m2

Creation avec les informations obligatoires renseignees
    Preparer Le Formulaire D'Annonce
    Click Element    xpath=//label[contains(normalize-space(.),'Logement complet')]
    Remplir Les Informations De Base De L'Annonce
    Verifier Les Informations Obligatoires
    Click Element    ${BOUTON BROUILLON}
    Wait Until Location Contains    add-listing    5s

Creation refusee avec le titre obligatoire vide
    Preparer Le Formulaire D'Annonce
    Input Text    ${CHAMP CHAMBRES}       2
    Input Text    ${CHAMP VOYAGEURS}      4
    Input Text    ${CHAMP LITS}           2
    Input Text    ${CHAMP SALLES DE BAIN}  1
    Input Text    ${CHAMP PIECES}         3
    Input Text    ${CHAMP SURFACE}        40
    Input Text    ${CHAMP UNITE SURFACE}  m2
    Click Element    ${BOUTON CONTINUER}
    Verifier Un Message D'Erreur De Champ Obligatoire

Creation refusee avec le nombre de chambres vide
    Preparer Le Formulaire D'Annonce
    Input Text    ${TITRE ANNONCE}        Annonce valide
    Input Text    ${CHAMP VOYAGEURS}      4
    Input Text    ${CHAMP LITS}           2
    Input Text    ${CHAMP SALLES DE BAIN}  1
    Input Text    ${CHAMP PIECES}         3
    Input Text    ${CHAMP SURFACE}        40
    Input Text    ${CHAMP UNITE SURFACE}  m2
    Click Element    ${BOUTON CONTINUER}
    Verifier Un Message D'Erreur De Champ Obligatoire

*** Keywords ***
Ouvrir Le Navigateur Et Acceder A L'Application
    Open Browser    ${URL}    ${NAVIGATEUR}
    Maximize Browser Window

Preparer Le Formulaire D'Annonce
    Se Connecter Avec Le Compte De Creation
    Go To    ${URL CREATION ANNONCE}
    Wait Until Element Is Visible    ${TITRE ANNONCE}    20s
    Wait Until Element Is Visible    ${FORMULAIRE ANNONCE}    20s

Se Connecter Avec Le Compte De Creation
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    15s
    Click Element    ${LIEN SE CONNECTER}
    Wait Until Element Is Visible    ${CHAMP UTILISATEUR}    10s
    Input Text        ${CHAMP UTILISATEUR}       ${UTILISATEUR CREATION}
    Input Password    ${CHAMP DE MOT DE PASSE}  ${MOT DE PASSE CREATION}
    Click Button      ${BOUTON SE CONNECTER}
    Wait Until Location Contains    dashboard    15s

Remplir Les Informations De Base De L'Annonce
    Wait Until Element Is Visible    ${FORMULAIRE ANNONCE}    15s
    Input Text       ${TITRE ANNONCE}       Annonce test automatique
    Select Frame     ${DESCRIPTION ANNONCE}
    Input Text       xpath=//body[@id='tinymce']    Logement cree par le test automatique.
    Unselect Frame
    Input Text       ${CHAMP CHAMBRES}      2
    Input Text       ${CHAMP VOYAGEURS}     4
    Input Text       ${CHAMP LITS}          2
    Input Text       ${CHAMP SALLES DE BAIN}  1
    Input Text       ${CHAMP PIECES}        3
    Input Text       ${CHAMP SURFACE}       40
    Input Text       ${CHAMP UNITE SURFACE}  m2

Verifier Les Informations Obligatoires
    ${titre_saisi}=    Get Value    ${TITRE ANNONCE}
    Should Contain    ${titre_saisi}    Annonce test automatique
    Textfield Value Should Be    ${CHAMP CHAMBRES}         2
    Textfield Value Should Be    ${CHAMP VOYAGEURS}        4
    Textfield Value Should Be    ${CHAMP LITS}             2
    Textfield Value Should Be    ${CHAMP SALLES DE BAIN}   1
    Textfield Value Should Be    ${CHAMP PIECES}           3
    Textfield Value Should Be    ${CHAMP SURFACE}          40
    Textfield Value Should Be    ${CHAMP UNITE SURFACE}    m2

Verifier Un Message D'Erreur De Champ Obligatoire
    Wait Until Element Is Visible    ${MESSAGE ERREUR CHAMP}    5s
    Element Should Be Visible         ${MESSAGE ERREUR CHAMP}

Un Champ D'Annonce Doit Conserver Sa Valeur
    [Arguments]    ${locator}    ${valeur}
    Se Connecter Avec Le Compte De Creation
    Go To    ${URL CREATION ANNONCE}
    Wait Until Element Is Visible    ${FORMULAIRE ANNONCE}    15s
    Wait Until Element Is Visible    ${locator}    10s
    Input Text    ${locator}    ${valeur}
    Textfield Value Should Be    ${locator}    ${valeur}
