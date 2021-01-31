<?php
session_start();
require_once ('BDD.php');
$conn = BDD::getInstance();
$isbn = $_GET['po'];
$sql = "select id_exemp,id_livre,titre_exemp ,dispo_exemp ,etat_exemp, num_salle_cat ,num_etagere_cat,emplacement_exemp from exemplaire,livre,categorie where exemplaire.dispo_exemp ='oui' and livre.isbn = ? and exemplaire.id_livre = ? and livre.categorie= categorie.intitule order by id_exemp";
$repo = $conn->executer($sql,[$isbn,$isbn]);

?>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Titre de la page</title>
    <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }
    </style>
    <script src=""></script>
</head>
<body>
<div>
    <a href="profile.php">Voir mon profile</a>
    <a style="margin-left: 50px" href="accueil.php">Retourner a l'accueil</a>
</div>
<br>
<br>
<b>Exemplaires disponibles</b>
<br>
<br>
<table>
    <tr>
        <th>Numero d'exemplaire</th>
        <th>ISBN</th>
        <th>Titre</th>
        <th>Disponibilité</th>
        <th>Etat</th>
        <th>Numero de salle</th>
        <th>Numero d'armoire</th>
        <th>Numero d'etagere</th>
        <th>Reserver</th>
    </tr>
    <?php foreach ($repo as $rep) : ?>
    <tr>
    <?php foreach ($rep as $key=>$value) :?>
    <td><?= $value ?></td>
    <?php endforeach;?>
        <td>
            <form action="effectuer.php" method="get">
                <button type="submit" value="<?= $rep['id_exemp'].'-'.$rep['id_livre']?>" name="reserver">Reserver</button>
            </form>
        </td>
    </tr>
    <?php endforeach; ?>
</table>

</body>