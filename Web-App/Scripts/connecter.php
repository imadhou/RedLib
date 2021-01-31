<?php
session_start();
require_once('BDD.php');
if ($_POST && array_key_exists('se_connecter',$_POST)){
    $email = $_POST['email'];
    $password = $_POST['password'];
    $bdd = BDD::getInstance();
    $sql = "select * from utilisateur where mail_u = ? and mot_de_passeu = ?";
    $resultat = $bdd->executer($sql,[$email,$password]);
    if (!empty($resultat)) {
        $resultat = $resultat[0];
        $_SESSION['id_u'] = $resultat['id_u'];
        header('Location: accueil.php');
    }else{
        echo "errr";
    }
}

?>


<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Titre de la page</title>
    <link rel="stylesheet" type="text/css" href="connecter.css">    <script src=""></script>
</head>
<body>
<h1>Bienvenu sur Redlib, la bibliotheque connectée!</h1>
<form method="post" action="connecter.php">
    <div>
        <label for="email">Email</label>
        <input type="text" name="email" style="margin-left: 60px"/>
    </div>
    <div>
        <label for="password">Mot de passe</label>
        <input type="password" name="password"/>
    </div>
    <div>
        <button type="submit" name="se_connecter">Se connecter</button>
    </div>
</form>
</body>
</html>

<?php if ($_POST && array_key_exists('dec',$_POST)){
    session_destroy();
} ?>