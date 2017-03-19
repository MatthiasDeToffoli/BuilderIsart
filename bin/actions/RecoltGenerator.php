<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Resources as Resources;

/**
* @author: de Toffoli Matthias
* recolt of a house production
*/

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");
include_once("utils/Resources.php");

const TABLE = 'Building';
const MAPX ='X';
const MAPY ='Y';
const REGIONX ='RegionX';
const REGIONY ='RegionY';
const PLAYER_ID ='IDPlayer';
const QUANTITY ='NbResource';

$lId = FacebookUtils::getId();

$TypeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(MAPX),
  Utils::getSinglePostValue(MAPY),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

if($TypeBuilding->Name != 'Hell House' && $TypeBuilding->Name != 'Heaven House') {
  echo json_encode(['error' => true, 'message' => 'you can not recolt on '.$TypeBuilding->Name]);
  exit;
}
Resources::additionResources($lId,'soft',$TypeBuilding->NbResource);
Utils::updateSetWhere(TABLE,['NbResource' => 0],'ID = '.$TypeBuilding->ID);
$lResource = Resources::getResource($lId,'soft');

echo json_encode(['error' => false, 'resource' => $lResource->Quantity]);
?>
