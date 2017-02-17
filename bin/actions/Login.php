<?php
/**
 * User: Vicktor Grenu
 */

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Regions as Regions;
use actions\utils\Resources as Resources;

include_once("utils/FacebookUtils.php");
include("utils/Regions.php");
include("utils/Resources.php");

$accessToken = FacebookUtils::getToken();
$fbId = FacebookUtils::getFacebookId();

// __________________________________

// return json format
$returnSize = 5;

// request to check if player is already in the database
$req = "SELECT * FROM Player WHERE IDFacebook = :playerId";
$reqPre = $db->prepare($req);
$reqPre->bindParam(':playerId', $fbId);

try {
    $reqPre->execute();
    $res = $reqPre->fetch(); // PDO::FETCH_ASSOC

    // if player is in db -> return profil info
    if (!empty($res)) {

        $retour['ID'] = $res['ID'];
        $retour['isNewPlayer'] = false;
    }
    // else -> put it in db
    else {
        $retour['isNewPlayer'] = true;

        $reqInsertion = "INSERT INTO Player(IDFacebook, DateInscription, DateLastConnexion, NumberRegionHell, NumberRegionHeaven,FtueProgress) VALUES (:idFB, NOW(), NOW(),0,0,0)";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':idFB', $fbId);

        try {
            $reqInsPre->execute();
            $id = FacebookUtils::getId();
            Resources::createResources($id, 'soft', 20000);
            Resources::createResources($id, 'hard', 0);
            Resources::createResources($id, 'resourcesFromHell', 0);
            Resources::createResources($id, 'resourcesFromHeaven', 0);
            Resources::createResources($id, 'badXp', 0);
            Resources::createResources($id, 'goodXP', 0);
            Regions::createRegion($id,"heaven",-1,0,-12,0);
            Regions::createRegion($id,"neutral",0,0,0,0);
            Regions::createRegion($id,"hell",1,0,3,0);
            $retour['ID'] = FacebookUtils::getId();
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
