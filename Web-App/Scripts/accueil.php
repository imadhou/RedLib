<?php
session_start();
require_once('BDD.php');
// trouver de quel utilisateur s'agit il
$utilsateur = $_SESSION['id_u'];
$conn = BDD::getInstance();
$resu = $conn->executer("select * from utilisateur where id_u = ?",[$utilsateur]);
if (!empty($resu)){
    $utilsateur = $resu[0];
}else{
    die("introduire des identifiants vaides");
}
//$trouver toute les categories de livre
$resu = $conn->executer("select intitule from categorie",[]);

$resu0 = $conn->executer("select titre_livre from livre",[]);

//trouver tout les autuers
$resu1 = $conn->executer("select nom_auteur, prenom_auteur from auteur",[]);

//trouver le nombre totale d'exemplaire et de livre
$resu2 = $conn->executer("select ( select count(id_exemp) as \"nb_exemp\" from exemplaire),( select count(isbn) as \"nbr_livre\"from livre )",[]);

// trouver nomre d'exemp dispo dans chaque livre
$resu3 = $conn->executer("select titre_livre,nom_auteur,prenom_auteur,categorie, maison_edition, date_publication, count(*) as num from livre join exemplaire on exemplaire.id_livre=livre.isbn join auteur on livre.id_auteur = auteur.id_auteur  where dispo_exemp = 'oui' group by titre_livre,nom_auteur,prenom_auteur, maison_edition, date_publication,categorie order by num desc",[]);

//trouver le livre ayant le plus d exemplaire
$resu4 = $conn->executer("select livre.isbn, titre_livre, nom_auteur,prenom_auteur,categorie, maison_edition, date_publication, nombre_exemplaire from livre join auteur on auteur.id_auteur = livre.id_auteur where nombre_exemplaire = (select max(nombre_exemplaire) from livre ) ",[]);

//min
$resu6 = $conn->executer("select livre.isbn, titre_livre, nom_auteur,prenom_auteur,categorie, maison_edition, date_publication, nombre_exemplaire from livre join auteur on auteur.id_auteur = livre.id_auteur where nombre_exemplaire = (select min(nombre_exemplaire) from livre ) ",[]);

//nombre de livre pour chaque auteur
$resu7 = $conn->executer("select auteur.id_auteur, nom_auteur, prenom_auteur, count(auteur.id_auteur) from auteur,livre as l where auteur.id_auteur = l.id_auteur group by auteur.id_auteur",[]);

//ivre pus prete
$resu00 = $conn->executer("select aa.titre_livre, aa.maison_edition, aa.date_publication,aa.nom_auteur,aa.prenom_auteur, max(aa.count) as b from(
                    select livre.titre_livre, livre.maison_edition, livre.date_publication, auteur.nom_auteur, auteur.prenom_auteur ,count(*) from
                         livre, exemplaire,auteur where livre.isbn = exemplaire.id_livre and
                         auteur.id_auteur =livre.id_auteur  and exemplaire.dispo_exemp='non' group by livre.titre_livre, livre.maison_edition, livre.date_publication, auteur.nom_auteur,auteur.prenom_auteur) as aa
                              group by aa.titre_livre, aa.maison_edition, aa.date_publication, aa.nom_auteur, aa.prenom_auteur order by b desc limit 1",[]);


//auteur le plus populaire
$resu8 = $conn->executer("select aa.nom_auteur, aa.prenom_auteur,max(aa.count) as b from (select auteur.nom_auteur, auteur.prenom_auteur, count(*) from auteur, livre ,exemplaire where auteur.id_auteur = livre.id_auteur and exemplaire.id_livre = livre.isbn and exemplaire.dispo_exemp = 'non' group by auteur.nom_auteur, auteur.prenom_auteur) as aa group by aa.nom_auteur, aa.prenom_auteur order by b desc limit 1",[]);
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
<a href="materiel.php">Salle de lecture</a>
<h1>Bienvenu sur Redlib
 Mr <?=$utilsateur['prenom_u']?>, la bibliotheque connectée!</h1>
<p>Redlib Contient <?=$resu2[0]["nb_exemp"]?> exemplaires dans <?= $resu2[0]["nbr_livre"] ?> deffirent livres </p>

<div>
    <h2>Top Dispo</h2>
    <p><?='<b>'. $resu4[0]['titre_livre']. '</b>'. ' ISBN  <i>'.$resu4[0]['isbn'] .'</i> de <b> ' .$resu4[0]['nom_auteur'].' '.$resu4[0]['prenom_auteur'].'</b>  est notre livre ayant le plus grand nombre d\'exemplaires :'. $resu4[0]['nombre_exemplaire'].' exemplaires. Il est publié en '.$resu4[0]['date_publication'].' par les editions ' .$resu4[0]['maison_edition'] ?> </p>
