with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     ada.IO_Exceptions,
     gestion_identite;
use ada.text_io,
    ada.integer_text_io,
    ada.characters.handling,
    gestion_identite;

package body gestion_personnel is

   procedure saisie_employe (E : out T_employe) is

      cat : Character;
      ok  : boolean;

   begin
      Put ("--- Saisie d'un nouvel employe ---");
      new_line;
      Saisie_Identite (E.Id_E);
      loop
         put_line ("l'employe est-il technicien ou ingenieur ? (T/I) : ");
         get (cat);
         skip_line;
         cat := To_upper (cat);
         exit when cat = 'T' or cat = 'I';
         Put_line ("erreur, saississez T pour technicien et I pour ingenieur");
      end loop;
      if cat = 'T' then
         E.ingenieur := false;
      else
         E.ingenieur := true;
      end if;
      E.nbj_presta := 0;
      E.dispo := true;
      E.D_depart := false;

   end saisie_employe;

   procedure visu_employe (E : in T_employe) is
   begin
      Put ("--- Visualisation de l'employe ---");
      new_line;
      Visualiser_Identite (E.Id_E);
      new_line;
      Put ("Categorie : ");
      if E.ingenieur then
         put ("ingenieur");
      else
         put ("technicien");
      end if;
      new_line;
      if E.dispo then
         put ("employe disponible");
      else
         put ("employe occupe");
         new_line;
         put ("depuis : ");
         put (E.nbj_presta, 3);
         put (" jours");
      end if;
      new_line;
      Put ("Cumul prestations : ");
      Put (E.nbj_presta, 0);
      Put_Line (" jours.");
      if E.D_depart then
         Put_Line
           ("Attention : Demande de depart enregistree (quittera apres sa mission).");
      else
         Put_Line ("Contrat : Actif (pas de demande de depart).");
      end if;
   end visu_employe;

   function recherche_employe
     (teteE : in T_Pteur_E; id_E : in T_identite; cat_E : in boolean)
      return T_Pteur_E is
   begin
      if teteE = null then
         return null;
      elsif teteE.employe.Id_E.Id_N.Nom (1 .. teteE.employe.Id_E.Id_N.kn)
        = id_E.Id_N.Nom (1 .. id_E.Id_N.kn)
        and then
          teteE.employe.Id_E.Id_P.prenom (1 .. teteE.employe.Id_E.Id_P.kp)
          = id_E.Id_P.prenom (1 .. id_E.Id_P.kp)
        and then teteE.employe.ingenieur = cat_E
      then
         return teteE;
      else
         return recherche_employe (teteE.suiv, id_E, cat_E);
      end if;
   end recherche_employe;

   function recherche_employe_dispo
     (teteE : in T_Pteur_E; cat_E : in integer) return T_Pteur_E is
   begin
      if teteE = null then
         return null;
      elsif cat_E = 0 then
         return null;
      elsif cat_E = 1
        and teteE.employe.ingenieur = false
        and teteE.employe.dispo
      then
         return teteE;
      elsif cat_E = 2 and teteE.employe.ingenieur and teteE.employe.dispo then
         return teteE;
      else
         return recherche_employe_dispo (teteE.suiv, cat_E);
      end if;
   end recherche_employe_dispo;

   procedure ajout_employe_liste (teteE : in out T_Pteur_E) is

      E : T_employe;

   begin
      saisie_employe (E);
      if teteE = null then
         teteE := new T_cell_E'(E, null);
      elsif recherche_employe (teteE, E.Id_E, E.ingenieur) /= null then
         put_line ("Erreur : l'employe existe deja dans la base.");
      else
         teteE := new T_cell_E'(E, teteE); --
         put_line ("Employe ajoute avec succes.");
      end if;
   end ajout_employe_liste;

   procedure visu_liste_employes (teteE : in T_Pteur_E) is
   begin
      if teteE /= null then
         visu_employe (teteE.employe);
         visu_liste_employes (teteE.suiv);
      end if;
   end visu_liste_employes;

   procedure visu_employe_par_nom (teteE : in T_Pteur_E) is
      id_E  : T_identite;
      cat   : Character;
      cat_E : boolean;
      P     : T_Pteur_E;
   begin
      Put_line ("entrez le nom de l'employe à visualiser");
      Saisie_Identite (id_E);
      loop
         put_line ("Technicien ou ingenieur ? (T/I) : ");
         get (cat);
         skip_line;
         cat := To_Upper (cat);
         exit when cat = 'T' or cat = 'I';
         put_line ("Entrez T ou I");
      end loop;
      cat_E := (cat = 'I');

      P := recherche_employe (teteE, id_E, cat_E);

      if P = null then
         put_line ("Employe non trouve");
      else
         visu_employe (P.employe);
      end if;
   end visu_employe_par_nom;

   procedure supprimer_employe (teteE : in out T_Pteur_E; P : in T_Pteur_E) is
      Parcours : T_Pteur_E;
   begin
      if P = null then
         return;
      elsif teteE = P then
         teteE := teteE.suiv;
      else
         Parcours := teteE;
         while Parcours /= null and then Parcours.suiv /= P loop
            Parcours := Parcours.suiv;
         end loop;
         if Parcours /= null then
            Parcours.suiv := P.suiv;
         end if;
      end if;
   end supprimer_employe;

   procedure demande_depart_employe (teteE : in out T_Pteur_E) is
      id_E     : T_identite;
      cat      : Character;
      cat_E    : boolean;
      P        : T_Pteur_E;
      Parcours : T_Pteur_E;
   begin
      put_line ("Entrez le nom de l'employe qui veut partir");
      Saisie_Identite (id_E);
      loop
         put_line ("Technicien ou ingenieur ? (T/I) : ");
         get (cat);
         skip_line;
         cat := To_Upper (cat);
         exit when cat = 'T' or cat = 'I';
         put_line ("Entrez T ou I");
      end loop;
      cat_E := (cat = 'I');
      P := recherche_employe (teteE, id_E, cat_E);

      if P = null then
         put_line ("Employe non trouve");

      elsif P.employe.dispo then
         supprimer_employe (teteE, P);
         put_line ("Employe disponible : supprime de la liste");
      else
         P.employe.D_depart := true;
         put_line ("Employe en mission : demande de depart enregistree");

         put_line ("Il sera supprime a la fin de sa mission");
      end if;

   end demande_depart_employe;

   procedure Liberer_Employe
     (P_Employe : in T_Pteur_E; Duree : in Integer; Tete_E : in out T_Pteur_E)
   is
      p    : T_Pteur_E := Tete_E;
      Prec : T_Pteur_E := null;
   begin
      P_Employe.employe.nbj_presta := P_Employe.employe.nbj_presta + Duree;

      if P_Employe.employe.D_depart then
         Put_Line ("Depart effectif de l'employe.");
         while p /= null loop
            if p = P_Employe then
               if Prec = null then
                  Tete_E := p.suiv;
               else
                  Prec.suiv := p.suiv;
               end if;
               exit;
            end if;
            Prec := p;
            p := p.suiv;
         end loop;
      else
         P_Employe.employe.dispo := True;
      end if;
   end Liberer_Employe;
end gestion_personnel;
