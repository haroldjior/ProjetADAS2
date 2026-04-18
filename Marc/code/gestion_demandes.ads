with Gestion_identite, gestion_date, Gestion_materiel, Gestion_Clients;
use Gestion_identite, gestion_date, Gestion_materiel, Gestion_Clients;

package Gestion_Demandes is

   type T_Demande is record
      numero           : integer;
      Client_Demandeur : T_identite;
      Mat              : T_appareil;
      Duree_J          : Positive;
      date_demande     : T_date;
      Acc              :
        integer
          range 0
                ..
                  2; -- 0 si pas d’accompagant, 1 si technicien, 2 si ingénieur
   end record;

   --file (Liste chaînée)
   type T_Cell_Demande;
   type pt_demande is access T_Cell_Demande;

   type T_Cell_Demande is record
      Demande : T_Demande;
      Suiv    : pt_demande;
   end record;

   type T_File_Demandes is record
      Tete  : pt_demande := null;
      Queue : pt_demande := null;
   end record;

   procedure visu_demande (demande : in T_Demande);
   procedure visu_file_demandes (file_D : in T_File_Demandes);
   procedure saisie_demande (D : out T_Demande; date_ajd : in T_date);
   procedure ajout_demande_file
     (file_D   : in out T_File_Demandes;
      tete_C   : in out pt_clients;
      date_ajd : T_date);
   procedure sup_demande (file_D : in out T_File_Demandes);

end Gestion_Demandes;
