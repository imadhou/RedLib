




//fonctions pour construire des requettes SQl
#include "requettes.h"
#include<stdio.h>
#include<stdlib.h>
char* req_ajout_adh( char *nom_u, char *prenom_u, char *tel_u, char* mail_u, char* adresse_u, char *date_naissu, char *mot_de_passu){
    char *requette = malloc(sizeof(300));
    sprintf(requette, "insert into utilisateur values(default,'%s','%s','%s','%s','%s','%s','%s')",nom_u,prenom_u,tel_u,mail_u,adresse_u,date_naissu,mot_de_passu);
    return requette;
}

char* req_confirmer_emp(char *id_utilisateur, char *id_exemplaire, char* isbn, char *date_emprunt, char *date_retoure){
    char *requette = malloc(sizeof(800));
    sprintf(requette,"update emprunt set effet='1',date_emprunt='%s',date_retoure='%s'where id_utilisateur='%s' and id_exemplaire='%s' and isbn ='%s\'" ,date_emprunt,date_retoure,id_utilisateur,id_exemplaire,isbn);
    return requette;
}

char* req_restitution_emp(char *id_utilisateur, char *id_exemplaire, char* isbn){
    char *requette = malloc(sizeof(300));
    sprintf(requette,"delete from emprunt where id_utilisateur = '%s' and id_exemplaire = '%s' and isbn = '%s'",id_utilisateur,id_exemplaire,isbn);
    return requette;
}

char* req_recherche_mat(){
    char *requette = "select id_mat, num_salle from materiel where disponibilte = 'true' order by id_mat";
    return requette;
}

char* req_utilisation_mat(char *id_mat, char *id_utilisateur, char *heure, char *date_effet){
    char *requette = malloc(sizeof(300));
    sprintf(requette,"insert into reservation values('%s','%s','%s','%s')", id_utilisateur,id_mat, date_effet, heure);
    return requette;
}

char* req_fin_uti_mat(char *id_mat, char *id_utilisateur){
    char *requette = malloc(sizeof(300));
    sprintf(requette,"delete from reservation where id_materiel = '%s' and id_utilisateur = '%s'",id_mat,id_utilisateur);
    return requette;
}
