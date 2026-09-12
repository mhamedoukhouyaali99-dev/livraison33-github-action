*** Settings ***
Library         SeleniumLibrary
Resource        commun.resource
Test Setup      Ouvrir Le Navigateur Et Accéder A L'Application
Test Template   Une Inscription Invalide Doit Conserver Le Formulaire Visible
Test Teardown   Close Browser

*** Test Cases ***
# Cas de test                                      # utilisateur # email          # mot de passe # confirmation # conditions
# Vérifie que l'inscription reste affichée si le nom utilisateur est manquant.
Inscription Sans Nom Utilisateur                   ${EMPTY}      ali@test.fr     Ali123!       Ali123!        TRUE
# Vérifie que l'inscription reste affichée si l'adresse email est manquante.
Inscription Sans Email                             ALI_TEST      ${EMPTY}         Ali123!       Ali123!        TRUE
# Vérifie que l'inscription reste affichée si les mots de passe sont absents.
Inscription Sans Mot De Passe                      ALI_TEST      ali@test.fr     ${EMPTY}       ${EMPTY}       TRUE
# Vérifie que l'inscription refuse deux mots de passe différents.
Inscription Avec Mots De Passe Differents          ALI_TEST      ali@test.fr     Ali123!       Autre123!      TRUE
# Vérifie que l'inscription refuse une soumission sans acceptation des conditions.
Inscription Sans Acceptation Des Conditions        ALI_TEST      ali@test.fr     Ali123!       Ali123!        FALSE

*** Keywords ***
Une Inscription Invalide Doit Conserver Le Formulaire Visible
    [Arguments]    ${nom utilisateur}    ${email}    ${mot de passe}    ${confirmation}    ${conditions}
    Accéder Au Formulaire D'Inscription Hote
    Remplir Le Formulaire D'Inscription Hote    ${nom utilisateur}    ${email}    ${mot de passe}    ${confirmation}    ${conditions}
    Soumettre L'Inscription Hote
    Verifier Que Le Formulaire D'Inscription Reste Visible