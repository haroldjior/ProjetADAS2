with gestion_identite; use gestion_identite;

package gestion_client is

   type T_client is record
      id_client     : T_identite;
      nb_loca       : integer;
      facture       : integer;
      montant_regle : integer;
   end record;

   type T_cell_client;
   type P_client is access T_cell_client;
   type T_cell_client is record
      client : T_client;
      fg, fd : P_client;
   end record;

   --Recherche d'un client donné dans l'ABR
   function recherche_client
     (tete : P_client; client : T_identite) return P_client;

   --Affichage d'un record T_client
   procedure affichage_client (client : in T_client);

   --Visualisation de l'ensemble de la clientèle (ordre préfixe)
   procedure visu_clients (tete : in P_client);

   --Saisie d'un record T_client
   procedure saisie_client (client : out T_client);

   --Ajout d'un client dans l'ABR, compare d'abord le nom puis le prénom
   procedure nouv_client (tete : in out P_client; client : in T_client);

   --Enregistrement d'un reglement (par son identite)
   --possible que si montant <= facture
   procedure enr_reglement (tete : in out P_client);

end gestion_client;
