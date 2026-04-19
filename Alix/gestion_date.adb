with ada.text_io, ada.integer_text_io;
use  ada.text_io, ada.integer_text_io;

package body gestion_date is

procedure saisirdate (D: out T_date) is
num:integer; MJ: T_tab_mois;

begin
    MJ(janvier):=31;
    MJ(fevrier):=28;
    MJ(mars):=31;
    MJ(avril):=30;
    MJ(mai):=31;
    MJ(juin):=30;
    MJ(juillet):=31;
    MJ(aout):=30;
    MJ(septembre):=30;
    MJ(octobre):=30;
    MJ(novembre):=31;
    MJ(decembre):=31;
loop
    put ("entrez le numero du jour ");New_Line;
    get(D.j);Skip_Line ;
    loop
        put("entrez le numero du mois"); new_line;
        get(num); skip_line;
        exit when  num <= 12 and num >= 1;
        put_line("le numero du mois n'exite pas");
    end loop;
    D.M:=T_nom_mois'val(num-1);
    loop
    put("entrez le numero de l'annee");new_line;
    Get(D.Annee);Skip_Line;
         EXIT WHEN D.Annee <= 3000  AND  D.Annee >= 2000 ;
         Put_Line("le numero de l'annee incorect");
      END LOOP;

    IF D.Annee MOD 4 = 0 AND (D.Annee MOD 100 /= 0 OR D.Annee MOD 400 = 0) THEN
        MJ(fevrier):=29;
    else
        MJ(fevrier):=28;
    end if;

    exit when D.j <= MJ(D.M);
    put("erreur la date n'exite pas, ressayer ");
    new_line;
end loop;
end saisirdate;


procedure visudate(D: in T_date) is
begin
put(D.j,1);put("-");put(T_nom_mois'image(D.M));put("-");put(D.annee,1);

end visudate;

FUNCTION Lendemain(D :  T_Date) RETURN T_DATE IS
   L: T_DATE:=D;
   MJ: T_Tab_mois;
BEGIN
    MJ(janvier):=31;
    MJ(fevrier):=28;
    MJ(mars):=31;
    MJ(avril):=30;
    MJ(mai):=31;
    MJ(juin):=30;
    MJ(juillet):=31;
    MJ(aout):=30;
    MJ(septembre):=30;
    MJ(octobre):=30;
    MJ(novembre):=31;
   MJ(Decembre):=31;

   if (D.Annee mod 4 = 0 and D.Annee mod 100 /= 0) or (D.Annee mod 400 = 0) then
        MJ(fevrier) := 29;
   END IF;

   IF D.J < MJ(D.M) THEN
      L.J:=D.J+1;
   ELSE
      L.J:=1;
      IF D.M=Decembre THEN
         L.M:=Janvier;
         L.Annee:=D.Annee+1;
      ELSE
         L.M:=T_Nom_Mois'Succ(D.M);
      END IF;
   END IF;

   RETURN L;
END Lendemain;


FUNCTION AvantD (D1, D2 : T_Date) RETURN Boolean IS

BEGIN

   IF D1.Annee < D2.Annee THEN

      RETURN True;

   ELSIF D1.Annee > D2.Annee THEN

      RETURN False;

   END IF;


   IF T_Nom_Mois'Pos(D1.M) < T_Nom_Mois'Pos(D2.M) THEN

      RETURN True;

   ELSIF T_Nom_Mois'Pos(D1.M) > T_Nom_Mois'Pos(D2.M) THEN

      RETURN False;

   END IF;

   IF D1.J < D2.J THEN

      RETURN True;

   ELSE

      RETURN False;

   END IF;

END AvantD;

FUNCTION Nombre_Jours (D: T_Date) return Integer IS
   J:Integer:=D.j;
   M:T_nom_Mois:=Janvier;
BEGIN
      WHILE M < D.M LOOP
         j := j + JoursMois(M, D.Annee);
         M := T_Nom_Mois'Succ(M);
   END LOOP;

   RETURN J;

END Nombre_Jours;



FUNCTION JoursMois(M : T_Nom_Mois; A : Integer) RETURN Integer IS
   BEGIN
      CASE M IS
         WHEN Janvier | Mars | Mai | Juillet | Aout | Octobre | Decembre => RETURN 31;
         WHEN Avril | Juin | Septembre | Novembre => RETURN 30;
         WHEN Fevrier =>
            IF (A MOD 4 = 0 AND A MOD 100 /= 0) OR (A MOD 400 = 0) THEN
               RETURN 29;
            ELSE
               RETURN 28;
            END IF;
      END CASE;
   END JoursMois;

   FUNCTION Differenced(D1,D2: T_Date) RETURN Integer IS
   BEGIN
      RETURN
         Nombre_Jours(D1)- Nombre_Jours(D2)-1;
   END Differenced;



END Gestion_Date;












