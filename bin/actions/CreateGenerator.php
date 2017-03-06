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
const PLAYER_ID ='IDPlayer';
const QUANTITY ='NbResource';
const END ='EndForNextProduction';

$TypeBuilding = BuildingUtils::getTypeBuildingWithPosition(
    Utils::getSinglePostValue(MAPX),
    Utils::getSinglePostValue(MAPY),
    Utils::getSinglePostValue(REGIONX),
    Utils::getSinglePostValue(REGIONY)
  );
if($TypeBuilding->EndForNextProduction != null) exit;
if($TypeBuilding->Name === 'Purgatory'){
  $pTime = time() +  60;
  $toSet = [
    QUANTITY => $TypeBuilding->MaxSoulsContained,
    END => Utils::timeStampToDateTime($pTime)
  ];
} else {
  $toSet = [
    QUANTITY => 0
  ];
}

Utils::updateSetWhere(TABLE,
  $toSet,
  MAPX.'='.Utils::getSinglePostValue(MAPX).
  ' AND '.MAPY.'='.Utils::getSinglePostValue(MAPY).
  ' AND '.REGIONX.'='.Utils::getSinglePostValue(REGIONX).
  ' AND '.REGIONY.'='.Utils::getSinglePostValue(REGIONY).
  ' AND '.PLAYER_ID.'='.FacebookUtils::getId());

echo MAPX.'='.Utils::getSinglePostValue(MAPX).
' AND '.MAPY.'='.Utils::getSinglePostValue(MAPY).
' AND '.REGIONX.'='.Utils::getSinglePostValue(REGIONX).
' AND '.REGIONY.'='.Utils::getSinglePostValue(REGIONY).
' AND '.PLAYER_ID.'='.FacebookUtils::getId()."\n";
echo json_encode($toSet);
echo "\n";
echo json_encode($TypeBuilding);
 ?>
