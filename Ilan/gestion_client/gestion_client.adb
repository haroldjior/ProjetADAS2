with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     ada.IO_Exceptions,
     gestion_identite;
use ada.text_io,
    ada.integer_text_io,
    ada.characters.handling,
    gestion_identite;

package body gestion_client is

   --Recherche d'un client donné dans l'ABR
   function recherche_client
     (tete : P_client; client : T_identite) return P_client is
   begin
      if tete = null then
         return (null);
      else
         if client.id_nom.nom = tete.client.id_client.id_nom.nom then
            return (tete);
         elsif client.id_nom.nom < tete.client.id_client.id_nom.nom then
            return (recherche_client (tete.fg, client));
         else
            return (recherche_client (tete.fd, client));
         end if;
      end if;
   end recherche_client;

   procedure affichage_client (client : in T_client) is
   begin
      new_line;
      affichage_id (client.id_client);
      put ("Nombre de locations : ");
      put (client.nb_loca, 2);
      new_line;
      put ("Facture en attente de reglement : ");
      put (client.facture, 3);
      new_line;
      put ("Montant regle : ");
      put (client.montant_regle, 3);
      new_line;
   end affichage_client;

   procedure saisie_client (client : out T_client) is
      id : T_identite;
   begin
      saisie_identite (id);
      client.id_client := id;
      client.nb_loca := 0;
      client.facture := 0;
      client.montant_regle := 0;
   end saisie_client;

   --Ajout d'un client dans l'ABR, compare d'abord le nom puis le prénom
   procedure nouv_client (tete : in out P_client; client : in T_client) is
   begin
      if tete = null then
         tete := new T_cell_client'(client, null, null);
      else
         if client.id_client.id_nom.nom < tete.client.id_client.id_nom.nom then
            nouv_client (tete.fg, client);
         elsif client.id_client.id_nom.nom = tete.client.id_client.id_nom.nom
         then
            if client.id_client.id_prenom.nom
              <= tete.client.id_client.id_prenom.nom
            then
               nouv_client (tete.fg, client);
            else
               nouv_client (tete.fd, client);
            end if;
         else
            nouv_client (tete.fd, client);
         end if;
      end if;
   end nouv_client;

   procedure visu_clients (tete : in P_client) is
   begin
      if tete /= null then
         affichage_client (tete.client);
         visu_clients (tete.fg);
         visu_clients (tete.fd);
      end if;
   end visu_clients;

   procedure enr_reglement (tete : in out P_client) is
      id_client : T_identite;
      client    : P_client;
      montant   : Positive;
   begin
      put_line ("Enregistrement d'un reglement :");
      loop
         saisie_identite (id_client);
         client := recherche_client (tete, id_client);
         exit when client /= null;
         put_line ("Ce client n'existe pas");
      end loop;
      loop
         begin
            put ("Montant : ");
            get (montant);
            skip_line;
            exit when montant'valid;
            put_line ("Le montant doit etre un entier");
         exception
            when Constraint_Error =>
               put ("Le montant doit etre un entier non nul");
         end;
      end loop;
      if montant > client.client.facture then
         put
           ("Le montant a regle ne peut pas etre superieur a la facture du client");
      else
         client.client.facture := client.client.facture - montant;
         client.client.montant_regle := client.client.montant_regle + montant;
      end if;
   end enr_reglement;

end gestion_client;
