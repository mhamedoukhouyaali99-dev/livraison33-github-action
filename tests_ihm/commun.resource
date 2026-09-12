*** Settings ***
Library     SeleniumLibrary
Resource    donnees.resource




*** Variables ***
# --- Locators Connexion (Existants) ---
${LIEN SE CONNECTER}     css=a[data-target="#modal-login"]
${MODAL CONNEXION}      css=#modal-login
${CHAMP UTILISATEUR}    css=#modal-login input[name="username"]
${CHAMP DE MOT DE PASSE}    css=#modal-login input[name="password"]
${BOUTON SE CONNECTER}     css=#modal-login button.homey_login_button
${LIEN SE DECONECTER}         xpath=//a[contains(normalize-space(.),'Se déconnecter')]
${ESPACE POUR AFFICHER LES ERREURS}  css=#modal-login .error

# --- NOUVEAUX LOCATORS & VARIABLES (Feature Contacter Hôte) ---
# Bouton dans la sidebar droite (version desktop)
${BOUTON CONTACTER HOTE SIDEBAR}    css=button[data-target="#modal-contact-host"]

# Champs du formulaire modal "Contactez l'hôte"
${MODAL CONTACT HOTE}       css=#modal-contact-host
${CHAMP NOM CONTACT}        css=#modal-contact-host input[name="name"]
${CHAMP EMAIL CONTACT}      css=#modal-contact-host input[name="email"]
${CHAMP TELEPHONE CONTACT}  css=#modal-contact-host input[name="phone"]
${CHAMP MESSAGE CONTACT}    css=#modal-contact-host textarea[name="message"]
${BOUTON SOUMETTRE CONTACT}    css=#modal-contact-host button.contact_listing_host

# Zone d'affichage des messages de succès ou d'erreur dans la modale
${MESSAGE RESULTAT CONTACT}    css=.homey_contact_messages

# --- Locators Inscription Hote ---
${LIEN DEVENIR HOTE}          css=a.btn-add-new-listing
${FORMULAIRE INSCRIPTION}     css=.register_module_wrap form
${CHAMP NOM INSCRIPTION}      css=.register_module_wrap input[name="username"]
${CHAMP EMAIL INSCRIPTION}    css=.register_module_wrap input[name="useremail"]
${CHAMP MOT DE PASSE INSCRIPTION}    css=.register_module_wrap input[name="register_pass"]
${CHAMP CONFIRMATION INSCRIPTION}    css=.register_module_wrap input[name="register_pass_retype"]
${CASE CONDITIONS INSCRIPTION}    css=.register_module_wrap input[name="term_condition"]
${BOUTON INSCRIPTION}         css=.register_module_wrap button.homey-register-button

