#ifndef _REQUETTES_H
#define _REQUETTES_H
char* req_ajout_adh( char *nom_u, char *prenom_u, char *tel_u, char* mail_u, char* adresse_u, char *date_naissu, char *mot_de_passu);
char* req_confirmer_emp(char *id_utilisateur, char *id_exemplaire, char* isbn, char *date_emprunt, char *date_retoure);
char* req_restitution_emp(char *id_utilisateur, char *id_exemplaire, char* isbn);
char* req_recherche_mat();
char* req_utilisation_tab(char *id_mat, char *id_utilisateur, char *heure, char *date_effet);
char* req_fin_uti_tab(char *id_mat, char *id_utilisateur);
#endif