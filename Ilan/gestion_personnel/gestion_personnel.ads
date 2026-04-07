with ada.unchecked_deallocation, gestion_identite;
use gestion_identite;

package gestion_personnel is

   --type qui définit un employé
   type T_employe is record
      id_employe     : T_identite;
      technicien     : boolean; --true si technicien, false si ingenieur
      nb_jour_presta : natural;
      dispo          : boolean; --true si disponible, false sinon
      depart         : boolean; --true si départ demandé, false sinon
   end record;

   --Liste des employés
   type T_cell_employe;
   type P_employe is access T_cell_employe;
   type T_cell_employe is record
      employe : T_employe;
      suiv    : P_employe;
   end record;

   procedure liberer_memoire_employe is new
     ada.unchecked_deallocation (T_cell_employe, P_employe);

   --Affichage d'un record T_employe
   procedure affichage_employe (employe : in T_employe);

   --Visualisation de l'ensemble du personnel
   procedure visu_personnel (tete : in P_employe);

   --Visualisation d'un employé donné (nom et catégorie)
   procedure visu_employe (tete : in P_employe);

   --Saisie d'un record T_employe
   procedure saisie_employe (Employe : out T_employe);

   --Saisie puis ajout d'un employe à la liste des employe
   procedure ajout_employe (tete : in out P_employe);

   --Enregistrement de la demande de départ d'un employe
   procedure dem_depart_employe (tete : in out P_employe);

   --Supprime tous les employes qui ont une demande de depart enregistree
   procedure depart_employe (tete : in out P_employe);

   --Recherche d'un employe donné
   function recherche_employe
     (tete : in P_employe; id : in T_identite; tech : boolean)
      return P_employe;

end gestion_personnel;
