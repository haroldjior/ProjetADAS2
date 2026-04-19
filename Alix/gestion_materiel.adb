with ada.text_io, ada.integer_text_io,gestion_date;
USE  Ada.Text_Io, Ada.Integer_Text_Io,Gestion_Date;

PACKAGE BODY Gestion_Materiel IS


   FUNCTION Maxid(Tete: T_Ptr_Materiel) RETURN Integer IS
      P: T_Ptr_Materiel:=tete;
      max:integer:=0;
   BEGIN
      WHILE P/=NULL LOOP
         IF P.Val.Id>Max THEN
            Max:=P.Val.Id;
         END IF;
         p:=p.suiv;
      END LOOP;
      RETURN Max+1;
   END Maxid;


   PROCEDURE Ajoutpack (Tete: IN OUT T_Ptr_Materiel) IS
      nouveau: T_Materiel;
      Choixp: integer;
      Choixd:Character;
      choixs:character;
   BEGIN
      Nouveau.Id:=Maxid(Tete);new_line;
      Put("le pack attribue est : "); Put(Nouveau.Id,1);new_line;
      Put_line("entrez le numero du pack voulue");
      Put_Line(" 1 - Camera");
      Put_Line(" 2 - Plateforme");
      Put_Line(" 3 - Sono");
      Put_Line(" 4 - Projecteur");
      Put_Line(" 5 - Lumiere");
      Put_Line("Votre choix : ");
      Get(Choixp); Skip_Line;
      CASE Choixp IS
         when 1 => Nouveau.mat := Camera;
         when 2 => Nouveau.mat := Plateforme;
         when 3 => Nouveau.mat := Sono;
         when 4 => Nouveau.mat := Projecteur;
         WHEN 5 => Nouveau.Mat := Lumiere;
         WHEN OTHERS =>
               Put("choix non valide veuillez recommencez");

      END CASE;
      Nouveau.Nb_J_Utilisation:=0;

      Put_Line("es ce que le pack est disponible O/N");
      Get(Choixd);Skip_Line;
      IF Choixd='o' or choixd='O' THEN
         Nouveau.Disponibilite:=True;
      ELSE
         Nouveau.Disponibilite:=false;
      END IF;
      Put_line("saisir la date de mise en service ");
      Saisirdate(Nouveau.Date_Service);

      Put_Line("date de suppression programme O/N");
      Get(Choixd);Skip_Line;
      IF Choixd='o' or choixd='O' THEN
         Nouveau.suppression:=True;
      ELSE
         Nouveau.suppression:=false;
      END IF;

      Tete:=NEW T_Cell_Materiel'(Nouveau,Tete);

      Put_Line("pack ajoute avec succes");

   END Ajoutpack;

  procedure Inserer(Tete : in out T_Ptr_Materiel; Id : Natural; Cat : T_Type_Materiel;  J : Integer; M : T_Nom_Mois; A : Integer; Dispo : Boolean; supp: boolean) is
     Nouveau : T_Materiel;
     Ds: T_Date;
  BEGIN
    Ds.J := J;
    Ds.M := M;
    Ds.Annee := A;
    Nouveau.Id := Id;
    Nouveau.mat := Cat;
    Nouveau.Date_Service :=Ds;
    Nouveau.Nb_J_Utilisation := 0;
    Nouveau.Disponibilite := Dispo;
    Nouveau.Suppression := supp;
    Tete := new T_Cell_Materiel'(Nouveau,tete);
  END Inserer;


   procedure Charger_Donnees_Initiales(Tete : in out T_Ptr_Materiel) is
   BEGIN
 Inserer(Tete, 2, Lumiere, 15, Avril, 2026, False, False);
    Inserer(Tete, 9, Lumiere, 19, Avril, 2026, False, false);
    Inserer(Tete, 3, Projecteur, 16, Avril, 2026, True, False);
    Inserer(Tete, 5, Projecteur, 17, Avril, 2026, True, false);
     Inserer(Tete, 6, Sono, 17, Avril, 2026, True, False);
Inserer(Tete, 7, Sono, 18, Avril, 2026, False, false);
Inserer(Tete, 1, Camera, 15, Avril, 2025, True, false);
Inserer(Tete, 4, Camera, 17, Avril, 2026, True, false);
 Inserer(Tete, 8, Camera, 18, Avril, 2026, False, false);
      Put_Line("chargement reussi");


