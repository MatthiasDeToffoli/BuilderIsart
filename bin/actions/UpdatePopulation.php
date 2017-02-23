<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");

const TABLE = 'Building';
const MAPX ='X';
const MAPY ='Y';
const REGIONX ='RegionX';
const REGIONY ='RegionY';
const TRIBUMAPX ='tribuX';
const TRIBUMAPY ='tribuY';
const TRIBUREGIONX ='tribuRegionX';
const TRIBUREGIONY ='tribuRegionY';
const PLAYER_ID ='IDPlayer';
const QUANTITY ='NbSoul';
const NBRESOURCES = 'NbResource';
const PLAYER_ID ='IDPlayer';
const END ='EndForNextProduction';
const CLIENTID = 'IdClient';

$typeTribu = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(TRIBUMAPX),
  Utils::getSinglePostValue(TRIBUMAPY),
  Utils::getSinglePostValue(TRIBUREGIONX),
  Utils::getSinglePostValue(TRIBUREGIONY)
);

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(MAPX),
  Utils::getSinglePostValue(MAPY),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

if($typeBuilding->Name != 'Hell House' && $typeBuilding->Name != 'Heaven House') {
  echo json_encode([
    "error" => true,
    "message" => $typeBuilding->Name." is wrong building"
  ]);

  exit;
}

$rest = $typeTribu->NbResource - Utils::getSinglePostValueInt(QUANTITY);

if($rest < 0) {
    echo json_encode([
      "error" => true,
      "message" => "tribunal doesn't have enought soul"
    ]);

    exit;
}

$quantity = $typeBuilding->NbSoul + Utils::getSinglePostValueInt(QUANTITY);

if($quantity > $typeBuilding->MaxSoulsContained){
    echo json_encode([
      "error" => true,
      "message" => "doesn't have place in this building"
    ]);

    exit;
}

$time = time() +  ((60*60)/$typeBuilding->ProductionPerHour)/$quantity;
$where = 'ID = '.$typeTribu->ID." AND ".PLAYER_ID.'='.FacebookUtils::getId();
Utils::updateSetWhere(TABLE,[NBRESOURCES => $rest], $where);

$where = 'ID = '.$typeBuilding->ID." AND ".PLAYER_ID.'='.FacebookUtils::getId();
Utils::updateSetWhere(TABLE,[
  QUANTITY => $quantity,
  END => Utils::timeStampToDateTime($time)
], $where);

echo json_encode([
  "error" => false,
  CLIENTID => Utils::getSinglePostValueInt(CLIENTID),
  END => Utils::timeStampToJavascript($time),
  QUANTITY => $quantity,
  NBRESOURCES => $rest
]);
?>
