#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include<stdlib.h>
#include<time.h>


void ajouter_adhernet(int sock);
void emprunt(int sock);
void restituer_exmp(int sock);
void use_material(int sock);
void fin_use_mat(int sock);
void rech_mat_dispo(int sock);
char* date2();
int main (int argc, char **argv ){


//si l'utilisateur ne fournit pas d'arguments (num port et adresse ip du serveur), 
//le programme se termine avec un message d'erreur
  if (argc != 3) {
        fprintf(stderr, "Utilisation: %s <numero de port> <addresse ip> \n", argv[0]);
        return EXIT_FAILURE;
    }

  
//creation de la socket avec l'adresse ip et le numero de port introduits
//par l'utilisateur. Un message est affiché selon le status de l'etablissement de la connexion 
  char * addr;
  u_short port;
  addr = argv[2];
  port = atoi(argv[1]);
  int s_cli ;
  struct sockaddr_in serv_addr ;
  char buf [80] ;
  s_cli = socket (PF_INET, SOCK_STREAM, 0) ;
  serv_addr.sin_family = AF_INET ;
  serv_addr.sin_addr.s_addr = inet_addr (addr) ;
  serv_addr.sin_port = htons (port) ;
  memset (&serv_addr.sin_zero, 0, sizeof(serv_addr.sin_zero));



  if(connect (s_cli, (struct sockaddr *)&serv_addr, sizeof serv_addr)==-1){
    printf("Impossible de se connecter au serveur\n");
    return EXIT_FAILURE;
  }else{
    printf("Connexion avec succes \n \n");
  }



//lecture et envoi au serveur des identifiants de l'utilisateur
//le programme ne se resume que si le serveur nous acquitte d'un avis favorable
//l'utilisateur a le choix d'annuler et de quitter le programme
  char identificateur[20];
  char mot_de_passe[20];
  int valid_u = 0;
  int valid_p = 0;
  while(valid_u == 0 || valid_p ==0 ){
    printf("Introduisez votre identifiant : \n");
    printf("0-pour quitter \n");
    scanf("%s",buf);
    if(strcmp(buf,"0")==0){
      write(s_cli,"0",2);
      close(s_cli);
      exit(0);
    }else{
      write(s_cli,buf,20);
      bzero(buf,20);

      read(s_cli,buf,2);
      valid_u = atoi(buf);
      bzero(buf,20);
    }
    

    if(valid_u == 1){

    printf("Introduisez votre mot de passe \n 0-pour quitter \n");
    scanf("%s",buf);
    if(strcmp(buf,"0")==0){
      write(s_cli,"0",2);
      bzero(buf,20);
      close(s_cli);
      exit(0);
    }
    write(s_cli,buf,20);
    bzero(buf,20);
    read(s_cli,buf,2);
    valid_p = atoi(buf);
    if(valid_p == 1){
      system("clear");
      printf("bienvenu sur redlib \n");
    }else{
      system("clear");
      printf("votre mot de passe n'est pas le bon \n");
    }
    
    }else{
      system("clear");
    printf("Utilisateur non trouvé ! \n");
    }
  }


  //l'utilisateur choisit une parmis les opertaions possible, un code representant
  //l'operation est envoyé au serveur qui répond avec 'ok' si le choix est valide  
  //une procedure est appelée pour communiquer avec le serveur
  int rep;
  printf("Vuillez choisir un numero\n \n");
  do{
    printf("[1]Ajouter un adherent\n");
    printf("[2]Effetuer un emprunt\n");
    printf("[3]Restituer un exemplaire\n");
    printf("[4]Reserver une table\n");
    printf("[5]liberer une table\n");
    printf("[6]Rechercher les tables disponibles\n");
    printf("[0]Quitter\n");
    scanf("%d",&rep);
      switch(rep){
        case 0:
        write(s_cli,"0",80);
        close(s_cli);
        break;
        case 1:
        ajouter_adhernet(s_cli);
        break;
        case 2:
        emprunt(s_cli);
        break;
        case 3:
        restituer_exmp(s_cli);
        break;
        case 4:
        use_material(s_cli);
        break;
        case 5:
        fin_use_mat(s_cli);
        break;
        case 6:
        rech_mat_dispo(s_cli);
        break;   
        default:
        system("clear");
        printf("erreur dans votre choix \n");
        break;
      }
    }while (rep != 0 );
    close(s_cli);
  return (0) ;
}



