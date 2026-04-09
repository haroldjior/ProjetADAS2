with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     ada.IO_Exceptions,
     gestion_date;
use ada.text_io, ada.integer_text_io, ada.characters.handling, gestion_date;

package body gestion_materiel is

   -- ### AFFICHAGES / VISUALISATIONS ###

   --Affichage d'un seul pack de materiel
   procedure affichage_materiel (Mat : in T_materiel) is
   begin
      new_line;
      --Numero ID
      put ("ID : ");
      put (Mat.id_mat, 3);
      new_line;
      --Categorie
      put ("Categorie : ");
      put (T_cat_materiel'image (Mat.cat));
      new_line;
      --Date de mise en service
      put ("Mise en service : ");
      affichage_date (Mat.date_serv);
      new_line;
      --Nombre de jours d'utilisation
      put ("Utilisation : ");
      put (Mat.util, 3);
      put (" jour(s)");
      new_line;
      --Disponibilité
      Put ("Disponible : ");
      if Mat.dispo then
         put ("OUI");
      else
         put ("NON");
      end if;
      new_line;
      --Suppression programmée
      put ("Suppression : ");
      if Mat.supp then
         put ("OUI");
      else
         put ("NON");
      end if;
      new_line;
   end affichage_materiel;

   --Affichage de l'ensemble des packs de materiel, erreur est a initalisé à true dans le main
   procedure visu_packs_mat (tete : in P_materiel) is
   begin
      if tete /= null then
         affichage_materiel (tete.materiel);
         visu_packs_mat (tete.suiv);
      end if;
   end visu_packs_mat;

   --Visualisation de tous les packs disponibles
   procedure visu_pack_dispo (tete : in P_materiel) is
   begin
      if tete /= null then
         visu_pack_dispo (tete.suiv);
         if tete.materiel.dispo then
            affichage_materiel (tete.materiel);
         end if;
      end if;
   end visu_pack_dispo;


   -- ### SAISIES / INSERTIONS ###

   --Saisie d'un record T_materiel
   procedure saisie_pack_mat (mat : out T_materiel; date : in T_date) is
      s : String (1 .. 11);
      k : integer;
   begin
      --Saisie de la categorie de materiel
      loop
         begin
            put ("Categorie de materiel : ");
            get_line (s, k);
            s := to_lower (s);
            Mat.cat := T_cat_materiel'value (s (1 .. k));
            exit when Mat.cat'Valid;
         exception
            when Constraint_Error =>
               skip_line;
               put_line ("/!\ Categorie invalide");
         end;
      end loop;

      --Initialisation de toutes les autres de variables
      mat.id_mat := 1;
      Mat.date_serv := date;
      Mat.util := 0;
      Mat.dispo := true;
      Mat.supp := false;
   end saisie_pack_mat;

   --Ajout d'un nouveau pack de materiel avec saisie de la categorie
   procedure nouv_pack_mat (tete : in out P_materiel; date : in T_date) is
      mat : T_materiel;
   begin
      --Saisie du pack
      saisie_pack_mat (mat, date);
      if tete = null then
         mat.id_mat := 1;
      else
         mat.id_mat := tete.materiel.id_mat + 1;
      end if;

      --Ajout en tete dans la liste des packs
      Tete := new T_cell_materiel'(mat, tete);
   end nouv_pack_mat;


   -- ### SUPPRESSIONS ###

   --Saisie d'un id et d'une categorie puis suppression du pack associé
   procedure supp_pack_idcat (tete : in out P_materiel) is
      id  : Positive;
      cat : T_cat_materiel;
      s   : string (1 .. 11);
      k   : integer;

      procedure SPIC
        (tete : in out P_materiel; id : in natural; cat : in T_cat_materiel) is
      begin
         if tete /= null then
            if (tete.materiel.id_mat = id) and (tete.materiel.cat = cat) then
               if tete.materiel.dispo = true then
                  if tete.suiv = null then
                     tete := null;
                  else
                     tete := tete.suiv;
                  end if;
               else
                  tete.materiel.supp := true;
               end if;
            else
               SPIC (tete.suiv, id, cat);
            end if;
         end if;
      end SPIC;

   begin
      loop
         begin
            put ("ID : ");
            get (id);
            skip_line;
            exit when id'Valid;
         exception
            when ada.IO_Exceptions.Data_Error =>
               skip_line;
               put_line ("/!\ ID invalide");
         end;
      end loop;
      loop
         begin
            put ("Categorie : ");
            get_line (s, k);
            cat := T_cat_materiel'value (s (1 .. k));
            exit when cat'valid;
         exception
            when Constraint_Error =>
               skip_line;
               put_line ("/!\ Categorie invalide");
         end;
      end loop;
      SPIC (tete, id, cat);
   end supp_pack_idcat;

   --Saisie d'une date puis suppression de tous les packs de materiel mis en service avant
   procedure supp_pack_date
     (tete : in out P_materiel; tab_mois : in T_tab_mois)
   is
      date : T_date;
      t    : T_tab_mois := tab_mois;

      procedure SPD (tete : in out P_materiel; date : in T_date) is
      begin
         if tete /= null then
            SPD (tete.suiv, date);
            if date_anterieure (tete.materiel.date_serv, date) then
               if tete.materiel.dispo then
                  if tete.suiv = null then
                     tete := null;
                  else
                     tete := tete.suiv;
                  end if;
               else
                  tete.materiel.supp := true;
               end if;
            end if;
         end if;
      end SPD;

   begin
      saisie_date (date, t);
      SPD (tete, date);
   end supp_pack_date;


end gestion_materiel;