end Charger_Donnees_Initiales;

   PROCEDURE Visupack(Tete: in T_Ptr_Materiel) IS
      P: T_Ptr_Materiel:=Tete;
   BEGIN
      WHILE P/=NULL loop
         put("numero : "); put(" "); Put(P.Val.Id,1);new_line;
         put("materiel");put(" ");Put(T_Type_Materiel'Image(P.Val.Mat));new_line;
         Visudate(P.Val.Date_Service);put(" ");new_line;
         Put("nombre de jours d'utilisation");put(" ");Put(P.Val.Nb_J_Utilisation,1);New_Line;
         put("disponible:");put(" ");
         IF P.Val.Disponibilite=True THEN
            Put("Oui");new_line;
         ELSE
            Put("Non");new_line;
         END IF;
         put("suppression programmee: ");put(" ");
         IF P.Val.Suppression=True THEN
            Put("Oui");New_Line;
         ELSE
            Put("Non");new_line;
         END IF;
         New_Line;
         new_line;
         P:=P.Suiv;
      END LOOP;

   END Visupack;

   PROCEDURE Suppack(Tete: IN OUT T_Ptr_Materiel; num: in integer; cat: in T_type_materiel) IS
   BEGIN
      IF Tete/=NULL THEN
         IF Tete.Val.Id=Num AND Tete.Val.Mat=Cat THEN
            IF Tete.Val.Disponibilite=True THEN
            Tete:=Tete.Suiv;
            Put_Line("pack supprimee");
            ELSE
            tete.val.suppression:=true;
               Put_Line("Pack occupe : suppression programmee pour la fin de la location.");
               put(tete.val.id);
            END IF;
         ELSE
         Suppack(Tete.Suiv, num, cat);
         END IF;
      ELSE
         Put_Line("le numero n'exite pas");
         end if;
   END Suppack;


   PROCEDURE SuppackD(Tete: IN OUT T_Ptr_Materiel; D2: IN T_Date) IS
   BEGIN
      IF Tete/=NULL THEN
         IF  AvantD(Tete.Val.Date_Service,D2)=True THEN
            IF Tete.Val.Disponibilite=True THEN
               Tete:=Tete.Suiv;

               SuppackD(Tete,D2);
            ELSE
               Put("Demande enregistree pour le pack numero");put(" "); put(Tete.Val.Id,1);new_line;
               Tete.Val.Suppression := True;
               SuppackD(Tete.Suiv,D2);
            END IF;

         ELSE
            SuppackD(Tete.Suiv, D2);
         END IF;
      ELSE
         null;
      END IF;


   END SuppackD;


   PROCEDURE Visupackdispo(Tete: IN T_Ptr_Materiel) IS
      P:T_Ptr_Materiel:=Tete;
   BEGIN
      WHILE P/=NULL LOOP
         IF P.Val.Disponibilite=True THEN
            Put(P.Val.Id,2);put(",");
         END IF;
         P:=P.Suiv;
--         put(" ");
      END LOOP;
      new_line;
   END Visupackdispo;

   FUNCTION Meuilleurpa(Pa: T_Ptr_Materiel; cat: T_type_materiel) RETURN T_Ptr_Materiel IS
      P:T_Ptr_Materiel:=Pa;
      M:T_ptr_materiel:=null;
   BEGIN
      WHILE P/=NULL LOOP
         IF P.Val.Mat=Cat AND P.Val.Disponibilite=True THEN
            IF M = NULL or else p.Val.Nb_J_Utilisation < M.Val.Nb_J_Utilisation THEN
                  M:= p;
            END IF;
         END IF;

         P:=p.suiv;
      END LOOP;
      return M;
   END Meuilleurpa;


   PROCEDURE Liberer_Pack(Tete: in out T_Ptr_Materiel;Npack: in natural) IS
      P:T_Ptr_Materiel:=Tete;
   BEGIN
      WHILE P/=NULL LOOP
         IF P.Val.Id=Npack THEN
            P.Val.Disponibilite:=True;
            IF P.Val.Suppression = True THEN
            Put_Line(" ce pack etait en attente de suppression. Suppression a �t� effectuee."); put_line("il sagit du pack ");put(Npack);
            Suppack(tete,Npack, P.Val.Mat);
            END IF;
            exit;
         END IF;
         P:=P.suiv;
      END LOOP;
   END Liberer_Pack;

   PROCEDURE Mettre_A_Jour_Materiel(tete : IN OUT T_Ptr_Materiel; ID_Mat : Integer; Jours : Integer) IS

BEGIN

   IF tete= NULL THEN

      return;

   END IF;


   IF tete.Val.Id = ID_Mat THEN

      tete.Val.Nb_J_Utilisation := tete.Val.Nb_J_Utilisation + Jours;


      IF tete.Val.Suppression THEN
         tete:= tete.Suiv;
      ELSE
         tete.Val.Disponibilite := True;
      END IF;

      return;
   END IF;

   Mettre_A_Jour_Materiel(tete.Suiv, ID_Mat, Jours);
END Mettre_A_Jour_Materiel;


END Gestion_Materiel;





