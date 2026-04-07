with gestion_identite; use gestion_identite;

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
   procedure depart_employe (tete : in out P_employe);

end gestion_personnel;
