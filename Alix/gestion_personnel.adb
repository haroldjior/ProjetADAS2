With Gestion_identite, ada.Text_IO, ada.Integer_Text_IO;
USE Gestion_Identite,Ada.Text_IO,Ada.Integer_Text_IO;

Package body Gestion_Personnel is

procedure saisie_pers(P : out t_pers) is
    Car : Character;
    begin
    Saisie_identite (P.identite);
    loop --boucle de saisie securisee du type de personnel
    Put("Role du personnel : Ingenieur (1) ou Technicien (2) ?"); new_line;
    get(car);
    case car is
    when '1' => P.ingenieur := true; exit;
    when '2' => P.ingenieur := false; exit;
    when others => put("Veuillez reessayer la saisie."); new_line;
    end case;
    end loop;
    skip_line;
    P.Nb_J_presta := 0;
    P.dispo := true;
    P.depart := false;
end saisie_pers;

Procedure ajout_pers (Liste : in out t_ptr_pers; P : in T_pers) is
   B1,B2 : Boolean;
   po:T_ptr_pers:=liste;
BEGIN

while Po /= null loop
        Meme_NP (Po.val.identite.Nom, P.identite.nom, B1); --on cherche si il y a une correspondance de noms
        Meme_NP (Po.val.identite.Prenom, P.identite.Prenom, B2); --Idem mais pour les prenoms
      IF (B1 AND B2) and then (Po.val.ingenieur = P.ingenieur) then
            Put_Line("Erreur : Ce membre du personnel existe deja avec ce role.");
            exit;
        end if;
        Po:= Po.suiv;
    end loop;
    Liste := new t_cell_pers'(P, Liste);
end ajout_pers;

procedure ajout_pers_liste (liste : in out t_ptr_pers) is
    P : T_pers;
begin
    saisie_pers (p);
    ajout_pers (Liste, P);
end ajout_pers_liste;

procedure affi_pers (P : in t_pers) is
begin
    affi_identite (P.identite);
    Put("Jours de prestation a son actif : "); put(P.Nb_J_presta,3); new_line;
    If P.ingenieur = true then
        put("Role : ingenieur"); new_line;
    else
        put("Role : Technicien"); new_line;
    end if;
    If P.dispo = true then
        put("Ce membre du personnel est actuellement disponible"); new_line;
    else
        put("Ce membre du personnel est actuellement indisponible"); new_line;
    end if;
    if P.depart = true then
        PUT("Ce membre du personnel a une demande de dpart d'active"); new_line;
    else
        put("Ce membre du personnel n'a pas de demande de depart d'active"); new_line;
    end if;
end affi_pers;

procedure visu_pers (Liste : in t_ptr_pers) is
    begin
    if liste /= null then
    put("-----------------------------------"); new_line;
    affi_pers (Liste.val);
    visu_pers (Liste.suiv);
    end if;
end visu_pers;

procedure del_pers (Liste : in out t_ptr_pers; P : in out T_pers) is
    b1,B2 : boolean;
begin
    if liste /= null then
        Meme_NP (Liste.Val.identite.Nom, P.identite.Nom, B1); -- on cherche une correspondance de noms
        Meme_NP (Liste.Val.identite.Prenom,P.identite.Prenom, B2); -- idem pour les prenoms
      IF (B1 = True AND B2 = True) AND THEN (Liste.Val.Ingenieur = P.Ingenieur) THEN
         if liste.val.dispo = true then
                liste := liste.suiv;
                Put("Personnel supprime de la liste avec succes"); new_line;
            else --Si le presonnel est en mission on enregistre la demande
                liste.val.depart := true;
                put("La demande de suppression a ete enregistree et sera effectuee quand l'employe reviendra de mission"); new_line;
            end if;
        else
            del_pers (Liste.suiv, P);
        end if;
    else
        put("Aucun personnel correspondant n'a ete trouve dans la liste."); new_line;
    end if;
end del_pers;

procedure supprimer_pers (Liste : in out t_ptr_pers) is
    P : T_pers;
    car : Character;
begin
    if liste = null then
        put("Aucun membre de personnel dans la liste");
    else
        Saisie_identite (P.identite);
        loop
            Put("Role du personnel : Ingenieur (1) ou Technicien (2) ?"); new_line;
            get(car);
            case car is
                when '1' => P.ingenieur := true; exit;
                when '2' => P.ingenieur := false; exit;
                when others => put("Veuillez reessayer la saisie."); new_line;
            end case;
        end loop;
        skip_line;
        del_pers (Liste, P);
    end if;
