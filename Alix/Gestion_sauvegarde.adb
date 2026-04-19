
Package body Gestion_sauvegarde is

procedure Save_date(D : in T_date) is
USE Fichier_Date;
      Fichier : Fichier_Date.File_type;
begin
IF Exists("Save_Date") THEN
         Open(Fichier,out_File,"Save_date");
      ELSE
         Create(Fichier, Name => "Save_date");
      END IF;
      Write(Fichier, D);
      Close(Fichier);
      Put("La date a ete sauvegardee avec succes"); new_line;
   END Save_date;

procedure empiler_client (C : in t_ptr_client; P : in out T_ptr_Client) is
begin
   if P = null then
      p := new T_cell_client'(C.val,null,null);
   else
      empiler_client (C, P.sg);
   end if;
end empiler_client;

procedure depiler_client(P : in out T_ptr_Client; C : out T_client) is
begin
   iF p/= null then
      C := P.val;
      P := P.sg;
   end if;
end depiler_client;

procedure Save_client (C : in T_ptr_Client) is
P : T_ptr_Client;

procedure Aux (C : in T_ptr_Client; P : in out T_ptr_Client) is
begin
   If C /= null then
      empiler_client (C, P);
      aux(C.sg, P);
      aux(C.sd, P);
   end if;
end aux;

USE Fichier_Client;
      Fichier : Fichier_Client.File_type;
begin
   if C /= null then
      IF Exists("Save_Client") THEN
         Open(Fichier,out_File,"Save_Client");
      ELSE
         Create(Fichier, Name => "Save_Client");
      END IF;
      Aux(C,P);
      Loop
         Write(Fichier, P.val);
         P := P.sg;
         exit when P = null;
      end loop;
      Close(Fichier);
      Put("La clientele a ete sauvegardee avec succes"); new_line;
   end if;
END Save_client;


procedure save_personnel(P : in t_ptr_pers) is
P1 : t_ptr_pers := P;
USE Fichier_Personnel;
      Fichier : Fichier_Personnel.File_type;
begin
   If P1/= null then
      IF Exists("Save_Personnel") THEN
         Open(Fichier,out_File,"Save_Personnel");
      ELSE
         Create(Fichier, Name => "Save_Personnel");
      END IF;
      Loop
         Write(Fichier, P1.val);
         P1 := P1.suiv;
         exit when P1 = null;
      end loop;
      Close(Fichier);
      Put("Le personnel a ete sauvegardee avec succes"); new_line;
   end if;
end save_personnel;

procedure save_location(L : in t_ptr_location) is
P : t_ptr_location := L;
USE Fichier_Location;
      Fichier : Fichier_Location.File_type;
BEGIN
   If P /= null then
      IF Exists("Save_Location") THEN
         Open(Fichier,out_File,"Save_Location");
      ELSE
         Create(Fichier, Name => "Save_Location");
      END IF;
      Loop
         Write(Fichier, P.val);
         P := P.suiv;
         exit when P = null;
      end loop;
      Close(Fichier);
      Put("La liste de locations a ete sauvegardee avec succes"); new_line;
   end if;
end save_location;

procedure save_demande (D : in t_ptr_demande) Is 
P : t_ptr_demande := D;
USE Fichier_demande;
      Fichier : Fichier_demande.File_type;
BEGIN
   If P /= null then
      IF Exists("Save_demande") THEN
         Open(Fichier,out_File,"Save_demande");
      ELSE
         Create(Fichier, Name => "Save_demande");
      END IF;
      Loop
         Write(Fichier, P.val);
         P := P.suiv;
         exit when P = null;
      end loop;
      Close(Fichier);
      Put("La liste de demandes a ete sauvegardee avec succes"); new_line;
   end if;
end save_demande;

procedure save_materiel (M : in t_ptr_materiel) is
P : t_ptr_materiel := M;
USE Fichier_materiel;
      Fichier : Fichier_materiel.File_type;
BEGIN
   If P /= null then
      IF Exists("Save_materiel") THEN
         Open(Fichier,out_File,"Save_materiel");
      ELSE
         Create(Fichier, Name => "Save_materiel");
      END IF;
      Loop
         Write(Fichier, P.val);
         P := P.suiv;
         exit when P = null;
      end loop;
      Close(Fichier);
      Put("La liste de materiel a ete sauvegardee avec succes"); new_line;
   end if;
