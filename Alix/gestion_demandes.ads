with ada.text_io, ada.integer_text_io,gestion_date,gestion_materiel,gestion_identite,gestion_client;
USE  Ada.Text_Io, Ada.Integer_Text_Io,Gestion_Date,gestion_materiel,gestion_identite,gestion_client;

PACKAGE Gestion_Demandes IS

   TYPE T_Accompagnement IS (Aucun,Ingenieur,Technicien);

   TYPE T_Demande IS RECORD
      Id:Natural;
      client: T_identite;
      Duree: Integer;
      Date_Dem:T_Date;
      Accompagnement: T_accompagnement;
      Materiel:T_Type_Materiel;
      attente:integer:=0;
   END RECORD;

   TYPE T_Cell_Demande;
   TYPE T_Ptr_Demande IS ACCESS T_Cell_Demande;
   TYPE T_Cell_Demande IS RECORD
      Val: T_Demande;
      Suiv:T_Ptr_Demande;
   END RECORD;

   TYPE T_File_Demande IS RECORD
      tete,Fin:T_Ptr_Demande;
   END RECORD;
   FUNCTION Max_IdF(F: T_File_Demande) RETURN Integer;

   PROCEDURE Enfilerd(F: IN OUT T_File_Demande ;D: IN OUT T_Demande);
   PROCEDURE Defiler(F: IN OUT T_File_Demande; Recup: OUT  T_Demande; Ok: OUT Boolean);
   PROCEDURE ChargerFa(F: IN OUT T_File_Demande);
   PROCEDURE VisuD(D: IN T_Demande);
   procedure visuF(F: in  T_file_demande);
   PROCEDURE Nouveldemande(F: in out T_File_Demande ; AC : in out T_ptr_Client; D: IN OUT  T_Demande);
   PROCEDURE Enfilern(F: IN OUT T_File_Demande ;D: IN OUT T_Demande);
   procedure supp(tete: in out T_ptr_demande; N : IN Integer; Trouve : OUT Boolean);
   PROCEDURE Suppdl(F: IN OUT T_file_Demande ;N: IN Integer);

end gestion_demandes;



