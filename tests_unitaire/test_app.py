import unittest
from appl import HomeyManager, Propriete

class TestHomeyManagerSolution(unittest.TestCase):
    """
    Solution complÃ¨te des tests unitaires pour le systÃ¨me de gestion Homey.
    
    Cette classe dÃ©montre l'utilisation de tous les types d'assertions apprises
    dans un contexte d'application rÃ©elle mais simplifiÃ©.
    """
    
    def setUp(self):
        """
        PrÃ©pare un HomeyManager et quelques propriÃ©tÃ©s de test avant chaque test.
        
        Utilisation de setUp() pour Ã©viter la duplication de code.
        """
        self.manager = HomeyManager()
        
        # Ajout de propriÃ©tÃ©s de test
        self.propriete1 = self.manager.ajouter_propriete(1, "Villa Sunset", 150.0)
        self.propriete2 = self.manager.ajouter_propriete(2, "Appartement Centre", 120.0)
        self.propriete3 = self.manager.ajouter_propriete(3, "Studio Plage", 80.0)
    
    def test_ajouter_propriete_valide(self):
        """
        Teste qu'une propriÃ©tÃ© valide peut Ãªtre ajoutÃ©e avec succÃ¨s.
        
        Utilise assertEqual pour vÃ©rifier les attributs de la propriÃ©tÃ© crÃ©Ã©e.
        """
        propriete = self.manager.ajouter_propriete(4, "Maison Campagne", 100.0)
        
        self.assertEqual(propriete.nom, "Maison Campagne")
        self.assertEqual(propriete.prix_par_nuit, 100.0)
        self.assertTrue(propriete.est_disponible)
    
    def test_ajouter_propriete_id_double(self):
        """
        Teste qu'ajouter une propriÃ©tÃ© avec un ID existant lÃ¨ve ValueError.
        
        Utilise assertRaises pour vÃ©rifier qu'une exception est levÃ©e.
        """
        with self.assertRaises(ValueError):
            self.manager.ajouter_propriete(1, "PropriÃ©tÃ© en double", 90.0)
    
    def test_ajouter_propriete_prix_negatif(self):
        """
        Teste qu'ajouter une propriÃ©tÃ© avec un prix nÃ©gatif lÃ¨ve ValueError.
        """
        with self.assertRaises(ValueError):
            self.manager.ajouter_propriete(10, "PropriÃ©tÃ© gratuite", -50.0)
    
    def test_supprimer_propriete_existante(self):
        """
        Teste la suppression d'une propriÃ©tÃ© existante.
        
        Utilise assertTrue pour vÃ©rifier le succÃ¨s.
        """
        resultat = self.manager.supprimer_propriete(1)
        self.assertTrue(resultat)
        
        # VÃ©rification que la propriÃ©tÃ© n'existe plus
        propriete_supprimee = self.manager.obtenir_propriete(1)
        self.assertIsNone(propriete_supprimee)
    
    def test_supprimer_propriete_inexistante(self):
        """
        Teste la suppression d'une propriÃ©tÃ© inexistante.
        
        Utilise assertFalse pour vÃ©rifier l'Ã©chec de l'opÃ©ration.
        """
        resultat = self.manager.supprimer_propriete(999)
        self.assertFalse(resultat)
    
    def test_obtenir_propriete_existante(self):
        """
        Teste l'obtention d'une propriÃ©tÃ© existante.
        
        Utilise assertIsNotNone pour vÃ©rifier le rÃ©sultat.
        """
        propriete = self.manager.obtenir_propriete(2)
        self.assertIsNotNone(propriete)
        self.assertEqual(propriete.nom, "Appartement Centre")
    
    def test_obtenir_propriete_inexistante(self):
        """
        Teste l'obtention d'une propriÃ©tÃ© inexistante.
        
        Utilise assertIsNone pour vÃ©rifier qu'aucune propriÃ©tÃ© n'est retournÃ©e.
        """
        propriete = self.manager.obtenir_propriete(999)
        self.assertIsNone(propriete)
    
    def test_rechercher_par_nom_existant(self):
        """
        Teste la recherche de propriÃ©tÃ©s par nom.
        
        Utilise assertIn pour vÃ©rifier que les bonnes propriÃ©tÃ©s sont trouvÃ©es.
        """
        proprietes_villa = self.manager.rechercher_par_nom("Villa")
        
        self.assertIn(self.propriete1, proprietes_villa)
        self.assertNotIn(self.propriete2, proprietes_villa)
    
    def test_rechercher_par_nom_inexistant(self):
        """
        Teste la recherche d'un nom qui n'existe pas.
        """
        proprietes_inexistantes = self.manager.rechercher_par_nom("ChÃ¢teau")
        self.assertEqual(len(proprietes_inexistantes), 0)
    
    def test_reserver_propriete_valide(self):
        """
        Teste une rÃ©servation valide.
        
        Utilise assertTrue et assertFalse pour vÃ©rifier le changement d'Ã©tat.
        """
        resultat = self.manager.reserver_propriete(1)
        self.assertTrue(resultat)
        
        # VÃ©rification que la propriÃ©tÃ© est maintenant indisponible
        self.assertFalse(self.propriete1.est_disponible)
    
    def test_reserver_propriete_inexistante(self):
        """
        Teste la rÃ©servation d'une propriÃ©tÃ© inexistante.
        
        Utilise assertFalse pour vÃ©rifier l'Ã©chec.
        """
        resultat = self.manager.reserver_propriete(999)
        self.assertFalse(resultat)
    
    def test_reserver_propriete_deja_reservee(self):
        """
        Teste la rÃ©servation d'une propriÃ©tÃ© dÃ©jÃ  rÃ©servÃ©e.
        """
        # PremiÃ¨re rÃ©servation
        premiere_reservation = self.manager.reserver_propriete(2)
        self.assertTrue(premiere_reservation)
        
        # Tentative de deuxiÃ¨me rÃ©servation
        deuxieme_reservation = self.manager.reserver_propriete(2)
        self.assertFalse(deuxieme_reservation)
    
    def test_obtenir_proprietes_disponibles(self):
        """
        Teste l'obtention de toutes les propriÃ©tÃ©s disponibles.
        
        Utilise assertIn et assertEqual pour vÃ©rifier le contenu de la liste.
        """
        # Toutes les propriÃ©tÃ©s sont initialement disponibles
        proprietes_disponibles = self.manager.obtenir_proprietes_disponibles()
        
        self.assertEqual(len(proprietes_disponibles), 3)
        self.assertIn(self.propriete1, proprietes_disponibles)
        self.assertIn(self.propriete2, proprietes_disponibles)
        self.assertIn(self.propriete3, proprietes_disponibles)
        
        # RÃ©serve une propriÃ©tÃ© et teste Ã  nouveau
        self.manager.reserver_propriete(1)
        proprietes_disponibles = self.manager.obtenir_proprietes_disponibles()
        
        self.assertEqual(len(proprietes_disponibles), 2)
        self.assertNotIn(self.propriete1, proprietes_disponibles)
    
    def test_obtenir_proprietes_reservees(self):
        """
        Teste l'obtention de toutes les propriÃ©tÃ©s rÃ©servÃ©es.
        """
        # Initialement, aucune propriÃ©tÃ© n'est rÃ©servÃ©e
        proprietes_reservees = self.manager.obtenir_proprietes_reservees()
        self.assertEqual(len(proprietes_reservees), 0)
        
        # RÃ©serve une propriÃ©tÃ©
        self.manager.reserver_propriete(1)
        
        proprietes_reservees = self.manager.obtenir_proprietes_reservees()
        self.assertEqual(len(proprietes_reservees), 1)
        self.assertIn(self.propriete1, proprietes_reservees)
        self.assertNotIn(self.propriete2, proprietes_reservees)


if __name__ == "__main__":
    unittest.main(verbosity=2) 