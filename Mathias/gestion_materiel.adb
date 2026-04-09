with ada.Text_IO;
with ada.integer_text_io;
with gestion_date;
with ada.Unchecked_Deallocation;
use ada.Text_IO;
use ada.integer_text_io;
use gestion_date;
with gestion_materiel;

package body gestion_materiel is

   procedure free is new ada.Unchecked_Deallocation (T_liste_materiel, T_pt);

   procedure liberer (tete : in out T_pt) is
   begin
      free (tete);
   end liberer;

   procedure visu_1pack (tete : in T_pt) is
   begin
      new_line;
      put ("Categorie du pack : ");
      put (T_cate_materiel'Image (tete.materiel.cat));
      new_line;
      put ("id materiel du pack :");
      put (tete.materiel.id_materiel);
      new_line;
      put ("Date debut : ");
      Affichage_Date (tete.materiel.date);
      put ("Nombre de jours de location : ");
      put (tete.materiel.nb_jours);
      new_line;
      if tete.materiel.dispo then
         put ("Materiel disponible");
      else
         put ("Materiel deja loue");
      end if;
      new_line;
      if tete.materiel.indic_sup then
         put ("Le pack va etre supprime");
      else
         put ("Le pack doit etre garde");
      end if;
      new_line;
      new_line;
      put ("------------------------------------------------");
      new_line;
   end visu_1pack;

   procedure visu_tous_pack (tete : in T_pt) is
   begin
      if tete /= null then
         visu_1pack (tete);
         visu_tous_pack (tete.suiv);
      end if;
   end visu_tous_pack;

   procedure visu_pack_dispo (tete : in T_pt) is
   begin
      if tete /= null then
         if tete.materiel.dispo = true then
            visu_1pack (tete);
         end if;
         visu_pack_dispo (tete.suiv);
      end if;
   end visu_pack_dispo;

   function nv_id (tete : T_pt) return integer is
      i   : integer := 0;
      tmp : T_pt := tete;

   begin
      while tmp /= null loop
         if tmp.materiel.id_materiel > i then
            i := tmp.materiel.id_materiel;
         end if;
         tmp := tmp.suiv;
      end loop;
      return i + 1;
   end nv_id;

   procedure nv_pack (mat : out T_materiel; tete : in out T_pt) is
      i : integer := 9;
      n : integer;
   begin
      -----catégorie du pack------------
      loop
         put
           ("Saisir la categorie du pack (0: camera, 1: son, 2: sono, 3: projection, 4: lumiere) :");
         get (n);
         skip_line;
         exit when n >= 0 and then n <= 4;
         put_line ("Categorie invalide, veuillez reessayer.");
      end loop;
      mat.cat := T_cate_materiel'Val (n);

      ----------id du pack----------------

      mat.id_materiel := nv_id (tete);

      -----------date de début de location----------------
      Saisie_Date (mat.date);

      -----------nombre de jours de location----------------il faudra l'incrémenter
      mat.nb_jours := 0;

      -----------disponibilité du pack----------------
      mat.dispo := true;

      -----------indicateur de suppression du pack----------------
      mat.indic_sup := false;

      tete := new T_liste_materiel'(mat, tete);

   end nv_pack;

   procedure chercher_supprimer_pack_idcat
     (tete : in out T_pt;
      id   : in integer;
      mat  : in T_cate_materiel;
      ok   : out boolean)
   is
      tmp : T_pt := tete;
   begin
      if tmp = null then
         ok := false;
      elsif tmp.materiel.id_materiel = id and then tmp.materiel.cat = mat then
         ok := true;
         if tmp.materiel.dispo = true then
            tmp := tete;
            tete := tete.suiv;
            Liberer (tmp);
            put_line ("Le pack a ete supprime.");
         else
            tete.materiel.indic_sup := true;
            put_line
              ("Le pack ne peut pas être supprime car il est deja loue, mais il va être marque pour suppression.");
         end if;
      else
         chercher_supprimer_pack_idcat (tete.suiv, id, mat, ok);
      end if;
   end chercher_supprimer_pack_idcat;

   procedure sup_pack_idcat (tete : in out T_pt) is
      id : integer;
      n  : T_cate_materiel;
      v  : integer;
      ok : boolean := false;
   begin
      if tete = null then
         ok := false;
         put_line ("La liste est vide");
      else
         loop
            put ("Saisir l'id du pack a supprimer :");
            get (id);
            skip_line;

            put
              ("Saisir la categorie du pack a supprimer (0: camera, 1: son, 2: sono, 3: projection, 4: lumiere) :");
            get (v);
            skip_line;
            exit when id > 0 and then v >= 0 and then v <= 4;
            put_line ("Id ou categorie invalide, veuillez reessayer.");
         end loop;
         n := T_cate_materiel'Val (v);
         chercher_supprimer_pack_idcat (tete, id, n, ok);
      end if;
   end sup_pack_idcat;

   procedure chercher_supprimer_pack_date
     (tete : in out T_pt; date : in T_date; ok : in out boolean)
   is
      tmp : T_pt := tete;
   begin
      if tete /= null then
         if Difference_Jours (tete.materiel.date, date) > 0 then
            ok := true;
            if tete.materiel.dispo = true then
               tmp := tete;
               tete := tete.suiv;
               Liberer (tmp);
               put_line ("Le pack a ete supprime.");
               chercher_supprimer_pack_date (tete, date, ok);
            else
               tete.materiel.indic_sup := true;
               put_line
                 ("Le pack ne peut pas être supprime car il est deja loue, mais il va être marque pour suppression.");
               chercher_supprimer_pack_date (tete.suiv, date, ok);
            end if;
         else
            chercher_supprimer_pack_date (tete.suiv, date, ok);
         end if;
      end if;
   end chercher_supprimer_pack_date;

   procedure sup_pack_date (tete : in out T_pt) is

      d  : T_date;
      ok : boolean := false;
   begin
      if tete = null then
         put_line ("La liste est vide");
         ok := false;
      else
         put_line
           ("Saisir la date de reference pour la suppression des packs :");
         Saisie_Date (d);
         chercher_supprimer_pack_date (tete, d, ok);
         if not ok then
            put_line ("Aucun pack n'a ete supprime.");
         else
            put_line ("La suppression des packs a ete effectuee.");
         end if;
      end if;
   end sup_pack_date;

   procedure user_story (tete : in out T_pt) is
   begin
      ------pack 1 ----------------------
      tete := new T_liste_materiel;

      tete.materiel.cat := camera;
      tete.materiel.id_materiel := 8;
      tete.materiel.date := (18, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := false;
      tete.materiel.indic_sup := false;

      --------pack 2 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := camera;
      tete.materiel.id_materiel := 4;
      tete.materiel.date := (17, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := true;
      tete.materiel.indic_sup := false;

      --------pack 3 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := camera;
      tete.materiel.id_materiel := 1;
      tete.materiel.date := (15, 4, 2025);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := true;
      tete.materiel.indic_sup := false;

      ---pas de pack son-------------------

      --------pack 4 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := sono;
      tete.materiel.id_materiel := 7;
      tete.materiel.date := (18, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := false;
      tete.materiel.indic_sup := false;

      --------pack 5 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := sono;
      tete.materiel.id_materiel := 6;
      tete.materiel.date := (17, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := true;
      tete.materiel.indic_sup := false;

      --------pack 6 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := projection;
      tete.materiel.id_materiel := 5;
      tete.materiel.date := (17, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := true;
      tete.materiel.indic_sup := false;

      --------pack 7 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := projection;
      tete.materiel.id_materiel := 3;
      tete.materiel.date := (16, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := true;
      tete.materiel.indic_sup := false;

      --------pack 8 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := lumiere;
      tete.materiel.id_materiel := 9;
      tete.materiel.date := (19, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := false;
      tete.materiel.indic_sup := false;

      --------pack 9 ----------------------
      tete := new T_liste_materiel'(tete.materiel, tete);
      tete.materiel.cat := lumiere;
      tete.materiel.id_materiel := 2;
      tete.materiel.date := (15, 4, 2026);
      tete.materiel.nb_jours := 0;
      tete.materiel.dispo := false;
      tete.materiel.indic_sup := false;

   end user_story;

end gestion_materiel;
