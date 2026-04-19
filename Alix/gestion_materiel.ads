with ada.text_io, ada.integer_text_io,gestion_date;
USE  Ada.Text_Io, Ada.Integer_Text_Io,gestion_date;

package Gestion_Materiel IS

   TYPE T_Type_Materiel IS(Camera, Plateforme, Sono,Projecteur,Lumiere);
   TYPE T_Materiel IS RECORD
      mat: T_Type_Materiel;
      Id:Natural;
      Date_Service:T_Date;
      Nb_J_Utilisation:Natural;
      Disponibilite:Boolean;
      Suppression:boolean;
   END RECORD;

   TYPE T_Cell_Materiel;
   TYPE T_Ptr_Materiel IS ACCESS T_Cell_Materiel;
   TYPE T_Cell_Materiel IS RECORD
      Val:T_Materiel;
      Suiv:T_Ptr_Materiel;
   END RECORD;
 FUNCTION Maxid(Tete:T_Ptr_Materiel) RETURN Integer;
PROCEDURE Ajoutpack (Tete: IN OUT T_Ptr_Materiel) ;

   PROCEDURE Inserer(Tete : IN OUT T_Ptr_Materiel; Id : Natural; Cat : T_Type_Materiel;  J : Integer; M : T_Nom_Mois; A : Integer; Dispo : Boolean; Supp: Boolean);
   PROCEDURE Charger_Donnees_Initiales(Tete : IN OUT T_Ptr_Materiel);
   PROCEDURE Visupack(Tete: IN T_Ptr_Materiel);
   procedure suppack(tete: in out T_ptr_materiel; num: in integer; cat: IN T_Type_Materiel );
   PROCEDURE Visupackdispo(Tete: IN T_Ptr_Materiel);
   PROCEDURE SuppackD( Tete: IN OUT T_Ptr_Materiel; D2: IN T_Date );
   FUNCTION Meuilleurpa(Pa:T_Ptr_Materiel; Cat:T_Type_Materiel) RETURN T_Ptr_Materiel;
   PROCEDURE Liberer_Pack(Tete: IN OUT T_Ptr_Materiel;Npack: IN Natural);
   PROCEDURE Mettre_A_Jour_Materiel(tete : IN OUT T_Ptr_Materiel; ID_Mat : Integer; Jours : Integer);

END Gestion_Materiel;

