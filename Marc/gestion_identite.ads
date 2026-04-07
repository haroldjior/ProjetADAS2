with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_io;

package Gestion_identite is

   subtype T_mot is string (1 .. 20);

   type T_prenom is record
      prenom : T_mot;
      kp     : integer;
   end record;

   type T_Nom is record
      Nom : T_Mot;
      kn  : Integer;
   end record;

   type T_identite is record
      Id_N : T_nom;
      Id_P : T_prenom;
   end record;

   function nom_valide (S : String) return Boolean;
   procedure Saisie_Nom (Nom : out T_Nom);
   procedure Saisie_Prenom (prenom : out T_prenom);
   procedure Saisie_Identite (Id : out T_identite);
   procedure Visualiser_Identite (Id : in T_identite);
   function meme_id (Id1, Id2 : T_identite) return Boolean;
   function id_inferieur (Id1, Id2 : T_identite) return Boolean;

end Gestion_identite;
