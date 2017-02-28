<?php
/**
 * User: Vicktor Grenu
 * User: Matthias DeTefolli
 * User: Ambroise Rabier (conenxion whitout fb)
 * Le fichier php le plus moche au monde ci-dessous.
 */

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Regions as Regions;
use actions\utils\Resources as Resources;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Utils as Utils;

include_once("utils/FacebookUtils.php");
include_once("utils/Regions.php");
include_once("utils/Resources.php");
include_once("utils/BuildingUtils.php");
include_once("utils/Utils.php");

$PWD = "com_isartdigital_perle_passwordNoFB";

$accessToken = FacebookUtils::getToken();
$fbId = FacebookUtils::getFacebookId();

// __________________________________

// return json format
$returnSize = 5; // todo : useless ?

$default= "FALSE";

// request to check if player is already in the database
$req = "SELECT * FROM Player WHERE IDFacebook = :playerId";
$reqPre = $db->prepare($req);
$reqPre->bindParam(':playerId', $fbId);

// for some reason (wtf) the expire only work here for "test", and then give the wrong date.
$date = new DateTime();
$maxExpires = $date->getTimestamp()+3600*24*360;
// wtf, my cookie "com_isartdigital_perle_passwordNoFB" only work if there is another cookie, WTF PHP WTF
setcookie("test", "mdp", $maxExpires, "/");

if (isset($_COOKIE[$PWD])){
    $rowPlayerNoFB = getTablePlayerWhitPwd(str_replace("/", "", $_COOKIE[$PWD]));
}

function getTablePlayerWhitPwd ($pwd) {
    global $db;

    $resBis = "SELECT * FROM Player WHERE PasswordNoFB = :passwordNoFB";
    $reqPreBis = $db->prepare($resBis);
    $reqPreBis->bindParam(':passwordNoFB', $pwd);

    try {
        $reqPreBis->execute();
    } catch (\Exception $e) {
        echo $e->getMessage();
        exit;
    }

    while($row = $reqPreBis->fetch(\PDO::FETCH_ASSOC))
    {
        $result[] = $row;
    }

    return $result[0];
}

try {
    $reqPre->execute();
    $res = $reqPre->fetch(); // PDO::FETCH_ASSOC
    // if player is in db -> return profil info
    if (!empty($res)) {
        $retour['ID'] = $res['ID'];
        $retour['level'] = $res['Level'];
        $retour['isNewPlayer'] = false;
        $retour['passwordNoFB'] = $res['PasswordNoFB'];
        $retour['debug3'] = "trace2";
		$retour['dateLastConnexion'] = $res['DateLastConnexion'];
        $retour['daysOfConnexion'] = $res['DaysOfConnexion'];
        $retour['dateInscription'] = $res['DateInscription'];
        //setcookie($PWD, $retour['PasswordNoFB'], $maxExpires, "/");
    }
    // else if no facebook id but a password
    else if (!empty($rowPlayerNoFB)) {
        $retour['ID'] = $rowPlayerNoFB['ID'];
		$retour['level'] = $res['Level'];
        $retour['isNewPlayer'] = false;
        $retour['passwordNoFB'] = $rowPlayerNoFB['PasswordNoFB'];
        $retour['debug'] = "ConnexionWhitoutFB";
		$retour['dateLastConnexion'] = $res['DateLastConnexion'];
        $retour['daysOfConnexion'] = $res['DaysOfConnexion'];
		$retour['dateInscription'] = $res['DateInscription'];
        //setcookie($PWD, $retour['PasswordNoFB'], $maxExpires, "/");
    }
    // else -> put it in db
    else {
        unset($_COOKIE[$PWD]);
        //setcookie(COOKIE_PWD, null, -1);
        $lPassword = md5(uniqid(rand(), true));
        $default = null;

        $reqInsertion = "INSERT INTO Player(IDFacebook, DateInscription, DateLastConnexion, NumberRegionHell, NumberRegionHeaven,FtueProgress,PasswordNoFB) VALUES (:idFB, NOW(), NOW(),0,0,0,:pwd)";
        $reqInsPre = $db->prepare($reqInsertion);
        if (isset($fbId))
            $reqInsPre->bindParam(':idFB', $fbId);
        else
            $reqInsPre->bindParam(':idFB', $default);
        $reqInsPre->bindParam(':pwd', $lPassword);

        try {
            $reqInsPre->execute();

            // setcookie need to be setted before creating default buildings
            setcookie($PWD, $lPassword, $maxExpires, "/");
            $_COOKIE[$PWD] = $lPassword;
            $id = FacebookUtils::getId();
            // cookie is not set so getId() will be null
            /*if (empty($id) || $id == null) {
                $id = getTablePlayerWhitPwd($lPassword)['ID'];
            }*/


            Resources::createResources($id, 'soft', 160);
            Resources::createResources($id, 'hard', 0);
            Resources::createResources($id, 'resourcesFromHell', 0);
            Resources::createResources($id, 'resourcesFromHeaven', 0);
            Resources::createResources($id, 'badXp', 0);
            Resources::createResources($id, 'goodXP', 0);
            Regions::createRegion($id,"heaven",-1,0,-12,0);
            Regions::createRegion($id,"neutral",0,0,0,0);
            Regions::createRegion($id,"hell",1,0,3,0);
            BuildingUtils::addPurgatoryToDatabase();
            BuildingUtils::addFirstHellBuildingToDatabase();
            $retour['ID'] = $id;
            $retour['isNewPlayer'] = true;
            $retour['passwordNoFB'] = $lPassword;
			$retour['lastDateConnexion'] = time();
			$retour['daysOfConnexion'] = 0;
			$retour['level'] = 2;
			$retour['dateInscription'] = time();

        } catch (Exception $e) {
            echo $e->getMessage();
            exit;
        }


    }
} catch (Exception $e) {
    echo $e->getMessage();
    exit;
}

echo json_encode($retour);

?>
