<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Player as Player;
use actions\utils\PackUtils as PackUtils;

/**
* @author: de Toffoli Matthias
* said when an upgrade is fine
*/

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");
include_once("utils/Player.php");
include_once("utils/PackUtils.php");

const TABLE = 'Building';
const MAPX ='X';
const MAPY ='Y';
const IDCLIENT ='IDClientBuilding';
const REGIONX ='RegionX';
const REGIONY ='RegionY';
const PLAYER_ID ='IDPlayer';
const QUANTITY ='NbSoul';
const NBRESOURCES = 'NbResource';
const PLAYER_ID ='IDPlayer';
const END ='EndForNextProduction';

$Player = Player::getPlayerById(FacebookUtils::getId());

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(MAPX),
  Utils::getSinglePostValue(MAPY),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

if($typeBuilding->IsBuilt != 1) return;

if(Utils::dateTimeToTimeStamp($typeBuilding->EndConstruction) > time()) {
  echo json_encode(['error' => true, 'message' => ($typeBuilding->Name.' not finish upgrade')]);
  exit;
}

$newTypeBuilding = BuildingUtils::getTypeBuilding($typeBuilding->Name, ($typeBuilding->Level + 1));

Utils::updateSetWhere('Building', [
  'IDTypeBuilding' => $newTypeBuilding->ID,
  'IsBuilt' => 0
], 'ID = '.$typeBuilding->ID);
echo 'update';
?>
