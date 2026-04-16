WITH Ada.Text_IO, Ada.Integer_Text_IO;
USE Ada.Text_IO, Ada.Integer_Text_IO;

-- Ajout de Gestion_Perso pour r�cup�rer le T_Role
WITH Gestion_Date, Gestion_Id, Gestion_Matos, Gestion_Clients,
   Gestion_Perso;
USE Gestion_Date, Gestion_Id, Gestion_Matos, Gestion_Clients,
   Gestion_Perso;

PACKAGE Gestion_Demandes IS

   -- dur�e loca 1 a10 jours
   SUBTYPE T_Duree IS Natural RANGE 1 .. 10;


   TYPE T_Demande IS
      RECORD
         Id_Demande     : Integer;
         Client         : T_Identite;
         Duree          : T_Duree;
         Date_Demande   : T_Date;
         Accompagnement : T_Role;       -- T_Role de Gestion_Perso
         Type_Materiel  : T_Equipement; -- Gestion_Matos
      END RECORD;
   --------------------------------------------------------------------
   TYPE T_Cellule_Demande;
   TYPE Ptr_Demande IS ACCESS T_Cellule_Demande;

   TYPE T_Cellule_Demande IS
      RECORD
         Val  : T_Demande;
         Suiv : Ptr_Demande;
      END RECORD;

   -- File attente (fifo)
   TYPE T_File_Demande IS
      RECORD
         Tete  : Ptr_Demande := NULL;
         Queue : Ptr_Demande := NULL;
      END RECORD;

   --------------------------------------------------------

   PROCEDURE Enregistrer_Demande (
         File_Demandes : IN OUT T_File_Demande;
         Arbre_Clients : IN OUT Ptr_Client;
         Date_Du_Jour  : IN     T_Date;
         Prochain_Id   : IN OUT Integer);

   PROCEDURE Visualiser_Demandes (
         File_Demandes : IN     T_File_Demande);

   PROCEDURE Supprimer_Demande (
      File_Demandes : IN OUT T_File_Demande);

procedure Initialiser_Demandes (
      File_Demandes : out T_File_Demande;
      Arbre_Clients : in out Ptr_Client);

PROCEDURE Supprimer_Demande_Automatique (
         File_Demandes : IN OUT T_File_Demande;
         Id_Cible      : IN     Integer);


END Gestion_Demandes;