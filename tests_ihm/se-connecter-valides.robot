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
    Wait Until Title Is    ${TITRE PAGE TABLEAU DE BORD}    timeout=30s

Effectuer Une Déconnexion Réussie
    ${clique}=    Execute Javascript    var liens = Array.from(document.querySelectorAll('a')); var lien = liens.find(function(element) { return element.textContent.includes('Se déconnecter') && element.offsetParent !== null; }); if (!lien) { return false; } lien.click(); return true;
    Should Be True    ${clique}
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    timeout=30s

Vérifier Que Le Lien De Connexion Est Visible
    Element Should Be Visible    ${LIEN SE CONNECTER}