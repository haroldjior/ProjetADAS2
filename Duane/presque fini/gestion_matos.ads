WITH Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Date;
USE Ada.Text_IO, Ada.Characters.Handling, Ada.Integer_Text_IO, Gestion_Date;

PACKAGE Gestion_Matos IS

   TYPE T_Equipement IS
         (Camera,
          Prise_Son,
          Sono,
          Projection,
          Lumiere);

   TYPE T_Matos IS
      RECORD
         Catego         : T_Equipement;
         Id_Materiel    : Integer      := 0;
         Date_Debut     : T_Date;
         Nb_Utilisation : Natural;
         Dispo          : Boolean;
         Suppression    : Boolean;
      END RECORD;

   TYPE T_Cellule_Matos;
   TYPE Ptr_Matos IS ACCESS T_Cellule_Matos;
   TYPE T_Cellule_Matos IS
      RECORD
         Val  : T_Matos;
         Suiv : Ptr_Matos;
      END RECORD;

   ------------------------------

   PROCEDURE Initialise (
         M : IN OUT T_Matos);

   --------------------------

   PROCEDURE Ajout_Lot (
         Pt : IN OUT Ptr_Matos;
         D  : IN OUT T_Date);

   ------------------------

   PROCEDURE Visu1prod (
         M : IN     T_Matos);

   --------------------------
   PROCEDURE VisuTTProd (
         PT : IN     Ptr_Matos);

   --------------------------------

   PROCEDURE Visudispo (Pt : IN Ptr_Matos);

   ----------------------------

 PROCEDURE Sup1pack (
    Pt : IN OUT Ptr_Matos);

 --------------------

 PROCEDURE Suppression_Programmee (
    Pt : IN OUT Ptr_Matos);

 -----------------------------------

 PROCEDURE Sup_Avant_Date (Pt : IN OUT Ptr_Matos);

---------------------------------

 PROCEDURE Initialiser_Stock (Pt : OUT Ptr_Matos);

---------------------------






END Gestion_Matos;


