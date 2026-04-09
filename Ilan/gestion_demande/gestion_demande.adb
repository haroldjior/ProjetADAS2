with ada.text_io,
     ada.integer_text_io,
     ada.characters.handling,
     ada.IO_Exceptions,
     gestion_date,
     gestion_identite,
     gestion_client,
     gestion_materiel;
use ada.text_io,
    ada.integer_text_io,
    ada.characters.handling,
    gestion_date,
    gestion_identite,
    gestion_client,
    gestion_materiel;

package body gestion_demande is

   procedure affichage_demande (dem : in T_dem_loca) is
   begin
      --Numero de la demande
      put ("Numero de la demande : ");
      put (dem.num, 2);
      new_line;

      --Identite du client
      affichage_id (dem.id_client);

      --Duree de la location
      put ("Duree de la location : ");
      put (dem.duree, 2);
      put_line (" jour(s)");

      --Date de la demande
      put ("Date de la demande : ");
      affichage_date (dem.date);
      new_line;

      --Accompagnement
      if dem.accomp = 0 then
         put ("Pas de demande d'accompagnement");
      elsif dem.accomp = 1 then
         put ("Accompagnement : Technicien");
      elsif dem.accomp = 2 then
         put ("Accompagnement : Ingenieur");
      end if;
      new_line;

      --Type de materiel
      put ("Type de materiel : ");
      put (T_cat_materiel'image (dem.materiel));
      new_line;

   end affichage_demande;

   --Visualisation de l'ensemble des demandes
   procedure visu_demandes (file : in T_file_dem) is
      procedure aux (tete : in P_dem_loca) is
      begin
         if tete /= null then
            affichage_demande (tete.demande);
            aux (tete.suiv);
         end if;
      end aux;
   begin
      aux (file.debut);
   end visu_demandes;


   procedure saisie_demande (dem : out T_dem_loca; date : in T_date) is
      choix_accomp, choix_tech : Character;
      s                        : T_mot;
      k                        : integer;

   begin
      --Numéoro de la demande
      dem.num := 0;

      --Identite du client
      saisie_identite (dem.id_client);

      --Duree de la location
      loop
         begin
            put ("Duree de la location en jour : ");
            get (dem.duree);
            skip_line;
            exit when dem.duree'valid;
            put_line ("Duree de la location invalide");
         exception
            when Constraint_Error =>
               put_line ("Duree de la location invalide");
         end;
      end loop;

      --Date du jour
      dem.date := date;

      --Type de materiel
      loop
         begin
            put ("Type de materiel : ");
            get_line (s, k);
            dem.materiel := T_cat_materiel'value (s (1 .. k));
            exit when dem.materiel'valid;
         exception
            when Constraint_Error =>
               put_line ("Saisie invalide");
         end;
      end loop;

      --Accompagnement
      loop
         put_line ("Souhaitez-vous un accompagnement ?");
         put ("(O/N) : ");
         get (choix_accomp);
         skip_line;
         choix_accomp := to_lower (choix_accomp);
         exit when choix_accomp = 'o' or choix_accomp = 'n';
         put_line ("Saisie invalide");
      end loop;
      if choix_accomp = 'n' then
         dem.accomp := 0;
      else
         loop
            put ("Type d'accompagement (T/I) : ");
            get (choix_tech);
            skip_line;
            choix_tech := to_lower (choix_tech);
            exit when choix_tech = 't' or choix_tech = 'i';
            put ("Saisie invalide");
         end loop;
         if choix_tech = 't' then
            dem.accomp := 1;
         else
            dem.accomp := 2;
         end if;
      end if;

   end saisie_demande;

   --Enregistrement d'une nouvelle demande de location
   procedure nouv_demande (file : in out T_file_dem; teteC : in out P_client)
   is
      dem        : T_dem_loca;
      date       : T_date;
      num        : integer := 0;
      client     : T_client;
      Pos_client : P_client;

      --Fonction auxilliaire qui cherche le num de demande le plus haut de la file
      function rech_num_dem (tete : P_dem_loca; num : integer) return integer
      is
      begin
         if tete /= null then
            if tete.demande.num > num then
               return (rech_num_dem (tete.suiv, tete.demande.num));
            else
               return (rech_num_dem (tete.suiv, num));
            end if;
         else
            return (num);
         end if;
      end rech_num_dem;

   begin
      --Saisie de la demande
      saisie_demande (dem, date);

      --Recherche du plus haut numero de demande pour définir celui de la nouvelle demande
      dem.num := rech_num_dem (file.debut, num) + 1;

      --Insertion à la fin de la file
      if file.debut = null then
         file.debut := new T_cell_dem'(dem, null);
         file.fin := file.debut;
      else
         file.fin.suiv := new T_cell_dem'(dem, null);
      end if;

      --Enregistrement du client si nouveau
      Pos_client := recherche_client (teteC, dem.id_client);
      if Pos_client = null then
         client.id_client := dem.id_client;
         client.facture := 0;
         client.montant_regle := 0;
         client.nb_loca := 0;
         insertion_client (teteC, client);
      end if;

   end nouv_demande;

   --Suppression de demande de location (par son numéro)
   procedure supp_demande (file : in out T_file_dem) is

      num : integer;
      procedure aux (tete : in out P_dem_loca; num : in integer) is
         p : P_dem_loca;
      begin
         if tete /= null then
            if tete.demande.num = num then
               p := tete;
               tete := tete.suiv;
               liberer_memoire_demande (p);
            else
               aux (tete.suiv, num);
            end if;
         end if;
      end aux;

   begin

      put ("Numero de la demande : ");
      get (num);
      skip_line;
      aux (file.debut, num);
      if file.debut = null then
         file.fin := null;
      end if;

   end supp_demande;

end gestion_demande;