</div>

<div>
    <h2>
        Piece Rare
    </h2>
    <p><?='<b>'. $resu6[0]['titre_livre']. '</b>'. ' ISBN  <i>'.$resu6[0]['isbn'] .'</i> de <b> ' .$resu6[0]['nom_auteur'].' '.$resu6[0]['prenom_auteur'].'</b>  est notre pièce rare, il est disponible en seullement  :'. $resu6[0]['nombre_exemplaire'].' exemplaires. Il est publié en '.$resu6[0]['date_publication'].' par les editions ' .$resu6[0]['maison_edition'] ?> </p>

</div>

<div>
    <h2>
        Top auteur
    </h2>
    <p>
        Notre auteur le plus populaire est <?=$resu8[0]['nom_auteur']?> <?= $resu8[0]['prenom_auteur']?> ,il s'agit de <?=$resu8[0]['b']?> personnes qui sont entraie
        de lire ses livres à l'instant!
    </p>
</div>

<div>
    <h2>
        Top livre
    </h2>
    <p>
        Notre livre le plus prété est <?= $resu00[0]['titre_livre'] ?> de <?= $resu00[0]['nom_auteur'] ?> <?= $resu00[0]['prenom_auteur'] ?>
        publié par :<?= $resu00[0]['maison_edition'] ?>, en <?= $resu00[0]['date_publication'] ?>
    </p>
</div>


<h1></h1>


<h2> Vous pouvez effectuer une recherche manuelle ici </h2>
<form action="accueil.php" method="get">
    <label for="recherche">Chercher des livres</label>
    <input type="search" name="recherche" id="recherche">

    <input type="radio" name="param_recherche" id="titre_" value="titre">
    <label for="titre">Titre</label>

    <input type="radio" name="param_recherche" id="auteur_" value="auteur">
    <label for="titre">Auteur(nom prenom)</label>

    <button type="submit" >Rechercher</button>
</form>

<?php
    if (array_key_exists('recherche',$_GET) && $_GET['recherche'] !=''){
        if (array_key_exists('param_recherche',$_GET) && $_GET['param_recherche']=='auteur'){
            $auteur = explode(" ",$_GET['recherche']);
            $requette = "select livre.isbn, titre_livre,nom_auteur,prenom_auteur,categorie, maison_edition, date_publication, count(*) as num from livre join exemplaire on exemplaire.id_livre=livre.isbn join auteur on livre.id_auteur = auteur.id_auteur  where dispo_exemp = 'oui' and  prenom_auteur like '%{$auteur[0]}%' or prenom_auteur like '{$auteur[1]}' group by livre.isbn,titre_livre,nom_auteur,prenom_auteur, maison_edition, date_publication,categorie";
            $resu5 = $conn->executer($requette,[]);
        }elseif(array_key_exists('param_recherche',$_GET) && $_GET['param_recherche'] == 'titre'){
            $titre = $_GET['recherche'];
            $requette = "select livre.isbn, titre_livre,nom_auteur,prenom_auteur,categorie, maison_edition, date_publication, count(*) as num from livre join exemplaire on exemplaire.id_livre=livre.isbn join auteur on livre.id_auteur = auteur.id_auteur  where dispo_exemp = 'oui' and titre_livre like ? group by livre.isbn,titre_livre,nom_auteur,prenom_auteur, maison_edition, date_publication,categorie";
            $resu5 = $conn->executer($requette,['%'.$titre.'%']);
        }
        if (!empty($resu5)){
    ?>
<table>
    <tr>
        <td>ISBN</td>
        <td>Titre</td>
        <td>Nom de l'auteur</td>
        <td>Prenom de l'auteur</td>
        <td>Categorie</td>
        <td>Maison d'édition</td>
        <td>Date de publication</td>
        <td>Nombre d'exemplaire disponible</td>
        <td>Voir les exemplaires disponibles</td>
    </tr>
    <?php foreach ($resu5 as $ress) : ?>
    <tr>
        <?php foreach ($ress as $key=>$value): $postt = $ress['isbn']?>
        <td>
            <?= $value?>
        </td>
        <?php endforeach; ?>
        <td>
            <form action="emprunter.php" method="get">
                <button type="submit" name="po" value="<?=$postt?>">voir exempaires dispo</button>
            </form>
        </td>
    </tr>
    <?php endforeach; ?>
</table>
<?php
    }else{
            echo "<h3>Aucun resultat trouvé</h3>";
        }
    }
?>
<br><br>

