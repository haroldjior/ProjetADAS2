With ada.text_io, ada.Integer_Text_IO;
Use ada.text_io, ada.Integer_Text_IO;


package Gestion_identite is

Subtype T_mot is string(1..50);

Type T_nomPnom is record
   Mot : T_mot;
   K : integer;
end record;

Type T_identite is record
   Nom,Prenom : T_NomPnom;
End record;

procedure Saisie_NP (NP : out T_nomPnom);
procedure Saisie_identite (I : out T_identite);
procedure Affi_NP (NP : in T_nomPnom);
procedure affi_identite (I : in T_identite);
procedure Meme_NP (I1,I2 : in T_nomPnom; Meme : out boolean);
procedure comp_identite (I1,I2 : in T_identite;I1superieur : out Boolean);
end Gestion_identite;