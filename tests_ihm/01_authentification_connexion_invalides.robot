*** Settings ***
Library        SeleniumLibrary
Resource       ../ressources.resource
Test Setup     Ouvrir Le Navigateur Et Accéder A L'Application
Test Template  Un Message d'Erreur Doit Etre Visible Apres Une Connexion Incorrecte
Test Teardown  Close Browser



*** Test Cases ***
#cas de test                                            #nom d'utilisateur    #mot de passe
# Vérifie qu'un mot de passe vide est refusé même avec un utilisateur valide.
Test Utilisateur Valide Mot De Passe Vide                robot                 ${EMPTY}        
# Vérifie qu'un utilisateur vide est refusé même avec un mot de passe valide.
Test Utilisateur Vide Mot De Passe Valide                ${EMPTY}              robot
# Vérifie que le formulaire refuse l'absence des deux identifiants.
Test Utilisateur Vide Mot De Passe Vide                  ${EMPTY}              ${EMPTY} 
# Vérifie qu'un nom d'utilisateur inconnu est refusé avec un mot de passe valide.
Test Utilisateur Non Valide Mot De Passe Valide          azerty                robot
# Vérifie qu'un mot de passe incorrect est refusé avec un utilisateur valide.
Test Utilisateur Valide Mot De Passe Non Valide          robot                 azerty
# Vérifie que deux identifiants incorrects produisent une erreur.
Test Utilisateur Non Valide Mot De Passe Non Valide      azerty                azerty
# Vérifie qu'un mot de passe incorrect reste refusé sans nom utilisateur.
Test Utilisateur Vide Mot De Passe Non Valide            ${EMPTY}              azerty
# Vérifie qu'un utilisateur inconnu reste refusé sans mot de passe.
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