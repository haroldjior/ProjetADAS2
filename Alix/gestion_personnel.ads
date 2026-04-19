With Gestion_identite, ada.Text_IO, ada.Integer_Text_IO;
USE Gestion_Identite,Ada.Text_IO,Ada.Integer_Text_IO;
Package Gestion_personnel Is

type T_pers is record
identite : T_identite;
ingenieur : boolean;
Nb_J_presta : Integer;
dispo: Boolean;
depart : Boolean;
end record;

type t_cell_pers;
type t_ptr_pers is access t_cell_pers;
type t_cell_pers is record
Val : T_pers;
suiv : t_ptr_pers;
end record;

procedure saisie_pers(P : out t_pers);
Procedure ajout_pers (Liste : in out t_ptr_pers; P : in T_pers);
procedure ajout_pers_liste (liste : in out t_ptr_pers);
procedure affi_pers (P: in T_pers);
procedure visu_pers (Liste : in t_ptr_pers);
procedure del_pers (Liste : in out t_ptr_pers; P : in out T_pers);
procedure supprimer_pers (Liste : in out t_ptr_pers);
procedure visu_mb_pers (Liste : in t_ptr_pers; P : in T_pers);
PROCEDURE Visu_Membre_Pers (Liste : IN T_Ptr_Pers);
FUNCTION MeuilleurP(Listep: T_Ptr_Pers;Bingenieur:Boolean) RETURN T_Ptr_Pers;
PROCEDURE Liberer_Pers(ListeP: IN T_Ptr_Pers; ID_Cherche : IN T_Identite);
procedure charger_p(liste: in out T_ptr_pers);



end Gestion_personnel;

