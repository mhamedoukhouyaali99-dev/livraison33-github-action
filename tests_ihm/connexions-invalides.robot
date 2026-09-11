*** Settings ***
Library        Selenium2Library
Resource       commun.resource
Test Setup     Ouvrir Le Navigateur Et Accéder A L'Application
Test Template  Un Message d'Erreur Doit Etre Visible Apres Une Connexion Incorrecte
Test Teardown  Close Browser



*** Test Cases ***
#cas de test                                            #nom d'utilisateur    #mot de passe
Test Utilisateur Valide Mot De Passe Vide                robot                 ${EMPTY}        
Test Utilisateur Vide Mot De Passe Valide                ${EMPTY}              robot
Test Utilisateur Vide Mot De Passe Vide                  ${EMPTY}              ${EMPTY} 
Test Utilisateur Non Valide Mot De Passe Valide          azerty                robot
Test Utilisateur Valide Mot De Passe Non Valide          robot                 azerty
Test Utilisateur Non Valide Mot De Passe Non Valide      azerty                azerty
Test Utilisateur Vide Mot De Passe Non Valide            ${EMPTY}              azerty
Test Utilisateur Non valide Mot De Passe Vide            azerty                ${EMPTY}


*** Keywords ***

Vérifier Que Le Message d'Erreur Est Visible
   Wait Until Element Is Visible      ${ESPACE POUR AFFICHER LES ERREURS}
   #Element Text Should Be            ${ESPACE POUR AFFICHER LES ERREURS}    Invalid username or email
   #Element Text Should Be            ${ESPACE POUR AFFICHER LES ERREURS}    The password you entered for the username robot is incorrect.
      

Un Message d'Erreur Doit Etre Visible Apres Une Connexion Incorrecte
    [Arguments]       ${nom utilisateur}      ${mot de passe}
   
    Accéder A La Page De Connexion
    Saisir Le Nom D'Utilisateur      ${nom utilisateur}
    Saisir Le Mot De Passe         ${mot de passe}    
    Soumette Le Formulaire De Connexion
    Vérifier Que Le Message d'Erreur Est Visible