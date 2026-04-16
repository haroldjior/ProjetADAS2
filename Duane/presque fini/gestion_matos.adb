WITH Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Date;
USE Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Date;

PACKAGE BODY Gestion_Matos IS

   ----------------------------

   PROCEDURE Initialise (
         M : IN OUT T_Matos) IS
   BEGIN
      M.Id_Materiel :=0 ;
      Initialise_Date(M.Date_Debut);
      M.Nb_Utilisation :=0;
      M.Dispo :=True;
      M.Suppression := False;
   END Initialise;

   ------------------------

procedure Initialiser_Stock (Pt : out Ptr_Matos) is

   procedure Ajouter_En_Tete (
         Tete      : in out Ptr_Matos;
         Id        : Integer;
         Categorie : T_Equipement;
         Jour      : Integer;
         Mois      : Integer;
         Annee     : Integer;
         Disponible: Boolean)
   is
      Nouveau : Ptr_Matos;
      M       : T_Matos;
   begin
      Initialise(M);
      M.Id_Materiel    := Id;
      M.Catego         := Categorie;
      M.Date_Debut.J   := Jour;
      M.Date_Debut.M   := Mois;
      M.Date_Debut.A   := Annee;
      M.Dispo          := Disponible;
      M.Nb_Utilisation := 0;
      M.Suppression    := False;

      Nouveau := new T_Cellule_Matos'(Val => M, Suiv => Tete);
      Tete := Nouveau;
   end Ajouter_En_Tete;

