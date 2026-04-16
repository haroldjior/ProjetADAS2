WITH Ada.Text_IO, Ada.Integer_Text_IO, Gestion_Id;
USE Ada.Text_IO, Ada.Integer_Text_IO, Gestion_Id;

PACKAGE BODY Gestion_Clients IS

   FUNCTION Inferieur (
         Id1,
         Id2 : T_Identite)
     RETURN Boolean IS
      Nom1 : String := Id1.Nom (1 .. Id1.Knom);
      Nom2 : String := Id2.Nom (1 .. Id2.Knom);
   BEGIN
      IF Nom1 < Nom2 THEN
         RETURN True;
      ELSIF Nom1 > Nom2 THEN
         RETURN False;
      ELSE
         RETURN Id1.Prenom(1..Id1.Kprenom) < Id2.Prenom(1..Id2.Kprenom);
      END IF;
   END Inferieur;

   --------------------------------------------------------

   PROCEDURE Ajouter_Client (
         Arbre      : IN OUT Ptr_Client;
         Id_Nouveau : IN     T_Identite) IS

      Nouveau_Client : T_Client;
   BEGIN
      IF Arbre = NULL THEN
         Nouveau_Client.Id_Client := Id_Nouveau;
         Arbre := NEW T_Arbre_Client'(
            Val => Nouveau_Client,
            Fg  => NULL,
            Fd  => NULL);

      ELSIF Inferieur(Id_Nouveau, Arbre.Val.Id_Client) THEN

         Ajouter_Client(Arbre.Fg, Id_Nouveau);

      ELSIF Inferieur(Arbre.Val.Id_Client, Id_Nouveau) THEN

         Ajouter_Client(Arbre.Fd, Id_Nouveau);

      ELSE
         NULL;
      END IF;
   END Ajouter_Client;

   --------------------------------------------------------

   FUNCTION Rechercher_Client (
         Tete   : Ptr_Client;
         Client : T_Identite)
     RETURN Ptr_Client IS
   BEGIN
      IF Tete = NULL THEN
         RETURN NULL;
      ELSE
         IF Client.Nom(1..Client.Knom) = Tete.Val.Id_Client.Nom(1..
               Tete.Val.Id_Client.Knom) AND THEN
               Client.Prenom(1..Client.Kprenom) =
               Tete.Val.Id_Client.Prenom(1..Tete.Val.Id_Client.Kprenom) THEN
            RETURN Tete;

         ELSIF Client.Nom(1..Client.Knom) < Tete.Val.Id_Client.Nom(1..
               Tete.Val.Id_Client.Knom) OR ELSE
               (Client.Nom(1..Client.Knom) = Tete.Val.Id_Client.Nom(1..
                  Tete.Val.Id_Client.Knom) AND THEN
               Client.Prenom(1..Client.Kprenom) <
               Tete.Val.Id_Client.Prenom(1..Tete.Val.Id_Client.Kprenom)) THEN

            RETURN Rechercher_Client (Tete.Fg, Client);

         ELSE
            RETURN Rechercher_Client (Tete.Fd, Client);
         END IF;
      END IF;
   END Rechercher_Client;

   --------------------------------------------------------

   PROCEDURE Affichage_Client (
         Client : IN     T_Client) IS
   BEGIN
      New_Line;
      Visu_Id(Client.Id_Client);
      New_Line;

      Put ("Nombre de locations : ");
      Put (Client.Nb_Locations, 0);
      New_Line;

      Put ("Facture en attente de reglement : ");
      Put (Client.Facture, 0);
      Put (" euros");
      New_Line;

      Put ("Montant regle : ");
      Put (Client.Montant_Regle, 0);
      Put (" euros");
      New_Line;
   END Affichage_Client;

   --------------------------------------------------------

   PROCEDURE Afficher_Clients (
         Arbre : IN     Ptr_Client) IS
   BEGIN
      IF Arbre /= NULL THEN
         Affichage_Client(Arbre.Val);

         Afficher_Clients(Arbre.Fg);

         Afficher_Clients(Arbre.Fd);
      END IF;
   END Afficher_Clients;

   --------------------------------------------------------

   PROCEDURE Enregistrer_Reglement (
         Arbre : IN OUT Ptr_Client) IS

      Client_Saisi : T_Identite;
      Cible        : Ptr_Client;
      Montant      : Integer;
   BEGIN
      Put_Line("---  reglement d'une facture ---");

      Saisie_Id(Client_Saisi);

      Cible := Rechercher_Client(Arbre, Client_Saisi);

      IF Cible = NULL THEN
         Put_Line("Erreur : Ce client n'est pas dans la bdd.");
      ELSE
         Put_Line("Facture en instance : " & Integer'Image(
               Cible.Val.Facture) & " euros.");

         IF Cible.Val.Facture = 0 THEN
            Put_Line("Ce client a deja tout regle.");
         ELSE
            LOOP
               BEGIN
                  Put("Saisir le montant du reglement : ");
                  Get(Montant);
                  Skip_Line;

                  IF Montant < 0 THEN
                     Put_Line("Erreur : Le montant doit etre positif.");
                  ELSIF Montant > Cible.Val.Facture THEN
                     Put_Line(
                        "Erreur : Le montant ne peut pas depasser la facture.");
                  ELSE
                     Cible.Val.Facture := Cible.Val.Facture - Montant;
                     Cible.Val.Montant_Regle := Cible.Val.Montant_Regle +
                        Montant;
                     Put_Line("Reglement réalisé.");
                     EXIT;
                  END IF;
               EXCEPTION
                  WHEN Data_Error =>
                     Skip_Line;
                     Put_Line("Erreur de saisie");
               END;
            END LOOP;
         END IF;
      END IF;
   END Enregistrer_Reglement;

------------------------

   PROCEDURE Initialiser_Clients (
         Arbre :    OUT Ptr_Client) IS

      PROCEDURE Inserer_Client (
            Prenom,
            Nom    : String) IS
         Id : T_Identite;
      BEGIN
         Id.Prenom(1..Prenom'Length) := Prenom;
         Id.Kprenom := Prenom'Length;
         Id.Nom(1..Nom'Length) := Nom;
         Id.Knom := Nom'Length;
         Ajouter_Client(Arbre, Id);
      END Inserer_Client;

   BEGIN
      Arbre := NULL;

      -- Insertion dans l'ordre alphabétique (parcours infixe identique)
      Inserer_Client("Aline",    "Mouton");
      Inserer_Client("Paul",     "Personne");
      Inserer_Client("Lucie",    "Belle");
      Inserer_Client("Jean",     "Arc");
      Inserer_Client("Josette",  "Dubois");
      Inserer_Client("Juliette", "Romeo");
      Inserer_Client("Belle",    "Bartok");
      Inserer_Client("Alicia",   "Rebel");
      Inserer_Client("Lily",     "Tigresse");

   END Initialiser_Clients;

END Gestion_Clients;