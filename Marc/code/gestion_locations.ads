with Gestion_identite;  use Gestion_identite;
with Gestion_date;      use Gestion_date;
with Gestion_materiel;  use Gestion_materiel;
with Gestion_personnel; use Gestion_personnel;
with Gestion_Clients;   use Gestion_Clients;
with Gestion_Demandes;  use Gestion_Demandes;

package Gestion_Locations is

   type T_location is record
      num         : Integer;
      Id_client   : T_identite;
      duree       : Integer range 1 .. 10;
      date_d      : T_date;
      date_f      : T_date;
      delais      : Integer;
      Acc         :
        Integer range 0 .. 2; -- 0: aucun, 1: technicien, 2: ingénieur
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

   procedure fin_presta
     (en_cours     : in out T_pteur_L;
      archive      : in out T_pteur_L;
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

   procedure visu_archives (archive : in T_pteur_L);
   procedure visu_locations_client
     (en_cours : in T_pteur_L; archive : in T_pteur_L; Id : in T_identite);
   procedure visu_locations_employe
     (en_cours : in T_pteur_L; archive : in T_pteur_L; Id : in T_identite);
   procedure visu_infos_loc (L : in T_location);
end Gestion_Locations;
