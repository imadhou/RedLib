#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>



#include"bdd.c"



#define USER "redlibadmin"
#define PASSWORD "redlibadmin00"
#define PORT_DEFAUT 5000
#define TAILLE_BUFFER 80

//structures pour enregestrer temporairement les données provenantes de 'utilisateur
//afin de construire les requettes adéquattes
typedef struct uti{
	char nom[80], prenom[80], tel[80], mail[80], adresse[80], date_naiss[80], mot_passe[80]; 
} utilisateur;

typedef struct emp{
	char id_u[80], id_exemp[80], isbn[80], date_emprunt[80], date_retour[80];
}empru;

typedef struct restitu{
	char id_user[80], id_exemp[80], isbn[80];
}restitut;

typedef struct mater{
	char id_mat[80], id_user[80], temp[80], date_m[80];
}materiel;

typedef struct finm{
	char id_mat[80], id_user[80];
}fin_mat;


//fonctions pour communiquer avec l'utilisateur apres lecture du code de cas d'utilisation
void ajouter_adherent(int sock,utilisateur *user);
void emprunter(int sock, empru *empr);
void restitutionner(int sock, restitut *rest);
void use_mat(int sock, materiel *mat);
void fin_use_mat(int sock, fin_mat *mat);
char* date1();

int main(void) {
	int s_ecoute, s_dial, cli_len;
	int option = 1;
	struct sockaddr_in serv_addr, cli_addr;
	char buf[TAILLE_BUFFER];
	int so_reuseaddr = 1;



	//on attend des connection sur notre adresse locale sur le port 5000
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1"); 
	serv_addr.sin_port = htons(PORT_DEFAUT); 
	memset(&serv_addr.sin_zero, 0, sizeof(serv_addr.sin_zero));

	// on crée la socket d'ecoute et on l'associe au couple (adresse,port) qu'on a defini 
	s_ecoute = socket(PF_INET, SOCK_STREAM, 0);
	setsockopt(s_ecoute, SOL_SOCKET, SO_REUSEADDR, &so_reuseaddr, sizeof so_reuseaddr);
    bind(s_ecoute, (struct sockaddr*)&serv_addr, sizeof serv_addr);
	
	//on attend les connexions entrantes
	listen(s_ecoute, 5);
	cli_len = sizeof cli_addr;

	
	
	//on initialise nos structures necessaires pour enregistrer les données envoyées par le client
	utilisateur *user = malloc(sizeof(utilisateur));
	empru *ump = malloc(sizeof(empru));
	restitut *ress = malloc(sizeof(restitut));
	materiel *matt = malloc(sizeof(materiel));
	fin_mat *mat_fin = malloc(sizeof(fin_mat));
	PGconn *conn = PQconnectdb("dbname=redlib user=dbadmin password=dbadmin00 host=localhost");
	

	//le serveur est toujours en ecoute des connexion et à chaque fois qu'un utilisateur
	//deconnecte il le detecte.
	while(1){
	  s_dial = accept(s_ecoute, (struct sockaddr*)&cli_addr, (socklen_t*)&cli_len);
	  printf("le client d'adresse: %s et de numero de port %d vient de se connecter \n",inet_ntoa(cli_addr.sin_addr), ntohs(cli_addr.sin_port));
	  int rep;

	  //verification de la validité des identifiants introduits par l'utilisateur,
	  //le programme ne va continuer à s'executer que si les infos sont valides
	  //l'utilisateur peut toujours quitter son programme
	  int valide = 0;
	  while(valide == 0 ){
		read(s_dial,buf,20);
		if(strcmp(buf,"0") == 0){
			close(s_dial);
			break;
		}
		if(strcmp(buf,USER) == 0){
			bzero(buf,20);
			write(s_dial, "1",2);
			valide = 1;
			read(s_dial,buf,20);
			if(strcmp(buf,"0") == 0){
			close(s_dial);
			break;
		}

			if(strcmp(buf,PASSWORD) == 0){
				valide =1;
				bzero(buf,20);
				write(s_dial,"1",2);
			}else{
				valide = 0;
				write(s_dial,"0",2);
			}
		}else{
			valide = 0;
			write(s_dial,"0",2);
		}
	  }

	    //lecture du code de choix de l'utilisateur, et traitement selon ce code.
		//une procedure d'envoi et la reception de données vers et depuis
		//son equivalent sur le client est associée à chaque code,
		//une fonction qui communique avec la bdd est aussi associée à chaque coperation
		//un message est affiché sur le serveur décrivant l'opertation courante .
		do{
			bzero(buf,80);
			read(s_dial, buf, TAILLE_BUFFER);
			rep = atoi(buf);
			strcpy(buf,"ok");
			write(s_dial,buf,TAILLE_BUFFER);
			bzero(buf,80);
				switch(rep){
					case 0:
					printf("le client d'adresse: %s et de numero de port %d vient de se déconnecter \n",inet_ntoa(cli_addr.sin_addr), ntohs(cli_addr.sin_port));
					close(s_dial);
					break;
	     			case 1:
					printf("Demande d'inscription d'un nouvel utilisateur \n");
					ajouter_adherent(s_dial,user);
					strcpy(buf,ajout_uti(conn,user->nom,user->prenom,user->tel,user->mail,user->adresse,user->date_naiss,user->mot_passe));
					write(s_dial,buf,80);
					bzero(buf,80);
					free(user);
					break;
					case 2:
					printf("Demande de confirmer un emprunt \n");
					emprunter(s_dial,ump);
					strcpy(buf,emprunt(conn,ump->id_u, ump->id_exemp, ump->isbn, ump->date_emprunt, ump->date_retour));
					write(s_dial,buf,80);
					bzero(buf,80);
					free(ump);
					break;
					case 3:
					printf("Demande d'enregistrement de restitution \n");
					restitutionner(s_dial,ress);
					strcpy(buf,restitution(conn,ress->id_user,ress->id_exemp,ress->isbn));
					write(s_dial,buf,80);
					bzero(buf,80);
					free(ress);
					break;
					case 4:
					printf("Demande d'attribution d'une table/ordinateur \n");
					use_mat(s_dial,matt);
					strcpy(buf,utilisatin_materiel(conn,matt->id_mat,matt->id_user,matt->temp,matt->date_m));
					write(s_dial,buf,80);
					bzero(buf,80);
					free(matt);
					break;
					case 5:
					printf("Demande d'inscription de fin d'utilisation d'une table/ordinateur \n");
					fin_use_mat(s_dial,mat_fin);
					strcpy(buf,fin_utilisation_materiel(conn,mat_fin->id_mat, mat_fin->id_user));
					write(s_dial,buf,80);
					bzero(buf,80);
					free(mat_fin);
					break;
					case 6:
					printf("Recherche de table/ordinateur disponibles \n");
					write(s_dial,materiel_deispo(conn),350);
					bzero(buf,80);
					break;
				}
				
		}while (rep<=6 && rep >0);
	}
    close(s_ecoute);
	PQfinish(conn);
	return 0;

}



