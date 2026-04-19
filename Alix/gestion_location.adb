with ada.text_io, ada.integer_text_io,gestion_date,gestion_materiel,gestion_demandes,gestion_client,gestion_identite,gestion_personnel;
use  ada.text_io, ada.integer_text_io,gestion_date,gestion_materiel,gestion_demandes,gestion_client,gestion_identite,gestion_personnel;

PACKAGE BODY Gestion_Location IS


   PROCEDURE Inserer(Tetel : IN OUT T_ptr_location;
      Ids : Natural;
      nump: integer;
      Client : T_identite;
      Duree : Integer;
      jd: integer;
      Md : T_Nom_Mois;
      Ad : Integer;
      jf: integer;
      Mf : T_Nom_Mois;
      Af : Integer;
      Duree_Attente : Integer;
      Accompagnant:T_Accompagnement;
      noma:T_identite;
      materiel:T_type_materiel) is
     Nouveau : T_location;
      Dd: T_Date;
      Df:T_date;
  BEGIN
    Dd.J := Jd;
    Dd.M := Md;
    Dd.Annee := Ad;
    Df.J := Jf;
    Df.M := Mf;
    Df.Annee := Af;
     Nouveau.Id := Ids;
     nouveau.num:=nump;
    Nouveau.client := Client;
    Nouveau.Date_D :=Dd;
    Nouveau.Date_F :=Df;
    Nouveau.Duree_Attente :=duree_attente;
    nouveau.accompagnant:=accompagnant;
    Nouveau.Materiel :=Materiel;
    nouveau.noma:=noma;
    Nouveau.Duree:=Duree;
    Inserer_Recursive(Tetel, Nouveau);


  END Inserer;

PROCEDURE Inserer_Recursive(tete : IN OUT T_Ptr_Location; Nouv : IN T_Location) IS
BEGIN

   IF tete = NULL OR ELSE AvantD(Nouv.Date_F, tete.Val.Date_F) THEN
      tete := new T_Cell_Location'(Nouv, tete);
   ELSE

      Inserer_Recursive(tete.Suiv, Nouv);
   END IF;
END Inserer_Recursive;

  PROCEDURE Charger_Donnees_L(Tetel : IN OUT T_Ptr_Location) IS
   Id_C : T_identite;
   Id_A : T_identite;

  BEGIN
     id_C.Nom.Mot(1..6) := "Bartok"; Id_C.Nom.K := 6;
   Id_C.Prenom.Mot(1..5) := "Belle"; Id_C.Prenom.K := 5;
   Id_A.Nom.Mot(1..6) := "Guerre"; Id_A.Nom.K := 6;
   Id_A.Prenom.Mot(1..6) := "Martin"; Id_A.Prenom.K := 6;
   Inserer(Tetel, 7,7, Id_C, 2, 21, Avril, 2026, 22, Avril, 2026, 0, Technicien, Id_A, Sono);
id_C.Nom.Mot(1..5) := "Aline"; Id_C.Nom.K := 5;
   Id_C.Prenom.Mot(1..6) := "Mouton"; Id_C.Prenom.K := 6;
   Id_A.Nom.Mot(1..6) := "Aurele"; Id_A.Nom.K := 6;
   Id_A.Prenom.Mot(1..4) := "Marc"; Id_A.Prenom.K := 4;
   Inserer(Tetel, 1,2, Id_C, 6, 17, Avril, 2026, 22, Avril, 2026, 0, Ingenieur, Id_A, Lumiere);
id_C.Nom.Mot(1..4) := "jean"; Id_C.Nom.K := 4;
   Id_C.Prenom.Mot(1..3) := "arc"; Id_C.Prenom.K := 3;
   Id_A.Nom.Mot(1..2) := "  "; Id_A.Nom.K := 2;
   Id_A.Prenom.Mot(1..2) := "  "; Id_A.Prenom.K := 2;
   Inserer(Tetel, 6,8, Id_C, 10, 14, Avril, 2026, 23, Avril, 2026, 0, Aucun, Id_A, Camera);

    id_C.Nom.Mot(1..5) := "Belle"; Id_C.Nom.K := 5;
   Id_C.Prenom.Mot(1..5) := "Lucie"; Id_C.Prenom.K := 5;
   Id_A.Nom.Mot(1..6) := "Galvin"; Id_A.Nom.K := 6;
   Id_A.Prenom.Mot(1..3) := "Luc"; Id_A.Prenom.K := 3;
   Inserer(Tetel, 3,9, Id_C, 5, 20, Avril, 2026, 24, Avril, 2026, 0, ingenieur, Id_A, lumiere);