<h2>Sinon parcourez les listes proposés ici</h2>
    <table width="80%" style="margin-left: 100px">
        <tr>
            <th>
                <p>Voir la liste des livre dans la categorie : </p>
            </th>
            <th>
                <p>Voir la liste des livre dont l'auteur est:</p>
            </th>
        </tr>
        <tr>
            <td>
                <form action="accueil.php" method="get" name="cat">
                    <label for="categorie">Choisir une categorie</label>
                    <select name="categorie" id="categorie">
                        <option value="">Choisir une categorie</option>
                        <?php foreach ($resu as $cat) : ?>
                            <option value="<?=$cat['intitule']?>"><?=$cat['intitule']?></option>
                        <?php endforeach; ?>
                    </select>
                    <div style="border-style: inset; ">
                        <p>Trier par</p>
                        <label for="isbn">ISBN</label>
                        <input type="radio" name="isbn" value="1">
                        <label for="titre">Titre</label>
                        <input type="radio" name="titre_livre" value="1">
                        <label for="date_publication">Date de publication</label>
                        <input type="radio" name="date_publication"value="1">
                    </div>
                    <button type="submit" style="float: right ">ok</button>
                </form>
            </td>
            <td>
                <form action="accueil.php" method="get" name="aut">
                    <label for="auteur">Choisir un auteur</label>
                    <select name="auteur" id="auteur">
                        <option value="">Choisir un auteur</option>
                        <?php foreach ($resu1 as $cat1) : ?>
                            <option value="<?=$cat1['nom_auteur'].'-'.$cat1['prenom_auteur']?>"><?=$cat1['nom_auteur'].' '.$cat1['prenom_auteur']?></option>
                        <?php endforeach; ?>
                    </select>
                    <div style= "border-style: inset;">
                        <p>Trier par</p>
                        <label for="isbn">ISBN</label>
                        <input type="radio" name="order" value="isbn">
                        <label for="titre">Titre</label>
                        <input type="radio" name="order" value="titre_livre">
                        <label for="date_publication">Date de publication</label>
                        <input type="radio" name="order"value="date_publication">
                    </div>
                    <button type="submit" style="float: right">ok</button>
                </form>
            </td>
        </tr>
    </table>


<?php if (array_key_exists('categorie',$_GET) && $_GET['categorie'] != '' || array_key_exists('auteur',$_GET) && $_GET['auteur'] != '') :
        $con = BDD::getInstance();
    if (array_key_exists('categorie',$_GET) != ''){
        if (array_key_exists('order',$_GET)){
            $o = $_GET['order'];}else{
            $o = '';
        }
        $c = $_GET['categorie'];
        if ($o != ''){
            $s = "select isbn, titre_livre, date_publication, maison_edition, nom_auteur, prenom_auteur, nombre_exemplaire from livre, auteur where categorie = ? and auteur.id_auteur = livre.id_auteur order by ?";
            $ru = $conn->executer($s,[$c,$o]);
        }else{
            $s = "select isbn, titre_livre, date_publication, maison_edition, nom_auteur, prenom_auteur, nombre_exemplaire from livre, auteur where categorie = ? and auteur.id_auteur = livre.id_auteur";
            $ru = $conn->executer($s,[$c]);
        }
    }else{
        if (array_key_exists('order',$_GET)){
            $o = $_GET['order'];}else{
            $o = '';
        }
        $c = $_GET['auteur'];
        $c = explode("-",$c);
        if ($o != ''){
            $s = "select isbn, titre_livre, date_publication, maison_edition, nombre_exemplaire, categorie from livre where livre.id_auteur = (select id_auteur from auteur where nom_auteur = ? and prenom_auteur = ?) order by ?";
            $ru = $conn->executer($s,[$c[0],$c[1],$o]);
        }else{
            $s = "select isbn, titre_livre, date_publication, maison_edition, nombre_exemplaire, categorie from livre where livre.id_auteur = (select id_auteur from auteur where nom_auteur = ? and prenom_auteur = ?)";
            $ru = $conn->executer($s,[$c[0],$c[1]]);
        }
    }
     ?>
    <br><br>
    <table style="width:100%">
        <tr>
            <th>ISBN</th>
            <th>Titre</th>
            <th>Date de publication</th>
            <th>Maison_Edition</th>
            <?php if (array_key_exists('categorie',$_GET)):?>
            <th>Nom auteur</th>
            <th>Prenom auteur</th>
            <?php endif; ?>
            <th>Nombre d'exemplaires</th>
            <?php if (array_key_exists('auteur',$_GET)) :?>
            <th>Categorie</th>
            <?php endif;?>

        </tr>
        <?php foreach ($ru as $row) :?>
        <tr>
            <?php foreach ($row as $k=>$v): $postt = $row['isbn'];?>
            <td><?= $v ?></td>
            <?php endforeach;?>

            <td>
                <form action="emprunter.php" method="get">
                    <button type="submit" name="po" value="<?=$postt?>">voir exempaires dispo</button>
                </form>
            </td>
        </tr>
    </table>
           <?php endforeach;?>
           <?php endif;?>
    <br>
    <br>
</body>
</html>
