with Ada.Text_IO,
     Ada.Integer_Text_IO,
     ada.characters.handling,
     Gestion_Clients;
use Ada.Text_IO, Ada.Integer_Text_IO, ada.characters.handling, Gestion_Clients;

package body Gestion_Demandes is

   procedure visu_demande (demande : in T_Demande) is
   begin
      put ("demande numero : ");
      put (demande.numero, 3);
      new_line;
      Visualiser_Identite (demande.Client_Demandeur);
      put ("Duree demandee : ");
      put (demande.Duree_J, 3);
      put ("jours");
      new_line;
      put ("demande effectuee le : ");
      visu_date (demande.date_demande);
      new_line;
      if demande.Acc = 0 then
         put ("pas d'accompagnant demande");
      elsif demande.Acc = 1 then
         put ("demande d'accompagnement par un TECHNICIEN");
      elsif demande.Acc = 2 then
         Put ("demande d'accompagnement par un INGENIEUR");
      end if;
      new_line;
      put ("type de materiel demande : ");
      put (T_appareil'image (demande.Mat));
      new_line;

   end visu_demande;

   procedure visu_file_demandes (file_D : in T_File_Demandes) is
      procedure Aux (tete_D : in pt_demande) is
      begin
         if tete_D /= null then
            visu_demande (tete_D.Demande);
            aux (tete_D.Suiv);
         end if;

      end Aux;
   begin
      Aux (file_D.Tete);
   end visu_file_demandes;

   procedure Saisie_demande (D : out T_Demande; date_ajd : T_date) is
      Choix_acc, type_acc : character;
      s                   : string (1 .. 10);
      k                   : integer;
   begin
      Put_Line ("--- Nouvelle demande de location ---");
      D.numero := 0;
      D.date_demande := date_ajd;
      Saisie_Identite (D.Client_Demandeur);

      loop
         begin
            put
              ("Type de materiel demande (camera/prise_son/sono/projection/lumiere): ");
            get_line (s, k);
            D.Mat := T_appareil'value (s (1 .. k));
            exit when D.Mat'valid;
         exception
            when Constraint_Error =>
               put_line
                 ("Saisie invalide, choisissez parmi camera/prise_son/sono/projection/lumiere ");
         end;
      end loop;
      loop
         begin
            put ("Duree de la demande en jour : ");
            get (D.Duree_J);
            skip_line;
            exit when D.Duree_J'valid;
            put_line ("Duree de la location invalide");
         exception
            when Constraint_Error =>
               skip_line;
               put_line ("Duree de la location invalide");
            when Data_Error =>
               skip_line;
               put_line ("Duree invalide entrez le nombre de jours");
         end;
      end loop;
      loop
         put_line ("Doit-il y avoir un accompagnant ? (O/N) : ");
         get (Choix_acc);
         skip_line;
         Choix_acc := To_Upper (Choix_acc);
         exit when Choix_acc = 'O' or Choix_acc = 'N';
         put_line ("entrez O pour oui et N pour non");
      end loop;
      if Choix_acc = 'N' then
         D.Acc := 0;
      else
         loop
            put ("Technicien ou ingenieur ? (T/I) : ");
            get (type_acc);
            Skip_Line;
            type_acc := To_Upper (type_acc);
            exit when type_acc = 'T' or type_acc = 'I';
            put ("entrez T pour un technicien ou I pour un ingenieur");
         end loop;
         if type_acc = 'T' then
            D.Acc := 1;
         elsif type_acc = 'I' then
            D.Acc := 2;
         end if;
      end if;

   end Saisie_demande;

   procedure ajout_demande_file
     (file_D   : in out T_File_Demandes;
      tete_C   : in out pt_clients;
      date_ajd : T_date)
   is
      demande          : T_Demande;
      Client_Demandeur : T_client;
      nouveau_client   : pt_clients;

      function num_dem_max (tete_D : pt_demande) return integer is
         p   : pt_demande := tete_D;
         max : integer := 0;
      begin
         while p /= null loop
            if p.demande.numero > max then
               max := p.demande.numero;
            end if;
            p := p.suiv;
         end loop;
         return max + 1;
      end num_dem_max;

   begin
      saisie_demande (demande, date_ajd);
      demande.numero := num_dem_max (File_D.Tete);
      if file_D.Tete = null then
         file_D.Tete := new T_Cell_Demande'(demande, null);
         file_D.Queue := file_D.Tete;
      else
         file_D.Queue.Suiv := new T_Cell_Demande'(demande, null);
         file_D.Queue := file_D.Queue.Suiv;
      end if;

      New_Line;
      Put_Line ("La demande suivante a ete ajoutee avec succes :");
      visu_demande (demande);

      nouveau_client := recherche_client (tete_C, demande.Client_Demandeur);
      if nouveau_client = null then
         Client_Demandeur.Identite_Client := demande.Client_Demandeur;
         Client_Demandeur.Facture_Due := 0;
         Client_Demandeur.Montant_Regle := 0;
         Client_Demandeur.Nb_Locations := 0;
         enregistrer_client (tete_C, Client_Demandeur.Identite_Client);
      end if;

   end ajout_demande_file;

   procedure sup_demande (file_D : in out T_File_Demandes) is
      num       : integer;
      courant   : pt_demande;
      precedent : pt_demande;
   begin
      loop
         begin
            if file_D.Tete = null then
               put_line ("La file est vide, aucune demande a supprimer.");
               return;
            else
               put_line ("--- Liste des demandes en attente ---");
               visu_file_demandes (file_D);
               new_line;
            end if;
            put ("Numero de la demande a supprimer : ");
            get (num);
            skip_line;
            exit when num'valid;
         exception
            when Data_Error =>
               skip_line;
               put_line ("Entrez un numero valide");
         end;
      end loop;
      if file_D.Tete = null then
         put_line ("La file est vide");
         return;
      end if;
      if file_D.Tete.Demande.numero = num then
         if file_D.Tete = file_D.Queue then
            -- un seul element : la file devient vide
            file_D.Tete := null;
            file_D.Queue := null;
         else
            file_D.Tete := file_D.Tete.Suiv;
         end if;
         put_line ("Demande supprimee");
         return;
      end if;
      precedent := file_D.Tete;
      courant := file_D.Tete.Suiv;
      while courant /= null loop
         if courant.Demande.numero = num then
            precedent.Suiv := courant.Suiv;
            if courant = file_D.Queue then
               file_D.Queue := precedent;
            end if;
            put_line ("Demande supprimee");
            return;
         end if;
         precedent := courant;
         courant := courant.Suiv;
      end loop;

      put_line ("Demande non trouvee");
   end sup_demande;

end Gestion_Demandes;