end Charger_Donnees_l;

  PROCEDURE Visul(Tetel: IN T_Ptr_Location) IS
     p:t_ptr_location:=tetel;
  BEGIN
     WHILE P/=NULL LOOP
        Put("numero : "); Put(" "); Put(P.Val.Id,1);New_Line;
        Put("numero du pack : "); Put(" "); Put(P.Val.num,1);New_Line;

        put("nom du client");new_line;
        affi_identite(p.val.client);
        Put("voici la date de debut de location");new_line;
        Visudate(P.Val.Date_D);Put(" ");New_Line;
        Put("voici la date de fin de location");new_line;
        Visudate(P.Val.Date_F);put(" ");new_line;
        Put("duree");Put(" ");Put(P.Val.Duree,1);New_Line;
        Put("duree d'attente");Put(" ");Put(P.Val.Duree_Attente,1);New_Line;
        Put("nom du prestataire:");New_Line;
        Affi_Identite(P.Val.Noma);
        Put("categorie du materiel");
        put(" ");Put(T_Type_Materiel'Image(P.Val.Materiel));new_line;
        New_Line;
        put_line("------------------------");
        P:=P.Suiv;
     END LOOP;
  END Visul;
  FUNCTION Calculfacture(L:T_Location) RETURN Integer IS
     PrixM:Integer:=0;
     Prixp:Integer:=0;
     total:integer;
  BEGIN
     CASE L.Materiel IS
        WHEN Camera     => PrixM := 412;
        WHEN Plateforme  => PrixM := 335;
        WHEN Sono       => PrixM := 125;
        WHEN Projecteur => PrixM := 120;
        WHEN Lumiere    => PrixM := 110;
        WHEN others     => PrixM :=0;
     END CASE;

     IF L.Accompagnant/=Aucun THEN
        IF L.Accompagnant=Ingenieur THEN
           Prixp:=230;
        ELSif L.Accompagnant=Technicien THEN
           PrixP:=140;
        END IF;
     END IF;

     Total := (PrixM + PrixP) * (L.Duree);

     IF L.Duree >= 8 THEN
        Total:=Integer(Total-Total*5/100);
     END IF;

     RETURN Total;
  END Calculfacture;

PROCEDURE Affi_Une_Location(Loc : IN T_Location) IS
BEGIN
    Put("Numero : "); Put(Loc.Id, 1); New_Line;
    Put("Nom du client : "); Affi_Identite(Loc.Client);
    Put("Date debut : "); Visudate(Loc.Date_D); New_Line;
    Put("Date fin : "); Visudate(Loc.Date_F); New_Line;
    Put("Duree : "); Put(Loc.Duree, 1); New_Line;
   Put("Prestataire : "); Affi_Identite(Loc.Noma);
   Put("numero du pack : "); put(Loc.num);
    Put("Materiel : "); Put(T_Type_Materiel'Image(Loc.Materiel)); New_Line;
    Put_Line("------------------------");
END Affi_Une_Location;


PROCEDURE Afficher_Loc_Client(Liste : IN T_Ptr_Location;
                                         Client_Cherche : IN T_Identite) IS
   P : T_Ptr_Location := Liste;
   B1, B2 : Boolean;
BEGIN
   WHILE P /= NULL LOOP
      Meme_NP(P.Val.Client.Nom, Client_Cherche.Nom, B1);
      Meme_NP(P.Val.Client.Prenom, Client_Cherche.Prenom, B2);
      IF B1 AND B2 THEN
         Affi_Une_Location(P.Val);
      END IF;
      P := P.Suiv;
   END LOOP;
END Afficher_Loc_Client;


PROCEDURE Visu_Locations_Client(L_En_Cours : IN T_Ptr_Location;
                                L_Archives : IN T_Ptr_Location;
                                Client_Cherche : IN T_Identite) IS
BEGIN
   New_Line;
   Put_Line(" LOCATIONS EN COURS ");
   Afficher_Loc_Client(L_En_Cours, Client_Cherche);
   New_Line;
   Put_Line(" LOCATIONS ARCHIVEES ");
   Afficher_Loc_Client(L_Archives, Client_Cherche);
   New_Line;
END Visu_Locations_Client;



PROCEDURE Afficher_Loc_Employe(Liste  : IN T_Ptr_Location; ID_Emp : IN T_Identite) IS
   P : T_Ptr_Location := Liste;
   B1, B2 : Boolean;
BEGIN
   WHILE P /= NULL LOOP
      Meme_NP(P.Val.Noma.Nom, ID_Emp.Nom, B1);
      Meme_NP(P.Val.Noma.Prenom, ID_Emp.Prenom, B2);

      IF B1 AND B2 THEN
         Affi_Une_Location(P.Val);
      END IF;

      P := P.Suiv;
   END LOOP;
END Afficher_Loc_Employe;

PROCEDURE Visu_Par_Employe(L_En_Cours : IN T_Ptr_Location;
                           L_Archives : IN T_Ptr_Location;
                           Nom_Emp    : IN T_Identite) IS
BEGIN
   New_Line;
   Put("LOCATIONS ACCOMPAGNEES PAR : ");
   Affi_Identite(Nom_Emp);
   New_Line;
   Put_Line("EN COURS");
   Afficher_Loc_Employe(L_En_Cours, Nom_Emp);
   Put_Line(" (ARCHIVES)");
   Afficher_Loc_Employe(L_Archives, Nom_Emp);
   New_Line;
END Visu_Par_Employe;

PROCEDURE Archivages(Liste_EC   : IN OUT T_Ptr_Location;    Liste_Arch : IN OUT T_Ptr_Location; Date_Ref : IN T_Date; Racine_C   : IN OUT T_Ptr_Client; Liste_M : IN OUT T_Ptr_Materiel; Liste_P : IN OUT T_Ptr_Pers) IS
   A_Archiver : T_Ptr_Location;
   Prix : Integer;

BEGIN

   IF Liste_EC /= NULL THEN
      IF AvantD(Liste_EC.Val.Date_F, Date_Ref) THEN
         Prix := Calculfacture(Liste_EC.Val);
         Mettre_A_Jour_Client(Racine_C, Liste_EC.Val.Client, Prix);
         Mettre_A_Jour_Materiel(Liste_M,Liste_EC.Val.num,Liste_EC.Val.Duree);
         Liberer_Pack(Liste_M, Liste_EC.Val.num);
         IF Liste_EC.Val.Accompagnant /= Aucun THEN

            Ajouter_Jours_Et_Liberer(Liste_P, Liste_EC.Val.Noma, Liste_EC.Val.Duree);

         END IF;

        A_Archiver := Liste_EC;
        Liste_EC := Liste_EC.Suiv;
        A_Archiver.Suiv := Liste_Arch;
        Liste_Arch := A_Archiver;
        Archivages(Liste_EC, Liste_Arch, Date_Ref, Racine_C, Liste_M, Liste_P);
      ELSE

    Archivages(Liste_EC.Suiv, Liste_Arch, Date_Ref, Racine_C, Liste_M, Liste_P);
      END IF;
   END IF;


   END Archivages;



pROCEDURE Traiter_File_Demandes(
    F_Demandes : IN OUT T_File_Demande;
    L_En_Cours : IN OUT T_Ptr_Location;
    Liste_M    : IN OUT T_Ptr_Materiel;
    Liste_P    : IN OUT T_Ptr_Pers;
    Date_Jour  : IN T_Date) IS

   D : T_demande;

   Faux : T_File_Demande;
   P_Mat : T_Ptr_Materiel;
   P_Pers : T_Ptr_Pers;
   ok:boolean;
   Ok_Mat, Ok_Pers : Boolean;

BEGIN
   Faux.Tete:=NULL;
   Faux.fin:=null;
    LOOP
      Defiler(F_Demandes, D,Ok);
      exit when not ok;
      P_Mat := Meuilleurpa(Liste_M, D.Materiel);
      IF P_MAT /= NULL THEN
         Ok_MAT := True;
      ELSE
         Ok_MAT := False;
      END IF;
        IF D.Accompagnement /= Aucun THEN
            P_Pers := meuilleurp(Liste_P, (D.Accompagnement = Ingenieur));
         IF P_Pers /= NULL THEN
            Ok_Pers := True;
         ELSE
            Ok_Pers := False;
         END IF;
        ELSE
            P_Pers := NULL;
            Ok_Pers := True;
      END IF;
        IF Ok_Mat AND Ok_Pers THEN
            P_Mat.Val.Disponibilite := False;
            IF P_Pers /= NULL THEN
                P_Pers.Val.dispo := False;

         END IF;
         D.attente:=Differenced(Date_Jour,D.date_dem);
         Inserer_De_Demande(L_En_Cours, D, P_Mat.Val.Id, P_Pers, Date_Jour,D.Attente);
         new_line;
         Put("Demande satisfaite numero: ");put(D.id,1);new_line;
        ELSE

         Enfilerd(Faux, D);
        END IF;
   END LOOP;
    F_Demandes := Faux;
END Traiter_File_Demandes;


PROCEDURE Inserer_De_Demande(
    Tetel      : IN OUT T_Ptr_Location;
   D          : IN T_Demande;
   nump: in integer;

    P_Pers     : IN T_Ptr_Pers;
   Date_Debut : IN T_Date;
      attente_F: in integer) IS

    Date_Fin : T_Date;
   Identite_Nulle : T_Identite;
   no:T_identite;
BEGIN

    Date_Fin := Date_Debut;
    FOR I IN 1..D.Duree-1 LOOP
       date_fin:=lendemain(Date_Fin);
    END LOOP;
    IF P_Pers = NULL THEN
        Identite_Nulle.Nom.K := 0;
        Identite_Nulle.Prenom.K := 0;
    END IF;
   IF P_Pers /= NULL
         THEN
      No:=P_Pers.Val.identite;

      ELSE
      no:=Identite_Nulle;
      END IF;
    Inserer(
      Tetel,
         D.id,
         NumP,
         D.Client,
        D.Duree,
       Date_Debut.J,
       Date_Debut.M,
        Date_Debut.Annee,
         Date_Fin.J,
        Date_Fin.M,
         Date_Fin.Annee,
         attente_F,
         D.Accompagnement,
        no,
        D.Materiel
    );
END Inserer_De_Demande;


procedure lendemaind(Date_j   : IN OUT T_Date;
    L_En_Cours : IN OUT T_Ptr_Location;
   L_Archive  : IN OUT T_Ptr_Location;
   Racine_C   : IN OUT T_Ptr_Client;
    F_Demandes : IN OUT T_File_Demande;
    Liste_M    : IN OUT T_Ptr_Materiel;
   Liste_P    : IN OUT T_Ptr_Pers
   ) IS

BEGIN
   Date_J:=Lendemain(Date_J);
   put_line("passage au jour suivant");
   VisuDate(Date_j);
   put_line("---------");
   Archivages(L_En_Cours, L_Archive, date_j, Racine_C, Liste_M, Liste_P);
   Traiter_File_Demandes(F_Demandes, L_En_Cours, Liste_M, Liste_P, Date_J);
   Put_Line("mise a jours terminee");
END Lendemaind;

PROCEDURE Ajouter_Jours_Et_Liberer(Liste : IN T_Ptr_Pers; ID_Cherche : T_Identite; Jours : Integer) IS
    P : T_Ptr_Pers := Liste;
    B1, B2 : Boolean;
BEGIN
    WHILE P /= NULL LOOP
        Meme_NP(P.Val.identite.Nom, ID_Cherche.Nom, B1);
        Meme_NP(P.Val.identite.Prenom, ID_Cherche.Prenom, B2);
        IF B1 AND B2 THEN
            P.Val.Nb_J_presta := P.Val.Nb_J_presta + Jours;
            P.Val.dispo := True;
            EXIT;
        END IF;
        P := P.Suiv;
    END LOOP;
END Ajouter_Jours_Et_Liberer;


END Gestion_Location;

