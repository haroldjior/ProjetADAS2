PACKAGE Gestion_Id IS

   SUBTYPE T_Mots IS String (1 .. 20);

   TYPE T_Identite IS
      RECORD
         Nom     : T_Mots  := (OTHERS => ' ');
         Knom    : Integer := 0;
         Prenom  : T_Mots  := (OTHERS => ' ');
         Kprenom : Integer := 0;
      END RECORD;

   Mot : T_Mots;

   ---------------------------------
   PROCEDURE Saisie_Mots (
         Mot  :    OUT T_Mots;
         Kmot :    OUT Integer);

   -----------------------------------

   PROCEDURE Saisie_Id (
         Id :    OUT T_Identite);

   -----------------------------------

   PROCEDURE Visu_Id (
         Id : IN     T_Identite);

END Gestion_Id;
