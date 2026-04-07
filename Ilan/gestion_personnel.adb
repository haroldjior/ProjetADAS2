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
      nom    : T_Nom;
      choix  : Character;
      tech   : Boolean;
      erreur : Boolean;

      --Procedure auxilliaire de visualisation
      procedure visualisation
        (tete : in P_employe; nom : in T_Nom; tech : in boolean) is
      begin
         if tete /= null then
            if tete.employe.id_employe.id_nom = nom
              and then tete.employe.technicien = tech
            then
               affichage_employe (tete.employe);
            end if;
         end if;
      end visualisation;

   begin
      --Saisie des données de l'employe a visualiser
      put ("Nom : ");
      saisie_nom (nom);
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
      visualisation (tete, nom, tech);
   end visu_employe;

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

   --Enregistrement de la demande de départ d'un employe
   procedure depart_employe (tete : in out P_employe) is
      nom          : T_Nom;
      erreur, tech : boolean;
      choix        : Character;

      --Procedure auxiliaire de recherche
      procedure recherche
        (tete : in out P_employe; nom : in T_Nom; tech : in boolean) is
      begin
         if tete /= null then
            if tete.employe.id_employe.id_nom = nom
              and then tete.employe.technicien = tech
            then
               tete.employe.depart := true;
            else
               recherche (tete.suiv, nom, tech);
            end if;
         end if;
      end recherche;

   begin
      --Saisie du nom
      put ("Nom : ");
      saisie_nom (nom);

      --Saisie de la catégorie
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

      recherche (tete, nom, tech);

   end depart_employe;

end gestion_personnel;
