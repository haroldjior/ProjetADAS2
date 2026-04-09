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

   -- ### UTILITAIRE ###

   --Recherche d'un employe donné
   function recherche_employe
     (tete : P_employe; id : T_identite; tech : boolean) return P_employe is
   begin
      if tete = null then
         return (null);
      else
         if tete.employe.id_employe.id_nom.nom
              (1 .. tete.employe.id_employe.id_nom.knom)
           = id.id_nom.nom (1 .. id.id_nom.knom)
           and then
             tete.employe.id_employe.id_prenom.nom
               (1 .. tete.employe.id_employe.id_prenom.knom)
             = id.id_prenom.nom (1 .. id.id_prenom.knom)
           and then tete.employe.technicien = tech
         then
            return (tete);
         else
            return (recherche_employe (tete.suiv, id, tech));
         end if;
      end if;
   end recherche_employe;


   -- ### AFFICHAGES / VISUALISATIONS ###

   --Affichage d'un record T_employe
   procedure affichage_employe (employe : in T_employe) is
   begin
      new_line;
      --Identité
      affichage_id (employe.id_employe);
      --Catégorie
      Put ("Categorie : ");
      if employe.technicien then
         put ("Technicien");
      else
         put ("Ingenieur");
      end if;
      new_line;
      --Disponibilite
      if employe.dispo then
         put ("Disponible : oui");
         new_line;
         --Nombre de jour de presta
         put ("En prestation depuis ");
         put (employe.nb_jour_presta, 3);
         put (" jour(s)");
         new_line;
      else
         put ("Disponible : non");
      end if;
      --Demande de départ
      if employe.depart then
         put ("Depart : demande");
      else
         put ("Depart : non demande");
      end if;
      new_line;
   end affichage_employe;

   --Visualisation de l'ensemble du personnel
   procedure visu_personnel (tete : in P_employe) is
   begin
      if tete /= null then
         affichage_employe (tete.employe);
         visu_personnel (tete.suiv);
      end if;
   end visu_personnel;

   --Visualisation d'un employé donné (nom et catégorie)
   procedure visu_employe (tete : in P_employe) is
      id      : T_identite;
      choix   : Character;
      tech    : Boolean;
      employe : P_employe;

   begin
      --Saisie des données de l'employe a visualiser
      saisie_identite (id);
      loop
         put ("Categorie (T/I): ");
         get (choix);
         skip_line;
         choix := to_lower (choix);
         exit when choix = 't' or choix = 'i';
      end loop;
      if choix = 't' then
         tech := true;
      else
         tech := false;
      end if;

      --Visualisation
      affichage_employe (recherche_employe (tete, id, tech).employe);
   end visu_employe;


   -- ### SAISIES / INSERTIONS ###

   --Saisie d'un record T_employe
   procedure saisie_employe (Employe : out T_employe) is
      choix  : Character;
      erreur : boolean;
   begin
      --Saisie nom prénom
      saisie_identite (Employe.id_employe);

      --Saisie catégorie
      loop
         put ("Catégorie (T/I) : ");
         get (choix);
         skip_line;
         choix := to_lower (choix);
         exit when choix = 't' or choix = 'i';
         put_line ("/!\ Saisie invalide");
      end loop;
      if choix = 't' then
         Employe.technicien := true;
      else
         Employe.technicien := false;
      end if;

      --Initalisation du reste
      Employe.nb_jour_presta := 0;
      Employe.dispo := true;
      Employe.depart := False;
   end saisie_employe;

   --Ajout d'un employe à la liste des employe
   procedure ajout_employe (tete : in out P_employe) is
      employe : T_employe;
   begin
      saisie_employe (employe);
      if tete = null then
         tete := new T_cell_employe'(employe, null);
      else
         tete := new T_cell_employe'(employe, tete);
      end if;
   end ajout_employe;


   -- ### FONCTIONNALITÉS ###

   --Enregistrement de la demande de départ d'un employe
   procedure dem_depart_employe (tete : in out P_employe) is
      id      : T_identite;
      tech    : boolean;
      choix   : Character;
      employe : P_employe;

   begin
      --Saisie des données de l'employé à visualiser
      saisie_identite (id);
      loop
         put ("Catégorie de l'employe (T/I) :");
         get (choix);
         skip_line;
         choix := to_lower (choix);
         exit when choix = 't' or choix = 'i';
      end loop;
      if choix = 't' then
         tech := true;
      elsif choix = 'i' then
         tech := false;
      end if;

      employe := recherche_employe (tete, id, tech);
      if employe /= null then
         employe.employe.depart := true;
      else
         put ("Le client n'existe pas");
      end if;
   end dem_depart_employe;

   procedure depart_employe (tete : in out P_employe) is
      p : P_employe;
   begin
      if tete /= null then
         if tete.employe.depart = true then
            p := tete;
            tete := tete.suiv;
            liberer_memoire_employe (p);
         else
            depart_employe (tete.suiv);
         end if;
      end if;
   end depart_employe;


end gestion_personnel;
