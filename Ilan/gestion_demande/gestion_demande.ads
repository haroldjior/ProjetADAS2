with ada.unchecked_deallocation,
     gestion_date,
     gestion_identite,
     gestion_materiel,
     gestion_client;
use gestion_date, gestion_identite, gestion_materiel, gestion_client;

package gestion_demande is

   --Record d'une demande de location
   type T_dem_loca is record
      num       : integer; --auto incrémenté
      id_client : T_identite;
      duree     : integer range 1 .. 10;
      date      : T_date;
      accomp    :
        integer range 0 .. 2; --0 si aucun, 1 si technicien, 2 si ingenieur
      materiel  : T_cat_materiel;
   end record;

   --Liste de demandes de location
   type T_cell_dem;
   type P_dem_loca is access T_cell_dem;
   type T_cell_dem is record
      demande : T_dem_loca;
      suiv    : P_dem_loca;
   end record;

   --File des demandes de location
   type T_file_dem is record
      debut, fin : P_dem_loca;
   end record;

   -- ### UTILITAIRE ###

   --Liberation de la memoire apres la suppression d'un employe
   procedure liberer_memoire_demande is new
     ada.unchecked_deallocation (T_cell_dem, P_dem_loca);


   -- ### AFFICHAGES / VISUALISATIONS ###

   --Affichage d'un record T_dem_loca
   procedure affichage_demande (dem : in T_dem_loca);

   --Visualisation de l'ensemble des demandes
   procedure visu_demandes (file : in T_file_dem);


   -- ### SAISIES / INSERTIONS ###

   --Saisie d'un record T_dem_loca
   procedure saisie_demande (dem : out T_dem_loca; date : T_date);

   --Enregistrement d'une nouvelle demande de location
   procedure nouv_demande (file : in out T_file_dem; teteC : in out P_client);


   -- ### SUPPRESSION ###

   --Suppression de demande de location (par son numéro)
   procedure supp_demande (file : in out T_file_dem);

end gestion_demande;
