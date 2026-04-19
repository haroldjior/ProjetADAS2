With Ada.Text_IO, ada.Integer_Text_IO, Gestion_personnel, Gestion_identite, Gestion_Client, gestion_materiel, gestion_location, gestion_demandes, Gestion_date, ada.Directories;
use Ada.Text_IO, ada.Integer_Text_IO, Gestion_personnel, Gestion_identite, Gestion_Client, gestion_materiel, gestion_location, gestion_demandes, Gestion_date, ada.Directories;
with Sequential_IO;


Package Gestion_Sauvegarde is
    PACKAGE Fichier_date IS NEW Sequential_Io(T_date);
    package Fichier_Client is new Sequential_IO(T_client);
    package Fichier_Personnel is new Sequential_IO(T_pers);
    package Fichier_Location is new Sequential_IO(T_location);
    package Fichier_demande is new Sequential_IO(T_demande);
    package Fichier_materiel is new Sequential_IO(T_materiel);

procedure Save_date(D : in T_date);
procedure empiler_client(C : in t_ptr_client;P : in out T_ptr_Client);
procedure depiler_client(P :in out T_ptr_Client; C : out T_client);
procedure Save_client(C : in T_ptr_client);
procedure save_personnel(P : in t_ptr_pers);
procedure save_location(L : in t_ptr_location);
procedure save_demande(D : in t_ptr_demande);
procedure save_materiel(M : in t_ptr_materiel);
procedure sauvegarder(D : in t_date; C : in T_ptr_Client; P : in t_ptr_pers; L : in t_ptr_location; De : in t_ptr_demande; M : in t_ptr_materiel);
procedure charger_save(D : out t_date; C : out T_ptr_Client; P : out t_ptr_pers; L : out t_ptr_location; De : out t_file_demande; M : out t_ptr_materiel);
end Gestion_Sauvegarde;