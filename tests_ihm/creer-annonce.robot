*** Settings ***
Library         SeleniumLibrary
Resource        commun.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Teardown   Close Browser

*** Test Cases ***
Acceder Au Formulaire De Creation D Annonce
    Acceder Au Formulaire De Creation D Annonce
    Page Should Contain Element    ${FORMULAIRE CREATION ANNONCE}

Verifier Les Champs Obligatoires De Creation
    Acceder Au Formulaire De Creation D Annonce
    Verifier Les Champs Creation Annonce
    ...    ${CHAMP TITRE ANNONCE}
    ...    ${CHAMP DESCRIPTION ANNONCE}
    ...    ${CONTROLE TYPE ANNONCE}
    ...    ${CHAMP CHAMBRES ANNONCE}
    ...    ${CHAMP VOYAGEURS ANNONCE}
    ...    ${CHAMP LITS ANNONCE}
    ...    ${BOUTON BROUILLON ANNONCE}
    ...    ${BOUTON CONTINUER ANNONCE}

Verifier Les Champs Numeriques De Creation
    Acceder Au Formulaire De Creation D Annonce
    Element Attribute Value Should Be    ${CHAMP CHAMBRES ANNONCE}    type    text
    Element Attribute Value Should Be    ${CHAMP VOYAGEURS ANNONCE}    type    text
    Element Attribute Value Should Be    ${CHAMP LITS ANNONCE}    type    text
    Element Attribute Value Should Be    ${CHAMP SALLES DE BAIN ANNONCE}    type    text
    Element Attribute Value Should Be    ${CHAMP PIECES ANNONCE}    type    text
    Element Attribute Value Should Be    ${CHAMP SURFACE ANNONCE}    type    text
    Element Attribute Value Should Be    ${CHAMP PRIX NUIT ANNONCE}    type    text

Saisir Les Informations De Logement
    Acceder Au Formulaire De Creation D Annonce
    Remplir Les Informations Minimales De L Annonce
    Verifier Les Valeurs Des Informations De L Annonce

Les Controles De Sauvegarde Sont Disponibles
    Acceder Au Formulaire De Creation D Annonce
    Element Should Be Enabled    ${BOUTON BROUILLON ANNONCE}
    Element Should Be Enabled    ${BOUTON CONTINUER ANNONCE}