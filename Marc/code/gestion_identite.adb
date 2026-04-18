with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling;
use Ada.Text_IO, Ada.Integer_Text_io, Ada.Characters.Handling;

package body Gestion_identite is

   function nom_valide (S : String) return Boolean is
      Nb_Traits_Bas : Integer := 0;
      Chiffre       : Boolean := False;
   begin
      if S'Length = 0 then
         return False;
      end if;

      if S (S'First) = '_' or S (S'Last) = '_' then
         return False;
      end if;

      for I in S'Range loop
         if S (I) = '_' then
            Nb_Traits_Bas := Nb_Traits_Bas + 1;
            if Nb_Traits_Bas > 1 then
               return False;
            end if;
            if Chiffre then
               return False;
            end if;

         elsif S (I) in '0' .. '9' then
            Chiffre := True;
         elsif (S (I) in 'A' .. 'Z') or (S (I) in 'a' .. 'z') then
            if Chiffre then
               return False;
            end if;
         else
            return False;
         end if;
      end loop;

      return True;
   end nom_valide;

   procedure Saisie_Nom (Nom : out T_Nom) is
      Saisie  : String (1 .. 80);
      k       : Natural;
      Correct : boolean := false;
   begin
      while not Correct loop
         Put ("Entrez le nom : ");
         Get_Line (Saisie, k);

         if k > 0 and k <= 20 then
            if nom_valide (Saisie (1 .. k)) then
               Nom.nom (1 .. k) := To_Upper (Saisie (1 .. k));
               Nom.kn := k;
               Correct := true;
            else
               Put_Line ("Erreur : Format invalide.");
            end if;
         else
            Put_Line ("Erreur : Le nom doit faire entre 1 et 20 caractères.");
         end if;
      end loop;
   end Saisie_Nom;

   procedure Saisie_Prenom (prenom : out T_prenom) is
      Saisie  : String (1 .. 80);
      k       : Natural;
      Correct : boolean := false;
   begin
      while not Correct loop
         Put ("Entrez le prenom : ");
         Get_Line (Saisie, k);

         if k > 0 and k <= 20 then
            if nom_valide (Saisie (1 .. k)) then
               prenom.prenom (1 .. k) := To_Upper (Saisie (1 .. k));
               prenom.kp := k;
               Correct := true;
            else
               Put_Line ("Erreur : Format invalide.");
            end if;
         else
            Put_Line
              ("Erreur : Le prenom doit faire entre 1 et 20 caractères.");
         end if;
      end loop;
   end Saisie_Prenom;

   procedure Saisie_Identite (Id : out T_identite) is
   begin
      Put_Line ("--- Saisie d'une nouvelle identite ---");
      Saisie_Nom (Id.Id_N);
      Saisie_Prenom (Id.Id_P);
      Put_Line ("Identite enregistree avec succes.");
   end Saisie_Identite;

   procedure Visualiser_Identite (Id : in T_identite) is
   begin
      Put (Id.Id_N.Nom (1 .. Id.Id_N.kn));
      Put (" ");
      Put_Line (Id.Id_P.prenom (1 .. Id.Id_P.kp));
   end Visualiser_Identite;

   function meme_id (Id1, Id2 : T_identite) return Boolean is
   begin
      if (Id1.Id_N.Nom (1 .. Id1.Id_N.kn) = Id2.Id_N.Nom (1 .. Id2.Id_N.kn))
        and then
          (Id1.Id_P.prenom (1 .. Id1.Id_P.kp)
           = Id2.Id_P.prenom (1 .. Id2.Id_P.kp))
      then
         return true;
      else
         return false;
      end if;
   end meme_id;

   function id_inferieur (Id1, Id2 : T_identite) return Boolean is
   begin
      if Id1.Id_N.Nom (1 .. Id1.Id_N.kn) < Id2.Id_N.Nom (1 .. Id2.Id_N.kn) then
         return True;
      elsif Id1.Id_N.Nom (1 .. Id1.Id_N.kn) > Id2.Id_N.Nom (1 .. Id2.Id_N.kn)
      then
         return false;
      elsif Id1.Id_N.Nom (1 .. Id1.Id_N.kn) = Id2.Id_N.Nom (1 .. Id2.Id_N.kn)
      then
         if Id1.Id_P.prenom (1 .. Id1.Id_P.kp)
           < Id2.Id_P.prenom (1 .. Id2.Id_P.kp)
         then
            return true;
         else
            return false;
         end if;
      else
         return false;
      end if;
   end id_inferieur;

   function faire_une_id (Nom, Prenom : String) return T_identite is
      Id : T_identite;
   begin
      Id.Id_N.Nom (1 .. Nom'Length) := To_Upper (Nom);
      Id.Id_N.kn := Nom'Length;
      Id.Id_P.prenom (1 .. Prenom'Length) := To_Upper (Prenom);
      Id.Id_P.kp := Prenom'Length;
      return Id;
   end faire_une_id;

end Gestion_identite;
