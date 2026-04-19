with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling;
with Gestion_Date;
with Gestion_Identite;
with Gestion_Materiel;
with Gestion_Demandes;
with Gestion_Clients;
with Gestion_Personnel;
with Gestion_Locations;
with Gestion_Donnees;

use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling;
use Gestion_Date;
use Gestion_Identite;
use Gestion_Materiel;
use Gestion_Demandes;
use Gestion_Clients;
use Gestion_Personnel;
use Gestion_Locations;
use Gestion_Donnees;

procedure Main is

   -- ============================================================
   --  Donnees globales
   -- ============================================================
   Date_Du_Jour : T_Date;
   Tab_Mois     : T_Tab_Mois;
   Tete_M       : T_Pteur_M;
   Tete_E       : T_Pteur_E;
   File_D       : T_File_Demandes;
   Tete_L       : T_Pteur_L;
   Tete_C       : Pt_Clients;
   Choix_Main   : Character;
   Choix        : Character;

   -- ============================================================
   --  Utilitaire : lire un caractere valide dans [Min..Max]
   -- ============================================================
   procedure Lire_Choix (C : out Character; Min, Max : Character) is
   begin
      loop
         begin
            Get (C);
            Skip_Line;
            exit when C >= Min and then C <= Max;
            Put ("Choix invalide, entrez un chiffre entre ");
            Put (Min);
            Put (" et ");
            Put (Max);
            Put (" : ");
         exception
            when others =>
               Skip_Line;
               Put ("Erreur de saisie, reessayez : ");
         end;
      end loop;
   end Lire_Choix;

   -- ============================================================
   --  Sous-menu MATERIEL
   --  US : consulter le materiel, ajouter/supprimer un pack,
   --       voir les packs dispo, supprimer les anciens
   -- ============================================================
   procedure Menu_Materiel is
      C : Character;
   begin
      loop
         New_Line;
         Put_Line ("============================================");
         Put_Line ("          GESTION DU MATERIEL");
         Put_Line ("============================================");
         Put_Line (" 1 - Afficher tout le materiel");
         Put_Line (" 2 - Afficher le materiel disponible");
         Put_Line (" 3 - Ajouter un pack");
         Put_Line (" 4 - Supprimer un pack par ID et type");
         Put_Line (" 5 - Supprimer les anciens packs");
         Put_Line (" 0 - Retour");
         Put_Line ("============================================");
         Put ("Votre choix : ");
         Lire_Choix (C, '0', '5');

         case C is
            when '1'    =>
               Put_Line ("--- Liste de tout le materiel ---");
               Visu_Liste_Mat (Tete_M);

            when '2'    =>
               Put_Line ("--- Materiel disponible ---");
               Visu_Mat_Dispo (Tete_M);

            when '3'    =>
               Put_Line ("--- Ajout d'un pack ---");
               Ajout_Mat_Liste (Tete_M, Date_Du_Jour);
               Put_line ("pack ajouté : ");
               visu_Mat (Tete_M.mat);

            when '4'    =>
               Put_Line ("--- Suppression d'un pack ---");
               Sup_Mat_Par_Id (Tete_M);

            when '5'    =>
               Put_Line ("--- Suppression des anciens packs ---");
               Sup_Mat_Anciens (Tete_M, Tab_Mois);
               Put_Line ("Anciens packs supprimes.");

            when '0'    =>
               exit;

            when others =>
               null;
         end case;
      end loop;
   end Menu_Materiel;

   -- ============================================================
   --  Sous-menu EMPLOYES
   --  US : consulter, ajouter, rechercher, demande de depart,
   --       voir les prestations d'un employe
   -- ============================================================
   procedure Menu_Employes is
      C  : Character;
      Id : T_identite;
   begin
      loop
         New_Line;
         Put_Line ("============================================");
         Put_Line ("          GESTION DES EMPLOYES");
         Put_Line ("============================================");
         Put_Line (" 1 - Afficher tous les employes");
         Put_Line (" 2 - Rechercher un employe par nom");
         Put_Line (" 3 - Ajouter un employe");
         Put_Line (" 4 - Enregistrer une demande de depart");
         Put_Line (" 5 - Voir les prestations d'un employe");
         Put_Line (" 0 - Retour");
         Put_Line ("============================================");
         Put ("Votre choix : ");
         Lire_Choix (C, '0', '5');

         case C is
            when '1'    =>
               Put_Line ("--- Liste des employes ---");
               Visu_Liste_Employes (Tete_E);

            when '2'    =>
               Put_Line ("--- Recherche d'un employe ---");
               Visu_Employe_Par_Nom (Tete_E);

            when '3'    =>
               Put_Line ("--- Ajout d'un employe ---");
               Ajout_Employe_Liste (Tete_E);

            when '4'    =>
               Put_Line ("--- Demande de depart ---");
               Demande_Depart_Employe (Tete_E);

            when '5'    =>
               Put_Line ("--- Prestations d'un employe ---");
               Put_Line ("Saisissez l'identite de l'employe :");
               Saisie_Identite (Id);
               Visu_Locations_Employe (Tete_L, Id);

            when '0'    =>
               exit;

            when others =>
               null;
         end case;
      end loop;
   end Menu_Employes;

   -- ============================================================
   --  Sous-menu CLIENTS
   --  US : consulter la clientele, rechercher un client,
   --       voir son historique de locations, enregistrer un
   --       reglement
   -- ============================================================
   procedure Menu_Clients is
      C  : Character;
      Id : T_identite;
   begin
      loop
         New_Line;
         Put_Line ("============================================");
         Put_Line ("          GESTION DES CLIENTS");
         Put_Line ("============================================");
         Put_Line (" 1 - Afficher toute la clientele");
         Put_Line (" 2 - Rechercher un client");
         Put_Line (" 3 - Voir l'historique de locations d'un client");
         Put_Line (" 4 - Enregistrer un reglement");
         Put_Line (" 0 - Retour");
         Put_Line ("============================================");
         Put ("Votre choix : ");
         Lire_Choix (C, '0', '4');

         case C is
            when '1'    =>
               Put_Line ("--- Clientele ---");
               Visu_Clientele (Tete_C);

            when '2'    =>
               Put_Line ("--- Recherche client ---");
               Visu_Client (Tete_C);

            when '3'    =>
               Put_Line ("--- Historique de locations d'un client ---");
               Put_Line ("Saisissez l'identite du client :");
               Saisie_Identite (Id);
               Visu_Locations_Client (Tete_L, Id);

            when '4'    =>
               Put_Line ("--- Enregistrement d'un reglement ---");
               Enregistrer_Reglement (Tete_C);

            when '0'    =>
               exit;

            when others =>
               null;
         end case;
      end loop;
   end Menu_Clients;

   -- ============================================================
   --  Sous-menu DEMANDES
   --  US : consulter la file, ajouter une demande, supprimer,
   --       traiter la file (convertir en locations si possible)
   -- ============================================================
   procedure Menu_Demandes is
      C : Character;
   begin
      loop
         New_Line;
         Put_Line ("============================================");
         Put_Line ("          GESTION DES DEMANDES");
         Put_Line ("============================================");
         Put_Line (" 1 - Afficher les demandes en attente");
         Put_Line (" 2 - Ajouter une demande");
         Put_Line (" 3 - Supprimer une demande");
         Put_Line (" 4 - Traiter la file des demandes");
         Put_Line (" 0 - Retour");
         Put_Line ("============================================");
         Put ("Votre choix : ");
         Lire_Choix (C, '0', '4');

         case C is
            when '1'    =>
               Put_Line ("--- File des demandes en attente ---");
               Visu_File_Demandes (File_D);

            when '2'    =>
               Put_Line ("--- Nouvelle demande ---");
               Ajout_Demande_File (File_D, Tete_C, Date_Du_Jour);

            when '3'    =>
               Put_Line ("--- Suppression d'une demande ---");
               Sup_Demande (File_D);

            when '4'    =>
               Put_Line ("--- Traitement de la file ---");
               Traiter_Demande (File_D, Tete_M, Tete_E, Tete_L, Date_Du_Jour);
               Put_Line ("File traitee.");

            when '0'    =>
               exit;

            when others =>
               null;
         end case;
      end loop;
   end Menu_Demandes;

   -- ============================================================
   --  Sous-menu LOCATIONS
   --  US : consulter les locations en cours, les archives,
   --       cloturer les prestations terminees
   -- ============================================================
   procedure Menu_Locations is
      C : Character;
   begin
      loop
         New_Line;
         Put_Line ("============================================");
         Put_Line ("          GESTION DES LOCATIONS");
         Put_Line ("============================================");
         Put_Line (" 1 - Afficher les locations en cours");
         Put_Line (" 2 - Afficher l'historique (archives)");
         Put_Line (" 3 - Clotures des prestations terminees");
         Put_Line (" 0 - Retour");
         Put_Line ("============================================");
         Put ("Votre choix : ");
         Lire_Choix (C, '0', '3');

         case C is
            when '1'    =>
               Visu_Presta (Tete_L);

            when '2'    =>
               Visu_Archives;

            when '3'    =>
               Put_Line ("--- Cloture des prestations terminees ---");
               Fin_Presta (Tete_L, Date_Du_Jour, Tete_C, Tete_M, Tete_E);
               Put_Line ("Prestations terminees cloturees.");

            when '0'    =>
               exit;

            when others =>
               null;
         end case;
      end loop;
   end Menu_Locations;

   -- ============================================================
   --  Programme principal
   -- ============================================================