//on envoie le code , si on ne reçoit pat 'ok' on ne continue pas
//sinon on commence l'envoie de données



void ajouter_adhernet(int sock){
    
    char buf[80];
    write(sock,"1",1);
    read(sock,buf,80);
    if(strncmp(buf,"ok",80)){
      printf("une erreure est produite reesseyez plus tard");
    }else{
      printf("introduisez à chaque etape la donnee demandee \n");

      //envoi du nom
        printf("nom: \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);

        //envoi du prenom
        printf("prenom: \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);


        //envoi du prenom
        printf("telephone \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        
        //envoi de l'@ mail 
        printf("mail \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);

        //envoi de l'@
        printf("adresse \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        
        //envoi de la date de naissence
        printf("date de naissance jj/mm/aaaa\n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        
        //envi du mot de passe
        printf("mot de passe \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        
        //rception de l'accusé
        bzero(buf,80);
        read(sock, buf,80);
        printf("%s \n",buf);
    }
}

void emprunt(int sock){
  char buf[80];
  write(sock,"2",1);
  read(sock,buf,80);
  if(strncmp(buf,"ok",80)){
    printf("une erreure est produite reesseyez plus tard");
  }else{
        //envoi du l'id du l'utilisateur
        printf("id utilisateur:  ");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        
        
        //envoi de l'id de l'exemplaire
        printf("numero de l'exemplaire: \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        

        //envoi de l'isbn du livre
        printf("isbn: \n");
        bzero(buf,80);
        scanf("%s",&buf);
        write(sock,buf,80);
        
       //envoie de date 
        bzero(buf,80);
        write(sock,date2(),80);
        printf("date de restitution: %s \n",date2());

        //reception de l'ccusé
        bzero(buf,80);
        read(sock,buf,80);
        printf("%s",buf);


  }
}

void restituer_exmp(int sock){
  char buf[80];
  write(sock,"3",1);
  read(sock,buf,80);
  if(strncmp(buf,"ok",80)){
    printf("une erreure est produite reesseyez plus tard");
  }else{

    printf("Saisissez l'id de l'utilisateur: \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock, buf, 80);

    printf("Saisissez le numero de l'exemplaire: \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    printf("Saissez l'ISBN : \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    bzero(buf,80);
    read(sock,buf,80);
    printf("%s",buf);
    
  }
}

void use_material(int sock){
  char buf[80];
  write(sock,"4",1);
  read(sock,buf,80);
  if(strncmp(buf,"ok",80)){
    printf("une erreure est produite reesseyez plus tard");
  }else{
    printf("introduisez l'id de la table/ordinateur : \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    printf("introduisez l'id de l'utilisateur' : \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    printf("introduisez le temps d'usage: \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    bzero(buf,80);
    read(sock, buf,80);
    printf("%s \n",buf);
  }

}

void fin_use_mat(int sock){
  char buf[80];
  write(sock,"5",1);
  read(sock,buf,80);
  if(strncmp(buf,"ok",80)){
    printf("une erreure est produite reesseyez plus tard");
  }else{
    printf("introduisez l'id de la table/ordinateur : \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    printf("introduisez l'id de l'utilisateur' : \n");
    bzero(buf,80);
    scanf("%s",&buf);
    write(sock,buf,80);

    bzero(buf,80);
    read(sock, buf,80);
    printf("%s \n",buf);
  }
}

void rech_mat_dispo(int sock){
  char buf[350];
  write(sock,"6",1);
  read(sock,buf,80);
  if(strncmp(buf,"ok",80)){
    printf("une erreure est produite reesseyez plus tard");
  }else{
    bzero(buf,350);
    read(sock, buf,350);
    printf("%s \n",buf);
  }
}


 char* date2(){
    char *date2 = malloc(sizeof(time_t));
    struct tm date = {0} ;
    time_t timer;
    timer=time(NULL);
    date = *gmtime( &timer ) ;
    date.tm_year = date.tm_year;
    date.tm_mon = date.tm_mon;
    date.tm_mday = date.tm_mday + 15;
    timer = mktime( &date ) ;
    date = *gmtime( &timer ) ;
    sprintf(date2,"%d/%d/%d",date.tm_mday-1,date.tm_mon+1,date.tm_year+1900);
    return date2;
 }



