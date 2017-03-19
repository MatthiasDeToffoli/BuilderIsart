<?php
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Player as Player;
use actions\utils\Utils as Utils;
use actions\utils\BuildingUtils as BuildingUtils;

/**
* check if we can add a soul to the tribunal and send it to the server
* @author de Toffoli Matthias
*/

include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");
include_once("utils/Utils.php");
include_once("utils/Player.php");

const TABLE = 'Building';
const TABLEPLAYER = 'Player';
const MAPX ='X';
const MAPY ='Y';
const REGIONX ='RegionX';
const REGIONY ='RegionY';
const NBRESOURCES = 'NbResource';
const PLAYER_ID ='IDPlayer';
const DATESOUL ='DateForInvitedSoul';

$Player = Player::getPlayerById(FacebookUtils::getId());

if($Player->DateForInvitedSoul	=== null) addSoul();
else addSoulWithTime($Player);

/**
* add a soul and a date for know when we can add a new soul in database
*/
function addSoul() {
  $day = 24*60*60;
  $typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
    Utils::getSinglePostValue(MAPX),
    Utils::getSinglePostValue(MAPY),
    Utils::getSinglePostValue(REGIONX),
    Utils::getSinglePostValue(REGIONY)
  );

  $lTime = time() + $day;
  Utils::updateSetWhere(TABLE, [NBRESOURCES => ($typeBuilding->NbResource + 1)],'ID = '.$typeBuilding->ID);
  Utils::updateSetWhere(TABLEPLAYER, [DATESOUL => Utils::timeStampToDateTime($lTime)],'ID = '.FacebookUtils::getId());

  echo json_encode(['error' => false, 'time' => Utils::timeStampToJavascript($lTime)]);
}

/**
* Check if we can add a soul in function of the date to block it
* @param	$pPlayer current player
*/
function addSoulWithTime($pPlayer){
  $timeForInviteNextSoul = Utils::dateTimeToTimeStamp($pPlayer->DateForInvitedSoul);

  if(time() > $timeForInviteNextSoul) addSoul();
  else {
    echo json_encode(['error' => true, 'message' => 'you can not invite a soul for now', 'time' => Utils::timeStampToJavascript($timeForInviteNextSoul)]);
    exit;
  }
}
?>
