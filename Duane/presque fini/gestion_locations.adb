WITH Ada.Text_IO, Ada.Integer_Text_IO;
USE Ada.Text_IO, Ada.Integer_Text_IO;





----------En Gros, le package est capable de :
-- Creer une location a partir d'une demande valide, en assignant le materiel et le personnel disponibles.
-- Afficher les details d'une location sp�cifique.
-- Visualiser la liste complete des locations en cours ou archives.
-- Rechercher et afficher les locations d'un client spcifique.
-- Rechercher et afficher les prestations d'un employ spcifique.
--normalement tout marche (je te depose mon boutique avec les with use correct et les types de dclars)
PACKAGE BODY Gestion_Locations IS

   -- comapre si c'est la meme personne
   FUNCTION Meme_Id (
         A,
         B : T_Identite)
     RETURN Boolean IS
   BEGIN
      RETURN A.Nom(1..A.Knom)       = B.Nom(1..B.Knom) AND THEN
         A.Prenom(1..A.Kprenom) = B.Prenom(1..B.Kprenom);
   END Meme_Id;

   -- Cr�ation d'une location

   PROCEDURE Creer_Location (
         Liste_Loc     : IN OUT Ptr_Location;
         Demande       : IN     T_Demande;
         Date_Actuelle : IN     T_Date;
         Pack_Id       : IN     Integer;
         Employe_Id    : IN     T_Identite;
         Employe_Role  : IN     T_Role) IS

      PROCEDURE Inserer (
            Tete  : IN OUT Ptr_Location;
            Noeud : IN     Ptr_Location) IS
      BEGIN
         IF Tete = NULL OR ELSE Date_J(Noeud.Val.Date_Fin) <= Date_J(
               Tete.Val.Date_Fin) THEN
            Noeud.Suiv := Tete;
            Tete := Noeud;
         ELSE
            Inserer(Tete.Suiv, Noeud);
         END IF;
      END Inserer;

      Date_Fin : T_Date := Date_Actuelle;

   BEGIN
      FOR I IN 1 .. Demande.Duree LOOP
         Lendemain(Date_Fin);
      END LOOP;

      Inserer(Liste_Loc, NEW T_Cellule_Location'(
            Val => (
               Num_Demande   => Demande.Id_Demande,
               Client        => Demande.Client,
               Duree         => Demande.Duree,
               Date_Debut    => Date_Actuelle,
               Date_Fin      => Date_Fin,
               Attente       => Difference_Jours(Demande.Date_Demande,
                  Date_Actuelle),
               Prestataire   => Employe_Id,
               Role_Perso    => Employe_Role,
               Id_Materiel   => Pack_Id,
               Type_Materiel => Demande.Type_Materiel),
            Suiv => NULL));
   END Creer_Location;


   -- Affichage une location

   PROCEDURE Afficher_Location (
         Loc : IN     T_Location) IS
   BEGIN
      New_Line;
      Put("Location identifiant ");
      Put(Loc.Num_Demande, 0);
      New_Line;
      Put("Effectuee par le client : ");
      Visu_Id(Loc.Client);
      New_Line;
      Put("Duree : ");
      Put(Loc.Duree, 0);
      Put_Line(" jours");
      Put("Date de debut : ");
      Affichage_Date(Loc.Date_Debut);
      Put("Date de fin : ");
      Affichage_Date(Loc.Date_Fin);
      Put("Materiel loue : ");
      Put(T_Equipement'Image(Loc.Type_Materiel));
      Put(" (Pack n�");
      Put(Loc.Id_Materiel, 0);
      Put_Line(")");
      Put("Attente avant obtention : ");
      Put(Loc.Attente, 0);
      Put_Line(" jours");

      IF Loc.Role_Perso = Autre THEN
         Put_Line("Aucun accompagnement demande.");
      ELSE
         Put("Accompagnement assure par : ");
         Visu_Id(Loc.Prestataire);
         Put_Line(" (" & T_Role'Image(Loc.Role_Perso) & ")");
      END IF;
      Put_Line("----------------------------------");
   END Afficher_Location;



   PROCEDURE Recherche (
         Courant   : IN     Ptr_Location;
         Trouve    : IN OUT Boolean;
         Condition : ACCESS               FUNCTION (
         L : T_Location)
     RETURN Boolean) IS
   BEGIN
      IF Courant /= NULL THEN
         IF Condition(Courant.Val) THEN
            Afficher_Location(Courant.Val);
            Trouve := True;
         END IF;
         Recherche(Courant.Suiv, Trouve, Condition);
      END IF;
   END Recherche;


   -- Visu toute la liste

   PROCEDURE Visu_Liste_Locations (
         Pt : IN     Ptr_Location) IS
      PROCEDURE Rec (
            C : Ptr_Location) IS
      BEGIN
         IF C /= NULL THEN
            Afficher_Location(C.Val);
            Rec(C.Suiv);
         END IF;
      END Rec;
   BEGIN
      IF Pt = NULL THEN
         Put_Line("Aucune location a afficher dans cette liste.");
      ELSE
         Rec(Pt);
      END IF;
   END Visu_Liste_Locations;


   -- locations d'un client

   PROCEDURE Visu_Locations_Client (
         Pt     : IN     Ptr_Location;
         Client : IN     T_Identite) IS
      PROCEDURE Rec (
            C      :        Ptr_Location;
            Trouve : IN OUT Boolean) IS
      BEGIN
         IF C /= NULL THEN
            IF Meme_Id(C.Val.Client, Client) THEN
               Afficher_Location(C.Val);
               Trouve := True;
            END IF;
            Rec(C.Suiv, Trouve);
         END IF;
      END Rec;
      Trouve : Boolean := False;
   BEGIN
      Rec(Pt, Trouve);
      IF NOT Trouve THEN
         Put_Line("Aucune prestation trouvee pour ce client.");
      END IF;
   END Visu_Locations_Client;

   -- LOCA D'un perso

   PROCEDURE Visu_Prestations_Employe (
         Pt      : IN     Ptr_Location;
         Employe : IN     T_Identite) IS
      PROCEDURE Rec (
            C      :        Ptr_Location;
            Trouve : IN OUT Boolean) IS
      BEGIN
         IF C /= NULL THEN
            IF C.Val.Role_Perso /= Autre AND THEN Meme_Id(
                  C.Val.Prestataire, Employe) THEN
               Afficher_Location(C.Val);
               Trouve := True;
            END IF;
            Rec(C.Suiv, Trouve);
         END IF;
      END Rec;
      Trouve : Boolean := False;
   BEGIN
      Rec(Pt, Trouve);
      IF NOT Trouve THEN
         Put_Line("Aucune prestation trouvee pour cet employe.");
      END IF;
   END Visu_Prestations_Employe;


   -- check si demande faisable et le transforme en loc

   PROCEDURE Loc_Possible (
         Demande      : IN     T_Demande;
         Liste_Matos  : IN OUT Ptr_Matos;
         Liste_Perso  : IN OUT Ptr_Employe;
         Liste_Loc    : IN OUT Ptr_Location;
         Date_Du_Jour : IN     T_Date;
         Satisfaite   :    OUT Boolean) IS

      -- Pour le matos
      Temp_Matos : Ptr_Matos := Liste_Matos;
      Matos      : Ptr_Matos := NULL;
      Min_Matos  : Integer   := Integer'Last;

      -- Pour perso
      Temp_Perso  : Ptr_Employe := Liste_Perso;
      Perso       : Ptr_Employe := NULL;
      Min_J_Perso : Integer     := Integer'Last;

      -- Id perso
      Employe_Id_Vide : T_Identite;

   BEGIN
      -- cherche matos (moins us�)
      WHILE Temp_Matos /= NULL LOOP
         IF Temp_Matos.Val.Catego = Demande.Type_Materiel AND THEN
               Temp_Matos.Val.Dispo THEN

            IF Temp_Matos.Val.Nb_Utilisation < Min_Matos THEN
               Min_Matos  := Temp_Matos.Val.Nb_Utilisation;
               Matos := Temp_Matos;
            END IF;

         END IF;
         Temp_Matos := Temp_Matos.Suiv;
      END LOOP;

      -- cherche perso (le plus au chomage)
      IF Demande.Accompagnement /= Autre THEN
         WHILE Temp_Perso /= NULL LOOP
            IF Temp_Perso.Val.Role = Demande.Accompagnement AND THEN
                  Temp_Perso.Val.Dispo THEN

               IF Temp_Perso.Val.Nb_J_Presta < Min_J_Perso THEN
                  Min_J_Perso    := Temp_Perso.Val.Nb_J_Presta;
                  Perso := Temp_Perso;
               END IF;

            END IF;
            Temp_Perso := Temp_Perso.Suiv;
         END LOOP;
      END IF;

      -- boolean validation
      IF Matos /= NULL AND THEN
            (Demande.Accompagnement = Autre OR ELSE Perso /= NULL) THEN

         -- bloque le matos
         Matos.Val.Dispo := False;

         IF Perso /= NULL THEN

            --bloque le perso
            Perso.Val.Dispo := False;

            -- Cr�ation AVEC accompagnement
            Creer_Location(
               Liste_Loc     => Liste_Loc,
               Demande       => Demande,
               Date_Actuelle => Date_Du_Jour,
               Pack_Id       => Matos.Val.Id_Materiel,
               Employe_Id    => Perso.Val.Id_Employe,
               Employe_Role  => Perso.Val.Role);
         ELSE
            -- Cr�ation SANS accompagnement
            Creer_Location(
               Liste_Loc     => Liste_Loc,
               Demande       => Demande,
               Date_Actuelle => Date_Du_Jour,
               Pack_Id       => Matos.Val.Id_Materiel,
               Employe_Id    => Employe_Id_Vide,
               Employe_Role  => Autre);
         END IF;

         --reussi
         Satisfaite := True;

         -- Affichage
         Put("Demande n�");
         Put(Demande.Id_Demande, 0);
         Put_Line(" satisfaite et transformee en location.");

      ELSE
         --. Impossible pour le moment
         Satisfaite := False;

         -- Affichage personnalis� de l'�chec
         Put("La demande n�");
         Put(Demande.Id_Demande, 0);
         Put_Line(" ne peut pas etre satisfaite (Ressources manquantes).");
      END IF;

   END Loc_Possible;

   -------------------

   PROCEDURE Loc_Archivage (
         Liste_Loc_En_Cours : IN OUT Ptr_Location;
         Liste_Loc_Archives : IN OUT Ptr_Location;
         Date_Du_Jour       : IN     T_Date) IS

      Courant    : Ptr_Location := Liste_Loc_En_Cours;
      Precedent  : Ptr_Location := NULL;
      A_Archiver : Ptr_Location;


      PROCEDURE Inserer (
            Tete  : IN OUT Ptr_Location;
            Noeud : IN     Ptr_Location) IS
      BEGIN
         IF Tete = NULL OR ELSE Date_J(Noeud.Val.Date_Fin) <= Date_J(Tete.Val.Date_Fin) THEN
            Noeud.Suiv := Tete;
            Tete := Noeud;
         ELSE
            Inserer(Tete.Suiv, Noeud);
         END IF;
      END Inserer;

   BEGIN
      WHILE Courant /= NULL LOOP

         IF Date_J(Courant.Val.Date_Fin) <= Date_J(Date_Du_Jour) THEN

            A_Archiver := Courant;

            IF Precedent = NULL THEN
               -- premier de la liste
               Liste_Loc_En_Cours := Courant.Suiv;
               Courant := Liste_Loc_En_Cours;
            ELSE
               --  milieu ou fin
               Precedent.Suiv := Courant.Suiv;
               Courant := Courant.Suiv;
            END IF;

            A_Archiver.Suiv := NULL;
            Inserer(Liste_Loc_Archives, A_Archiver);

            Put("Location n�");
            Put(A_Archiver.Val.Num_Demande, 0);
            Put_Line(" terminee et archivee avec succes.");

         ELSE
            Precedent := Courant;
            Courant := Courant.Suiv;
         END IF;

      END LOOP;
   END Loc_Archivage;

-----------------------------------------

   PROCEDURE Initialiser_Locations (
         Liste_Loc :    OUT Ptr_Location) IS

      PROCEDURE Inserer_Tri_Date_Fin (
            Tete  : IN OUT Ptr_Location;
            Noeud : IN     Ptr_Location) IS
      BEGIN
         IF Tete = NULL OR ELSE Date_J(Noeud.Val.Date_Fin) <= Date_J(Tete.Val.Date_Fin) THEN
            Noeud.Suiv := Tete;
            Tete := Noeud;
         ELSE
            Inserer_Tri_Date_Fin(Tete.Suiv, Noeud);
         END IF;
      END Inserer_Tri_Date_Fin;

      PROCEDURE Ajouter_Location (
            Num_Demande   : Integer;
            Prenom_Client : String;
            Nom_Client    : String;
            Duree         : Natural;
            Jour_Deb      : Integer;
            Mois_Deb      : Integer;
            Annee_Deb     : Integer;
            Jour_Fin      : Integer;
            Mois_Fin      : Integer;
            Annee_Fin     : Integer;
            Attente       : Natural;
            Prenom_Presta : String;
            Nom_Presta    : String;
            Role_P        : T_Role;
            Id_Mat        : Integer;
            Type_Mat      : T_Equipement) IS
         Nouvelle_Loc : Ptr_Location;
         Client_Id    : T_Identite;
         Presta_Id    : T_Identite;
         Date_Deb     : T_Date;
         Date_Fi      : T_Date;
      BEGIN
         -- Construction identit� client
         Client_Id.Prenom(1..Prenom_Client'Length) := Prenom_Client;
         Client_Id.Kprenom := Prenom_Client'Length;
         Client_Id.Nom(1..Nom_Client'Length) := Nom_Client;
         Client_Id.Knom := Nom_Client'Length;

         -- Construction identit� prestataire (si accompagnement)
         IF Role_P /= Autre THEN
            Presta_Id.Prenom(1..Prenom_Presta'Length) := Prenom_Presta;
            Presta_Id.Kprenom := Prenom_Presta'Length;
            Presta_Id.Nom(1..Nom_Presta'Length) := Nom_Presta;
            Presta_Id.Knom := Nom_Presta'Length;
         ELSE
            -- Presta_Id garde ses valeurs par d�faut (cha�nes vides, longueurs 0)
            NULL;
         END IF;

         -- Construction dates
         Date_Deb.J := Jour_Deb;
         Date_Deb.M := Mois_Deb;
         Date_Deb.A := Annee_Deb;
         Date_Fi.J  := Jour_Fin;
         Date_Fi.M  := Mois_Fin;
         Date_Fi.A  := Annee_Fin;

         Nouvelle_Loc := NEW T_Cellule_Location'(
            Val => (
               Num_Demande   => Num_Demande,
               Client        => Client_Id,
               Duree         => Duree,
               Date_Debut    => Date_Deb,
               Date_Fin      => Date_Fi,
               Attente       => Attente,
               Prestataire   => Presta_Id,
               Role_Perso    => Role_P,
               Id_Materiel   => Id_Mat,
               Type_Materiel => Type_Mat),
            Suiv => NULL);

         Inserer_Tri_Date_Fin(Liste_Loc, Nouvelle_Loc);
      END Ajouter_Location;

   BEGIN
      Liste_Loc := NULL;

      -- Location n�7
      Ajouter_Location(7, "Belle",   "Bartok",   2,
         21,4,2026, 22,4,2026, 0,
         "Martin", "Guerre", Technicien, 7, Sono);

      -- Location n�1
      Ajouter_Location(1, "Aline",   "Mouton",   6,
         17,4,2026, 22,4,2026, 0,
         "Marc", "Aurele", Ingenieur, 2, Lumiere);

      -- Location n�6 (sans prestataire)
      Ajouter_Location(6, "Jean",    "Arc",      10,
         14,4,2026, 23,4,2026, 0,
         "", "", Autre, 8, Camera);

      -- Location n�3
      Ajouter_Location(3, "Lucie",   "Belle",    5,
         20,4,2026, 24,4,2026, 0,
         "Luc", "Galvin", Ingenieur, 9, Lumiere);

   END Initialiser_Locations;

END Gestion_Locations;