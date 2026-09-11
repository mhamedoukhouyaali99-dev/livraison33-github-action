*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${Base_URL}           https://mock-api-h0g7.onrender.com/
${API_KEY}            Cle-API-ReqRes-test-academy
${Id_Utilisateur}     2
${FirstName_Attendu}  Janet
${LastName_Attendu}   Weaver
${Email_Attendu}      janet.weaver@api.testacademy.fr

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
    Should Match Regexp    ${last_name}    ^(Weaver|Zion-Weaver)$
    ${email}=          Get From Dictionary    ${utilisateur}    email
    Should Match Regexp    ${email}    ^janet\.(weaver|zion)@api\.testacademy\.fr$

Test Requete POST Creation Utilisateur
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=${FirstName_Attendu}    last_name=${LastName_Attendu}    email=${Email_Attendu}
    ${Reponse}=        POST    ${Base_URL}api/users    json=${Corps_Requete}    headers=${headers}    expected_status=201
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    id
    Dictionary Should Contain Key    ${Reponse.json()}    createdAt

Test Requete PUT
    &{headers}=        Create Dictionary    Authorization=Bearer ${API_KEY}
    &{Corps_Requete}=  Create Dictionary    first_name=${FirstName_Attendu}    last_name=${LastName_Attendu}    email=${Email_Attendu}
    ${Reponse}=        PUT    ${Base_URL}api/users/${Id_Utilisateur}    json=${Corps_Requete}    headers=${headers}    expected_status=200
    Log                ${Reponse.json()}
    Dictionary Should Contain Key    ${Reponse.json()}    updatedAt
    ${first_name}=     Get From Dictionary    ${Reponse.json()}    first_name
    Should Be Equal As Strings    ${FirstName_Attendu}    ${first_name}
    ${last_name}=      Get From Dictionary    ${Reponse.json()}    last_name
    Should Be Equal As Strings    ${LastName_Attendu}    ${last_name}
    ${email}=          Get From Dictionary    ${Reponse.json()}    email
    Should Be Equal As Strings    ${Email_Attendu}    ${email}