end supprimer_pers;

procedure visu_mb_pers (Liste : in t_ptr_pers; P : in T_pers) is
    B1,B2 : boolean;
    begin
    if liste = null then
        put("Aucun membre du personnel ne correspond au criteres recherches"); new_line;
    else
        Meme_NP (Liste.val.identite.Nom, P.identite.Nom, B1);
        Meme_NP (Liste.val.identite.Prenom, P.identite.Prenom, B2);
        if B1 = true and then B2 = true then
            if Liste.Val.ingenieur = P.ingenieur then
                affi_pers (Liste.val);
            else
                visu_mb_pers (Liste.suiv, P);
            end if;
        else
            visu_mb_pers (Liste.suiv, P);
        end if;
    end if;
end visu_mb_pers;

procedure Visu_membre_pers (liste : in t_ptr_pers) is
    p : T_pers;
    car : Character;
    begin
    if liste = null then
        put("La liste des membres du personnel est vide"); new_line;
    else
        Saisie_identite (P.identite);
        loop
            Put("Role du personnel : Ingenieur (1) ou Technicien (2) ?"); new_line;
            get(car);
            case car is
                when '1' => P.ingenieur := true; exit;
                when '2' => P.ingenieur := false; exit;
                when others => put("Veuillez reessayer la saisie."); new_line;
            end case;
        end loop;
        skip_line;
        visu_mb_pers(liste,P);
    end if;
    END Visu_Membre_Pers;



function Meuilleurp (Listep :  t_ptr_pers; bingenieur:  Boolean) return t_ptr_pers is
    P : t_ptr_pers := Listep;
    Meilleur : t_ptr_pers := null;
begin
    while P /= null loop
        if P.val.ingenieur = Bingenieur and then P.val.dispo = True then
            if Meilleur = null or else P.val.Nb_J_presta < Meilleur.val.Nb_J_presta then
                Meilleur := P;
            end if;
      END IF;
     P := P.suiv;
    end loop;
    return Meilleur;
END Meuilleurp;

PROCEDURE Liberer_Pers(ListeP: T_Ptr_Pers; ID_Cherche : IN T_Identite) IS
P : t_ptr_pers := listep;
B1, B2 : Boolean;
begin
   while P /= null loop
      Meme_NP(P.Val.identite.Nom, ID_Cherche.Nom, B1);
      Meme_NP(P.Val.identite.Prenom, ID_Cherche.Prenom, B2);
      if B1 and B2 then
         P.Val.dispo := True;
         exit;
      end if;
      P := P.Suiv;
   end loop;
END Liberer_Pers;


PROCEDURE Charger_P(liste: in OUT T_Ptr_Pers) IS
   ID: T_Identite;
   P1: T_Pers;

BEGIN
ID.Nom.K := 6;
ID.Nom.Mot(1..6) :="Galvin";
ID.Prenom.K := 3;
ID.Prenom.Mot(1..3) :="Luc";
P1.identite := ID;
P1.dispo := false;
P1.ingenieur := true;
P1.Nb_J_presta := 0;
P1.depart := false;
ajout_pers (Liste, P1);
ID.Nom.K := 6;
ID.Nom.Mot(1..6) :="Aurele";
ID.Prenom.K := 4;
ID.Prenom.Mot(1..4) :="Marc";
P1.identite := ID;
P1.dispo := false;
P1.ingenieur := true;
P1.Nb_J_presta := 0;
P1.depart := false;
ajout_pers (Liste, P1);
ID.Nom.K := 6;
ID.Nom.Mot(1..6) :="Guerre";
ID.Prenom.K := 6;
ID.Prenom.Mot(1..6) :="Martin";
P1.identite := ID;
P1.dispo := false;
P1.ingenieur := false;
P1.Nb_J_presta := 0;
P1.depart := false;
ajout_pers (Liste, P1);
ID.Nom.K := 3;
ID.Nom.Mot(1..3) :="Fer";
ID.Prenom.K := 5;
ID.Prenom.Mot(1..5) :="Lucie";
P1.identite := ID;
P1.dispo := true;
P1.ingenieur := false;
P1.Nb_J_presta := 0;
P1.depart := false;
   Ajout_Pers (Liste, P1);
END Charger_P;



END Gestion_Personnel;

