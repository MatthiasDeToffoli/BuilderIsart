<?php

use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\PackUtils as PackUtils;
use actions\utils\Resources as Resources;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");
include_once("utils/PackUtils.php");
include_once("utils/Resources.php");

/**
* @author: de Toffoli Matthias
* start a collector production
*/

const REGIONX = 'RegionX';
const REGIONY = 'RegionY';
const X = 'X';
const Y = 'Y';
const NAME ='Name';
const MONEYTYPE = 'soft';
const CLIENTID = 'IDClientBuilding';

$lId = FacebookUtils::getId();

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(X),
  Utils::getSinglePostValue(Y),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

$pack = PackUtils::getPackByName(Utils::getSinglePostValue(NAME));
$resource = Resources::getResource($lId,MONEYTYPE);

if($typeBuilding->ProductionResource != $pack->ProductionResource) {
  echo json_encode(['error' => true, 'message' => 'this pack not match with this building',MONEYTYPE =>$resource->Quantity]);
  exit;
}

$resource->Quantity -= $pack->CostGold;

if($resource->Quantity < 0) {
  echo json_encode(['error' => true, 'message' => 'not have enought money',MONEYTYPE => ($resource->Quantity + $pack->CostGold)]);
  exit;
}


$time = Utils::timeToTimeStamp($pack->Time) + time();
Resources::updateResources($lId,MONEYTYPE,$resource->Quantity);

  Utils::updateSetWhere('Building',
    [
      'PackId' => $pack->ID,
      'EndForNextProduction' => Utils::timeStampToDateTime($time)
    ],
    'ID = '.$typeBuilding->ID.' AND IDPlayer = '.$lId
  );

  echo json_encode([
    'error' => false,
    CLIENTID => Utils::getSinglePostValue(CLIENTID),
    MONEYTYPE => $resource->Quantity,
    'time' => Utils::timeStampToJavascript($time)
  ]);
?>
