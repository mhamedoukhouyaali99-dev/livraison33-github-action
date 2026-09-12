*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${Base_URL}           https://mock-api-h0g7.onrender.com/
${API_KEY}            Cle-API-ReqRes-test-academy
${Id_Utilisateur}     1
${FirstName_Attendu}  George
${LastName_Attendu}   Bluth
${Email_Attendu}      george.bluth@api.testacademy.fr
${FirstName_Nouveau}  Api
${LastName_Nouveau}   Test
${Email_Nouveau}      api.test.${Id_Utilisateur}@testacademy.fr

*** Test Cases ***
Test Requete GET Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    ${Reponse}=        GET    ${Base_URL}api/users/${Id_Utilisateur}    headers=${headers}    expected_status=200
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    data 
    ${utilisateur}=    Get From Dictionary    ${Reponse.json()}    data
    ${first_name}=     Get From Dictionary    ${utilisateur}    first_name
    Should Be Equal As Strings    ${FirstName_Attendu}    ${first_name}
    ${last_name}=      Get From Dictionary    ${utilisateur}    last_name
    Should Be Equal As Strings    ${LastName_Attendu}    ${last_name}
    ${email}=          Get From Dictionary    ${utilisateur}    email
    Should Be Equal As Strings    ${Email_Attendu}    ${email}

Test Requete GET Liste Utilisateurs
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    ${Reponse}=        GET    ${Base_URL}api/users    headers=${headers}    expected_status=200
    Dictionary Should Contain Key    ${Reponse.json()}    data
    Dictionary Should Contain Key    ${Reponse.json()}    total
    ${utilisateurs}=   Get From Dictionary    ${Reponse.json()}    data
    Should Not Be Empty    ${utilisateurs}

Test Requete GET Page Deux
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    ${Reponse}=        GET    url=${Base_URL}api/users?page=2    headers=${headers}    expected_status=200
    ${page}=            Get From Dictionary    ${Reponse.json()}    page
    Should Be Equal As Integers    ${page}    2
    ${utilisateurs}=   Get From Dictionary    ${Reponse.json()}    data
    Should Not Be Empty    ${utilisateurs}

Test Requete GET Utilisateur Inexistant
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    GET    ${Base_URL}api/users/999999    headers=${headers}    expected_status=404

Test Requete GET Sans Authentification
    GET    ${Base_URL}api/users/${Id_Utilisateur}    expected_status=401

Test Requete POST Creation Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=${FirstName_Nouveau}    last_name=${LastName_Nouveau}    email=${Email_Nouveau}
    ${Reponse}=        POST    ${Base_URL}api/users    json=${Corps_Requete}    headers=${headers}    expected_status=201
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    id
    Dictionary Should Contain Key    ${Reponse.json()}    createdAt

Test Requete POST Sans Champs Obligatoires
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Corps_Requete}=  Create Dictionary
    POST    ${Base_URL}api/users    json=${Corps_Requete}    headers=${headers}    expected_status=422

Test Requete PUT
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Creation}=       Create Dictionary    first_name=${FirstName_Nouveau}    last_name=${LastName_Nouveau}    email=${Email_Nouveau}
    ${Creation_Reponse}=    POST    ${Base_URL}api/users    json=${Creation}    headers=${headers}    expected_status=201
    ${id}=              Get From Dictionary    ${Creation_Reponse.json()}    id
    &{Corps_Requete}=  Create Dictionary    first_name=ApiUpdated    last_name=TestUpdated    email=api.updated@testacademy.fr
    ${Reponse}=        PUT    ${Base_URL}api/users/${id}    json=${Corps_Requete}    headers=${headers}    expected_status=200
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    updatedAt
    ${first_name}=     Get From Dictionary    ${Reponse.json()}    first_name
    Should Be Equal As Strings    ApiUpdated    ${first_name}
    ${last_name}=      Get From Dictionary    ${Reponse.json()}    last_name
    Should Be Equal As Strings    TestUpdated    ${last_name}
    ${email}=          Get From Dictionary    ${Reponse.json()}    email
    Should Be Equal As Strings    api.updated@testacademy.fr    ${email}

Test Requete PUT Utilisateur Inexistant
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=Api    last_name=Missing    email=missing@testacademy.fr
    PUT    ${Base_URL}api/users/999999    json=${Corps_Requete}    headers=${headers}    expected_status=404

Test Requete PATCH Non Autorisee
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=Api
    PATCH    ${Base_URL}api/users/${Id_Utilisateur}    json=${Corps_Requete}    headers=${headers}    expected_status=405

Test Structure Reponse Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    ${Reponse}=        GET    ${Base_URL}api/users/${Id_Utilisateur}    headers=${headers}    expected_status=200
    ${utilisateur}=    Get From Dictionary    ${Reponse.json()}    data
    Dictionary Should Contain Key    ${utilisateur}    id
    Dictionary Should Contain Key    ${utilisateur}    email
    Dictionary Should Contain Key    ${utilisateur}    first_name
    Dictionary Should Contain Key    ${utilisateur}    last_name