WITH Ada.Text_IO, Ada.Integer_Text_IO, Gestion_Id;
USE Ada.Text_IO, Ada.Integer_Text_IO, Gestion_Id;

PACKAGE Gestion_Clients IS

   TYPE T_Client IS
      RECORD
         Id_Client     : T_Identite;
         Nb_Locations  : Natural    := 0;
         Facture       : Natural    := 0;
         Montant_Regle : Natural    := 0;
      END RECORD;


   TYPE T_Arbre_Client;
   TYPE Ptr_Client IS ACCESS T_Arbre_Client;

   TYPE T_Arbre_Client IS
      RECORD
         Val : T_Client;
         Fg  : Ptr_Client;
         Fd  : Ptr_Client;
      END RECORD;

   --------------------------------------------------------
   PROCEDURE Ajouter_Client (
         Arbre      : IN OUT Ptr_Client;
         Id_Nouveau : IN     T_Identite);

   FUNCTION Rechercher_Client (
         Tete   : Ptr_Client;
         Client : T_Identite)
     RETURN Ptr_Client;

   PROCEDURE Afficher_Clients (
         Arbre : IN     Ptr_Client);
   PROCEDURE Affichage_Client (
         Client : IN     T_Client);
   PROCEDURE Enregistrer_Reglement (
      Arbre : IN OUT Ptr_Client);

PROCEDURE Initialiser_Clients (
         Arbre :    OUT Ptr_Client);

END Gestion_Clients;