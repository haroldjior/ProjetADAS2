with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;

package body Gestion_Locations is

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
      for i in 1 .. duree loop
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
      archive      : in out T_pteur_L;
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
         if ordre_dates (p.loc.date_f, Date_Du_Jour)
           or else dates_egales (p.loc.date_f, Date_Du_Jour)
         then
            Montant := Calcule_facture (p.loc);
            Client_Trouve := recherche_client (tete, p.loc.Id_client);
            if Client_Trouve /= null then
               Client_Trouve.Client.Facture_Due :=
                 Client_Trouve.Client.Facture_Due + Montant;
               Client_Trouve.Client.Nb_Locations :=
                 Client_Trouve.Client.Nb_Locations + 1;
            end if;
            Liberer_mat (p.loc.Id_M, p.loc.app, p.loc.duree, teteM);
            if p.loc.Intervenant /= null then
               Liberer_Employe (p.loc.Intervenant, p.loc.duree, Tete_E);
            end if;

            ASupprimer := p;
            if Precedant = null then
               en_cours := p.suiv;
            else
               Precedant.suiv := p.suiv;
            end if;

            ASupprimer.suiv := archive;
            archive := ASupprimer;

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
            Put ("la demande n° ");
            put (Nouvelle_Loc.num, 2);
            put (" peut être satisfaite");
            new_line;
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

   procedure visu_archives (archive : in T_pteur_L) is
   begin
      Put_Line ("=========================================");
      Put_Line ("       HISTORIQUE DES PRESTATIONS        ");
      Put_Line ("=========================================");
      if archive = null then
         Put_Line ("Aucune prestation n'est encore archivee.");
      else
         visu_presta (archive);
      end if;
      new_line;
   end visu_archives;

   procedure visu_locations_client
     (en_cours : in T_pteur_L; archive : in T_pteur_L; Id : in T_identite)
   is
      procedure Afficher (Liste : T_pteur_L; s : String) is
         P      : T_pteur_L := Liste;
         Trouve : Boolean := False;
      begin
         Put ("--- ");
         Put (s);
         Put (" ---");
         while P /= null loop
            if meme_id (P.loc.Id_client, Id) then
               Trouve := True;
               visu_infos_loc (P.loc);
            end if;
            P := P.suiv;
         end loop;
         if not Trouve then
            Put_Line ("Aucune location trouvee.");
         end if;
      end Afficher;

   begin
      Put ("Historique pour le client : ");
      Visualiser_Identite (Id);
      Afficher (en_cours, "LOCATIONS EN COURS");
      Afficher (archive, "LOCATIONS ARCHIVEES");
   end visu_locations_client;

   procedure visu_locations_employe
     (en_cours : in T_pteur_L; archive : in T_pteur_L; Id : in T_identite)
   is
      procedure Afficher (Liste : T_pteur_L; s : String) is
         P      : T_pteur_L := Liste;
         Trouve : Boolean := False;
      begin
         Put ("--- ");
         Put (s);
         Put (" ---");
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
            Put_Line ("Aucune prestation trouvee.");
         end if;
      end Afficher;

   begin
      Put ("Prestations assurees par : ");
      Visualiser_Identite (Id);
      Afficher (en_cours, "MISSIONS ACTUELLES");
      Afficher (archive, "MISSIONS TERMINEES");
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
