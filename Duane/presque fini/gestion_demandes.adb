WITH Ada.Text_IO, Ada.Integer_Text_IO;
USE Ada.Text_IO, Ada.Integer_Text_IO;

PACKAGE BODY Gestion_Demandes IS


procedure Initialiser_Demandes (
      File_Demandes : out T_File_Demande;
      Arbre_Clients : in out Ptr_Client)
is
   procedure Ajouter_Demande (
         Numero       : Integer;
         Nom_Client   : String;
         Prenom_Client: String;
         Duree        : T_Duree;
         Jour         : Integer;
         Mois         : Integer;
         Annee        : Integer;
         Accomp       : T_Role;
         Type_Mat     : T_Equipement)
   is
      Nouvelle_Demande : T_Demande;
      Identite         : T_Identite;
      Nouvelle_Cellule : Ptr_Demande;
   begin
      -- Construction de l'identit� client
      Identite.Nom(1..Nom_Client'Length) := Nom_Client;
      Identite.Knom := Nom_Client'Length;
      Identite.Prenom(1..Prenom_Client'Length) := Prenom_Client;
      Identite.Kprenom := Prenom_Client'Length;

      -- Ajout du client dans l'arbre s'il n'existe pas
      if Rechercher_Client(Arbre_Clients, Identite) = null then
         Ajouter_Client(Arbre_Clients, Identite);
      end if;

      -- Remplissage des champs de la demande
      Nouvelle_Demande.Id_Demande     := Numero;
      Nouvelle_Demande.Client         := Identite;
      Nouvelle_Demande.Duree          := Duree;
      Nouvelle_Demande.Date_Demande.J := Jour;
      Nouvelle_Demande.Date_Demande.M := Mois;
      Nouvelle_Demande.Date_Demande.A := Annee;
      Nouvelle_Demande.Accompagnement := Accomp;
      Nouvelle_Demande.Type_Materiel  := Type_Mat;

      -- Cr�ation de la cellule
      Nouvelle_Cellule := new T_Cellule_Demande'(Val => Nouvelle_Demande, Suiv => null);

      -- Ajout en fin de file (FIFO)
      if File_Demandes.Tete = null then
         File_Demandes.Tete  := Nouvelle_Cellule;
         File_Demandes.Queue := Nouvelle_Cellule;
      else
         File_Demandes.Queue.Suiv := Nouvelle_Cellule;
         File_Demandes.Queue      := Nouvelle_Cellule;
      end if;
   end Ajouter_Demande;

begin
   -- Initialisation de la file vide
   File_Demandes.Tete  := null;
   File_Demandes.Queue := null;

   -- Ajout dans l'ordre chronologique des demandes (par num�ro croissant)

   -- Demande n�2
   Ajouter_Demande(2, "Personne", "Paul",     4, 19, 4, 2026, Autre,      Prise_Son);

   -- Demande n�4
   Ajouter_Demande(4, "Romeo",   "Juliette",  2, 20, 4, 2026, Ingenieur,  Camera);

   -- Demande n�5
   Ajouter_Demande(5, "Tigresse","Lily",      3, 20, 4, 2026, Ingenieur,  Camera);

   -- Demande n�8
   Ajouter_Demande(8, "Dubois",  "Josette",   2, 21, 4, 2026, Technicien, Lumiere);

   -- Demande n�9
   Ajouter_Demande(9, "Tigresse","Lily",      4, 21, 4, 2026, Technicien, Lumiere);

   -- Demande n�10
   Ajouter_Demande(10,"Rebel",   "Alicia",    2, 21, 4, 2026, Ingenieur,  Prise_Son);

   -- Le prochain num�ro de demande (variable � g�rer dans Boutique) devra �tre positionn� � 11.
END Initialiser_Demandes;

--------------------------------

   PROCEDURE Enregistrer_Demande (
         File_Demandes : IN OUT T_File_Demande;
         Arbre_Clients : IN OUT Ptr_Client;
         Date_Du_Jour  : IN     T_Date;
         Prochain_Id   : IN OUT Integer) IS

      Nouvelle_Demande : T_Demande;
      Identite_Saisie  : T_Identite;
      Client_Trouve    : Ptr_Client;
      Nouvelle_Cellule : Ptr_Demande;
      Choix_Menu       : Integer;

   BEGIN
      Put_Line("--- NOUVELLE DEMANDE DE LOCATION ---");

      Saisie_Id(Identite_Saisie);
      Client_Trouve := Rechercher_Client(Arbre_Clients, Identite_Saisie);

      IF Client_Trouve = NULL THEN
         Ajouter_Client(Arbre_Clients, Identite_Saisie);
         Put_Line("-> Nouveau client dans l'arbre.");
      ELSE
         Put_Line("-> Client existant reconnu.");
      END IF;

      Nouvelle_Demande.Client := Identite_Saisie;

      LOOP
         BEGIN
            Put("Saisir la duree de la location (1 a 10 jours) : ");
            Get(Nouvelle_Demande.Duree);
            Skip_Line;
            EXIT;
         EXCEPTION
            WHEN Constraint_Error | Data_Error =>
               Skip_Line;
               Put_Line(
                  "Erreur : la duree doit etre un nombre entier entre 1 et 10.");
         END;
      END LOOP;

      --  Saisie de l'accompagnement
      Put_Line("Type d'accompagnement souhaite :");
      Put_Line("  1 - Technicien");
      Put_Line("  2 - Ingenieur");
      Put_Line("  3 - Aucun");
      LOOP
         BEGIN
            Put("Votre choix (1-3) : ");
            Get(Choix_Menu);
            Skip_Line;

            CASE Choix_Menu IS
               WHEN 1 =>
                  Nouvelle_Demande.Accompagnement := Technicien;
                  EXIT;
               WHEN 2 =>
                  Nouvelle_Demande.Accompagnement := Ingenieur;
                  EXIT;
               WHEN 3 =>
                  Nouvelle_Demande.Accompagnement := Autre;
                  EXIT;
               WHEN OTHERS =>
                  Put_Line("Choix invalide. Veuillez saisir 1, 2 ou 3.");
            END CASE;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur : Veuillez saisir un chiffre.");
         END;
      END LOOP;

      Put_Line("Type de materiel souhaite :");
      Put_Line("  1 - Cameras");
      Put_Line("  2 - Prise de son");
      Put_Line("  3 - Sono");
      Put_Line("  4 - Projection");
      Put_Line("  5 - Lumieres");
      LOOP
         BEGIN
            Put("Votre choix (1-5) : ");
            Get(Choix_Menu);
            Skip_Line;

            CASE Choix_Menu IS
               WHEN 1 =>
                  Nouvelle_Demande.Type_Materiel := Camera;
                  EXIT;
               WHEN 2 =>
                  Nouvelle_Demande.Type_Materiel := Prise_Son;
                  EXIT;
               WHEN 3 =>
                  Nouvelle_Demande.Type_Materiel := Sono;
                  EXIT;
               WHEN 4 =>
                  Nouvelle_Demande.Type_Materiel := Projection;
                  EXIT;
               WHEN 5 =>
                  Nouvelle_Demande.Type_Materiel := Lumiere;
                  EXIT;
               WHEN OTHERS =>
                  Put_Line(
                     "Choix invalide. Veuillez saisir un chiffre entre 1 et 5.");
            END CASE;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur : Veuillez saisir un chiffre.");
         END;
      END LOOP;

      Nouvelle_Demande.Id_Demande := Prochain_Id;
      Prochain_Id := Prochain_Id + 1;
      Nouvelle_Demande.Date_Demande := Date_Du_Jour;

      Nouvelle_Cellule := NEW T_Cellule_Demande'(
         Val  => Nouvelle_Demande,
         Suiv => NULL);

      IF File_Demandes.Tete = NULL THEN
         File_Demandes.Tete  := Nouvelle_Cellule;
         File_Demandes.Queue := Nouvelle_Cellule;
      ELSE
         File_Demandes.Queue.Suiv := Nouvelle_Cellule;
         File_Demandes.Queue      := Nouvelle_Cellule;
      END IF;

      New_Line;
      Put_Line("Demande validee et placee en attente sous le numero" &
         Integer'Image(Nouvelle_Demande.Id_Demande));

   END Enregistrer_Demande;

   -- -- Visualise  toutes les demandes ----
   PROCEDURE Visualiser_Demandes (
         File_Demandes : IN     T_File_Demande) IS

      Courant : Ptr_Demande := File_Demandes.Tete;
   BEGIN
      IF Courant = NULL THEN
         Put_Line("Il n'y a actuellement aucune demande en attente.");
      ELSE
         Put_Line("--- LISTE DES DEMANDES EN ATTENTE ---");
         WHILE Courant /= NULL LOOP
            New_Line;

            Put("Demande numero : ");
            Put(Courant.Val.Id_Demande, 0);
            New_Line;

            Put("Client : ");
            Visu_Id(Courant.Val.Client);
            New_Line;

            Put("Duree : ");
            Put(Courant.Val.Duree, 0);
            Put_Line(" jours");

            Put("Date de la demande : ");
            Affichage_Date(Courant.Val.Date_Demande);

            Put("Materiel souhaite : ");
            Put_Line(T_Equipement'Image(Courant.Val.Type_Materiel));

            IF Courant.Val.Accompagnement = Autre THEN
               Put_Line("Accompagnement : Aucun");
            ELSE
               Put("Accompagnement : ");
               Put_Line(T_Role'Image(Courant.Val.Accompagnement));
            END IF;

            Courant := Courant.Suiv;
         END LOOP;
         Put_Line("-------------------------------------");
      END IF;
   END Visualiser_Demandes;


   -- Supprime une demande par son id--
   PROCEDURE Supprimer_Demande (
         File_Demandes : IN OUT T_File_Demande) IS

      Id_Cible  : Integer;
      Buffer    : Ptr_Demande := File_Demandes.Tete;
      Precedent : Ptr_Demande := NULL;
      Trouve    : Boolean     := False;
   BEGIN
      IF File_Demandes.Tete = NULL THEN
         Put_Line("La liste des demandes est vide.");
         RETURN;
      END IF;

      LOOP
         BEGIN
            Put("Saisir le numero de la demande a supprimer : ");
            Get(Id_Cible);
            Skip_Line;
            EXIT;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur : Veuillez entrer un numero valide.");
         END;
      END LOOP;

      -- Recherche de la cellule
      WHILE Buffer /= NULL AND THEN NOT Trouve LOOP
         IF Buffer.Val.Id_Demande = Id_Cible THEN
            Trouve := True;
         ELSE
            Precedent := Buffer;
            Buffer := Buffer.Suiv;
         END IF;
      END LOOP;

      IF Trouve THEN
         --si c'est le premier element
         IF Precedent = NULL THEN
            File_Demandes.Tete := Buffer.Suiv;
            --si c'est le seul element
            IF File_Demandes.Tete = NULL THEN
               File_Demandes.Queue := NULL;
            END IF;
            --element random
         ELSE
            Precedent.Suiv := Buffer.Suiv;
            -- Si c'est le dernier
            IF Buffer.Suiv = NULL THEN
               File_Demandes.Queue := Precedent;
            END IF;
         END IF;
         Put_Line("La demande numero" & Integer'Image(Id_Cible) &
            " a ete supprimee avec succes.");
      ELSE
         Put_Line("Il n'y a pas de demande en attente avec ce numero.");
      END IF;

   END Supprimer_Demande;


   PROCEDURE Supprimer_Demande_Automatique (
         File_Demandes : IN OUT T_File_Demande;
         Id_Cible      : IN     Integer) IS

      Buffer    : Ptr_Demande := File_Demandes.Tete;
      Precedent : Ptr_Demande := NULL;
      Trouve    : Boolean     := False;
   BEGIN
      -- Recherche
      WHILE Buffer /= NULL AND THEN NOT Trouve LOOP
         IF Buffer.Val.Id_Demande = Id_Cible THEN
            Trouve := True;
         ELSE
            Precedent := Buffer;
            Buffer := Buffer.Suiv;
         END IF;
      END LOOP;

      IF Trouve THEN
         IF Precedent = NULL THEN
            File_Demandes.Tete := Buffer.Suiv;
            IF File_Demandes.Tete = NULL THEN
               File_Demandes.Queue := NULL;
            END IF;
         ELSE
            Precedent.Suiv := Buffer.Suiv;
            IF Buffer.Suiv = NULL THEN
               File_Demandes.Queue := Precedent;
            END IF;
         END IF;
      END IF;
   END Supprimer_Demande_Automatique;

END Gestion_Demandes;