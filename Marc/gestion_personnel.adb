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

   procedure ajout_employe_liste (teteE : in out T_Pteur_E) is

      E : T_employe;

   begin
      saisie_employe (E);
      if teteE = null then
         teteE := new T_cell_E'(E, null);
      elsif teteE.employe.Id_E.Id_N = E.Id_E.Id_N
        and teteE.employe.Id_E.Id_P = E.Id_E.Id_P
        and teteE.employe.ingenieur = E.ingenieur
      then
         put ("erreur, l'employe existe deja");
      else
         teteE := new T_cell_E'(E, teteE);
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
end gestion_personnel;
