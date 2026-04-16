With Ada.Text_IO , Ada.Integer_Text_IO;
USE Ada.Text_IO , Ada.Integer_Text_IO;


PACKAGE Gestion_Date IS

   SUBTYPE Int31 IS Integer RANGE 1..31;
   subTYPE Tint_12 IS integer range 1..12;


   TYPE T_Date IS
      RECORD
         J : Int31;
         M : Tint_12;
         A : Natural;
      END RECORD;

   FUNCTION Annee_Bis (
         A : Natural)
     RETURN Boolean;

   FUNCTION Nb_Jour (
         M : Tint_12;
         A : Natural)
     RETURN Integer;

   PROCEDURE Saisie_Date (
         D : in OUT T_Date);

   PROCEDURE Affichage_Date (
         D : IN     T_Date);

   PROCEDURE Lendemain (
      Date_Du_Jour : IN OUT T_Date);

   PROCEDURE Initialise_Date ( D : IN OUT T_Date);


FUNCTION Date_J (
      D : T_Date)
  RETURN Integer;

FUNCTION Difference_Jours (
      Date1,
      Date2 : T_date)
   RETURN Integer;



END Gestion_Date;
