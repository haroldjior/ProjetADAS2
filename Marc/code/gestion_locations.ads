with Gestion_identite;  use Gestion_identite;
with Gestion_date;      use Gestion_date;
with Gestion_materiel;  use Gestion_materiel;
with Gestion_personnel; use Gestion_personnel;
with Gestion_Clients;   use Gestion_Clients;
with Gestion_Demandes;  use Gestion_Demandes;
with Ada.Sequential_IO;

package Gestion_Locations is

   --  Type archive : version sans pointeur de T_location,
   --  stockable directement par Sequential_IO
   type T_loc_archive is record
      num             : Integer;
      Id_client       : T_identite;
      duree           : Integer range 1 .. 10;
      date_d          : T_date;
      date_f          : T_date;
      delais          : Integer;
      Acc             : Integer range 0 .. 2;
      Id_M            : Integer;
      app             : T_appareil;
      facture         : Integer;
      -- Intervenant stocke par valeur (pas de pointeur)
      a_intervenant   : Boolean;
      Id_intervenant  : T_identite;
      ing_intervenant : Boolean;
   end record;

   -- Package Sequential_IO instancie pour T_loc_archive
   package Archive_IO is new Ada.Sequential_IO (T_loc_archive);

   Nom_Fichier_Archive : constant String := "archives_locations";

   --  Type location en cours (avec pointeur vers employé) stocké dans la liste chainée
   type T_location is record
      num         : Integer;
      Id_client   : T_identite;
      duree       : Integer range 1 .. 10;
      date_d      : T_date;
      date_f      : T_date;
      delais      : Integer;
      Acc         : Integer range 0 .. 2;
      Id_M        : Integer;
      app         : T_appareil;
      Intervenant : T_Pteur_E;
   end record;

   type T_cell_L;
   type T_pteur_L is access T_cell_L;

   type T_cell_L is record
      loc  : T_location;
      suiv : T_pteur_L;
   end record;

   procedure Creer_presta (Tete : in out T_pteur_L; L : in T_location);

   procedure visu_presta (tete : in T_pteur_L);

   function Calcule_facture (Loc : T_location) return Integer;

   function calculer_date_fin
     (Date_Ajd : in T_date; duree : in integer) return T_date;

   -- fin_presta : ecrit dans le fichier Sequential_IO au lieu d'une liste
   procedure fin_presta
     (en_cours     : in out T_pteur_L;
      Date_Du_Jour : in T_date;
      Tete         : in out pt_clients;
      teteM        : in out T_Pteur_M;
      Tete_E       : in out T_Pteur_E);

   procedure traiter_demande
     (File_D   : in out T_File_Demandes;
      Liste_M  : in out T_Pteur_M;
      Liste_E  : in out T_Pteur_E;
      Liste_L  : in out T_pteur_L;
      Date_Ajd : T_date);

   -- Affiche tout le fichier archive
   procedure visu_archives;

   -- Affiche locations en cours + archives pour un client
   procedure visu_locations_client
     (en_cours : in T_pteur_L; Id : in T_identite);

   -- Affiche missions en cours + archives pour un employe
   procedure visu_locations_employe
     (en_cours : in T_pteur_L; Id : in T_identite);

   procedure visu_infos_loc (L : in T_location);

end Gestion_Locations;
