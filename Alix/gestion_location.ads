with ada.text_io, ada.integer_text_io,gestion_date,gestion_materiel,gestion_demandes,gestion_client,gestion_identite,gestion_personnel;
use  ada.text_io, ada.integer_text_io,gestion_date,gestion_materiel,gestion_demandes,gestion_client,gestion_identite,gestion_personnel;

PACKAGE Gestion_Location IS

   TYPE T_Location IS RECORD
      Id:Natural;
      num:integer;
      Client:T_Identite;
      Duree:Integer;
      Date_D:T_Date;
      Date_F:T_Date;
      Duree_Attente: Integer;
      Accompagnant:T_Accompagnement;
      noma:T_identite;
      Materiel:T_Type_Materiel;
   END RECORD;

   TYPE T_Cell_Location;
   TYPE T_Ptr_Location IS ACCESS T_Cell_Location;
   TYPE T_Cell_Location IS RECORD
      Val: T_Location;
      Suiv:T_Ptr_Location;
   END RECORD;
   PROCEDURE Inserer_Recursive(tete : IN OUT T_Ptr_Location; Nouv : IN T_Location);
   PROCEDURE Inserer(Tetel : IN OUT T_ptr_location;
      Ids : Natural;
      nump: integer;
      Client : T_identite;
      Duree : Integer;
      jd: integer;
      Md : T_Nom_Mois;
      Ad : Integer;
      jf: integer;
      Mf : T_Nom_Mois;
      Af : Integer;
      Duree_Attente : Integer;
      Accompagnant:T_Accompagnement;
      noma:T_identite;
      materiel:T_type_materiel);
   PROCEDURE Charger_Donnees_L(Tetel : IN OUT T_Ptr_Location);
   PROCEDURE Visul(Tetel: IN T_Ptr_Location);
   FUNCTION Calculfacture(L:T_Location) RETURN Integer;
   PROCEDURE Affi_Une_Location(Loc : IN T_Location) ;
   PROCEDURE Afficher_Loc_Client(Liste : IN T_Ptr_Location;  Client_Cherche : IN T_Identite);
   PROCEDURE Visu_Locations_Client(L_En_Cours : IN T_Ptr_Location; L_Archives : IN T_Ptr_Location; Client_Cherche : IN T_Identite);
   PROCEDURE Afficher_Loc_Employe(Liste  : IN T_Ptr_Location; ID_Emp : IN T_Identite);
   PROCEDURE Visu_Par_Employe(L_En_Cours : IN T_Ptr_Location; L_Archives : IN T_Ptr_Location; Nom_Emp : IN T_Identite);
PROCEDURE Archivages(Liste_EC   : IN OUT T_Ptr_Location;    Liste_Arch : IN OUT T_Ptr_Location; Date_Ref : IN T_Date; Racine_C   : IN OUT T_Ptr_Client; Liste_M : IN OUT T_Ptr_Materiel; Liste_P : IN OUT T_Ptr_Pers);

 pROCEDURE Traiter_File_Demandes(
    F_Demandes : IN OUT T_File_Demande;
    L_En_Cours : IN OUT T_Ptr_Location;
    Liste_M    : IN OUT T_Ptr_Materiel;
    Liste_P    : IN OUT T_Ptr_Pers;
    Date_Jour  : IN T_Date);

procedure lendemaind(Date_j   : IN OUT T_Date;
    L_En_Cours : IN OUT T_Ptr_Location;
   L_Archive  : IN OUT T_Ptr_Location;
   Racine_C   : IN OUT T_Ptr_Client;
    F_Demandes : IN OUT T_File_Demande;
    Liste_M    : IN OUT T_Ptr_Materiel;
    Liste_P    : IN OUT T_Ptr_Pers);

procedure Inserer_De_Demande(     Tetel      : IN OUT T_Ptr_Location;
   D          : IN T_Demande;
   nump:in integer;

    P_Pers     : IN T_Ptr_Pers;
   Date_Debut : IN T_Date;
   attente_F: in integer
      );
PROCEDURE Ajouter_Jours_Et_Liberer(Liste : IN T_Ptr_Pers; ID_Cherche : in T_Identite; Jours : in Integer);



END Gestion_Location;

