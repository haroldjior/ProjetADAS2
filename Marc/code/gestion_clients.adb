with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling;
use Ada.Text_IO, Ada.Integer_Text_io, Ada.Characters.Handling;

package body Gestion_Clients is

   procedure enregistrer_client (tete : in out pt_clients; Id : in T_identite)
   is
   begin
      if tete = null then
         tete := new T_cellule_client'((Id, 0, 0, 0), null, null);
      elsif meme_id (Id, tete.Client.Identite_Client) then
         null;
      elsif id_inferieur (Id, tete.Client.Identite_Client) then
         Enregistrer_Client (tete.FG, Id);
      else
         Enregistrer_Client (tete.FD, Id);
      end if;
   end enregistrer_client;

   procedure visu_clientele (tete : in pt_clients) is
   begin
      if tete /= null then
         Visualiser_Identite (tete.Client.Identite_Client);
         Put (" | Loc: " & Integer'Image (tete.Client.Nb_Locations));
         Put (" | Facture: " & Integer'Image (tete.Client.Facture_Due));
         Put_Line (" | Regle: " & Integer'Image (tete.Client.Montant_Regle));
         visu_clientele (tete.FG);
         visu_clientele (tete.FD);
      end if;
   end visu_clientele;

   function recherche_client
     (tete : pt_clients; Id : T_identite) return pt_clients is
   begin
      if tete = null then
         return null;
      elsif meme_id (Id, tete.Client.Identite_Client) then
         return tete;
      elsif id_inferieur (Id, tete.Client.Identite_Client) then
         return recherche_client (tete.FG, Id);
      else
         return recherche_client (tete.FD, Id);
      end if;
   end recherche_client;

   procedure visu_client (tete : in pt_clients) is
      Id_Recherche : T_identite;
      P_Client     : pt_clients;
   begin
      Put_Line ("--- Recherche d'un client ---");
      Saisie_Identite (Id_Recherche);

      P_Client := recherche_client (tete, Id_Recherche);

      if P_Client /= null then
         Put ("Infos : ");
         Visualiser_Identite (P_Client.Client.Identite_Client);
         Put ("Locations : ");
         Put (P_Client.Client.Nb_Locations, 0);
         New_Line;
         Put ("Facture due : ");
         Put (P_Client.Client.Facture_Due, 0);
         New_Line;
      else
         Put_Line ("Client inconnu.");
      end if;
   end visu_client;

   procedure initialiser_clientele (tete : in out pt_clients) is
   begin
      enregistrer_client (tete, faire_une_id ("Mouton", "Aline"));
      enregistrer_client (tete, faire_une_id ("Belle", "Lucie"));
      enregistrer_client (tete, faire_une_id ("Arc", "Jean"));
      enregistrer_client (tete, faire_une_id ("Bartok", "Belle"));
   end initialiser_clientele;

   procedure Enregistrer_Reglement (Tete : in out pt_clients) is
      Id_Recherche : T_identite;
      P_Client     : pt_clients;
      Montant      : Integer;
   begin
      Put_Line ("--- Enregistrement d'un reglement ---");
      Saisie_Identite (Id_Recherche);

      P_Client := recherche_client (Tete, Id_Recherche);

      if P_Client = null then
         Put_Line ("Erreur : Ce client n'existe pas dans la base.");
      else
         Put ("Facture en instance : ");
         Put (P_Client.Client.Facture_Due, 0);
         Put_Line (" Euros");

         loop
            Put ("Entrez le montant du reglement : ");
            Get (Montant);
            Skip_Line;
            if Montant > 0 and Montant <= P_Client.Client.Facture_Due then
               P_Client.Client.Montant_Regle :=
                 P_Client.Client.Montant_Regle + Montant;
               P_Client.Client.Facture_Due :=
                 P_Client.Client.Facture_Due - Montant;
               Put_Line ("Reglement enregistre avec succes.");
               Put ("Nouveau solde a regler : ");
               Put (P_Client.Client.Facture_Due, 0);
               Put_Line (" Euros.");
               exit;
            else
               Put_Line
                 ("Erreur : Le montant doit etre positif et inferieur ou egal a la facture due.");
            end if;
         end loop;
      end if;
   end Enregistrer_Reglement;

end Gestion_Clients;
