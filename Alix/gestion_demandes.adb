with ada.text_io, ada.integer_text_io,gestion_date,gestion_materiel,gestion_identite,gestion_client;
USE  Ada.Text_Io, Ada.Integer_Text_Io,Gestion_Date,gestion_materiel,gestion_identite,gestion_client;

PACKAGE BODY Gestion_Demandes IS


   FUNCTION Max_IdF(F: T_File_Demande) RETURN Integer is
   Maxid:Integer:=0;
   P:T_Ptr_Demande:=F.Tete;
   BEGIN
      WHILE P/=NULL LOOP
         IF P.Val.Id>Maxid THEN
            Maxid:=P.Val.Id;
         END IF;
         P:=P.Suiv;
      END LOOP;
      RETURN Maxid+1;
   END Max_IdF;


   PROCEDURE Enfilerd(F: in out T_File_Demande ;D: in out T_Demande) IS

   BEGIN
      IF F.Tete=NULL THEN
         F.Tete:=NEW T_Cell_Demande'(D,null);
         F.Fin:=F.Tete;
      ELSE
         F.Fin.Suiv:=NEW T_Cell_Demande'(D,NULL);
         F.Fin:=F.Fin.Suiv;
      END IF;
   END Enfilerd;

   PROCEDURE Enfilern(F: in out T_File_Demande ;D: in out T_Demande) IS

   BEGIN
      D.id:=Max_IdF(F);
      IF F.Tete=NULL THEN
         F.Tete:=NEW T_Cell_Demande'(D,null);
         F.Fin:=F.Tete;
      ELSE
         F.Fin.Suiv:=NEW T_Cell_Demande'(D,NULL);
         F.Fin:=F.Fin.Suiv;
      END IF;
   END Enfilern;


   PROCEDURE ChargerFa(F: in out T_File_Demande) IS
      D:T_Demande;
   BEGIN

      D.id:=2;
      D.Duree:=4;
      D.Date_Dem.J:=19;
      D.Date_Dem.M:=Avril;
      D.Date_Dem.Annee:=2026;
      D.Accompagnement:=Aucun;
      D.Materiel:=Sono;
      D.Client.Nom.Mot(1..8) := "Personne";
      D.Client.Nom.K := 8;
      D.Client.Prenom.Mot(1..4) := "Paul";
      D.Client.Prenom.K := 4;
      Enfilerd(F,D);
      D.id:=4;
      D.Duree:=2;
      D.Date_Dem.J:=20;
      D.Date_Dem.M:=Avril;
      D.Date_Dem.Annee:=2026;
      D.Accompagnement:=ingenieur;
      D.Materiel:=Camera;
      D.Client.Nom.Mot(1..5) := "Romeo";
      D.Client.Nom.K := 5;
      D.Client.Prenom.Mot(1..8) := "Juliette";
      D.Client.Prenom.K := 8;
      Enfilerd(F,D);
      D.id:=5;
      D.Duree:=3;
      D.Date_Dem.J:=20;
      D.Date_Dem.M:=Avril;
      D.Date_Dem.Annee:=2026;
      D.Accompagnement:=ingenieur;
      D.Materiel:=Camera;
      D.Client.Nom.Mot(1..8) := "Tigresse";
      D.Client.Nom.K := 8;
      D.Client.Prenom.Mot(1..4) := "Lily";
      D.Client.Prenom.K := 4;
      Enfilerd(F,D);
      D.id:=8;
      D.Duree:=2;
      D.Date_Dem.J:=21;
      D.Date_Dem.M:=Avril;
      D.Date_Dem.Annee:=2026;
      D.Accompagnement:=technicien;
      D.Materiel:=Lumiere;
      D.Client.Nom.Mot(1..6) := "Dubois";
      D.Client.Nom.K := 6;
      D.Client.Prenom.Mot(1..7) := "Josette";
      D.Client.Prenom.K := 7;
      Enfilerd(F,D);
      D.id:=9;
      D.Duree:=4;
      D.Date_Dem.J:=21;
      D.Date_Dem.M:=Avril;
      D.Date_Dem.Annee:=2026;
      D.Accompagnement:=technicien;
      D.Materiel:=Lumiere;
      D.Client.Nom.Mot(1..8) := "Tigresse";
      D.Client.Nom.K := 8;
      D.Client.Prenom.Mot(1..4) := "Lily";
      D.Client.Prenom.K := 4;
      Enfilerd(F,D);
      D.id:=10;
      D.Duree:=2;
      D.Date_Dem.J:=21;
      D.Date_Dem.M:=Avril;
      D.Date_Dem.Annee:=2026;
      D.Accompagnement:=ingenieur;
      D.Materiel:=Sono;
      D.Client.Nom.Mot(1..5) := "Rebel";
      D.Client.Nom.K := 5;
      D.Client.Prenom.Mot(1..6) := "Alicia";
      D.Client.Prenom.K := 6;
      Enfilerd(F,D);
      --TYPE T_Type_Materiel IS(Camera, Plateforme, Sono,Projecteur,Lumiere);

   END ChargerFa;

   PROCEDURE Defiler(F: IN OUT T_File_Demande; Recup: OUT  T_Demande; Ok: OUT Boolean) IS
   BEGIN
      IF F.Tete=NULL THEN
         Ok:=False;
      ELSE
         Ok:=True;
         recup:=F.tete.val;
         F.Tete:=F.Tete.Suiv;
      END IF;
      IF F.Tete=NULL THEN
         F.Fin:=NULL;
      END IF;
   END Defiler;

   PROCEDURE VisuD(D: IN T_Demande) IS
   BEGIN
      Put("identite:");Put(" ");Put(D.Id,1);New_Line;
      affi_identite(D.client);
      Put("duree: ");Put(" ");Put(D.Duree,1);Put(" ");Put("jours");New_Line;
      visudate(D.date_dem);new_line;
      Put("type d'accompagnement: ");Put(" ");Put(T_accompagnement'image(D.Accompagnement));New_Line;
      Put("type de materiel: ");Put(" ");Put(T_Type_Materiel'Image(D.Materiel));New_Line;
      new_line;
   END VisuD;

   PROCEDURE VisuF(F: IN  T_File_Demande) IS
      Faux:T_File_Demande:=F;
      Recup:T_Demande;
      Ok:Boolean;
   BEGIN
      LOOP
         Defiler(Faux,Recup,Ok);
         EXIT WHEN ok=false;
         VisuD(Recup);
      END LOOP;
      END VisuF;

   PROCEDURE Nouveldemande(F: in out T_File_Demande ;AC : in out T_ptr_Client; D: IN out T_Demande) IS
      Choix:Integer;
      Choixp:Integer;
      Cl: T_Client;
      existe:boolean;
   BEGIN
      Put("identification du client");new_line;
      Saisie_Client(Cl);
      Existe:=Client_Existe(AC,Cl);
      if existe=false then
         Ajout_Client(AC,Cl);
      ELSE
         NULL;
      END IF;
      D.Client := Cl.client;
      Put("entrez la duree:   ");Get(D.Duree);Skip_Line;New_Line;
      Saisirdate(D.Date_Dem);
      Put("entrez le type d'accompagnement ");New_Line;
      Put("1-aucun");New_Line;
      Put("2-ingenieur");New_Line;
      Put("3-technicien");New_Line;
      Get(Choix);Skip_Line;
      CASE Choix IS
         WHEN 1 => D.Accompagnement:= Aucun;
         WHEN 2 => D.Accompagnement:= Ingenieur;
         WHEN 3 => D.Accompagnement:= Technicien;
         WHEN OTHERS =>
            Put_Line("choix non propose");
      END CASE;
      Put("entrez le numero du materiel"); New_Line;
      Put_Line(" 1 - Camera");
      Put_Line(" 2 - Plateforme");
      Put_Line(" 3 - Sono");
      Put_Line(" 4 - Projecteur");
      Put_Line(" 5 - Lumiere");
      Put_Line("Votre choix : ");
      Get(Choixp); Skip_Line;
      CASE Choixp IS
         when 1 => D.materiel := Camera;
         when 2 => D.materiel := Plateforme;
         when 3 => D.materiel := Sono;
         when 4 => D.materiel := Projecteur;
         WHEN 5 => D.materiel := Lumiere;
         WHEN OTHERS =>
               Put("choix non valide veuillez recommencez");
      END CASE;
      enfilern(F,D);
   END Nouveldemande;



   PROCEDURE Supp(Tete: IN OUT T_Ptr_Demande; N : IN Integer; Trouve : OUT Boolean) IS
   BEGIN
      IF Tete = NULL THEN
         Trouve := False;
      ELSIF tete.Val.Id = N THEN
         Tete:= Tete.Suiv;
         Trouve := True;
      ELSE
         Supp(tete.Suiv, N, Trouve);
   END IF;
   END Supp;

   PROCEDURE Suppdl(F: IN OUT T_File_Demande ;N: IN Integer) IS
      Ok : Boolean := False;
   BEGIn
      Supp(F.tete,N,ok);
      IF ok THEN
         Put_Line("La demande a ete supprimee.");
         IF F.Tete = NULL THEN
         F.Fin := NULL;
         END IF;
      ELSE
         Put("Il n'y a pas de demande en attente avec le numero ");
         END IF;
   END Suppdl;

END Gestion_Demandes;


