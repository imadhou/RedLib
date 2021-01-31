<?php
require_once('BDD.php');
function utilisateur($param){
    $c = BDD::getInstance();
    $re = $c->pdo->prepare("select titre_livre,id_exemplaire,emprunt.isbn, emprunt.effet,emprunt.date_emprunt, emprunt.date_retoure  from livre ,emprunt, exemplaire where exemplaire.id_exemp = emprunt.id_exemplaire and livre.isbn = emprunt.isbn and emprunt.id_utilisateur = ?");
    $re->bindValue(1,$param);
    if ($re->execute()){
        $uti = $re->fetchAll(PDO::FETCH_ASSOC);
        return $uti;
    }
}
