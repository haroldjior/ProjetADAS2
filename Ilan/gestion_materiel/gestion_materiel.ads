with gestion_date; use gestion_date;

package gestion_materiel is

   --Type énuméré des catégories de materiel
   type T_cat_materiel is (camera, prise_son, sono, projection, lumiere);

   --Record des packs de materiel
   type T_materiel is record
      id_mat    : Positive; --identifiant du pack
      cat       : T_cat_materiel; --categorie de materiel
      date_serv : T_date; --date de mise en service
      util      : Natural; --nombre de jours d'utilisation
      dispo     : boolean; --true si disponible, false sinon
      supp      : boolean; --true si suppression programmée, false sinon
   end record;

   --Liste des packs de materiel
   type T_cell_materiel;
   type P_materiel is access T_cell_materiel;
   type T_cell_materiel is record
      materiel : T_materiel;
      suiv     : P_materiel;
   end record;

   --Affichage d'un seul pack de materiel
   procedure affichage_materiel (Mat : in T_materiel);

   --Affichage de l'ensemble des packs de materiel
   procedure affichage_packs (tete : in P_materiel);

   --Ajout d'un nouveau pack de materiel avec saisie de la categorie
   procedure nouv_pack_mat (tete : in out P_materiel; date : in T_date);

   --Saisie d'un id  et d'une categorie puis suppression du pack associé
   procedure supp_pack_idcat (tete : in out P_materiel);

   --Saisie d'une date puis suppression de tous les packs de materiel mis en service avant
   --Utilise la procedure SPD
   procedure supp_pack_date
     (tete : in out P_materiel; tab_mois : in T_tab_mois);

   --Visualisation de tous les packs disponibles
   procedure visu_pack_dispo (tete : in P_materiel);

end gestion_materiel;
