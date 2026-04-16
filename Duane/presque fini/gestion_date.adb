WITH Ada.Text_IO, Ada.Integer_Text_IO;
USE Ada.Text_IO, Ada.Integer_Text_IO;


PACKAGE BODY Gestion_Date IS


   FUNCTION Annee_Bis (
         A : Natural)
     RETURN Boolean IS

      Bis : Boolean;

   BEGIN

      Bis := False;
      IF (A mod 4 /= 0) AND (A mod 100 /= 0 OR A mod 400 = 0) THEN
         Bis := True;
      ELSE
         Bis := False;
      END IF;

      RETURN (Bis);
   END Annee_Bis;

---------


   FUNCTION Nb_Jour (
         M : Tint_12;
         A : Natural)
     RETURN Integer IS

      Nb : Integer;

   BEGIN

      CASE M IS
         WHEN 01 | 03 | 05 | 07 | 08 | 10 | 12 =>
            Nb := 31;
         WHEN 04 | 06 | 09 | 11 =>
            Nb := 30;
         WHEN 02 =>
            IF Annee_Bis(A) = True THEN
               Nb := 29;
            ELSE
               Nb := 28;
            END IF;
      END CASE;

      RETURN (Nb);
   END Nb_Jour;

----------


   PROCEDURE Saisie_Date (
         D : IN OUT T_Date) IS

   BEGIN

      LOOP
         BEGIN
            Put("Saisir une annee ");
            Get(D.A);
            Skip_Line;
            EXIT WHEN D.A > 2024;
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur de saisie, recommencez");
            WHEN Constraint_Error =>
               Skip_Line;
               Put_Line("Mauvaise valeur, recommencez");
         END;
      END LOOP;


      LOOP
         BEGIN
            Put("Saisir le mois en chiffre ");
            Get(D.M);
            Skip_Line;
            EXIT when D.M>=1 and D.M<=31;
         EXCEPTION
            WHEN Constraint_Error =>
               Skip_Line;
               Put_Line("Mauvaise valeur, recommencez");
         END;
      END LOOP;


      LOOP
         BEGIN
            Put("Saisir le jour (nombre) ");
            Get(D.J);
            Skip_Line;
            EXIT WHEN D.J <= Nb_Jour (D.M, D.A);
         EXCEPTION
            WHEN Data_Error =>
               Skip_Line;
               Put_Line("Erreur de saisie, recommencez");
            WHEN Constraint_Error =>
               Skip_Line;
               Put_Line("Mauvaise valeur, recommencez");
         END;
      END LOOP;

   END Saisie_Date;

---------


   PROCEDURE Affichage_Date (
         D : IN     T_Date) IS

   BEGIN

      Put(D.J);
      Put("/");
      Put(Tint_12'Image(D.M));
      Put("/");
      Put(D.A, 0);
      New_Line;

   END Affichage_Date;

--------

   PROCEDURE Lendemain (
         Date_Du_Jour : IN OUT T_Date) IS

   BEGIN

      IF Date_Du_Jour.J < Nb_Jour (Date_Du_Jour.M, Date_Du_Jour.A) THEN
         Date_Du_Jour.J := Date_Du_Jour.J + 1;
      ELSE
         Date_Du_Jour.J := 1;
         IF Date_Du_Jour.M = Tint_12'Last THEN
            Date_Du_Jour.M := Tint_12'First;
            Date_Du_Jour.A := Date_Du_Jour.A + 1;
         ELSE
            Date_Du_Jour.M := Tint_12'Succ(Date_Du_Jour.M);
         END IF;
      END IF;

   END Lendemain;

--------
   PROCEDURE Initialise_Date (
         D : IN OUT T_Date) IS
   BEGIN
      D.J := 1;
      D.M := 1;
      D.A := 0;
   END Initialise_Date;

--------


   FUNCTION Date_J (
         D : T_Date)
     RETURN Integer IS
      TT_Jours : Integer := 0;

   BEGIN

      FOR I IN 1 .. D.A - 1 LOOP
         IF Annee_Bis(I) THEN
            TT_Jours := TT_Jours + 366;
         ELSE
            TT_Jours := TT_Jours + 365;
         END IF;
      END LOOP;

      FOR I IN 1 .. D.M - 1 LOOP
         TT_Jours := TT_Jours + Nb_Jour(I, D.A);
      END LOOP;

      TT_Jours := TT_Jours + D.J;

      RETURN TT_Jours;
   END Date_J;


   FUNCTION Difference_Jours (
         Date1,
         Date2 : T_Date)
     RETURN Integer IS
Resultat : Integer;

   BEGIN
      Resultat := (Date_J(Date2) - Date_J(Date1));
      RETURN (Resultat);
   END Difference_Jours;


END Gestion_Date;


