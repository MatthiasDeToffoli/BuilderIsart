<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\PackUtils as PackUtils;
use actions\utils\Resources as Resources;
use actions\utils\Experience as Experience;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");
include_once("utils/PackUtils.php");
include_once("utils/Resources.php");
include_once("utils/Experience.php");


const REGIONX = 'RegionX';
const REGIONY = 'RegionY';
const X = 'X';
const Y = 'Y';
const CLIENTID = 'IDClientBuilding';

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(X),
  Utils::getSinglePostValue(Y),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

$lId = FacebookUtils::getId();

if($typeBuilding->PackId <= 0 ) {
  echo json_encode(["error" => true, "message" => "not pack used by ".$typeBuilding->Name]);
  exit;
}

$pack = PackUtils::getPackById($typeBuilding->PackId);

if($pack->ProductionResource == 'stone') {
  $lType = 'resourcesFromHell';
  $gain = $pack->GainIron;
  $xpObject = Experience::gaignBadXp($pack->XPHellGiven);
} else if($pack->ProductionResource == 'wood') {
  $lType = 'resourcesFromHeaven';
  $gain = $pack->GainWood;

  $xpObject = Experience::gaignGoodXp($pack->XPHeavenGiven);
} else {
  echo json_encode(["error" => true, "message" => "type ".$pack->ProductionResource." not found"]);
  exit;
}

Resources::additionResources($lId,$lType,$gain);

Utils::updateSetWhere('Building', ['PackId' => 0], 'ID = '.$typeBuilding->ID);
$lResourceHell = Resources::getResource($lId,'resourcesFromHell');
$lResourceHeaven = Resources::getResource($lId,'resourcesFromHeaven');
echo json_encode([
  "error" => false,
  'badXp' => $xpObject->badXp,
  'goodXp' => $xpObject->goodXp,
  'level' => $xpObject->level,
  'type' => $lType,
  'resourcesFromHell' => $lResourceHell->Quantity,
  'resourcesFromHeaven' => $lResourceHeaven->Quantity
]);

?>
