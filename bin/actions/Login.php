<?php
/**
 * User: Vicktor Grenu
 */

include("FacebookUtils.php");
include("Regions.php");
include("Resources.php");

$accessToken = getToken();
$fbId = getFacebookId();

// __________________________________

// return json format
$returnSize = 5;
$retour = array();

// request to check if player is already in the database
$req = "SELECT * FROM Player WHERE IDFacebook = :playerId";
$reqPre = $db->prepare($req);
$reqPre->bindParam(':playerId', $fbId);

try {
    $reqPre->execute();
    $res = $reqPre->fetch(); // PDO::FETCH_ASSOC

    // if player is in db -> return profil info
    if (!empty($res)) {
        for ($i=0; $i < $returnSize; $i++) {
            $retour[$i] = $res[$i];
        }
    }
    // else -> put it in db
    else {
        $reqInsertion = "INSERT INTO Player(IDFacebook, DateInscription, DateLastConnexion, NumberRegionHell, NumberRegionHeaven,FtueProgress) VALUES (:idFB, NOW(), NOW(),0,0,0)";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':idFB', $fbId);
        try {
            $reqInsPre->execute();
            $id = getId();
            createResources($id, 'soft', 20000);
            createResources($id, 'hard', 0);
            createResources($id, 'resourcesFromHell', 0);
            createResources($id, 'resourcesFromHeaven', 0);
            createResources($id, 'badXp', 0);
            createResources($id, 'goodXP', 0);
            createRegion($id,"heaven",-1,0,-12,0);
            createRegion($id,"neutral",0,0,0,0);
            createRegion($id,"hell",1,0,3,0);

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

?>
