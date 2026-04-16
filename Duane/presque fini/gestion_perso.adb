WITH Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Id;
USE Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Id;

PACKAGE BODY Gestion_Perso IS

   PROCEDURE Initialiseperso (
         E : IN OUT T_Employe) IS
   BEGIN
      E.Nb_J_Presta   := 0;
      E.Dispo            := True;
      E.Depart           := False;
   END Initialiseperso;

   ------------------------------------------

   PROCEDURE Initialiser_Personnel (
         Pt :    OUT Ptr_Employe) IS

      PROCEDURE Ajouter_En_Tete (
            Tete      : IN OUT Ptr_Employe;
            Prenom    :        String;
            Nom       :        String;
            Le_Role   :        T_Role;
            Est_Dispo :        Boolean) IS
         Nouvel : Ptr_Employe;
         E      : T_Employe;
      BEGIN
         InitialisePerso(E);
         -- Remplissage de l'identité
         DECLARE
            Long_Prenom : CONSTANT Integer := Prenom'Length;
            Long_Nom    : CONSTANT Integer := Nom'Length;
         BEGIN
            E.Id_Employe.Prenom(1..Long_Prenom) := Prenom;
            E.Id_Employe.Kprenom := Long_Prenom;
            E.Id_Employe.Nom(1..Long_Nom)       := Nom;
            E.Id_Employe.Knom    := Long_Nom;
         END;

         E.Role           := Le_Role;
         E.Dispo          := Est_Dispo;
         E.Nb_J_Presta    := 0;
         E.Depart         := False;

         Nouvel := NEW T_Cellule_Employe'(
            Val  => E,
            Suiv => Tete);
         Tete := Nouvel;
      END Ajouter_En_Tete;

   BEGIN
      Pt := NULL;

      -- Ajout en tête dans l'ordre inverse pour conserver un ordre naturel
      Ajouter_En_Tete(Pt, "Lucie",   "Fer",     Technicien, True);   -- disponible
      Ajouter_En_Tete(Pt, "Martin",  "Guerre",  Technicien, False);  -- en prestation
      Ajouter_En_Tete(Pt, "Marc",    "Aurele",  Ingenieur,  False);  -- en prestation
      Ajouter_En_Tete(Pt, "Luc",     "Galvin",  Ingenieur,  False);  -- en prestation
   END Initialiser_Personnel;

   ---------------------------------

   PROCEDURE Ajout_Perso (
         Pt : IN OUT Ptr_Employe) IS
      S              : String (1 .. 11);
      K              : Integer;
      Position       : Integer          := 1;
      Role           : T_Role;
      Nouvel_Employe : T_Employe;
      Temp           : Ptr_Employe;
      Saisie_OK      : Boolean          := False;

   BEGIN
      Put_Line ("Vous avez ces roles de disponible");
      FOR I IN T_Role LOOP
         Put_Line (T_Role'Image(I));
      END LOOP;

      LOOP
         BEGIN
            Put ("saisir votre role : ");
            Get_Line (S, K);

            FOR I IN 1..K LOOP
               S(I) := To_Upper(S(I));
            END LOOP;

            Role := T_Role'Value(S(1..K));
            Saisie_OK := True;
            EXIT;
         EXCEPTION
            WHEN Constraint_Error =>
               Put_Line("Mauvaise valeur, recommencez. Valeurs acceptees : TECHNICIEN, INGENIEUR, AUTRE");
         END;
      END LOOP;

      InitialisePerso(Nouvel_Employe);
      Saisie_Id (Nouvel_Employe.Id_Employe);
      Nouvel_Employe.Role:=Role;

      IF Pt = NULL THEN
         Pt := NEW T_Cellule_Employe'(
            Val  => Nouvel_Employe,
            Suiv => NULL);
      ELSE
         Temp := Pt;
         WHILE Temp.Suiv /= NULL LOOP
            Temp := Temp.Suiv;
         END LOOP;
         Temp.Suiv := NEW T_Cellule_Employe'(
            Val  => Nouvel_Employe,
            Suiv => NULL);
      END IF;

      New_Line;
      Put ("Nouvel employe ajoute");
      New_Line;

   END Ajout_Perso;

   --------------------

   PROCEDURE Visu1perso (
         E : IN     T_Employe) IS
   BEGIN
      Visu_Id (E.Id_Employe);
      New_Line;
      Put ("Role : ");
      Put(T_Role'Image(E.Role));
      New_Line;
      Put("Nombre de jour de prestation : ");
      Put(E.Nb_J_Presta);
      New_Line;
      IF E.Dispo THEN
         Put ("Dsiponible");
      ELSE
         Put ("Indisponible");
      END IF;
      New_Line;
      IF E.Depart THEN
         Put ("Depart prevu");
      ELSE
         Put("Pas de depart prevu");
      END IF;
      New_Line;
      FOR I IN 1..30 LOOP
         Put ("*");
      END LOOP;
      New_Line;
   END;

   -----------------------------------

   PROCEDURE Visuttperso (
         Pt : IN     Ptr_Employe) IS
      Temp : Ptr_Employe := Pt;
   BEGIN
      WHILE Temp/=NULL LOOP
         Visu1perso(Temp.Val);
         Temp:=Temp.Suiv;
      END LOOP;
   END;

   --------------------------

   PROCEDURE VisuCEperso (
         Pt : IN     Ptr_Employe) IS
      Temp      : Ptr_Employe      := Pt;
      Nom_Saisi : T_Mots;
      Knom      : Integer;
      Role      : T_Role;
      S         : String (1 .. 50);
      K         : Integer;

   BEGIN
      Put ("Saisir le nom de l'employe : ");
      Saisie_Mots (Nom_Saisi, Knom);

      LOOP
         BEGIN
            Put ("Saisir le role de l'employe : ");
            Get_Line (S, K);

            IF K = S'Last THEN
               Skip_Line;
            END IF;

            FOR I IN 1..K LOOP
               S(I) := To_Upper(S(I));
            END LOOP;

            Role := T_Role'Value(S(1..K));
            EXIT;
         EXCEPTION
            WHEN Constraint_Error =>
               Put_Line("Mauvaise valeur, recommencez. Valeurs acceptees : TECHNICIEN, INGENIEUR, AUTRE");
         END;
      END LOOP;

      WHILE Temp /= NULL LOOP
         IF Temp.Val.Id_Employe.Nom(1..Temp.Val.Id_Employe.Knom) = Nom_Saisi(1..Knom)
               AND THEN Temp.Val.Role = Role
               THEN
            Visu1perso(Temp.Val);
            EXIT;
         ELSE
            Temp := Temp.Suiv;
         END IF;
      END LOOP;

   END;

   -----------------------------------------------

   PROCEDURE Depart_Perso (
         Pt : IN OUT Ptr_Employe) IS
      Temp      : Ptr_Employe      := Pt;
      Precedent : Ptr_Employe      := NULL;
      Trouve    : Boolean          := False;
      Nom_Saisi : T_Mots;
      Knom      : Integer;
      Role      : T_Role;
      S         : String (1 .. 50);
      K         : Integer;

   BEGIN

      Put ("Saisir le nom de l'employe : ");
      Saisie_Mots (Nom_Saisi, Knom);

      LOOP
         BEGIN
            Put ("Saisir le role de l'employe : ");
            Get_Line (S, K);

            IF K = S'Last THEN
               Skip_Line;
            END IF;

            FOR I IN 1..K LOOP
               S(I) := To_Upper(S(I));
            END LOOP;

            Role := T_Role'Value(S(1..K));
            EXIT;
         EXCEPTION
            WHEN Constraint_Error =>
               Put_Line("Mauvaise valeur, recommencez. Valeurs acceptees : TECHNICIEN, INGENIEUR, AUTRE");
         END;
      END LOOP;

      WHILE Temp /= NULL AND THEN NOT Trouve LOOP
         IF Temp.Val.Id_Employe.Nom(1..Temp.Val.Id_Employe.Knom) = Nom_Saisi(1..Knom)
               AND THEN Temp.Val.Role = Role
               THEN
            Trouve := True;
         ELSE
            Precedent := Temp;
            Temp := Temp.Suiv;
         END IF;
      END LOOP;

      IF Trouve THEN
         IF Temp.Val.Dispo THEN
            IF Precedent = NULL THEN
               Pt := Temp.Suiv;
            ELSE
               Precedent.Suiv := Temp.Suiv;
            END IF;
            Put_Line("Employe non en prestation : il quitte la societe.");
         ELSE
            Temp.Val.Depart := True;
            Put_Line("Employe actuellement en prestation.");
            Put_Line("Demande de depart enregistree.");
         END IF;
      ELSE
         Put_Line("Erreur : Employe non trouve (nom et role).");
      END IF;

   END Depart_Perso;

   -----------------------------------

   PROCEDURE Depart_Programme (
         Pt : IN OUT Ptr_Employe) IS
      Temp      : Ptr_Employe := Pt;
      Precedent : Ptr_Employe := NULL;

   BEGIN
      WHILE Temp /= NULL LOOP
         IF Temp.Val.Depart AND THEN Temp.Val.Dispo THEN
            IF Precedent = NULL THEN
               Pt := Temp.Suiv;
               Temp := Pt;
               Precedent := NULL;
            ELSE
               Precedent.Suiv := Temp.Suiv;
               Temp := Precedent.Suiv;
            END IF;
         ELSE
            Precedent := Temp;
            Temp := Temp.Suiv;
         END IF;
      END LOOP;

   END Depart_Programme;

   --------------------------------------






END Gestion_Perso;


