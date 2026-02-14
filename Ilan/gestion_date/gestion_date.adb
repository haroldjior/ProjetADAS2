with ada.text_io, ada.integer_text_io, ada.IO_Exceptions;
use ada.text_io, ada.integer_text_io;

package body gestion_date is

   --Fonction qui initialise le tableau de mois, le mois de février sera initalisé pendant la saisie de la date (en fonction de l'année)
   function init_tab_mois (liste_mois : T_liste_mois) return T_tab_mois is
      tab_mois : T_tab_mois;
   begin
      --Initialisation des mois
      for i in tab_mois'range loop
         tab_mois (i).mois := T_liste_mois'val (i - 1);
      end loop;

      --Initialisation du nombre de jours par mois (de janvier à juillet)
      for i in 1 .. 7 loop
         if T_liste_mois'pos (tab_mois (i).mois) mod 2 = 0 then
            tab_mois (i).nb_jour := 31;
         else
            tab_mois (i).nb_jour := 30;
         end if;
      end loop;

      --Initialisation du nombre de jours par mois (de aout à decembre)
      for i in 8 .. 12 loop
         if T_liste_mois'pos (tab_mois (i).mois) mod 2 = 0 then
            tab_mois (i).nb_jour := 30;
         else
            tab_mois (i).nb_jour := 31;
         end if;
      end loop;

      return (tab_mois);
   end init_tab_mois;

   --Fonction qui prend une annee et qui retourne un booleen true si elle est bissextile et false elle ne l'est pas
   function bissextile (annee : integer) return boolean is
   begin
      if ((annee mod 4 = 0) and (annee mod 400 = 0))
        or ((annee mod 4 = 0) and (annee mod 100 /= 0))
      then
         return (true);
      else
         return (false);
      end if;
   end bissextile;

   --Saisie d'une date, avec vérification de la bissextilité de l'année et initialisation du nombre de jour du mois de février dans le tableau de mois
   procedure saisie_date (date : in out T_date; tab_mois : in out T_tab_mois)
   is
      s      : string (1 .. 10);
      k      : integer;
      valide : boolean := false;
      biss   : boolean;
   begin
      loop
         --Saisie du jour
         loop
            begin
               put ("Jour : ");
               get (date.jour);
               skip_line;
               exit when date.jour'Valid;
            exception
               when Constraint_Error =>
                  skip_line;
                  put_line
                    ("/!\ Jour invalide, veuillez entrer un entier compris entre 1 et 31");
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  put_line ("/!\ Jour invalide, veuillez entrer un entier");
            end;
         end loop;

         --Saisie du mois
         loop
            begin
               put ("Mois : ");
               get_line (s, k);
               date.mois := T_liste_mois'value (s (1 .. k));
               exit when date.mois'valid;
            exception
               when Constraint_Error =>
                  skip_line;
                  put_line
                    ("/!\ Mois invalide, veuillez entrer un nom de mois valide");
            end;
         end loop;

         --Saisie de l'année
         loop
            begin
               put ("Annee : ");
               get (date.annee);
               skip_line;
               exit when date.annee'Valid;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  put_line
                    ("/!\ Annee invalide, veuillez entrer un entier positif");
               when Constraint_Error =>
                  skip_line;
                  put_line
                    ("/!\ Annee invalide, veuillez entrer un entier positif");
            end;
         end loop;

         --Initialisation du nb de jour du mois de fevrier en fonction de l'annee
         biss := bissextile (date.annee);
         if biss then
            tab_mois (2).nb_jour := 29;
         else
            tab_mois (2).nb_jour := 28;
         end if;

         --Verification de la validité de la date saisie
         if date.jour <= tab_mois (T_liste_mois'pos (date.mois) + 1).nb_jour
         then
            valide := True;
         elsif (date.mois = T_liste_mois'val (1)) and then (date.jour = 29)
         then
            put
              ("La date saisie est invalide, pas de 29 fevrier pour l'année ");
            put (date.annee, 4);
            new_line;
            put_line ("Veuillez entrer une date valide : ");
         else
            Put ("La date saisie est invalide, pas de ");
            put (date.jour, 2);
            put (" pour le mois de ");
            put (T_liste_mois'image (date.mois));
            New_Line;
            Put_Line ("Veuillez entrer une date valide :");
         end if;
         exit when valide;
      end loop;
   end saisie_date;

   --Affichage d'une date au format JJ/MM/AAAA
   procedure affichage_date (date : in T_date) is
   begin
      if date.jour < 10 then
         put ("0");
         put (date.jour, 1);
      else
         put (date.jour, 2);
      end if;
      put ("/");
      if T_liste_mois'pos (date.mois) + 1 < 10 then
         put ("0");
         put (T_liste_mois'pos (date.mois) + 1, 1);
      else
         put (T_liste_mois'pos (date.mois) + 1, 2);
      end if;
      put ("/");
      put (date.annee, 4);
   end affichage_date;

   --Passage au lendemain
   procedure lendemain (date : in out T_date; tab_mois : in T_tab_mois) is
   begin
      if date.jour = tab_mois (T_liste_mois'pos (date.mois) + 1).nb_jour then
         date.jour := 1;
         if date.mois
           = tab_mois (T_liste_mois'pos (T_liste_mois'last) + 1).mois
         then
            date.mois := T_liste_mois'first;
            date.annee := date.annee + 1;
         else
            date.mois := T_liste_mois'val (T_liste_mois'pos (date.mois) + 1);
         end if;
      else
         date.jour := date.jour + 1;
      end if;
   end lendemain;

   --Différence entre 2 dates en utilisant la procedure de passage au lendemain
   function diff_date
     (date_debut : T_date; date_fin : T_date; tab_mois : T_tab_mois)
      return integer
   is
      diff     : integer := 0;
      date_tmp : T_date;
   begin
      date_tmp := date_debut;
      while date_tmp /= date_fin loop
         lendemain (date_tmp, tab_mois);
         diff := diff + 1;
      end loop;
      return (diff);
   end diff_date;

end gestion_date;
