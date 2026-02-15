package gestion_identite is

   subtype T_mot is string (1 .. 20);

   --Prenom et sa taille
   type T_prenom is record
      prenom  : T_mot;
      kprenom : integer range 1 .. 20;
   end record;

   --Nom et sa taille
   type T_Nom is record
      nom  : T_mot;
      knom : integer range 1 .. 20;
   end record;

   --Identite avec Nom et Prenom
   type T_identite is record
      id_nom    : T_nom;
      id_prenom : T_prenom;
   end record;

   --Saisie du nom ou prenom d'une personne selon les contraintes du sujet
   procedure saisie_nom
     (mot : out T_mot; k : out integer; erreur : out boolean);

   --Saisie de l'identité complète d'une personne
   procedure saisie_identite (id : out T_identite);

   --Affichage de l'identite d'une personne
   procedure affichage_id (id : in T_identite);

end gestion_identite;