end save_materiel;

procedure sauvegarder(D : in t_date; C : in T_ptr_Client; P : in t_ptr_pers; L : in t_ptr_location; De : in t_ptr_demande; M : in t_ptr_materiel) is
begin
save_date(D);
Save_client (C);
save_personnel (P);
save_location (L);
save_demande (De);
save_materiel (M);
end sauvegarder;

procedure charger_save(D : out t_date; C : out T_ptr_Client; P : out t_ptr_pers; L : out t_ptr_location; De : out t_file_demande; M : out t_ptr_materiel) is
USE Fichier_materiel;
      Fichier_m : Fichier_materiel.File_type;
USE Fichier_demande;
      Fichier_de : Fichier_demande.File_type;
USE Fichier_Location;
      Fichier_l : Fichier_Location.File_type;
USE Fichier_Personnel;
      Fichier_p : Fichier_Personnel.File_type;
USE Fichier_Client;
      Fichier_c : Fichier_Client.File_type;
USE Fichier_Date;
      Fichier_d : Fichier_Date.File_type;

Buffer_C : t_client;
buffer_p : t_pers;
buffer_l : T_Location;
buffer_de : t_demande;
buffer_m : T_Materiel;
begin
      -- chargement de la date
      IF Exists("Save_date") THEN
         Open(Fichier_d,in_File,"Save_date");
      ELSE
         Put("Aucune date n'a ete enregistree auparavant"); New_Line;
      END IF;
      Read(Fichier_d, D);
      Close(Fichier_d);
      PUt("La date a ete chargee avec succes !"); new_line;
      --chargement de la clientele
      if Exists ("Save_Client") then
         open(Fichier_C,in_file,"Save_client");
      else
         put("Aucun arbre de clientele enregistre auparavant"); new_line;
      end if;
      c := null; -- reset de l'arbre de clientele avant le chargement de la sauvegarde
      loop
         exit when End_Of_File(Fichier_C); -- sortie de boucle en fin de fichier
         read(Fichier_c,Buffer_C);
         Ajout_client (C, Buffer_C);
      end loop;
      close(Fichier_c);
      put("L'arbre de clientele a bien ete charge avec succes !"); new_line;
      --charmement de la liste du personnel
      if exists("save_personnel") then
         open(Fichier_p,in_file,"Save_personnel");
      else
         put("Auncune liste de personnel n'a ete enregistree auraparavant"); new_line;
      end if;
      loop
         exit when End_Of_File(Fichier_P);
         read(fichier_p,buffer_p);
         ajout_pers (P, buffer_p);
      end loop;
      close(Fichier_p);
      put("La liste du personnel a ete chargee avec succes !"); new_line;
      --chargement de la liste des locations
      if exists("Save_Location") then
         open(Fichier_L,in_file,"Save_location");
      else
         put("Aucune liste de location n'a ete enregistree auparavant"); new_line;
      end if;
      loop
         exit when End_Of_File(Fichier_L);
         read(Fichier_L,buffer_L);
         Inserer_Recursive (L, Buffer_L);
      end loop;
      close(Fichier_L);
      put("La liste des locations a ete charge avec succes !"); new_line;
      -- chargement de la liste des demandes
      if exists("Save_demande") then
         open(Fichier_de,in_file,"Save_demande");
      else
         put("Aucune file de demandes n'a ete enregistree auparavant"); new_line;
      end if;
      loop
         exit when End_Of_File(Fichier_de);
         read(fichier_de,buffer_de);
         Enfilerd (De, buffer_de);
      end loop;
      close(fichier_de);
      put("la file de demandes a ete chargee avec succes !"); new_line;
      --chargement de la liste du materiel
      if exists("Save_materiel") then
         open(Fichier_m,in_file,"Save_materiel");
      else
         put("Aucune liste de materiel n'a ete enregistree auparavant"); new_line;
      end if;
      loop
         exit when End_Of_File(Fichier_m);
         read(Fichier_m,buffer_m);
         Inserer (M, buffer_m.id, buffer_m.mat, buffer_m.Date_Service.j, buffer_m.Date_Service.M, buffer_m.Date_Service.annee, buffer_m.Disponibilite,buffer_m.Suppression);
      end loop;
      close(fichier_m);
      put("La liste du materiel a ete charge avec succces !"); new_line;
   END charger_save;


end Gestion_sauvegarde;