begin
   Pt := null;

   -- On ajoute dans l'ordre inverse pour que le chaînage respecte l'ordre de la liste
   -- (optionnel, ici on les met dans l'ordre décroissant des IDs pour finir avec 1 en tête)

   Ajouter_En_Tete(Pt, 2,  Lumiere,    15, 4, 2026, False);
   Ajouter_En_Tete(Pt, 9,  Lumiere,    19, 4, 2026, False);
   Ajouter_En_Tete(Pt, 3,  Projection, 16, 4, 2026, True);
   Ajouter_En_Tete(Pt, 5,  Projection, 17, 4, 2026, True);
   Ajouter_En_Tete(Pt, 6,  Sono,       17, 4, 2026, True);
   Ajouter_En_Tete(Pt, 7,  Sono,       18, 4, 2026, False);
   Ajouter_En_Tete(Pt, 1,  Camera,     15, 4, 2025, True);
   Ajouter_En_Tete(Pt, 4,  Camera,     17, 4, 2026, True);
   Ajouter_En_Tete(Pt, 8,  Camera,     18, 4, 2026, False);

   -- Le prochain ID sera bien 10 (max actuel = 9)
END Initialiser_Stock;

---------------------------------------

   PROCEDURE Ajout_Lot (
         Pt : IN OUT Ptr_Matos;
         D  : IN OUT T_Date) IS
      S             : String (1 .. 10);
      K             : Integer;
      Position      : Integer          := 1;
      Prod          : T_Equipement;
      Nouveau_Matos : T_Matos;
      Temp          : Ptr_Matos;
      Max_Id        : Integer          := 0;
      Nouvel_Id     : Integer;

   BEGIN
      Put ("vous aurez le choix entre ces produits");
      New_Line;
      FOR I IN T_Equipement  LOOP
         Put (T_Equipement'Image((I))) ;
         New_Line;
      END LOOP;
      LOOP
         BEGIN
            Put ("saisir le type de produit");
            New_Line;
            Get_Line (S,K);
            Prod := T_Equipement'Value(S(1..K));
            EXIT ;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur de saisie, recommencez");

            WHEN Constraint_Error =>
               Skip_Line;
               Put_Line("Mauvaise valeur, recommencez");
         END;
      END LOOP;

      IF Pt /= NULL THEN
         Temp := Pt;
         WHILE Temp /= NULL LOOP
            IF Temp.Val.Id_Materiel > Max_Id THEN
               Max_Id := Temp.Val.Id_Materiel;
            END IF;
            Temp := Temp.Suiv;
         END LOOP;
      END IF;

      Nouvel_Id := Max_Id + 1;

      Initialise(Nouveau_Matos);
      Nouveau_Matos.Catego := Prod;
      Nouveau_Matos.Date_Debut := D;
      Nouveau_Matos.Id_Materiel := Nouvel_Id;

      IF Pt = NULL THEN
         Pt := NEW T_Cellule_Matos'(
            Val  => Nouveau_Matos,
            Suiv => NULL);
      ELSE
         Temp := Pt;
         WHILE Temp.Suiv /= NULL LOOP
            Temp := Temp.Suiv;
         END LOOP;
         Temp.Suiv := NEW T_Cellule_Matos'(
            Val  => Nouveau_Matos,
            Suiv => NULL);
      END IF;

      New_Line;
      Put ("Matériel ajouté avec l'identifiant : ");
      Put (Nouvel_Id);
      New_Line;

   END Ajout_Lot;

   ------------------------

   PROCEDURE Visu1prod (
         M : IN     T_Matos) IS

   BEGIN
      Put ("Categorie :");
      Put (T_Equipement'Image(M.Catego));
      New_Line;
      Put ("Identifiant :");
      Put (M.Id_Materiel);
      New_Line;
      Put("date_debut :");
      Affichage_Date (M.Date_Debut);
      New_Line;
      Put("nombre d'utilisation:");
      Put(M.Nb_Utilisation);
      New_Line;
      IF M.Dispo THEN
         Put ("Disponible");
      ELSE
         Put("Indisponible");
      END IF;
      New_Line;
      IF M.Suppression THEN
         Put("Suppression prevue");
      ELSE
         Put("Pas de supression prevue");
      END IF;
      New_Line;
      FOR I IN 1..30 LOOP
         Put ("*");
      END LOOP;
      New_Line;
   END;

   ----------------------------

   PROCEDURE VisuTTProd (
         Pt : IN     Ptr_Matos) IS
      Temp : Ptr_Matos := Pt;

   BEGIN
      WHILE Temp/=NULL LOOP
         Visu1prod(Temp.Val);
         Temp:=Temp.Suiv;
      END LOOP;

   END Visuttprod;

   ----------------------------

   PROCEDURE Visudispo (
         Pt : IN     Ptr_Matos) IS
      Temp : Ptr_Matos := Pt;
   BEGIN
      WHILE Temp/=NULL LOOP
         IF Temp.Val.Dispo THEN
            Visu1prod(Temp.Val);
         END IF;
         Temp:=Temp.Suiv;
      END LOOP;
   END;

   ----------------------

   PROCEDURE Sup1pack (
         Pt : IN OUT Ptr_Matos) IS
      Temp      : Ptr_Matos        := Pt;
      Precedent : Ptr_Matos        := NULL;
      Trouve    : Boolean          := False;
      Equip     : T_Equipement;
      Id        : Integer;
      S         : String (1 .. 10);
      K         : Integer;

   BEGIN

      LOOP
         BEGIN
            Put ("Saisir l'identifiant :");
            Get (Id);
            Skip_Line;
            EXIT WHEN (Id)>0 ;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line ("erreur de saisie, recommencez");
         END;
      END LOOP;

      LOOP
         BEGIN
            Put ("saisir le type de produit");
            New_Line;
            Get_Line (S,K);
            Equip := T_Equipement'Value(S(1..K));
            EXIT ;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur de saisie, recommencez");

            WHEN Constraint_Error =>
               Skip_Line;
               Put_Line("Mauvaise valeur, recommencez");
         END;
      END LOOP;

      WHILE Temp /= NULL AND THEN NOT Trouve LOOP
         IF Temp.Val.Catego = Equip AND THEN Temp.Val.Id_Materiel = Id THEN
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
            Put_Line("Matériel supprimé définitivement.");
         ELSE
            Temp.Val.Suppression := True;
            Put_Line("Matériel actuellement en location.");
            Put_Line("Demande de suppression enregistrée.");
            Put_Line("Le matériel sera supprimé à la fin de la prestation.");
         END IF;
      ELSE
         Put_Line("Erreur : Matériel non trouvé (catégorie et identifiant).");
      END IF;

   END Sup1pack;

   --------------------------

   PROCEDURE Suppression_Programmee (
         Pt : IN OUT Ptr_Matos) IS
      Temp      : Ptr_Matos := Pt;
      Precedent : Ptr_Matos := NULL;

   BEGIN
      WHILE Temp /= NULL LOOP
         IF Temp.Val.Suppression AND THEN Temp.Val.Dispo THEN
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

   END Suppression_Programmee;

   ----------------------

   PROCEDURE Sup_Avant_Date (
         Pt : IN OUT Ptr_Matos) IS
      Temp        : Ptr_Matos := Pt;
      Precedent   : Ptr_Matos := NULL;
      Date_Limite : T_Date;
   BEGIN
      Put ("Veuillez rentrer la date limite :");
      Saisie_Date (Date_Limite);
      WHILE Temp /= NULL LOOP
         IF Difference_Jours(Temp.Val.Date_Debut, Date_Limite) < 0 THEN
            IF Temp.Val.Dispo THEN
               IF Precedent = NULL THEN
                  Pt := Temp.Suiv;
                  Temp := Pt;
                  Precedent := NULL;
               ELSE
                  Precedent.Suiv := Temp.Suiv;
                  Temp := Precedent.Suiv;
               END IF;
            ELSE
               Temp.Val.Suppression := True;
               Precedent := Temp;
               Temp := Temp.Suiv;
            END IF;
         ELSE
            Precedent := Temp;
            Temp := Temp.Suiv;
         END IF;
      END LOOP;

   END Sup_Avant_Date;

----------------------


END Gestion_Matos;



