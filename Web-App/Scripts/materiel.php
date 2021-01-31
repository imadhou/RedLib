<?php
session_start();
require_once 'BDD.php';
$utilsateur = $_SESSION['id_u'];

$conn = BDD::getInstance();
$resuu = $conn->executer("select * from utilisateur where id_u = ?",[$utilsateur]);
if (!empty($resuu)){
    $utilsateur = $resuu[0];
}else{
    die("introduire des identifiants vaides");
}


//marques system
$requette01 = "select distinct marque_ordi from ordinateur";
$requette02 = "select distinct system from ordinateur";
$requette03 = "select distinct nombre_place from table_l";
$marque = $conn->executer($requette01,[]);
$systeme = $conn->executer($requette02,[]);
$nbr_p = $conn->executer(($requette03),[]);





//max debit internet ordi
$requette2 = "select id_ordi, num_salle, marque_ordi, debit_internet, system, impression from ordinateur join materiel on id_ordi=id_mat  where debit_internet = (select max(debit_internet) from ordinateur) ";

//le nombre d'ordi selon dispo impression
$requette3 = "select impression, count(impression) as nombre_elt from ordinateur group by impression order by impression desc ";
$req3 = $conn->executer($requette3,[]);

//le nombre d'ordi selon la marque
$requette4 = "select marque_ordi, count(marque_ordi) as nombre_elt from ordinateur group by marque_ordi order by marque_ordi";
$req4 = $conn->executer($requette4,[]);

//moyenne debit
$requette5 = "select avg(debit_internet) from ordinateur";
$req5 = $conn->executer($requette5,[]);



?>


<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Titre de la page</title>
    <style>
        table, th, td {
            border: 3px solid black;
            border-collapse: collapse;
        }
    </style>
    <script src=""></script>
</head>
<body>
<a href="profile.php" style="float: right"><h2>Consulter mon pannier</h2></a>
<h1>Bienvenu sur Redlib Mr <?=$utilsateur['prenom_u']?>, la bibliotheque connectée!</h1>

<p>

</p>

<div>
    <form action="materiel.php" method="get">
        <label for="marque">Choisissez une marque</label>
        <select name="marque" id="marque">
            <option value="">Marques</option>
            <?php foreach ($marque as $ma) : ?>
            <?php foreach ($ma as $k=>$v) : ?>
                <option value="<?=$v?>"><?=$v?></option>
            <?php endforeach; ?>
            <?php endforeach; ?>
        </select>

        <label for="systeme">Choisaissez le systeme</label>
        <select name="systeme" id="systeme">
            <option value="">Systemes</option>
            <?php foreach ($systeme as $ma) : ?>
                <?php foreach ($ma as $k=>$v) : ?>
                    <option value="<?=$v?>"><?=$v?></option>
                <?php endforeach; ?>
            <?php endforeach; ?>
        </select>
        <br>
        <label> Impression :</label>
        <label for="oui">Oui avec</label>
        <input type="radio" id="oui" name="impression" value="true">
        <label for="non">Non pas besoin</label>
        <input type="radio" id="non" name="impression" value="false">

        <button type="submit" name="ordi">Chercher les postes disponibles</button>
    </form>
</div>
<?php
if (isset($_GET['ordi'])){
    $mar = '';
    $sy = '';
    $impp = '';
    $mar = $_GET['marque'];
    $sy = $_GET['systeme'];
    $impp = $_GET['impression'];
    $req = "select id_ordi, num_salle, marque_ordi, debit_internet, system, impression ,disponibilte from ordinateur join materiel on id_ordi=id_mat where marque_ordi = ? and system = ? and impression = ?";
    $resu = $conn->executer($req,[$mar,$sy,$impp]);
?>
<?php if ($resu != []) : ?>
    <table>
        <tr>
            <td>Identifiant</td>
            <td>Numero de salle</td>
            <td>Marque</td>
            <td>Debit d'internet</td>
            <td>Systeme d'exploitation</td>
            <td>Impression</td>
            <td>Disponibilité</td>
        </tr>
        <?php foreach ($resu as $r) : ?>
            <tr>
                <?php foreach ($r as $i=>$a) : ?>
                    <td><?= $a ?></td>
                <?php endforeach; ?>
            </tr>
        <?php endforeach; ?>
    </table>
<?php else : ?>
    <p> Malheureusement aucun ordinateur ne correspon à vos choix </p>
<?php endif; }?>
<br>
<br>
<div>
    <form action="materiel.php" method="get">
        <label for="nbr_p">Coissez le nombre de places</label>
        <select name="nbr_p" id="nbr_p">
            <option value="">Places</option>
            <?php foreach ($nbr_p as $ma) : ?>
                <?php foreach ($ma as $k=>$v) : ?>
                    <option value="<?=$v?>"><?=$v?></option>
                <?php endforeach; ?>
            <?php endforeach; ?>
        </select>
        <br>
        <label for="prise">Vous avez besoin d'une prise d'elecrtricité ?</label>
        <label for="oui">Oui</label>
        <input type="radio" name="prise" value="true">
        <label for="non">Non</label>
        <input type="radio" name="prise" value="false">
        <button type="submit" name="tab">Rechercher les tables disponibles</button>
    </form>
</div>
<?php
if (isset($_GET['tab'])){
    $nombre = $_GET['nbr_p'];
    $prise = $_GET['prise'];
    $req = "select id_table, num_salle, nombre_place, prise_electricite ,disponibilte from table_l join materiel on id_table=id_mat where nombre_place = ? and  prise_electricite = ?";
    $tabb = $conn->executer($req,[$nombre,$prise]);

    if ($tabb != []){
        ?>
        <table>
            <tr>
                <td>Id de la table</td>
                <td>Numero de salle</td>
                <td>Nombre de places</td>
                <td>Disponibilité d'electricité</td>
                <td>Disponibilite</td>
            </tr>
            <?php foreach ($tabb as $ta) : ?>
            <tr>
                <?php foreach ($ta as $t=>$tt) : ?>
                <td><?= $tt ?></td>
                <?php endforeach; ?>
            </tr>
            <?php endforeach; ?>
        </table>
<?php
    }
}
?>

</body>
</html>






