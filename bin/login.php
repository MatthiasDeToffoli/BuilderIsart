<?php
/**
 * User: Vicktor Grenu
 */


include("base.php");

// return json format
$returnSize = 5;
$retour = array();

// request to check if player is already in the database
$req = "SELECT * FROM Player WHERE IDFacebook = :playerId";
$reqPre = $db->prepare($req);
$reqPre->bindParam(':playerId', $fbId);

try {
    $reqPre->execute();
    $res = $reqPre->fetch();

    // if player is in db -> return profil info
    if (!empty($res)) {
        for ($i=0; $i < $returnSize; $i++) {
            $retour[$i] = $res[$i];
        }
    }
    // else -> put it in db
    else {
        $reqInsertion = "INSERT INTO Player(IDFacebook, DateInscription, DateLastConnexion, email) VALUES (:idFB, NOW(), NOW(), 'monmail')";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':idFB', $fbId);
        try {
            $reqInsPre->execute();
            //$res = $reqInsPre->fetch(PDO::FETCH_ASSOC); inutile ?
        } catch (Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }
} catch (Exception $e) {
    echo $e->getMessage();
    exit;
}

if (isset($accessToken)) {
    echo json_encode($retour);
}


