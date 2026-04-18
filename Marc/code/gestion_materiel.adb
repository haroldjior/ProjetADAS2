with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     ada.IO_Exceptions,
     gestion_date;
use ada.text_io, ada.integer_text_io, ada.characters.handling, gestion_date;

package body gestion_materiel is

   procedure visu_Mat (m : in T_materiel) is
   begin
      put_line ("---Visualisation d'un pack---");
      new_line;
      Put ("type : ");
      put (T_appareil'image (m.app));
      new_line;
      put ("numero id : ");
      Put (m.Id_M, 3);
      New_Line;
      put ("date de mise en service : ");
      visu_date (m.Date_service);
      new_line;
      put ("nombre de jours d'utilisation : ");
      put (m.nbj_uti, 3);
      new_line;
      Put ("disponibilite : ");
      if m.loue then
         put ("en location");
      else
         put ("disponible");
      end if;
      new_line;
      Put ("suppression ? : ");
      if m.sup then
         put ("programmée");
      else
         put ("NON");
      end if;
      new_line;

   end visu_Mat;

   procedure visu_liste_mat (teteM : in T_Pteur_M) is
   begin
      if teteM /= null then
         visu_Mat (teteM.mat);
         visu_liste_mat (teteM.suiv);
      end if;
   end visu_liste_mat;

   procedure ajout_mat_liste (teteM : in out T_Pteur_M; date : in T_date) is

      m : T_materiel;
      s : String (1 .. 10);
      k : integer;
   begin
      put ("---saisie d'un materiel---");
      new_line;
      loop
         begin
            put
              ("Type de materiel (camera/prise_son/sono/projection/lumiere): ");
            get_line (s, k);
            s := To_Upper (s);
            m.app := T_appareil'value (s (1 .. k));
            exit when m.app'Valid;
         exception
            when Constraint_Error =>
               skip_line;
               Put_line ("saisie invalide");
         end;

      end loop;
      if teteM = null then
         m.Id_M := 1;
      else
         m.Id_M := teteM.mat.Id_M + 1;
      end if;
      m.Date_service := date;
      m.nbj_uti := 0;
      m.loue := false;
      m.sup := false;
      teteM := new T_cell_M'(m, teteM);

   end ajout_mat_liste;

   procedure sup_mat_par_id (teteM : in out T_Pteur_M) is
      num_id   : integer;
      appareil : T_appareil;
      s        : string (1 .. 10);
      k        : integer;
      Trouve   : Boolean := False;

      procedure aux
        (teteM    : in out T_Pteur_M;
         num_id   : in integer;
         appareil : in T_appareil) is
      begin
         if teteM /= null then
            if teteM.mat.Id_M = num_id and teteM.mat.app = appareil then
               Trouve := True;
               if teteM.mat.loue = false then
                  if teteM.suiv = null then
                     teteM := null;
                  else
                     teteM := teteM.suiv;
                  end if;
                  Put_Line
                    ("Confirmation : Le pack a ete supprime de la liste.");
               else
                  teteM.mat.sup := true;
                  Put_Line
                    ("Note : Le pack est loue. Suppression programmee pour la fin de la location.");
               end if;
            else
               aux (teteM.suiv, num_id, appareil);
            end if;
         end if;
      end aux;

   begin
      Put_line ("---suppression d'un pack par id et type d'apareil---");
      new_line;
      loop
         begin
            put ("ID du pack a supprimer : ");
            get (num_id);
            Skip_Line;
            exit when num_id'Valid;
         exception
            when Data_Error =>
               skip_line;
               Put_line
                 ("erreur de saisie du numero d'identification du pack a supprimer");
         end;
      end loop;
      put_line ("-confirmation avec le type d'appareil-");
      new_line;
      loop
         begin
            put ("type d'appereil du pack a supprimer : ");
            get_line (s, k);
            appareil := T_appareil'value (s (1 .. K));
            exit when appareil'Valid;
         exception
            when Constraint_Error =>
               skip_line;
               put_line ("erreur de saisie du type d'appareil");
         end;
      end loop;
      aux (teteM, num_id, appareil);
      if not Trouve then
         Put_Line
           ("Erreur : Aucun pack correspondant n'a été trouvé dans la liste.");
      end if;
   end sup_mat_par_id;

   procedure sup_mat_anciens
     (teteM : in out T_Pteur_M; tab_mois : in T_tab_mois)
   is
      date     : T_date;
      nbj_mois : T_tab_mois := tab_mois;
      Trouve   : Boolean := False;

      procedure aux (teteM : in out T_Pteur_M; date : in T_date) is
      begin
         if teteM /= null then
            aux (teteM.suiv, date);
            if ordre_dates (teteM.mat.Date_service, date) then
               Trouve := True;
               Put ("Pack n°");
               Put (teteM.mat.Id_M, 0);
               Put (" (");
               Put (T_appareil'Image (teteM.mat.app));
               Put (") : ");
               if teteM.mat.loue = false then
                  if teteM.suiv = null then
                     teteM := null;
                  else
                     teteM := teteM.suiv;
                  end if;
                  Put_Line ("SUPPRIME.");
               else
                  teteM.mat.sup := true;
                  Put_Line ("PROGRAMME pour suppression (Actuellement loue).");
               end if;
            end if;
         end if;

      end aux;

   begin
      Put_Line ("--- Suppression par anciennete ---");
      Put_Line
        ("Entrez la date limite (tous les packs avant cette date seront traites) :");
      saisie_date (date, nbj_mois);
      aux (teteM, date);
      Put_Line
        ("Traitement termine : Les packs anterieurs a la date saisie ont ete traites.");
      if not Trouve then
         Put_Line
           ("Aucun pack plus ancien que la date saisie n'a ete trouve.");
      end if;
   end sup_mat_anciens;

   procedure visu_mat_dispo (teteM : in T_Pteur_M) is

   begin
      if teteM /= null then
         visu_mat_dispo (teteM.suiv);
         if teteM.mat.loue = false then
            visu_Mat (teteM.mat);
         end if;
      end if;
   end visu_mat_dispo;

   procedure Liberer_mat
     (Id_R      : Integer;
      cat       : T_appareil;
      Duree_Loc : Positive;
      tete      : in out T_Pteur_M)
   is
      P         : T_Pteur_M := tete;
      Precedant : T_Pteur_M := null;
   begin
      while P /= null loop
         if P.mat.Id_M = Id_R and P.mat.app = cat then
            P.mat.nbj_uti := P.mat.nbj_uti + Duree_Loc;
            if P.mat.sup then
               Put_Line ("Suppression effective du pack n°");
               Put (Id_R);
               new_line;
               if Precedant = null then
                  tete := P.suiv;
               else
                  Precedant.suiv := P.suiv;
               end if;
            else
               P.mat.loue := False;
               Put_Line ("Le pack n°");
               Put (Id_R);
               new_line;
               Put_Line (" est a nouveau disponible.");
            end if;

            return;

         end if;

         Precedant := P;
         P := P.suiv;
      end loop;

      Put_Line ("Erreur : Pack n°");
      Put (Id_R);
      new_line;
      Put_Line (" non trouve.");
   end Liberer_mat;

   function trouver_mat (tete : T_Pteur_M; Cat : T_appareil) return T_Pteur_M
   is
      P : T_Pteur_M := tete;
      q : T_Pteur_M := null;
   begin
      while P /= null loop
         if not P.mat.loue and P.mat.app = Cat and not P.mat.sup then
            if q = null or else P.mat.nbj_uti < q.mat.nbj_uti then
               q := P;
            end if;
         end if;
         P := P.suiv;
      end loop;
      return q;
   end trouver_mat;

end gestion_materiel;
