*** Settings ***
Library     SeleniumLibrary
Resource    commun.resource
Metadata    Title     RobotframeworkGHIZLANEELAZKALANIReport

*** Test Cases ***
Le Tableau De Bord Doit Etre Visible Apres Une Connexion Réussie
    [Setup]       Effectuer Une Connection Réussie
    Vérifier Que Le Tableau De Bord Est Visible
    [Teardown]    Effectuer Une Déconnexion Réussie

Le Lien De Connexion Devrait Etre Visible Après Une Déconnexion Réussie
    [Setup]    Effectuer Une Connection Réussie
    Vérifier Que Le Tableau De Bord Est Visible
    Effectuer Une Déconnexion Réussie
    Vérifier Que Le Lien De Connexion Est Visible


*** Keywords ***
Effectuer Une Connection Réussie
    Ouvrir Le Navigateur Et Accéder A L'Application
    Accéder A La Page De Connexion
    Saisir Le Nom D'Utilisateur    ${UTILISATEUR VALIDE}
    Saisir Le Mot De Passe         ${MOT DE PASSE VALIDE}
    Soumette Le Formulaire De Connexion

Vérifier Que Le Tableau De Bord Est Visible
    Wait Until Element Is Not Visible    ${CHAMP UTILISATEUR}    timeout=10s
    Title Should Be    ${TITRE PAGE TABLEAU DE BORD}

Effectuer Une Déconnexion Réussie
    Click Link    ${LIEN SE DECONECTER}
    Wait Until Element Is Not Visible    ${LIEN SE DECONECTER}    timeout=10s

Vérifier Que Le Lien De Connexion Est Visible
    Element Should Be Visible    ${LIEN SE CONNECTER}