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

package body gestion_donnees is

  function faire_date
   (J : integer; M : T_liste_mois; A : positive) return T_date is
  begin
    return (jour => J, mois => M, annee => A);
  end faire_date;

  function init_mat
   (app          : in T_appareil;
    num          : in integer;
    date_service : in T_date;
    loue         : in boolean;
    sup          : in boolean) return T_materiel
  is
    m : T_materiel;
  begin
    m.app := app;
    m.Id_M := num;
    m.Date_service := date_service;
    m.nbj_uti := 0;
    m.loue := loue;
    m.sup := sup;
    return (m);
  end init_mat;

  function faire_nom (N : string) return T_nom is
    mot : T_mot := (others => ' ');
  begin
    mot (1 .. N'Length) := N (N'First .. N'Last);
    return (Nom => mot, kn => N'Length);
  end faire_nom;

  function faire_prenom (P : string) return T_prenom is
    mot : T_mot := (others => ' ');
  begin
    mot (1 .. P'Length) := P (P'First .. P'Last);
    return (prenom => mot, kp => P'Length);
  end faire_prenom;

  function faire_identite (Nom, Prenom : string) return T_identite is
  begin
    return (Id_N => faire_nom (Nom), Id_P => faire_prenom (Prenom));
  end faire_identite;

  function init_employe
   (Id_E       : in T_identite;
    ingenieur  : in boolean;
    nbj_presta : in integer;
    dispo      : in boolean;
    D_Depart   : in boolean) return T_employe
  is
    e : T_employe;
  begin
    e.Id_E := Id_E;
    e.ingenieur := ingenieur;
    e.nbj_presta := nbj_presta;
    e.dispo := dispo;
    e.D_depart := D_Depart;
    return (e);
  end init_employe;

  function init_demande
   (num    : in integer;
    nom    : in string;
    prenom : in string;
    app    : in T_appareil;
    duree  : in positive;
    date   : in T_date;
    acc    : in integer) return T_Demande
  is
    d : T_Demande;
  begin
    d.numero := num;
    d.Client_Demandeur := faire_identite (nom, prenom);
    d.date_demande := date;
    d.Mat := app;
    d.Duree_J := duree;
    d.Acc := acc;
    return (d);
  end init_demande;

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
    app    : in T_appareil) return T_location
  is
    l : T_location;
  begin
    L.num := num;
    L.Id_client := faire_identite (nom, prenom);
    L.duree := duree;
    L.date_d := date_d;
    L.date_f := date_f;
    L.delais := 0;
    L.Acc := acc;
    L.Id_M := id_m;
    L.app := app;
    return l;

  end init_location;

  procedure init_donnees
   (teteM  : out T_Pteur_M;
    teteE  : out T_Pteur_E;
    file_D : out T_File_Demandes;
    teteL  : out T_pteur_L;
    teteC  : out pt_clients) is
  begin
    teteM := null;
    teteE := null;
    teteL := null;
    teteC := null;
    file_D := (Tete => null, Queue => null);
    -- MATERIEL
    --Lumiere
    teteM :=
     new T_cell_M'
      (init_mat (lumiere, 2, faire_date (15, avril, 2026), true, false),
       teteM);
    teteM :=
     new T_cell_M'
      (init_mat (lumiere, 9, faire_date (19, avril, 2026), true, false),
       teteM);
    -- Projection
    teteM :=
     new T_cell_M'
      (init_mat (projection, 3, faire_date (16, avril, 2026), false, false),
       teteM);
    teteM :=
     new T_cell_M'
      (init_mat (projection, 5, faire_date (17, avril, 2026), false, false),
       teteM);
    -- sono
    teteM :=
     new T_cell_M'
      (init_mat (sono, 6, faire_date (17, avril, 2026), false, false), teteM);
    teteM :=
     new T_cell_M'
      (init_mat (sono, 7, faire_date (18, avril, 2026), true, false), teteM);
    -- Cameras
    teteM :=
     new T_cell_M'
      (init_mat (camera, 1, faire_date (15, avril, 2025), false, false),
       teteM);
    teteM :=
     new T_cell_M'
      (init_mat (camera, 4, faire_date (17, avril, 2026), false, false),
       teteM);
    teteM :=
     new T_cell_M'
      (init_mat (camera, 8, faire_date (18, avril, 2026), true, false), teteM);

    --PERSONNEL
    teteE :=
     new T_cell_E'
      (init_employe (faire_identite ("FER", "LUCIE"), false, 0, true, false),
       teteE);
    teteE :=
     new T_cell_E'
      (init_employe
        (faire_identite ("GUERRE", "MARTIN"), false, 0, false, false),
       teteE);
    teteE :=
     new T_cell_E'
      (init_employe (faire_identite ("AURELE", "MARC"), true, 0, false, false),
       teteE);
    teteE :=
     new T_cell_E'
      (init_employe (faire_identite ("GALVIN", "LUC"), true, 0, false, false),
       teteE);

    --DEMANDES
    file_D.Tete :=
     new T_Cell_Demande'
      (init_demande
        (num    => 10,
         nom    => "REBEL",
         prenom => "ALICIA",
         app    => prise_son,
         duree  => 2,
         date   => faire_date (21, avril, 2026),
         acc    => 2),
       file_D.Tete);
    file_D.Queue := file_D.Tete;

    file_D.Tete :=
     new T_Cell_Demande'
      (init_demande
        (num    => 9,
         nom    => "TIGRESSE",
         prenom => "LILY",
         app    => lumiere,
         duree  => 4,
         date   => faire_date (21, avril, 2026),
         acc    => 1),
       file_D.Tete);

    file_D.Tete :=
     new T_Cell_Demande'
      (init_demande
        (num    => 8,
         nom    => "DUBOIS",
         prenom => "JOSETTE",
         app    => lumiere,
         duree  => 2,
         date   => faire_date (21, avril, 2026),
         acc    => 1),
       file_D.Tete);

    file_D.Tete :=
     new T_Cell_Demande'
      (init_demande
        (num    => 5,
         nom    => "TIGRESSE",
         prenom => "LILY",
         app    => camera,
         duree  => 3,
         date   => faire_date (20, avril, 2026),
         acc    => 2),
       file_D.Tete);

    file_D.Tete :=
     new T_Cell_Demande'
      (init_demande
        (num    => 4,
         nom    => "ROMEO",
         prenom => "JULIETTE",
         app    => camera,
         duree  => 2,
         date   => faire_date (20, avril, 2026),
         acc    => 2),
       file_D.Tete);

    file_D.Tete :=
     new T_Cell_Demande'
      (init_demande
        (num    => 2,
         nom    => "PERSONNE",
         prenom => "PAUL",
         app    => prise_son,
         duree  => 4,
         date   => faire_date (19, avril, 2026),
         acc    => 0),
       file_D.Tete);

    --LOCATIONS

    teteL :=
     new T_cell_L'
      (init_location
        (num    => 3,
         nom    => "BELLE",
         prenom => "LUCIE",
         duree  => 5,
         date_d => faire_date (20, avril, 2026),
         date_f => faire_date (24, avril, 2026),
         delais => 0,
         acc    => 2,
         id_m   => 9,
         app    => lumiere),
       teteL);

    teteL :=
     new T_cell_L'
      (init_location
        (num    => 6,
         nom    => "ARC",
         prenom => "JEAN",
         duree  => 10,
         date_d => faire_date (14, avril, 2026),
         date_f => faire_date (23, avril, 2026),
         delais => 0,
         acc    => 0,
         id_m   => 8,
         app    => camera),
       teteL);

    teteL :=
     new T_cell_L'
      (init_location
        (num    => 1,
         nom    => "MOUTON",
         prenom => "ALINE",
         duree  => 6,
         date_d => faire_date (17, avril, 2026),
         date_f => faire_date (22, avril, 2026),
         delais => 0,
         acc    => 2,
         id_m   => 2,
         app    => lumiere),
       teteL);

    teteL :=
     new T_cell_L'
      (init_location
        (num    => 7,
         nom    => "BARTOK",
         prenom => "BELLE",
         duree  => 2,
         date_d => faire_date (21, avril, 2026),
         date_f => faire_date (22, avril, 2026),
         delais => 0,
         acc    => 1,
         id_m   => 7,
         app    => sono),
       teteL);

    --CLIENTS
    enregistrer_client (teteC, faire_identite ("MOUTON", "ALINE"));
    enregistrer_client (teteC, faire_identite ("BELLE", "LUCIE"));
    enregistrer_client (teteC, faire_identite ("PERSONNE", "PAUL"));
    enregistrer_client (teteC, faire_identite ("ARC", "JEAN"));
    enregistrer_client (teteC, faire_identite ("DUBOIS", "JOSETTE"));
    enregistrer_client (teteC, faire_identite ("ROMEO", "JULIETTE"));
    enregistrer_client (teteC, faire_identite ("BARTOK", "BELLE"));
    enregistrer_client (teteC, faire_identite ("REBEL", "ALICIA"));
    enregistrer_client (teteC, faire_identite ("TIGRESSE", "LILY"));

  end init_donnees;
end gestion_donnees;
