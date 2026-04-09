with ada.Text_IO;
with ada.integer_text_io;
with gestion_date;
use ada.Text_IO;
use ada.integer_text_io;
use gestion_date;

package gestion_materiel is

   type T_cate_materiel is (camera, son, sono, projection, lumiere);

   type T_materiel is record
      cat         : T_cate_materiel;
      id_materiel : integer;
      date        : T_date;
      nb_jours    : integer; -- max 10 jours
      Dispo       : boolean; -- true si le materiel est disponible, false sinon
      indic_sup   :
        boolean; -- true si le materiel va être supprimé, false sinon
   end record;

   type T_liste_materiel;
   type T_pt is access T_liste_materiel;
   type T_liste_materiel is record
      materiel : T_materiel;
      suiv     : T_pt;
   end record;

   ---------------------------------
   procedure liberer (tete : in out T_pt); --- Libère la mémoire de la liste

   procedure visu_1pack
     (tete : in T_pt); --- Affiche les informations d'un pack

   procedure visu_tous_pack (tete : in T_pt); --- Affiche tous les packs

   procedure visu_pack_dispo
     (tete : in T_pt); --- Affiche les packs disponibles

   function nv_id
     (tete : T_pt) return integer; --- Retourne le prochain id de pack

   procedure nv_pack
     (mat : out T_materiel; tete : in out T_pt); --- Ajoute un pack à la liste

   procedure chercher_supprimer_pack_idcat
     (tete : in out T_pt;
      id   : in integer;
      mat  : in T_cate_materiel;
      ok   :
        out boolean); --- Cherche et supprime un pack d'une catégorie donnée et d'un id donné

   procedure sup_pack_idcat
     (tete :
        in out T_pt); --- Supprime les packs d'une catégorie donnée et d'un id donné

   procedure chercher_supprimer_pack_date
     (tete : in out T_pt; date : in T_Date; ok : in out boolean);

   procedure sup_pack_date
     (tete :
        in out T_pt); --- Supprime les packs dont la date de début est antérieure à une date donnée

   procedure user_story
     (tete :
        in out T_pt); --- Permet à l'utilisateur de charger les user stories

end gestion_materiel;
