<?php
session_start();
require_once 'BDD.php';
$uti = $_SESSION['id_u'];
$livre = explode('-',$_GET['reserver']);

$co = BDD::getInstance();
$sql = "insert into emprunt (id_exemplaire, id_utilisateur, isbn, effet) values ( ?, ? , ? , ? )";
if ($co->executer($sql,[$livre[0],$uti,$livre[1],'0'])){
    $sql = "update exemplaire set dispo_exemp = 'non' where id_exemp= ? and id_livre = ? ";
    $co->executer($sql,[$livre[0],$livre[1]]);
    header('Location: profile.php');
}




