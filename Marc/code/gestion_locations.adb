with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;

package body Gestion_Locations is

   --  Conversion T_location -> T_loc_archive
   --  (remplace le pointeur Intervenant par une copie des donnees)
   function Vers_Archive (Loc : T_location) return T_loc_archive is
      A : T_loc_archive;
   begin
      A.num := Loc.num;
      A.Id_client := Loc.Id_client;
      A.duree := Loc.duree;
      A.date_d := Loc.date_d;
      A.date_f := Loc.date_f;
      A.delais := Loc.delais;
      A.Acc := Loc.Acc;
      A.Id_M := Loc.Id_M;
      A.app := Loc.app;
      A.facture := Calcule_facture (Loc);

      if Loc.Intervenant /= null then
         A.a_intervenant := True;
         A.Id_intervenant := Loc.Intervenant.employe.Id_E;
         A.ing_intervenant := Loc.Intervenant.employe.ingenieur;
      else
         A.a_intervenant := False;
         A.Id_intervenant :=
           (Id_N => (Nom => (others => ' '), kn => 0),
            Id_P => (prenom => (others => ' '), kp => 0));
         A.ing_intervenant := False;
      end if;
      return A;
   end Vers_Archive;

   --  Ecriture d'une location dans le fichier Sequential_IO
   --  On ouvre en mode Append si le fichier existe, sinon on cree (cf cours semestre 1)

   procedure Ecrire_Archive (Loc : in T_location) is
      F : Archive_IO.File_Type;
      A : constant T_loc_archive := Vers_Archive (Loc);
   begin
      begin
         Archive_IO.Open (F, Archive_IO.Append_File, Nom_Fichier_Archive);
      exception
         when Archive_IO.Name_Error =>
            Archive_IO.Create (F, Archive_IO.Out_File, Nom_Fichier_Archive);
      end;
      Archive_IO.Write (F, A);
      Archive_IO.Close (F);
   end Ecrire_Archive;

   procedure Creer_presta (tete : in out T_pteur_L; L : in T_location) is
   begin
      tete := new T_cell_L'(L, tete);
      if L.Intervenant /= null then
         L.Intervenant.employe.dispo := False;
      end if;
   end Creer_presta;

   function calculer_date_fin
     (Date_Ajd : in T_date; duree : in integer) return T_date
   is
      date_fin   : T_date := Date_Ajd;
      liste_mois : T_liste_mois;
      tab_mois   : T_tab_mois := nb_J_mois (liste_mois, Date_Ajd.annee);
   begin
      for i in 1 .. duree - 1 loop
         date_fin := gestion_date.passage_lendemain (date_fin, tab_mois);
      end loop;
      return date_fin;
   end calculer_date_fin;

   procedure visu_presta (tete : in T_pteur_L) is
      p : T_pteur_L := tete;
   begin
      Put_Line ("--- Prestations en cours ---");
      if p = null then
         Put_Line ("Aucune location en cours.");
      end if;

      while p /= null loop
         Put ("Location n° ");
         Put (p.loc.num, 0);
         New_Line;
         Put ("Client : ");
         Visualiser_Identite (p.loc.Id_client);
         Put ("Materiel : ");
         Put (T_appareil'Image (p.loc.app));
         Put (" (Pack n°");
         Put (p.loc.Id_M, 0);
         Put_Line (")");
         Put ("Duree : ");
         Put (p.loc.duree, 0);
         Put_Line (" jours");
         Put ("Periode : du ");
         visu_date (p.loc.date_d);
         Put (" au ");
         visu_date (p.loc.date_f);
         if p.loc.Intervenant /= null then
            Put (" | Intervenant : ");
            if p.loc.Intervenant.employe.ingenieur then
               Put ("(INGENIEUR) ");
            else
               Put ("(TECHNICIEN) ");
            end if;
            Visualiser_Identite (p.loc.Intervenant.employe.Id_E);
         else
            Put_Line (" | Intervenant : Aucun");
         end if;
         New_Line;
         p := p.suiv;
      end loop;
   end visu_presta;

   function Calcule_facture (Loc : T_location) return Integer is
      Prix_M, Prix_P, Total : Integer;
   begin
      case Loc.app is
         when camera     =>
            Prix_M := 412;

         when prise_son  =>
            Prix_M := 335;

         when sono       =>
            Prix_M := 125;

         when projection =>
            Prix_M := 120;

         when lumiere    =>
            Prix_M := 110;
      end case;

      case Loc.Acc is
         when 1      =>
            Prix_P := 140;

         when 2      =>
            Prix_P := 230;

         when others =>
            Prix_P := 0;
      end case;

      Total := (Prix_M + Prix_P) * Loc.duree;

      if Loc.duree >= 8 then
         Total := Total - (Total * 5 / 100);
      end if;

      return Total;
   end Calcule_facture;

   procedure fin_presta
     (en_cours     : in out T_pteur_L;
      Date_Du_Jour : in T_date;
      Tete         : in out pt_clients;
      teteM        : in out T_Pteur_M;
      Tete_E       : in out T_Pteur_E)
   is
      p             : T_pteur_L := en_cours;
      Precedant     : T_pteur_L := null;
      ASupprimer    : T_pteur_L;
      Montant       : Integer;
      Client_Trouve : pt_clients;
   begin
      while p /= null loop
         if ordre_dates (p.loc.date_f, Date_Du_Jour) then

            -- Mise a jour de la facture client
            Montant := Calcule_facture (p.loc);
            Client_Trouve := recherche_client (Tete, p.loc.Id_client);
            if Client_Trouve /= null then
               Client_Trouve.Client.Facture_Due :=
                 Client_Trouve.Client.Facture_Due + Montant;
               Client_Trouve.Client.Nb_Locations :=
                 Client_Trouve.Client.Nb_Locations + 1;
            end if;

            -- Liberation du materiel et de l'employe
            Liberer_mat (p.loc.Id_M, p.loc.app, p.loc.duree, teteM);
            if p.loc.Intervenant /= null then
               Liberer_Employe (p.loc.Intervenant, p.loc.duree, Tete_E);
            end if;

            -- Archivage dans le fichier Sequential_IO
            Ecrire_Archive (p.loc);

            -- Suppression de la liste en cours
            ASupprimer := p;
            if Precedant = null then
               en_cours := p.suiv;
            else
               Precedant.suiv := p.suiv;
            end if;
            p := (if Precedant = null then en_cours else Precedant.suiv);

         else
            Precedant := p;
            p := p.suiv;
         end if;
      end loop;
   end fin_presta;

   procedure traiter_demande
     (File_D   : in out T_File_Demandes;
      Liste_M  : in out T_Pteur_M;
      Liste_E  : in out T_Pteur_E;
      Liste_L  : in out T_pteur_L;
      Date_Ajd : T_date)
   is
      p            : pt_demande := File_D.Tete;
      Precedant_D  : pt_demande := null;
      matos        : T_Pteur_M;
      Emp          : T_Pteur_E;
      Nouvelle_Loc : T_location;
      possible     : Boolean;
      liste_mois   : T_liste_mois;
      tab_mois     : T_tab_mois := nb_J_mois (liste_mois, Date_Ajd.annee);
   begin
      while p /= null loop
         possible := False;
         matos := trouver_mat (Liste_M, p.Demande.Mat);
         if matos /= null then
            if p.Demande.Acc = 0 then
               possible := True;
               Emp := null;
            else
               Emp := recherche_employe_dispo (Liste_E, p.Demande.Acc);
               if Emp /= null then
                  possible := True;
               end if;
            end if;
         end if;

         if possible then
            Nouvelle_Loc.num := p.Demande.numero;
            Nouvelle_Loc.Id_client := p.Demande.Client_Demandeur;
            Nouvelle_Loc.duree := p.Demande.Duree_J;
            Nouvelle_Loc.date_d := Date_Ajd;
            Nouvelle_Loc.date_f :=
              calculer_date_fin (Date_Ajd, p.Demande.Duree_J);
            Nouvelle_Loc.delais :=
              ecart_dates (p.Demande.date_demande, Date_Ajd, tab_Mois);
            Nouvelle_Loc.Acc := p.Demande.Acc;
            Nouvelle_Loc.Id_M := matos.mat.Id_M;
            Nouvelle_Loc.app := p.Demande.Mat;
            Nouvelle_Loc.Intervenant := Emp;

            Creer_presta (Liste_L, Nouvelle_Loc);
            matos.mat.loue := True;

            if Precedant_D = null then
               File_D.Tete := p.Suiv;
            else
               Precedant_D.Suiv := p.Suiv;
            end if;
            if p = File_D.Queue then
               File_D.Queue := Precedant_D;
            end if;
            p :=
              (if Precedant_D = null then File_D.Tete else Precedant_D.Suiv);
         else
            Precedant_D := p;
            p := p.Suiv;
         end if;
      end loop;
   end traiter_demande;

   --  Affichage d'un enregistrement archive
   procedure Afficher_Archive (A : in T_loc_archive) is
   begin
      Put_Line ("----------------------------------");
      -- "Identifiant 1"
      Put ("Identifiant ");
      Put (A.num, 0);
      New_Line;

      Put ("location par le client ");
      Visualiser_Identite (A.Id_client);
      Put ("pour une duree de ");
      Put (A.duree, 0);
      Put_Line (" jours entre le");
      Visu_Date (A.date_d);
      New_Line;
      -- "et le 22 AVRIL 2026"
      Put ("et le ");
      Visu_Date (A.date_f);
      New_Line;
      -- "6 jours entre"

      -- Accompagnement
      if A.a_intervenant then
         Put ("Accompagnement assure par ");
         Visualiser_Identite (A.Id_intervenant);
         Put (", ");
         if A.ing_intervenant then
            Put_Line ("INGENIEUR");
         else
            Put_Line ("TECHNICIEN");
         end if;
      else
         Put_Line ("Aucun accompagnement");
      end if;
      -- "le pack loue est un pack de LUMIERES, il a le numero 2"
      Put ("le pack loue est un pack de ");
      Put (T_appareil'Image (A.app));
      Put (", il a le numero ");
      Put (A.Id_M, 0);
      New_Line;
      -- "le client a attendu 0 jours avant de recevoir le materiel"
      Put ("le client a attendu ");
      Put (A.delais, 0);
      Put_Line (" jours avant de recevoir le materiel");
   end Afficher_Archive;

   procedure visu_archives is
      F : Archive_IO.File_Type;
      A : T_loc_archive;
   begin
      Put_Line ("=========================================");
      Put_Line ("       HISTORIQUE DES PRESTATIONS");
      Put_Line ("=========================================");
      begin
         Archive_IO.Open (F, Archive_IO.In_File, Nom_Fichier_Archive);
      exception
         when Archive_IO.Name_Error =>
            Put_Line ("Aucune prestation archivee pour le moment.");
            return;
      end;
      while not Archive_IO.End_Of_File (F) loop
         Archive_IO.Read (F, A);
         Afficher_Archive (A);
      end loop;
      Archive_IO.Close (F);
      New_Line;
   end visu_archives;

   procedure visu_locations_client
     (en_cours : in T_pteur_L; Id : in T_identite)
   is
      P       : T_pteur_L := en_cours;
      Trouve  : Boolean := False;
      F       : Archive_IO.File_Type;
      A       : T_loc_archive;
      Trouve2 : Boolean := False;
   begin
      Put ("Historique pour le client : ");
      Visualiser_Identite (Id);

      -- Locations en cours
      Put_Line ("--- LOCATIONS EN COURS ---");
      while P /= null loop
         if meme_id (P.loc.Id_client, Id) then
            Put ("Location n°");
            Put (P.loc.num, 0);
            Put (" | Materiel : ");
            Put (T_appareil'Image (P.loc.app));
            Put (" | Du ");
            visu_date (P.loc.date_d);
            Put (" au ");
            visu_date (P.loc.date_f);
            New_Line;
            Trouve := True;
         end if;
         P := P.suiv;
      end loop;
      if not Trouve then
         Put_Line ("Aucune location en cours.");
      end if;

      -- Archives fichier
      Put_Line ("--- LOCATIONS ARCHIVEES ---");
      begin
         Archive_IO.Open (F, Archive_IO.In_File, Nom_Fichier_Archive);
         while not Archive_IO.End_Of_File (F) loop
            Archive_IO.Read (F, A);
            if meme_id (A.Id_client, Id) then
               Afficher_Archive (A);
               Trouve2 := True;
            end if;
         end loop;
         Archive_IO.Close (F);
      exception
         when Archive_IO.Name_Error =>
            Put_Line ("Aucune archive disponible.");
      end;
      if not Trouve2 then
         Put_Line ("Aucune location archivee pour ce client.");
      end if;
   end visu_locations_client;

   procedure visu_locations_employe
     (en_cours : in T_pteur_L; Id : in T_identite)
   is
      P       : T_pteur_L := en_cours;
      Trouve  : Boolean := False;
      F       : Archive_IO.File_Type;
      A       : T_loc_archive;
      Trouve2 : Boolean := False;
   begin
      Put ("Prestations assurees par : ");
      Visualiser_Identite (Id);

      -- Missions en cours
      Put_Line ("--- MISSIONS ACTUELLES ---");
      while P /= null loop
         if P.loc.Intervenant /= null
           and then meme_id (P.loc.Intervenant.employe.Id_E, Id)
         then
            visu_infos_loc (P.loc);
            Trouve := True;
         end if;
         P := P.suiv;
      end loop;
      if not Trouve then
         Put_Line ("Aucune mission en cours.");
      end if;

      -- Archives fichier
      Put_Line ("--- MISSIONS TERMINEES ---");
      begin
         Archive_IO.Open (F, Archive_IO.In_File, Nom_Fichier_Archive);
         while not Archive_IO.End_Of_File (F) loop
            Archive_IO.Read (F, A);
            if A.a_intervenant and then meme_id (A.Id_intervenant, Id) then
               Afficher_Archive (A);
               Trouve2 := True;
            end if;
         end loop;
         Archive_IO.Close (F);
      exception
         when Archive_IO.Name_Error =>
            Put_Line ("Aucune archive disponible.");
      end;
      if not Trouve2 then
         Put_Line ("Aucune mission terminee trouvee.");
      end if;
   end visu_locations_employe;

   procedure visu_infos_loc (L : in T_location) is
   begin
      Put ("Identifiant ");
      Put (L.num, 0);
      New_Line;

      Put ("location par le client ");
      Visualiser_Identite (L.Id_client);

      Put ("pour une duree de ");
      Put (L.duree, 0);
      Put_Line (" jours");

      Put ("entre le ");
      visu_date (L.date_d);
      New_Line;
      Put ("et le ");
      visu_date (L.date_f);
      New_Line;
      New_Line;

      if L.Intervenant /= null then
         Put ("Accompagnement assure par ");
         Visualiser_Identite (L.Intervenant.employe.Id_E);
         if L.Intervenant.employe.ingenieur then
            Put_Line (", INGENIEUR");
         else
            Put_Line (", TECHNICIEN");
         end if;
      else
         Put_Line ("Sans accompagnement.");
      end if;

      Put ("le pack loue est un pack de ");
      Put (T_appareil'Image (L.app));
      Put ("S, il a le numero ");
      Put (L.Id_M, 0);
      New_Line;

      Put ("le client a attendu ");
      Put (L.delais, 0);
      Put_Line (" jours avant de recevoir le materiel");
      Put_Line
        ("------------------------------------------------------------");
   end visu_infos_loc;

end Gestion_Locations;
