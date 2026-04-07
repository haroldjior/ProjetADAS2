with gestion_identite; use gestion_identite;
with gestion_locations;

package gestion_personnel is

   type T_employe is record
      Id_E       : T_identite;
      ingenieur  : boolean;
      nbj_presta : integer;
      dispo      : boolean;
      D_depart   : boolean; --true si demande de départ
   end record;

   --liste :
   type T_cell_E;
   type T_Pteur_E is access T_cell_E;
   type T_cell_E is record
      employe : T_employe;
      suiv    : T_Pteur_E;
   end record;

   procedure saisie_employe (E : out T_employe);

   procedure visu_employe (E : in T_employe);

   function recherche_employe
     (teteE : in T_Pteur_E; id_E : in T_identite; cat_E : in boolean)
      return T_Pteur_E;

   procedure ajout_employe_liste (teteE : in out T_pteur_E);

   procedure visu_liste_employes (teteE : in T_Pteur_E);

   procedure visu_employe_par_nom (teteE : in T_Pteur_E);

   procedure supprimer_employe (teteE : in out T_Pteur_E; P : in T_Pteur_E);

   procedure demande_depart_employe (teteE : in out T_Pteur_E);

end gestion_personnel;
