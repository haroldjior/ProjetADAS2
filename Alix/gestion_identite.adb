with ada.text_io, ada.integer_text_io;
USE  Ada.Text_Io, Ada.Integer_Text_Io;

PACKAGE BODY Gestion_Identite IS

procedure Saisie_NP (NP : out T_nomPnom) is
   begin
   Get_Line(NP.mot,NP.k);
end Saisie_NP;

procedure Saisie_identite (I : out T_identite) is
   buffer : T_nomPnom;
   begin
      Put("Veuillez saisir le Nom :"); new_line;
      Saisie_NP(Buffer);
      I.Nom := buffer;
      Put("Veuillez saisir le Prenom :"); new_line;
      Saisie_NP (Buffer);
      I.Prenom := Buffer;
end Saisie_identite;

procedure Affi_NP (NP : in T_nomPnom) is
   begin
   For i in 1..NP.K loop
      Put(NP.Mot(i));
   end loop;
end Affi_NP;

procedure affi_identite (I : in T_identite) is
   begin
   put("Nom : "); Affi_NP (I.Nom); New_line;
   put("Prenom : "); Affi_NP (I.Prenom); New_Line;
end affi_identite;

procedure Meme_NP (I1,I2 : in T_nomPnom; Meme : out boolean) is
   begin
   meme := true;
   if I1.K /= I2.K then --Verification  si la taille des noms et prenoms diffère
   Meme := false;
   else
   for i in 1..I1.K loop
      if I1.Mot(i) /= I2.Mot(i) then --Si un caractère diffère alors le boolean passe en false
         Meme := false;
      end if;
   end loop;
   end if;
   END Meme_Np;

procedure comp_identite (I1,I2 : in T_identite; I1superieur : out Boolean) is
   n : integer;
   buffer : boolean;
   begin
      I1superieur := true; -- On part du principe que I1 > I2, si I2 est plus grand que I1 alors le boolean passera en false
      Meme_NP (I1.Nom,I2.Nom, buffer); -- on verifie si les noms sont identiques
      if buffer = false then
         if I1.Nom.K > I2.Nom.K then -- On prends la longueur de nom la plus courte
            n := I2.nom.K;
         else
            n := I1.Nom.K;
         end if;
         for i in 1..n loop
            If I2.Nom.Mot(i) > I1.Nom.Mot(i) and then I1superieur = true then -- on compare les caractères, si I2 est plus grand que I1 alors on passe I1superieur en false
            I1superieur := false;
            exit;
            end if;
         end loop;
      else -- si les noms sont identiques on compare les prénoms
         Meme_NP (I1.Prenom,I2.Prenom, buffer); -- on verifie si les prenoms sont identiques
         if buffer = true then
            I1superieur := False; --le boolean passe en false pour que la valeur parte a gauche de l'ABR
         else
            if I1.Prenom.K > I2.Prenom.K then --comparaison a nouveau effectuée sur la chaine la plus courte
            n := I2.Prenom.K;
            else
            n := I1.Prenom.K;
            end if;
            for i in 1..n loop
               If I2.Prenom.Mot(i) > I1.Prenom.Mot(i) and then I1superieur = true then --même principe que pour les prénoms
               I1superieur := false;
               exit;
               end if;
            end loop;
         end if;
      end if;
end comp_identite;
End Gestion_identite;