//reeption des deonnées d'un adherent et enregistrement dans une structure intermediare 
//afin de l'utiliser pour communiquer avec la base de données
void ajouter_adherent(int sock,utilisateur *user){

	char buf[80];

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->nom,buf,80);
		bzero(buf,80);

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->prenom,buf,80);
		bzero(buf,80);

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->tel,buf,80);
		bzero(buf,80);

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->mail,buf,80);
		bzero(buf,80);

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->adresse,buf,80);
		bzero(buf,80);

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->date_naiss,buf,80);
		bzero(buf,80);

		read(sock,buf,TAILLE_BUFFER);
		strncpy(user->mot_passe,buf,80);
		bzero(buf,80);
}


//reception des données concernant un emprunt et population des attributs d'une structure
//intermediare afin de les filer à la bdd
//la date d'emprunt et de restitution sont gerer par le serveur
void emprunter(int sock, empru *empr){
	 char buf[80];

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(empr->id_u,buf,80);
	 bzero(buf,80);

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(empr->id_exemp,buf,80);
	 bzero(buf,80);

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(empr->isbn,buf,80);
	 bzero(buf,80);

	 strcpy(empr->date_emprunt,date1());

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(empr->date_retour,buf,80);
	 bzero(buf,80);
}



//reception des données pour restitutionner un livre
void restitutionner(int sock, restitut *rest){
	 char buf[80];

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(rest->id_user,buf,80);
	 bzero(buf,80);

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(rest->id_exemp,buf,80);
	 bzero(buf,80);

	 read(sock,buf,TAILLE_BUFFER);
	 strncpy(rest->isbn,buf,80);
	 bzero(buf,80);
}


//recption des données pour permettre l'utilisation d'un materiel
void use_mat(int sock, materiel *mat){
	char buf[80];

	read(sock,buf,TAILLE_BUFFER);
	strncpy(mat->id_mat,buf,80);
	bzero(buf,80);

	read(sock,buf,TAILLE_BUFFER);
	strncpy(mat->id_user,buf,80);
	bzero(buf,80);

	read(sock,buf,TAILLE_BUFFER);
	strncpy(mat->temp,buf,80);
	bzero(buf,80);

	strcpy(mat->date_m,date1());
	
}


//recption des données pour marquer la fin d'utilisation d'un materiel
void fin_use_mat(int sock, fin_mat *mat){
	char buf[80];

	read(sock,buf,80);
	strncpy(mat->id_mat,buf,80);
	bzero(buf,80);

    read(sock,buf,80);
	strncpy(mat->id_user,buf,80);
	bzero(buf,80);

}


//recuperation de la date locale du serveur
char* date1(){

    char *date1=malloc(sizeof(20));
    struct tm date = {0} ;
    time_t timer;
    timer=time(NULL);
    date = *gmtime( &timer ) ;
    sprintf(date1,"%d/%d/%d",date.tm_mday-1,date.tm_mon+1,date.tm_year+1900);
    return date1;
 }

