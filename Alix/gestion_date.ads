with ada.text_io, ada.integer_text_io;
use  ada.text_io, ada.integer_text_io;

package  gestion_date is

type T_nom_mois is (janvier, fevrier, mars, avril, mai, juin, juillet, aout, septembre, octobre, novembre, decembre);

type T_mois is record
M: T_nom_mois;
nj:integer range 1..31;
end record;

type T_tab_mois is array (T_nom_mois) of integer;

type T_date is record
 j : integer;
 M: T_nom_mois;
 annee: integer;
end record;

procedure saisirdate (D: out T_date) ;
PROCEDURE Visudate(D: IN T_Date);
FUNCTION Lendemain(D :  T_Date) RETURN T_DATE;
FUNCTION AvantD(D1,D2: T_Date) RETURN Boolean;
FUNCTION Nombre_Jours (D: T_Date) return Integer;
FUNCTION JoursMois(M : T_Nom_Mois; A : Integer) RETURN Integer ;
FUNCTION Differenced(D1,D2: T_Date) RETURN Integer;
end gestion_date;
