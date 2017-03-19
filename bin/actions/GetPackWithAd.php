<?php
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Player as Player;
use actions\utils\Utils as Utils;
use actions\utils\Resources as Resources;

/**
* @author: de Toffoli Matthias
* get resources gain when we see a ad movies in shop
*/

include_once("utils/FacebookUtils.php");
include_once("utils/Utils.php");
include_once("utils/Player.php");
include_once("utils/Resources.php");

$Player = Player::getPlayerById(FacebookUtils::getId());

if($Player->DateForSawAdInShop	=== null) gain();
else gainWithTime($Player);

/**
* update database add gain and time de bloc gain for one day
*/
function gain() {
  $day = 24*60*60;
  $lPack = getPack();

  Resources::additionResources(FacebookUtils::getId(),'hard', $lPack->GiveKarma);

  $lTime = time() + $day;
  Utils::updateSetWhere('Player', ['DateForSawAdInShop' => Utils::timeStampToDateTime($lTime)],'ID = '.FacebookUtils::getId());

  echo json_encode(['error' => false, 'time' => Utils::timeStampToJavascript($lTime)]);
}

/**
* check if we pass the delay for see a new video
*/
function gainWithTime($pPlayer) {
  $timeForSeeAd = Utils::dateTimeToTimeStamp($pPlayer->DateForSawAdInShop);

  if(time() > $timeForSeeAd) gain();
  else {
    echo json_encode(['error' => true, 'message' => 'you can not see ad video for now', 'time' => Utils::timeStampToJavascript($timeForSeeAd)]);
    exit;
  }
}

/**
* get the video pack
*/
function getPack() {
  global $db;

  $req = "SELECT * FROM TypeShopPack  WHERE PackName = karma ad";
  $reqPre = $db->prepare($req);

  try {
    $reqPre->execute();
    return $reqPre->fetch(PDO::FETCH_OBJ);
  } catch (Exception $e) {
    echo $e->getMessage();
    exit;
  }
}
?>
