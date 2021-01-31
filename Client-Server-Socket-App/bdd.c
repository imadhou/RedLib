

//fonctions de communication avec la base de données,
//elles renvoient un message décrivant le statut de l'execution de la requette

#include<postgresql/libpq-fe.h>
#include<stdio.h>
#include<stdlib.h>
#include"requettes.c"
#include<string.h>



//envoi une requete insert vers la table adherent renvoie un message selon 
//l'etat de l'execution de la requette
char* ajout_uti(PGconn *conn, char *nom_u, char *prenom_u, char *tel_u, char* mail_u, char* adresse_u, char *date_naissu, char *mot_de_passu){
    char *requette = req_ajout_adh(nom_u, prenom_u,tel_u, mail_u, adresse_u, date_naissu, mot_de_passu);
    PGresult *resultat = PQexec(conn, requette);
    free(requette);


    if (PQresultStatus(resultat) == PGRES_COMMAND_OK){
        PQclear(resultat);
        return"ajout reussit \n";
    }else{
        PQclear(resultat);
        return"erreur, verifiez bien votre syntaxe! \n";
    }
}



//envoie une requette update dans la table emprunt et exemplaire pour confirmer un emprunt
//le message de retour est formatter selon le resultat de la requette
char* emprunt(PGconn *conn,char *id_utilisateur, char *id_exemplaire, char* isbn, char *date_emprunt, char *date_retoure){
    char *requette = req_confirmer_emp(id_utilisateur,id_exemplaire,isbn,date_emprunt,date_retoure);
    PGresult *resultat = PQexec(conn, requette);
    free(requette);
    if (PQresultStatus(resultat) == PGRES_COMMAND_OK){
        char * req = malloc(sizeof(300));
        sprintf(req,"update exemplaire set dispo_exemp = 'non' where id_exemp='%s' and id_livre ='%s'",id_exemplaire,isbn);
        PGresult * aaa = PQexec(conn,req);
        PQclear(resultat);
        PQclear(aaa);
        free(req);
        return "emprunt effectué \n";
    }else{
        PQclear(resultat);
        return"une erreure est produite! verifier votre syntaxe \n";
    }
    
}


//envoie une requette update dans la table emprunt et exemplaire pour restituer un exemp
//le message de retour est formatter selon le resultat de la requette
char* restitution(PGconn *conn,char *id_utilisateur, char *id_exemplaire, char* isbn){
    char *requette = req_restitution_emp(id_utilisateur,id_exemplaire,isbn);
    PGresult *resultat = PQexec(conn, requette);
    free(requette);

    if (PQresultStatus(resultat) == PGRES_COMMAND_OK){
        char * req = malloc(sizeof(300));
        sprintf(req,"update exemplaire set dispo_exemp = 'oui' where id_exemp='%s' and id_livre ='%s'",id_exemplaire,isbn);
        PGresult * aaa = PQexec(conn,req);
        PQclear(resultat);
        PQclear(aaa);
        free(req);
        return"restitution effectuee avec succes \n";
    }else{
        PQclear(resultat);
        return"verifier bien votre syntaxe! une erreure est produite \n";
    }
    
    
}


//envoi une requette insert dans la table reservation et update dans materiel
//pour marque le debut d'utilisation d'un materiel
char*utilisatin_materiel(PGconn *conn,char *id_mat, char *id_utilisateur, char *heure, char *date_effet){
    char *requette = req_utilisation_mat(id_mat,id_utilisateur,heure,date_effet);
    PGresult *resultat = PQexec(conn,requette);
    free(requette);
    if (PQresultStatus(resultat) == PGRES_COMMAND_OK){
        char * req = malloc(sizeof(300));
        sprintf(req,"update materiel set disponibilte = 'false' where id_mat='%s'",id_mat);
        PGresult * aaa = PQexec(conn,req);
        PQclear(resultat);
        PQclear(aaa);
        free(req);
        return"la table peut bien etre utilisee \n";
    }else{
        PQclear(resultat);
        return"verifier bien votre syntaxe! une erreure est produite \n";
    }
    
}

//envoi une requette delete dans la table reservation et update dans materiel
//pour marque la fin d'utilisation d'un materiel
char* fin_utilisation_materiel(PGconn *conn,char *id_mat, char *id_utilisateur){
    char *requette = req_fin_uti_mat(id_mat, id_utilisateur);
    PGresult *resultat = PQexec(conn, requette);
    free(requette);
    if (PQresultStatus(resultat) == PGRES_COMMAND_OK){
        char * req = malloc(sizeof(300));
        sprintf(req,"update materiel set disponibilte = 'true' where id_mat='%s'",id_mat);
        PGresult * aaa = PQexec(conn,req);
        PQclear(resultat);
        PQclear(aaa);
        free(req);
        return"enregistre avec succes \n";
    }else{
        PQclear(resultat);
        return "erreur verifier bien votre syntaxe \n";
    }
    
    
}


//envoi une requette select dans la table materiel
char* materiel_deispo(PGconn *conn){
    char *requette = req_recherche_mat();
    PGresult *resultat = PQexec(conn, requette);
    if (PQresultStatus(resultat) == PGRES_TUPLES_OK){
        int num_tup = PQntuples(resultat);
        int num_att = 2;
        char *affichage = malloc(sizeof(350)) ;
        strcpy(affichage,"id_materiel--numero_salle\n");
        for (int i = 0; i < num_tup; i++)
        {
            char *af1 = malloc(sizeof(25));
            sprintf(af1, " %d: '%s'-- ", i+1, PQgetvalue(resultat, i, 0)); 
            strcat(affichage, af1);

            sprintf(af1, "---'%s' \n",PQgetvalue(resultat, i, 1));
            strcat(affichage,af1);
            free(af1);
        }
        PQclear(resultat);
        return affichage;    
    }else{
        PQclear(resultat);
        return "y a une erreure \n";
    }
}


