<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Player as Player;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Player.php");

$ID = FacebookUtils::getID();

$player = Player::getPlayerById($ID);

$daysOfConnexion = $player->DaysOfConnexion;

$accessToken = FacebookUtils::getToken();

// __________________________________

// return json format
$returnSize = 5;

// request to check if player is already in the database
$req = "SELECT * FROM DailyReward WHERE Day = :pDays";
$reqPre = $db->prepare($req);
$reqPre->bindParam(':pDays', $daysOfConnexion);

try {
    $reqPre->execute();
    $res = $reqPre->fetch(); // PDO::FETCH_ASSOC

    // if player is in db -> return profil info
    if (!empty($res)) {

        $retour['day'] = $res['Day'];
        $retour['wood'] = $res['Wood'];
        $retour['iron'] = $res['Iron'];
        $retour['gold'] = $res['Gold'];
        $retour['karma'] = $res['Karma'];
    }
    // else -> put it in db
    else {
        $retour['day'] = 0;
        $retour['wood'] = 0;
        $retour['iron'] = 0;
        $retour['gold'] = 0;
        $retour['karma'] = 0;
    }
} catch (Exception $e) {
    echo $e->getMessage();
    exit;
}

if (isset($accessToken)) {
    echo json_encode($retour);
}


?>