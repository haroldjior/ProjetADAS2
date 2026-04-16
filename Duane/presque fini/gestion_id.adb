WITH Ada.Text_IO, Ada.Characters.Handling;
USE Ada.Text_IO, Ada.Characters.Handling;

PACKAGE BODY Gestion_Id IS

   PROCEDURE Saisie_Mots (
         Mot  :    OUT T_Mots;
         Kmot :    OUT Integer) IS
      S,
      Savemot         : String (1 .. 20);
      Correct         : Boolean;
      K               : Integer;
      Chiffre_Deja_Vu : Boolean          := False;
   BEGIN
      LOOP
         Correct := True;
         Chiffre_Deja_Vu := False;
         Savemot := (OTHERS=>' ');

         Get_Line(S, K);
         IF K = 0 THEN
            Correct := False;
         ELSE
            Savemot(1..K) := S(1..K);


            FOR I IN 1..K LOOP
               S(I) := To_Upper(S(I));
            END LOOP;

            FOR I IN 1..K LOOP
               CASE S(I) IS
                  WHEN 'A'..'Z' =>
                     IF Chiffre_Deja_Vu THEN
                        Correct := False;
                        EXIT;
                     END IF;
                  WHEN '0'..'9' =>
                     Chiffre_Deja_Vu := True;
                  WHEN '_' =>
                     IF I = 1 OR I = K OR Chiffre_Deja_Vu THEN
                        Correct := False;
                        EXIT;
                     END IF;
                  WHEN OTHERS =>
                     Correct := False;
                     EXIT;
               END CASE;
            END LOOP;
         END IF;

         IF Correct THEN
            Mot := Savemot;
            Kmot := K;
            EXIT;
         ELSE
            Put_Line("Saisie non conforme - format attendu: lettres puis optionnellement chiffres");

            IF K = 20 THEN
               Skip_Line;
            END IF;
         END IF;
      END LOOP;
   END Saisie_Mots;

   ------------------------------------------

   PROCEDURE Saisie_Id (
         Id :    OUT T_Identite) IS
      Mot   : T_Mots;
      Nbmot : Integer;

   BEGIN
      Put ("quel est votre nom?");
      Saisie_Mots(Mot,Nbmot);
      Id.Nom:=Mot;
      Id.Knom:=Nbmot;
      Put ("Quel est votre prenom ?");
      Saisie_Mots(Mot,Nbmot);
      Id.Prenom:=Mot;
      Id.Kprenom:=Nbmot;
   END Saisie_Id;

   ----------------------------------------

   PROCEDURE Visu_Id (
         Id : IN     T_Identite) IS
   BEGIN
      Put ("Prenom : ");
      Put(Id.Prenom(1..Id.Kprenom));
      Put ("Nom : ");
      Put(Id.Nom(1..Id.Knom));
   END;

   -----------------------------------


END Gestion_Id;
