*** Settings ***
Library         SeleniumLibrary
Resource        commun.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Template   Soumettre Le Formulaire De Contact Hôte Et Vérifier Le Retour
Test Teardown   Close Browser


*** Test Cases ***
#cas de test                                       #nom      #email               #téléphone      #message
Test Formulaire Contact Avec Toutes Les Données     Jean      jean@test.fr         0600000000      Bonjour, je suis intéressé.
Test Formulaire Contact Sans Nom                     ${EMPTY}    jean@test.fr        0600000000      Bonjour, je suis intéressé.
Test Formulaire Contact Sans Email                   Jean        ${EMPTY}            0600000000      Bonjour, je suis intéressé.
Test Formulaire Contact Sans Message                 Jean        jean@test.fr        0600000000      ${EMPTY}


*** Keywords ***
Soumettre Le Formulaire De Contact Hôte Et Vérifier Le Retour
    [Arguments]    ${nom}    ${email}    ${telephone}    ${message}
    Accéder A Une Page Annonce
    Ouvrir Le Formulaire De Contact Hôte
    Remplir Le Formulaire De Contact    ${nom}    ${email}    ${telephone}    ${message}
    Soumettre Le Formulaire De Contact
    Vérifier Que Le Message De Retour Est Visible
