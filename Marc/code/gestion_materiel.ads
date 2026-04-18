with gestion_date; use gestion_date;

package gestion_materiel is

   type T_appareil is (camera, prise_son, sono, projection, lumiere);

   type T_materiel is record
      app          : T_appareil;
      Id_M         : integer;
      Date_service : T_date;
      nbj_uti      : natural;
      loue         : boolean; --true si loué, false sinon
      sup          :
        boolean; --true si la suppression est programmé, false sinon
   end record;

   --liste :
   type T_cell_M;
   type T_Pteur_M is access T_cell_M;
   type T_cell_M is record
      mat  : T_materiel;
      suiv : T_Pteur_M;
   end record;

   procedure visu_Mat (m : in T_materiel);

   procedure visu_liste_mat (teteM : in T_Pteur_M);

   procedure ajout_mat_liste (teteM : in out T_Pteur_M; date : in T_date);

   procedure sup_mat_par_id (teteM : in out T_Pteur_M);

   procedure sup_mat_anciens
     (teteM : in out T_Pteur_M; tab_mois : in T_tab_mois);

   procedure visu_mat_dispo (teteM : in T_Pteur_M);

   procedure Liberer_mat
     (Id_R      : Integer;
      cat       : T_appareil;
      Duree_Loc : Positive;
      tete      : in out T_Pteur_M);

   function trouver_mat (tete : T_Pteur_M; Cat : T_appareil) return T_Pteur_M;

end gestion_materiel;
