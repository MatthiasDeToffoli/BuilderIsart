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
const QUANTITY ='NbSoul';
const NBRESOURCES = 'NbResource';
const PLAYER_ID ='IDPlayer';
const END ='EndForNextProduction';

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(MAPX),
  Utils::getSinglePostValue(MAPY),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

echo $typeBuilding->Name;
if($typeBuilding->Name == 'Hell House' || $typeBuilding->Name == 'Heaven House') {
  if($typeBuilding->NbResource >= $typeBuilding->MaxGoldContained)exit;
  $results = calculGain(
      Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
      ((60*60)/$typeBuilding->ProductionPerHour)/$typeBuilding->NbSoul,
      $typeBuilding->NbResource,
      $typeBuilding->MaxGoldContained
    );
} else if($typeBuilding->Name == 'Purgatory') {
  if($typeBuilding->NbResource >= $typeBuilding->MaxSoulsContained)exit;
} else {
  exit;
}

Utils::updateSetWhere('Building',
  [
    'NbResource' => $results->nbResource,
    'EndForNextProduction' => Utils::timeStampToDateTime($results->end)
  ],
  'ID = '.$typeBuilding->ID.' AND IDPlayer = '.FacebookUtils::getId()
);

echo json_encode($results);

function calculGain($pEnd,$pCalcul,$pResource, $pMax){
  $currentTime = time();
  if($currentTime > $pEnd) {
    $newResource = $pResource + 1;
    $end = $pEnd + $pCalcul;
    echo "\n";
    echo "end ".$pEnd;
    if($newResource >= $pMax) {
      return (object) array("nbResource" => $pMax, "end" => $end);
    } else {
      return calculGain($end,$pCalcul,$newResource,$pMax);
    }
  }

  return (object) array("nbResource" => $pResource, "end" => $pEnd);
}
?>
