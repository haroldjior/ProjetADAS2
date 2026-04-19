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

   function passage_lendemain
     (date : in out T_date; tab_mois : in out T_tab_mois) return T_date;

   function ordre_dates
     (D1, D2 : T_date)
      return boolean; --true si D1 est avant D2 false sinon y compris pour la meme date

   function ecart_dates
     (D1, D2 : T_date; tab_mois : T_tab_mois) return integer;

   function dates_egales (D1, D2 : T_date) return Boolean;

end gestion_date;
