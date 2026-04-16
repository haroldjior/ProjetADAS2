WITH Ada.Text_IO, Ada.Integer_Text_IO;
USE Ada.Text_IO, Ada.Integer_Text_IO;
WITH Gestion_Date, Gestion_Matos, Gestion_Demandes;
USE Gestion_Date, Gestion_Matos, Gestion_Demandes;
WITH Gestion_Id, Gestion_Perso;
USE Gestion_Id, Gestion_Perso;

PACKAGE Gestion_Locations IS

   TYPE T_Location IS
      RECORD
         Num_Demande   : Integer;
         Client        : T_Identite;
         Duree         : Natural;
         Date_Debut    : T_Date;
         Date_Fin      : T_Date;
         Attente       : Natural;
         Prestataire   : T_Identite;
         Role_Perso    : T_Role;
         Id_Materiel   : Integer;
         Type_Materiel : T_Equipement;
      END RECORD;

   TYPE T_Cellule_Location;
   TYPE Ptr_Location IS ACCESS T_Cellule_Location;

   TYPE T_Cellule_Location IS
      RECORD
         Val  : T_Location;
         Suiv : Ptr_Location;
      END RECORD;

   --------------------------------------------------------

   -- Proc�dure pour cr�er une location � partir d'une demande satisfaite
   -- Elle calcule la Date_Fin et la dur�e d'Attente
   PROCEDURE Creer_Location (
         Liste_Loc     : IN OUT Ptr_Location;
         Demande       : IN     T_Demande;
         Date_Actuelle : IN     T_Date;
         Pack_Id       : IN     Integer;
         Employe_Id    : IN     T_Identite;
         Employe_Role  : IN     T_Role);
   ----------------------------------------------------
   PROCEDURE Afficher_Location (
         Loc : IN     T_Location);
   ----------------------------------------------------
   PROCEDURE Visu_Liste_Locations (
         Pt : IN     Ptr_Location);
   ----------------------------------------------------
   PROCEDURE Visu_Locations_Client (
         Pt     : IN     Ptr_Location;
         Client : IN     T_Identite);
   ----------------------------------------------------

   PROCEDURE Visu_Prestations_Employe (
         Pt      : IN     Ptr_Location;
         Employe : IN     T_Identite);

   ----------------------------
   PROCEDURE Loc_Possible (
         Demande      : IN     T_Demande;
         Liste_Matos  : IN OUT Ptr_Matos;
         Liste_Perso  : IN OUT Ptr_Employe;
         Liste_Loc    : IN OUT Ptr_Location;
         Date_Du_Jour : IN     T_Date;
      Satisfaite   :    OUT Boolean);

PROCEDURE Loc_archivage (
         Liste_Loc_En_Cours : IN OUT Ptr_Location;
         Liste_Loc_Archives : IN OUT Ptr_Location;
   Date_Du_Jour       : IN     T_Date);


 PROCEDURE Initialiser_Locations (
         Liste_Loc :    OUT Ptr_Location);


END Gestion_Locations;