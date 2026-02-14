package gestion_date is

   --Liste énumérée des mois de l'année
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

   --Record du mois avec son nombre de jour
   type T_mois is record
      mois    : T_liste_mois;
      nb_jour : integer range 1 .. 31;
   end record;

   --Tableau de tous les mois de l'année avec leurs nombre de jours respectifs
   type T_tab_mois is array (integer range 1 .. 12) of T_mois;

   --Record d'une date au format JJ/MM/AAAA
   type T_date is record
      jour  : integer range 1 .. 31;
      mois  : T_liste_mois;
      annee : positive range 2000 .. 2300;
   end record;

   --Fonction qui initialise le tableau de mois, le mois de février sera initalisé pendant la saisie de la date (en fonction de l'année)
   function init_tab_mois (liste_mois : T_liste_mois) return T_tab_mois;

   --Fonction qui prend une annee et qui retourne un booleen true si elle est bissextile et false elle ne l'est pas
   function bissextile (annee : integer) return boolean;

   --Saisie d'une date, avec vérification de la bissextilité de l'année et initialisation du nombre de jour du mois de février dans le tableau de mois
   procedure saisie_date (date : in out T_date; tab_mois : in out T_tab_mois);

   --Affichage d'une date au format JJ/MM/AAAA
   procedure affichage_date (date : in T_date);

   --Passage au lendemain
   procedure lendemain (date : in out T_date; tab_mois : in T_tab_mois);

   --Différence entre 2 dates en utilisant la procedure de passage au lendemain
   function diff_date
     (date_debut : T_date; date_fin : T_date; tab_mois : T_tab_mois)
      return integer;

end gestion_date;