begin

   Put_Line ("=========================================");
   Put_Line ("  Gestion de Prestations Audio-Visuelles");
   Put_Line ("=========================================");
   New_Line;

   -- Chargement des donnees initiales
   loop
      Put ("Charger les donnees initiales des User Stories ? (O/N) : ");
      Get (Choix_Main);
      Skip_Line;
      Choix_Main := To_Upper (Choix_Main);
      exit when Choix_Main = 'O' or else Choix_Main = 'N';
      Put_Line ("Entrez O ou N.");
   end loop;

   if Choix_Main = 'O' then
      Init_Donnees (Tete_M, Tete_E, File_D, Tete_L, Tete_C);
      Reinitialiser_Archive;
      Date_Du_Jour := Faire_Date (22, Avril, 2026);
      Tab_Mois := Nb_J_Mois (Date_Du_Jour.Mois, Date_Du_Jour.Annee);
      Put_Line ("Donnees initiales chargees (date : 22 avril 2026).");
   else
      Tete_M := null;
      Tete_E := null;
      File_D := (Tete => null, Queue => null);
      Tete_L := null;
      Tete_C := null;
      Reinitialiser_Archive;
      Date_Du_Jour := Faire_Date (22, Avril, 2026);
      Tab_Mois := Nb_J_Mois (Date_Du_Jour.Mois, Date_Du_Jour.Annee);
      Put_Line ("Aucune donnee chargee.");
   end if;

   -- Boucle principale
   loop
      New_Line;
      Put_Line ("============================================");
      Put ("  Date du jour : ");
      Visu_Date (Date_Du_Jour);
      New_Line;
      Put_Line ("============================================");
      Put_Line (" 1 - Gerer le materiel");
      Put_Line (" 2 - Gerer les employes");
      Put_Line (" 3 - Gerer les clients");
      Put_Line (" 4 - Gerer les demandes");
      Put_Line (" 5 - Gerer les locations");
      Put_Line (" 6 - Passer au lendemain");
      Put_Line (" 0 - Quitter");
      Put_Line ("============================================");
      Put ("Votre choix : ");
      Lire_Choix (Choix, '0', '6');

      case Choix is
         when '1'    =>
            Menu_Materiel;

         when '2'    =>
            Menu_Employes;

         when '3'    =>
            Menu_Clients;

         when '4'    =>
            Menu_Demandes;

         when '5'    =>
            Menu_Locations;

         when '6'    =>
            -- 1. recalcul tab_mois pour l'annee courante
            -- 2. avance la date
            -- 3. cloture les prestations terminees (libere mat + employes)
            -- 4. tente de traiter les demandes en attente
            Tab_Mois := Nb_J_Mois (Date_Du_Jour.Mois, Date_Du_Jour.Annee);
            Date_Du_Jour := Passage_Lendemain (Date_Du_Jour, Tab_Mois);
            Tab_Mois := Nb_J_Mois (Date_Du_Jour.Mois, Date_Du_Jour.Annee);
            Put ("Nouveau jour : ");
            Visu_Date (Date_Du_Jour);
            New_Line;
            Fin_Presta (Tete_L, Date_Du_Jour, Tete_C, Tete_M, Tete_E);
            Traiter_Demande (File_D, Tete_M, Tete_E, Tete_L, Date_Du_Jour);
            Put_Line ("============================================");
            Put_line ("la liste des locations est : ");
            visu_presta (tete_L);

         when '0'    =>
            Put_Line ("Au revoir !");
            exit;

         when others =>
            null;
      end case;
   end loop;

end Main;
