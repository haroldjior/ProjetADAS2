with ada.text_io, ada.characters.handling;
use ada.text_io, ada.characters.handling;

package body gestion_identite is

   --Saisie du nom et prenom d'une personne, selon les contraintes du sujet
   procedure saisie_nom
     (mot : out T_mot; k : out integer; erreur : out boolean)
   is
      n_trait : integer := 0;
   begin
      loop
         get_line (mot, k);
         mot := to_upper (mot);
         exit when k > 0;
         put_line ("/!\ La saisie ne peut pas etre vide");
      end loop;

      erreur := false;

      --Commence ou termine par _
      if (mot (k) = '_') or (mot (1) = '_') then
         put ("erreur 1"); --debug
         erreur := true;
      end if;

      for i in 1 .. k loop

         --Contient un chiffre au milieu ou contient des caractères interdits
         if (mot (i) not in '0' .. '9' | 'a' .. 'z' | 'A' .. 'Z' | '_') then
            put ("erreur 2"); --debug
            erreur := true;
            exit;
         elsif (mot (i) in '0' .. '9')
           and then (mot (i + 1) in 'a' .. 'z' | 'A' .. 'Z')
         then
            put ("erreur 3"); --debug
            erreur := true;
            exit;

         --Conteur de _
         elsif mot (i) = '_' then
            put ("trait"); --debug
            n_trait := n_trait + 1;
         end if;
      end loop;

      --Contient plus de 1 _
      if n_trait > 1 then
         put ("erreur 4"); --debug
         erreur := true;
      end if;

   end saisie_nom;

   --Saisie de l'identité complète d'une personne
   procedure saisie_identite (id : out T_identite) is
      erreur : boolean;
   begin

      --Saisie du nom
      loop
         put ("Nom : ");
         saisie_nom (id.id_nom.nom, id.id_nom.knom, erreur);
         exit when erreur = false;
         put_line ("/!\ Nom invalide");
      end loop;

      --Saisie du prénom
      loop
         put ("Prenom : ");
         saisie_nom (id.id_prenom.prenom, id.id_prenom.kprenom, erreur);
         exit when erreur = false;
         put_line ("/!\ Prenom invalide");
      end loop;
   end saisie_identite;

   --Affichage de l'identite d'une personne
   procedure affichage_id (id : in T_identite) is
   begin
      put (id.id_nom.nom (1 .. id.id_nom.knom));
      new_line;
      put (id.id_prenom.prenom (1 .. id.id_prenom.kprenom));
      new_line;
   end affichage_id;

end gestion_identite;
