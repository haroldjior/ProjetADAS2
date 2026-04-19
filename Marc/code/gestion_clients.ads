with Gestion_identite; use Gestion_identite;

package Gestion_Clients is

   type T_client is record
      Identite_Client : T_identite;
      Nb_Locations    : Integer := 0;
      Facture_Due     : Integer := 0;
      Montant_Regle   : Integer := 0;
   end record;

   type T_cellule_client;
   type pt_clients is access T_cellule_client;

   type T_cellule_client is record
      Client : T_client;
      FG, FD : pt_clients;
   end record;

   procedure enregistrer_client (tete : in out pt_clients; Id : in T_identite);

   procedure visu_clientele (tete : in pt_clients);

   function recherche_client
     (tete : pt_clients; Id : T_identite) return pt_clients;

   procedure initialiser_clientele (tete : in out pt_clients);

   procedure Enregistrer_Reglement (Tete : in out pt_clients);

   procedure visu_client (tete : in pt_clients);

end Gestion_Clients;
