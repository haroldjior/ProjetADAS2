WITH Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Id;
USE Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Id;

PACKAGE Gestion_Perso IS

   TYPE T_Role IS
         (Technicien,
          Ingenieur,
      Autre);

   TYPE T_Employe IS
      RECORD
         Id_Employe : T_Identite;
         Role             : T_Role;
         Nb_J_Presta   : Natural;
         Dispo            : Boolean;
         Depart           : Boolean;
      END RECORD;

   TYPE T_Cellule_Employe;
   TYPE Ptr_Employe IS ACCESS T_Cellule_Employe;
   TYPE T_Cellule_Employe IS
      RECORD
         Val  : T_Employe;
         Suiv : Ptr_Employe;
   END RECORD;

   -----------------------------------

PROCEDURE Initialiseperso (
   E : IN OUT T_Employe);

   --------------------------------------

 PROCEDURE Ajout_Perso (
    Pt : IN OUT Ptr_Employe);

 -------------------------------

 PROCEDURE Visu1perso (
    E : IN     T_Employe);

 --------------------------

PROCEDURE Visuttperso (
   Pt : IN     Ptr_Employe);

-------------------------------

PROCEDURE VisuCEperso (
   Pt : IN     Ptr_Employe);

-------------------------------------

PROCEDURE Depart_Perso (
   Pt : IN OUT Ptr_Employe);

-------------------------------

PROCEDURE Depart_Programme (
   Pt : IN OUT Ptr_Employe);

-------------------------------

PROCEDURE Initialiser_Personnel (
   Pt :    OUT Ptr_Employe);



end gestion_perso;

