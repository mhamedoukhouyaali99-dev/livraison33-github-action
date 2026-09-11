
class Propriete:
    """ReprÃ©sente une propriÃ©tÃ© de location saisonniÃ¨re sur Homey."""
    
    def __init__(self, propriete_id, nom, prix_par_nuit):
        """Initialise une propriÃ©tÃ© avec ID, nom et prix."""
        self.propriete_id = propriete_id
        self.nom = nom
        self.prix_par_nuit = prix_par_nuit
        self.est_disponible = True
    
    def __str__(self):
        """Retourne une reprÃ©sentation textuelle de la propriÃ©tÃ©."""
        statut = "Disponible" if self.est_disponible else "RÃ©servÃ©e"
        return f"PropriÃ©tÃ© {self.propriete_id}: '{self.nom}' - {self.prix_par_nuit}â‚¬/nuit - {statut}"


class HomeyManager:
    """GÃ¨re une collection de propriÃ©tÃ©s de location saisonniÃ¨re sur Homey."""
    
    def __init__(self):
        """Initialise une collection de propriÃ©tÃ©s vide."""
        self.proprietes = []
    
    def ajouter_propriete(self, propriete_id, nom, prix_par_nuit):
        """
        Ajoute une nouvelle propriÃ©tÃ© Ã  la collection.
        LÃ¨ve ValueError si propriete_id existe dÃ©jÃ  ou si le prix est nÃ©gatif.
        """
        if prix_par_nuit <= 0:
            raise ValueError("Le prix par nuit doit Ãªtre positif")
        
        # VÃ©rifie si propriete_id existe dÃ©jÃ 
        for propriete in self.proprietes:
            if propriete.propriete_id == propriete_id:
                raise ValueError(f"Une propriÃ©tÃ© avec l'ID {propriete_id} existe dÃ©jÃ ")
        
        # CrÃ©e et ajoute la nouvelle propriÃ©tÃ©
        nouvelle_propriete = Propriete(propriete_id, nom, prix_par_nuit)
        self.proprietes.append(nouvelle_propriete)
        return nouvelle_propriete
    
    def supprimer_propriete(self, propriete_id):
        """
        Supprime une propriÃ©tÃ© de la collection.
        Retourne True si rÃ©ussi, False si la propriÃ©tÃ© n'a pas Ã©tÃ© trouvÃ©e.
        """
        for i, propriete in enumerate(self.proprietes):
            if propriete.propriete_id == propriete_id:
                del self.proprietes[i]
                return True
        return False
    
    def obtenir_propriete(self, propriete_id):
        """
        Obtient une propriÃ©tÃ© par son ID.
        Retourne la propriÃ©tÃ© si trouvÃ©e, None sinon.
        """
        for propriete in self.proprietes:
            if propriete.propriete_id == propriete_id:
                return propriete
        return None
    
    def rechercher_par_nom(self, nom_recherche):
        """
        Recherche des propriÃ©tÃ©s contenant le nom donnÃ© (insensible Ã  la casse).
        Retourne une liste des propriÃ©tÃ©s correspondantes.
        """
        resultats = []
        for propriete in self.proprietes:
            if nom_recherche.lower() in propriete.nom.lower():
                resultats.append(propriete)
        return resultats
    
    def reserver_propriete(self, propriete_id):
        """
        RÃ©serve une propriÃ©tÃ© (la marque comme indisponible).
        Retourne True si rÃ©ussi, False si la propriÃ©tÃ© n'existe pas ou est dÃ©jÃ  rÃ©servÃ©e.
        """
        propriete = self.obtenir_propriete(propriete_id)
        if propriete is None or not propriete.est_disponible:
            return False
        
        propriete.est_disponible = False
        return True
    
    def liberer_propriete(self, propriete_id):
        """
        LibÃ¨re une propriÃ©tÃ© rÃ©servÃ©e (la marque comme disponible).
        Retourne True si rÃ©ussi, False si la propriÃ©tÃ© n'existe pas ou est dÃ©jÃ  libre.
        """
        propriete = self.obtenir_propriete(propriete_id)
        if propriete is None or propriete.est_disponible:
            return False
        
        propriete.est_disponible = True
        return True
    
    def obtenir_proprietes_disponibles(self):
        """Retourne une liste de toutes les propriÃ©tÃ©s disponibles."""
        return [propriete for propriete in self.proprietes if propriete.est_disponible]
    
    def obtenir_proprietes_reservees(self):
        """Retourne une liste de toutes les propriÃ©tÃ©s rÃ©servÃ©es."""
        return [propriete for propriete in self.proprietes if not propriete.est_disponible]