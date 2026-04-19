with gestion_materiel,
     gestion_personnel,
     gestion_demandes,
     gestion_locations,
     gestion_clients,
     gestion_date,
     gestion_identite;
use gestion_materiel,
    gestion_personnel,
    gestion_demandes,
    gestion_locations,
    gestion_clients,
    gestion_date,
    gestion_identite;

package gestion_donnees is

   procedure Reinitialiser_Archive;

   function faire_date
     (J : integer; M : T_liste_mois; A : positive) return T_date;

   function init_mat
     (app          : in T_appareil;
      num          : in integer;
      date_service : in T_date;
      loue         : in boolean;
      sup          : in boolean) return T_materiel;

   function faire_nom (N : string) return T_nom;
   function faire_prenom (P : string) return T_prenom;
   function faire_identite (Nom, Prenom : string) return T_identite;

   function init_employe
     (Id_E       : in T_identite;
      ingenieur  : in boolean;
      nbj_presta : in integer;
      dispo      : in boolean;
      D_Depart   : in boolean) return T_employe;

   function init_demande
     (num    : in integer;
      nom    : in string;
      prenom : in string;
      app    : in T_appareil;
      duree  : in positive;
      date   : in T_date;
      acc    : in integer) return T_Demande;

   function init_location
     (num    : in integer;
      nom    : in string;
      prenom : in string;
      duree  : in integer;
      date_d : in T_date;
      date_f : in T_date;
      delais : in integer;
      acc    : in integer;
      id_m   : in integer;
      app    : in T_appareil;
      interv : in T_Pteur_E := null) return T_location;

   procedure init_donnees
     (teteM  : out T_Pteur_M;
      teteE  : out T_Pteur_E;
      file_D : out T_File_Demandes;
      teteL  : out T_pteur_L;
      teteC  : out pt_clients);

end gestion_donnees;
