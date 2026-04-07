with ada.text_io, ada.integer_text_io, ada.IO_Exceptions, gestion_date;
use ada.text_io, ada.integer_text_io, gestion_date;

package body gestion_date is

   function bissextile (A : integer) return boolean is

   begin
      if (A mod 4 = 0 and A mod 100 /= 0) or (A mod 4 = 0 and A mod 400 = 0)
      then
         return (true);
      else
         return (false);
      end if;
   end bissextile;


   function nb_J_mois
     (liste_mois : T_liste_mois; annee : integer) return T_tab_mois
   is
      -- crée le tableau avec le nombre de jours de chaque mois
      tab_mois : T_tab_mois;
   begin
      tab_mois (janvier) := 31;
      if bissextile (annee) then
         tab_mois (fevrier) := 29;
      else
         tab_mois (fevrier) := 28;
      end if;
      tab_mois (mars) := 31;
      tab_mois (avril) := 30;
      tab_mois (mai) := 31;
      tab_mois (juin) := 30;
      tab_mois (juillet) := 31;
      tab_mois (aout) := 31;
      tab_mois (septembre) := 30;
      tab_mois (octobre) := 31;
      tab_mois (novembre) := 30;
      tab_mois (decembre) := 31;
      return (tab_mois);
   end nb_J_mois;

   procedure saisie_date (date : in out T_date; tab_mois : in out T_tab_mois)
   is

      s    : string (1 .. 10);
      k    : integer;
      ok   : boolean := false;
      biss : boolean;

   begin
      loop
         loop
            begin
               put ("Jour : ");
               get (date.jour);
               skip_line;
               exit when date.jour'Valid;
            exception
               when Constraint_Error =>
                  skip_line;
                  put_line ("Entrez un entier compris entre 1 et 31");
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  put_line ("Entrez un entier");
            end;
         end loop;
         loop
            begin
               put ("Mois : ");
               get_line (s, k);
               date.mois := T_liste_mois'value (s (1 .. k));
               exit when date.mois'valid;
            exception
               when Constraint_Error =>
                  skip_line;
                  put_line ("Entrez un nom de mois valide");
            end;
         end loop;
         loop
            begin
               put ("Annee : ");
               get (date.annee);
               skip_line;
               exit when date.annee'Valid;
            exception
               when ada.IO_Exceptions.Data_Error =>
                  skip_line;
                  put_line ("Entrez un entier positif");
               when Constraint_Error =>
                  skip_line;
                  put_line ("Entrez un entier positif");
            end;
         end loop;
         tab_mois := nb_J_mois (date.mois, date.annee);
         biss := gestion_date.bissextile (date.annee);
         if date.jour > tab_mois (date.mois) then
            ok := false;
            put ("La date saisie est invalide");
            New_Line;
         else
            ok := true;
         end if;
         exit when ok = true;
      end loop;

   end saisie_date;

   procedure visu_date (date : in T_date) is
   begin
      put (date.jour, 2);
      put (" ");
      put (T_liste_mois'image (date.mois));
      put (" ");
      put (date.annee, 4);
   end visu_date;

   procedure passage_lendemain
     (date : in out T_date; tab_mois : in out T_tab_mois) is

   begin
      tab_mois := nb_J_mois (date.mois, date.annee);
      if date.jour = tab_mois (Date.mois) then
         date.jour := 1;
         if date.mois = decembre then
            date.mois := janvier;
            date.annee := date.annee + 1;
         else
            date.mois := T_liste_mois'val (T_liste_mois'pos (date.mois) + 1);
         end if;
      else
         date.jour := date.jour + 1;
      end if;
   end passage_lendemain;

   function ecart_dates (D1, D2 : T_date; tab_mois : T_tab_mois) return integer
   is
      ecart           : integer := 0;
      date_tampon     : T_date;
      tab_mois_tampon : T_tab_mois;
   begin
      date_tampon := D1;
      tab_mois_tampon := tab_mois;
      while date_tampon /= D2 loop
         passage_lendemain (date_tampon, tab_mois_tampon);
         ecart := ecart + 1;
      end loop;
      return (ecart);
   end ecart_dates;


end gestion_date;
