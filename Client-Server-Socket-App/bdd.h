#ifndef _BDD_H
#define _BDD_H


char* ajout_uti(PGconn *conn, char *nom_u, char *prenom_u, char *tel_u, char* mail_u, char* adresse_u, char *date_naissu, char *mot_de_passu);
char* emprunt(PGconn *conn,char *id_utilisateur, char *id_exemplaire, char* isbn, char *date_emprunt, char *date_retoure);
char* restitution(PGconn *conn,char *id_utilisateur, char *id_exemplaire, char* isbn);
char* utilisatin_materiel(PGconn *conn,char *id_mat, char *id_utilisateur, char *heure, char *date_effet);
char* fin_utilisation_materiel(PGconn *conn,char *id_mat, char *id_utilisateur); 
char* materiel_deispo(PGconn *conn);

#endif