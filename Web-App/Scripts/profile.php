<?php
session_start();
require_once 'uti.php';
$uti = $_SESSION['id_u'];
$emp = utilisateur($uti);
if (array_key_exists('annuler',$_GET)){
    $emprunt = explode('-',$_GET['annuler']);
    $co = BDD::getInstance();
    $sql = "delete from emprunt where id_utilisateur = ? and id_exemplaire = ? and isbn = ?";
    $up = "update exemplaire set dispo_exemp = 'oui' where id_exemp = ? and id_livre = ? ";
    if($co->executer($sql,[$_SESSION['id_u'],$emprunt[1],$emprunt[0]])){
       $co->executer($up,[$emprunt[1],$emprunt[0]]);
    }
}

?>

<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Titre de la page</title>
    <style>
        table, th, td {
            border: 2px solid black;
            border-collapse: collapse;
        }
    </style>
    <script src=""></script>
</head>
<body>
<form action="connecter.php" method="post">
    <button type="submit" name="dec" >Se deconnecter</button>
</form>
<h1>Bienvenu sur Redlib, la bibliotheque connectée!</h1>
<br>
<br>
<a href="materiel.php">Chercher manuellement</a>
<a style="margin-left: 50px" href="accueil.php">Retourner a l'accueil</a>
<br>
<br>
<form>
    <table>
        <tr>
            <th>
                Titre de livre
            </th>
            <th>
                Numero d'exemplaire
            </th>
            <th>
                ISBN
            </th>
            <th>
                Validité
            </th>
            <th>
                Date d'emprunt
            </th>
            <th>
                Date de restitution
            </th>
            <th>
                Annuller la reservation
            </th>
        </tr>
        <?php foreach ($emp as $k) : ?>
        <tr>
        <?php foreach ($k as $key=>$value) : ?>
        <td>
            <?php if ($key == 'effet'){
                if ($value == true){
                    echo "Emprunt validé";
                }else{echo "Emprunt non validé";}
            }else echo $value ?>
        </td>
        <?php endforeach; ?>
            <td>
                <?php if($k['effet'] !== true) : ?>
                <form action="profile.php" method="get">
                    <button type="submit" name="annuler" value="<?=$k['isbn'].'-'.$k['id_exemplaire']?>">Annuler</button>
                </form>
                <?php endif;?>
            </td>
        </tr>
        <?php endforeach; ?>
    </table>
</form>
</body>
</html>
