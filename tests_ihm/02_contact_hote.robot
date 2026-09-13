*** Settings ***
Library         SeleniumLibrary
Resource        ../ressources.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Template   Soumettre Le Formulaire De Contact Hôte Et Vérifier Le Retour
Test Teardown   Close Browser


*** Test Cases ***
#cas de test                                       #nom      #email               #téléphone      #message
# Vérifie qu'un hôte peut envoyer un message complet et obtenir un retour de l'application.
Test Formulaire Contact Avec Toutes Les Données     ${NOM CONTACT}      ${EMAIL CONTACT}      ${TELEPHONE CONTACT}      ${MESSAGE CONTACT}
# Vérifie que le formulaire réagit correctement lorsque le nom du contact est absent.
Test Formulaire Contact Sans Nom                    ${EMPTY}            ${EMAIL CONTACT}      ${TELEPHONE CONTACT}      ${MESSAGE CONTACT}
# Vérifie que le formulaire réagit correctement lorsque l'email du contact est absent.
Test Formulaire Contact Sans Email                  ${NOM CONTACT}      ${EMPTY}               ${TELEPHONE CONTACT}      ${MESSAGE CONTACT}
# Vérifie que le formulaire réagit correctement lorsque le message est absent.
Test Formulaire Contact Sans Message                ${NOM CONTACT}      ${EMAIL CONTACT}      ${TELEPHONE CONTACT}      ${EMPTY}


*** Keywords ***
Soumettre Le Formulaire De Contact Hôte Et Vérifier Le Retour
    [Arguments]    ${nom}    ${email}    ${telephone}    ${message}
    Accéder A Une Page Annonce
    Ouvrir Le Formulaire De Contact Hôte
    Remplir Le Formulaire De Contact    ${nom}    ${email}    ${telephone}    ${message}
    Soumettre Le Formulaire De Contact
    Vérifier Que Le Message De Retour Est Visible
