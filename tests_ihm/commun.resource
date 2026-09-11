*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem




*** Variables ***
# --- Configuration de base ---
${URL}            http://livraison3.testacademy.fr
${NAVIGATEUR}      chrome

# --- Locators Connexion (Existants) ---
${LIEN SE CONNECTER}     xpath=//a[contains(text(),'Se connecter')]
${CHAMP UTILISATEUR}    name=username
${CHAMP DE MOT DE PASSE}    name=password
${UTILISATEUR VALIDE}      test 
${MOT DE PASSE VALIDE}     test
${BOUTON SE CONNECTER}     css=.homey_login_button
${TITRE PAGE TABLEAU DE BORD}    Tableau de bord - Livraison 3
${LIEN SE DECONECTER}         xpath=(//a[contains(text(),'Se déconnecter')])[3]
${UTILISATEUR NON VALIDE}     nonvalide
${MOT DE PASSE NON VALIDE}     nonvalide
${ESPACE POUR AFFICHER LES ERREURS}  css=#modal-login .error

# --- NOUVEAUX LOCATORS & VARIABLES (Feature Contacter Hôte) ---
# URL directe vers l'annonce "Beautiful Cove" identifiée dans le fichier HTML
${URL ANNONCE}    http://livraison3.testacademy.fr/index.php/listing/beautiful-cove/

# Bouton dans la sidebar droite (version desktop)
${BOUTON CONTACTER HOTE SIDEBAR}    xpath=//div[@class='sidebar-booking-module-footer']//button[contains(text(), "Contactez l'hôte")]

# Champs du formulaire modal "Contactez l'hôte"
${MODAL CONTACT HOTE}       css=#modal-contact-host
${CHAMP NOM CONTACT}        name=name
${CHAMP EMAIL CONTACT}      name=email
${CHAMP TELEPHONE CONTACT}  name=phone
${CHAMP MESSAGE CONTACT}    name=message
${BOUTON SOUMETTRE CONTACT}    css=.contact_listing_host

# Zone d'affichage des messages de succès ou d'erreur dans la modale
${MESSAGE RESULTAT CONTACT}    css=.homey_contact_messages


*** Keywords ***
# --- Keywords Généraux ---
Ouvrir Le Navigateur Et Accéder A L'Application
    ${chrome binary}=    Get Environment Variable    CHROME_BIN    ${EMPTY}
    Run Keyword If    "${chrome binary}" == "${EMPTY}"
    ...    Open Browser    ${URL}    ${NAVIGATEUR}    options=add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-blink-features=AutomationControlled");add_argument("--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36");add_argument("--window-size=1920,1080")
    ...    ELSE
    ...    Open Browser    ${URL}    ${NAVIGATEUR}    options=binary_location="${chrome binary}";add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-blink-features=AutomationControlled");add_argument("--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36");add_argument("--window-size=1920,1080")
    Set Window Size    1920    1080
    ${location}=    Get Location
    ${title}=    Get Title
    ${body}=    Get Text    xpath=//body
    ${body preview}=    Evaluate    $body[:500]
    Log To Console    URL finale: ${location}
    Log To Console    Titre: ${title}
    Log To Console    Apercu body: ${body preview}

# --- Keywords Connexion (Existants) ---
Accéder A La Page De Connexion
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    timeout=30s
    Click Element    ${LIEN SE CONNECTER}

Saisir Le Nom D'Utilisateur
    [Arguments]      ${nom utilisateur}
    Wait Until Element Is Visible    ${CHAMP UTILISATEUR}    timeout=10s
    Click Element    ${CHAMP UTILISATEUR}
    Input Text       ${CHAMP UTILISATEUR}    ${nom utilisateur}

Saisir Le Mot De Passe
    [Arguments]      ${mot de passe}
    Input Password   ${CHAMP DE MOT DE PASSE}    ${mot de passe}

Soumette Le Formulaire De Connexion
   Click Button     ${BOUTON SE CONNECTER}

# --- NOUVEAUX KEYWORDS (Feature Contacter Hôte) ---
Accéder A Une Page Annonce
    Go To    ${URL ANNONCE}
    Wait Until Element Is Visible    ${BOUTON CONTACTER HOTE SIDEBAR}    timeout=30s

Ouvrir Le Formulaire De Contact Hôte
    Click Element    ${BOUTON CONTACTER HOTE SIDEBAR}
    Wait Until Element Is Visible    ${MODAL CONTACT HOTE}    timeout=30s
    Wait Until Element Is Visible    ${CHAMP NOM CONTACT}    timeout=30s

Remplir Le Formulaire De Contact
    [Arguments]    ${nom}    ${email}    ${telephone}    ${message}
    # CORRECTION ICI : Utilisation de guillemets doubles "..." pour gérer les apostrophes dans le texte
    Run Keyword If    "${nom}" != "${EMPTY}"          Input Text    ${CHAMP NOM CONTACT}    ${nom}
    Run Keyword If    "${email}" != "${EMPTY}"        Input Text    ${CHAMP EMAIL CONTACT}    ${email}
    Run Keyword If    "${telephone}" != "${EMPTY}"    Input Text    ${CHAMP TELEPHONE CONTACT}    ${telephone}
    Run Keyword If    "${message}" != "${EMPTY}"      Input Text    ${CHAMP MESSAGE CONTACT}    ${message}

Soumettre Le Formulaire De Contact
    Click Button    ${BOUTON SOUMETTRE CONTACT}

Vérifier Que Le Message De Retour Est Visible
    # Vérifie que la div de message (succès ou erreur) s'affiche après soumission
    Wait Until Element Is Visible    ${MESSAGE RESULTAT CONTACT}    timeout=5s