
*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   donnees.resource
Suite Setup    Verifier La Configuration Des Secrets

*** Keywords ***
Verifier La Configuration Des Secrets
    Should Not Be Empty    ${API KEY}    La variable d'environnement API_KEY est obligatoire.

*** Test Cases ***
Test Requete GET Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    ${Reponse}=        GET    ${API BASE URL}api/users/${ID UTILISATEUR}    headers=${headers}    expected_status=200
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    data 
    ${utilisateur}=    Get From Dictionary    ${Reponse.json()}    data
    ${first_name}=     Get From Dictionary    ${utilisateur}    first_name
    Should Be Equal As Strings    ${PRENOM ATTENDU}    ${first_name}
    ${last_name}=      Get From Dictionary    ${utilisateur}    last_name
    Should Be Equal As Strings    ${NOM ATTENDU}    ${last_name}
    ${email}=          Get From Dictionary    ${utilisateur}    email
    Should Be Equal As Strings    ${EMAIL ATTENDU}    ${email}

Test Requete GET Liste Utilisateurs
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    ${Reponse}=        GET    ${API BASE URL}api/users    headers=${headers}    expected_status=200
    Dictionary Should Contain Key    ${Reponse.json()}    data
    Dictionary Should Contain Key    ${Reponse.json()}    total
    ${utilisateurs}=   Get From Dictionary    ${Reponse.json()}    data
    Should Not Be Empty    ${utilisateurs}

Test Requete GET Page Deux
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    ${Reponse}=        GET    url=${API BASE URL}api/users?page=2    headers=${headers}    expected_status=200
    ${page}=            Get From Dictionary    ${Reponse.json()}    page
    Should Be Equal As Integers    ${page}    2
    ${utilisateurs}=   Get From Dictionary    ${Reponse.json()}    data
    Should Not Be Empty    ${utilisateurs}

Test Requete GET Utilisateur Inexistant
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    GET    ${API BASE URL}api/users/${ID INEXISTANT}    headers=${headers}    expected_status=404

Test Requete GET Sans Authentification
    GET    ${API BASE URL}api/users/${ID UTILISATEUR}    expected_status=401

Test Requete POST Creation Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=${NOUVEAU PRENOM}    last_name=${NOUVEAU NOM}    email=${NOUVEL EMAIL}
    ${Reponse}=        POST    ${API BASE URL}api/users    json=${Corps_Requete}    headers=${headers}    expected_status=201
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    id
    Dictionary Should Contain Key    ${Reponse.json()}    createdAt

Test Requete POST Sans Champs Obligatoires
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    &{Corps_Requete}=  Create Dictionary
    POST    ${API BASE URL}api/users    json=${Corps_Requete}    headers=${headers}    expected_status=422

Test Requete PUT
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    &{Creation}=       Create Dictionary    first_name=${NOUVEAU PRENOM}    last_name=${NOUVEAU NOM}    email=${NOUVEL EMAIL}
    ${Creation_Reponse}=    POST    ${API BASE URL}api/users    json=${Creation}    headers=${headers}    expected_status=201
    ${id}=              Get From Dictionary    ${Creation_Reponse.json()}    id
    &{Corps_Requete}=  Create Dictionary    first_name=ApiUpdated    last_name=TestUpdated    email=api.updated@testacademy.fr
    ${Reponse}=        PUT    ${API BASE URL}api/users/${id}    json=${Corps_Requete}    headers=${headers}    expected_status=200
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    updatedAt
    ${first_name}=     Get From Dictionary    ${Reponse.json()}    first_name
    Should Be Equal As Strings    ApiUpdated    ${first_name}
    ${last_name}=      Get From Dictionary    ${Reponse.json()}    last_name
    Should Be Equal As Strings    TestUpdated    ${last_name}
    ${email}=          Get From Dictionary    ${Reponse.json()}    email
    Should Be Equal As Strings    api.updated@testacademy.fr    ${email}

Test Requete PUT Utilisateur Inexistant
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=Api    last_name=Missing    email=missing@testacademy.fr
    PUT    ${API BASE URL}api/users/${ID INEXISTANT}    json=${Corps_Requete}    headers=${headers}    expected_status=404

Test Requete PATCH Non Autorisee
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=Api
    PATCH    ${API BASE URL}api/users/${ID UTILISATEUR}    json=${Corps_Requete}    headers=${headers}    expected_status=405

Test Structure Reponse Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API KEY}
    ${Reponse}=        GET    ${API BASE URL}api/users/${ID UTILISATEUR}    headers=${headers}    expected_status=200
    ${utilisateur}=    Get From Dictionary    ${Reponse.json()}    data
    Dictionary Should Contain Key    ${utilisateur}    id
    Dictionary Should Contain Key    ${utilisateur}    email
    Dictionary Should Contain Key    ${utilisateur}    first_name
    Dictionary Should Contain Key    ${utilisateur}    last_name