package gestion_date is

   type T_liste_mois is
     (janvier,
      fevrier,
      mars,
      avril,
      mai,
      juin,
      juillet,
      aout,
      septembre,
      octobre,
      novembre,
      decembre);

   type T_mois is record
      mois : T_liste_mois;
      nbj  : integer range 0 .. 31;
   end record;

   type T_tab_mois is array (T_liste_mois) of Integer;

   type T_date is record
      jour  : integer range 0 .. 31;
      mois  : T_liste_mois;
      annee : positive;
   end record;

   function bissextile
     (A : integer) return boolean; -- true si annee bisextile false sinon

   function nb_J_mois
     (liste_mois : T_liste_mois; annee : integer)
      return T_tab_mois; -- crée le tableau avec le nombre de jours de chaque mois

   procedure saisie_date (date : in out T_date; tab_mois : in out T_tab_mois);

   procedure visu_date (date : in T_date);

   procedure passage_lendemain
     (date : in out T_date; tab_mois : in out T_tab_mois);

   function ecart_dates
     (D1, D2 : T_date; tab_mois : T_tab_mois) return integer;

end gestion_date;