# --- Locators Creation Annonce ---
${LIEN CREER ANNONCE}         xpath=(//a[contains(@href,'/add-listing/') and contains(normalize-space(.),'Créer annonce')])[last()]
${FORMULAIRE CREATION ANNONCE}    id=submit_listing_form
${CHAMP TITRE ANNONCE}        id=listing_title
${CHAMP DESCRIPTION ANNONCE}    id=description_ifr
${ZONE DESCRIPTION ANNONCE}      css=body#tinymce
${CONTROLE TYPE ANNONCE}         xpath=//select[@id='listing_type']/preceding-sibling::button
${CHAMP TYPE ANNONCE}         id=listing_type
${CHAMP CHAMBRES ANNONCE}     id=listing_bedrooms
${CHAMP VOYAGEURS ANNONCE}    id=guests
${CHAMP LITS ANNONCE}         id=beds
${CHAMP SALLES DE BAIN ANNONCE}    id=baths
${CHAMP PIECES ANNONCE}       id=listing_rooms
${CHAMP SURFACE ANNONCE}      id=listing_size
${CHAMP UNITE SURFACE ANNONCE}    id=listing_size_unit
${CHAMP PRIX NUIT ANNONCE}    id=night_price
${CHAMP ADRESSE ANNONCE}      id=listing_address
${CHAMP VILLE ANNONCE}        id=city
${CHAMP CODE POSTAL ANNONCE}  id=zip
${CHAMP PAYS ANNONCE}         id=homey_country
${BOUTON BROUILLON ANNONCE}  id=save_as_draft
${BOUTON CONTINUER ANNONCE}  css=#submit_listing_form .btn-step-next

# --- Locators Profil ---
${PAGE PROFIL}                 css=#body-area
${CHAMP PROFIL PRENOM}         id=firstname
${CHAMP PROFIL NOM}            id=lastname
${CHAMP PROFIL LANGUE NATIVE}  id=native_language
${CHAMP PROFIL AUTRE LANGUE}   id=other_language
${CHAMP PROFIL BIO}            id=bio
${BOUTON ENREGISTRER PROFIL}   xpath=//input[@id='firstname']/ancestor::div[contains(@class,'block')][1]//button[contains(@class,'homey_profile_save')]
${CHAMP ADRESSE RUE}           id=street_address
${CHAMP ADRESSE APPARTEMENT}   id=apt_suit
${CHAMP ADRESSE VILLE}         id=city
${CHAMP ADRESSE ETAT}          id=state
${CHAMP ADRESSE CODE POSTAL}   id=zipcode
${CHAMP ADRESSE QUARTIER}      id=neighborhood
${CHAMP ADRESSE PAYS}          id=country
${BOUTON ENREGISTRER ADRESSE}  xpath=//input[@id='street_address']/ancestor::div[contains(@class,'block')][1]//button[contains(@class,'homey_profile_save')]
${CHAMP CONTACT URGENCE NOM}       id=em_contact_name
${CHAMP CONTACT URGENCE LIEN}      id=em_relationship
${CHAMP CONTACT URGENCE EMAIL}     id=em_email
${CHAMP CONTACT URGENCE TELEPHONE}    id=em_phone
${BOUTON ENREGISTRER CONTACT}      xpath=//input[@id='em_contact_name']/ancestor::div[contains(@class,'col-sm-12')][1]//button[contains(@class,'homey_profile_save')]
${LIEN VOIR PROFIL}                xpath=//strong[contains(normalize-space(.),'Voir le profil')]/ancestor::a[1]
${BOUTON SUPPRIMER COMPTE}         css=button.delete_user_account
${ALERTE SUPPRESSION COMPTE}        id=delete_account_warning
${BOUTON ANNULER SUPPRESSION}      css=#delete_account_warning button:not(.delete_user_account_confirmed)


*** Keywords ***
# --- Keywords Généraux ---
Ouvrir Le Navigateur Et Accéder A L'Application
    Wait Until Keyword Succeeds    3x    10s    Ouvrir Le Navigateur
    Set Window Size    1920    1080
    Wait Until Location Contains    livraison3.testacademy.fr    timeout=30s

Ouvrir Le Navigateur
    Open Browser    ${URL APPLICATION}    ${NAVIGATEUR}    options=add_argument("--headless=new");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--window-size=1920,1080")

# --- Keywords Connexion (Existants) ---
Accéder A La Page De Connexion
    Wait Until Element Is Visible    ${LIEN SE CONNECTER}    timeout=30s
    Scroll Element Into View    ${LIEN SE CONNECTER}
    Click Element    ${LIEN SE CONNECTER}
    Wait Until Element Is Visible    ${MODAL CONNEXION}    timeout=30s

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
    Wait Until Location Contains    /listing/beautiful-cove/    timeout=30s
    Wait Until Element Is Visible    ${BOUTON CONTACTER HOTE SIDEBAR}    timeout=30s
    Scroll Element Into View    ${BOUTON CONTACTER HOTE SIDEBAR}

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

# --- Keywords Inscription Hote ---
Accéder Au Formulaire D'Inscription Hote
    Wait Until Element Is Visible    ${LIEN DEVENIR HOTE}    timeout=30s
    Scroll Element Into View    ${LIEN DEVENIR HOTE}
    Click Element    ${LIEN DEVENIR HOTE}
    Wait Until Location Contains    /become-a-host/    timeout=30s
    Wait Until Element Is Visible    ${FORMULAIRE INSCRIPTION}    timeout=30s

Accéder Au Profil
    Go To    ${URL APPLICATION}/index.php/profile/
    Wait Until Location Contains    /profile/    timeout=30s
    Wait Until Element Is Visible    ${PAGE PROFIL}    timeout=30s

Se Connecter Avec Le Compte Valide
    Accéder A La Page De Connexion
    Saisir Le Nom D'Utilisateur    ${UTILISATEUR VALIDE}
    Saisir Le Mot De Passe         ${MOT DE PASSE VALIDE}
    Soumette Le Formulaire De Connexion
    Wait Until Element Is Not Visible    ${CHAMP UTILISATEUR}    timeout=15s

Acceder Au Formulaire De Creation D Annonce
    Se Connecter Avec Le Compte Valide
    Wait Until Page Contains    Tableau de bord    timeout=30s
    Wait Until Element Is Visible    ${LIEN CREER ANNONCE}    timeout=30s
    Scroll Element Into View    ${LIEN CREER ANNONCE}
    Click Element    ${LIEN CREER ANNONCE}
    Wait Until Location Contains    /add-listing/    timeout=30s
    Wait Until Element Is Visible    ${FORMULAIRE CREATION ANNONCE}    timeout=30s

Saisir La Description De L Annonce
    Execute Javascript    document.getElementById('description_ifr').contentDocument.body.innerHTML = arguments[0];    ARGUMENTS    ${DESCRIPTION ANNONCE}

Verifier Les Champs Creation Annonce
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        ${nombre}=    Get Element Count    ${locator}
        Should Be Equal As Integers    ${nombre}    1
        Element Should Be Visible    ${locator}
    END

Remplir Les Informations Minimales De L Annonce
    Input Text    ${CHAMP TITRE ANNONCE}    ${TITRE ANNONCE}
    Saisir La Description De L Annonce
    Select From List By Label    ${CHAMP TYPE ANNONCE}    ${TYPE ANNONCE}
    Input Text    ${CHAMP CHAMBRES ANNONCE}    ${CHAMBRES ANNONCE}
    Input Text    ${CHAMP VOYAGEURS ANNONCE}    ${VOYAGEURS ANNONCE}
    Input Text    ${CHAMP LITS ANNONCE}    ${LITS ANNONCE}
    Input Text    ${CHAMP SALLES DE BAIN ANNONCE}    ${SALLES DE BAIN ANNONCE}
    Input Text    ${CHAMP PIECES ANNONCE}    ${PIECES ANNONCE}
    Input Text    ${CHAMP SURFACE ANNONCE}    ${SURFACE ANNONCE}
    Input Text    ${CHAMP UNITE SURFACE ANNONCE}    ${UNITE SURFACE ANNONCE}

Verifier Les Valeurs Des Informations De L Annonce
    Textfield Value Should Be    ${CHAMP TITRE ANNONCE}    ${TITRE ANNONCE}
    Textfield Value Should Be    ${CHAMP CHAMBRES ANNONCE}    ${CHAMBRES ANNONCE}
    Textfield Value Should Be    ${CHAMP VOYAGEURS ANNONCE}    ${VOYAGEURS ANNONCE}
    Textfield Value Should Be    ${CHAMP LITS ANNONCE}    ${LITS ANNONCE}
    Textfield Value Should Be    ${CHAMP SALLES DE BAIN ANNONCE}    ${SALLES DE BAIN ANNONCE}
    Textfield Value Should Be    ${CHAMP PIECES ANNONCE}    ${PIECES ANNONCE}
    Textfield Value Should Be    ${CHAMP SURFACE ANNONCE}    ${SURFACE ANNONCE}

Remplir Le Formulaire D'Inscription Hote
    [Arguments]    ${nom utilisateur}    ${email}    ${mot de passe}    ${confirmation}    ${conditions}=TRUE
    Input Text    ${CHAMP NOM INSCRIPTION}    ${nom utilisateur}
    Input Text    ${CHAMP EMAIL INSCRIPTION}    ${email}
    Input Password    ${CHAMP MOT DE PASSE INSCRIPTION}    ${mot de passe}
    Input Password    ${CHAMP CONFIRMATION INSCRIPTION}    ${confirmation}
    Run Keyword If    '${conditions}' == 'TRUE'    Select Checkbox    ${CASE CONDITIONS INSCRIPTION}

Soumettre L'Inscription Hote
    Click Button    ${BOUTON INSCRIPTION}

Verifier Que Le Formulaire D'Inscription Reste Visible
    Wait Until Element Is Visible    ${FORMULAIRE INSCRIPTION}    timeout=10s