<?php
use actions\utils\Utils as Utils;
use actions\utils\BuildingUtils as BuildingUtils;

include_once("utils/Utils.php");
include_once("utils/BuildingUtils.php");

const IDCLIENT = 'IDClientBuilding';
const REGIONX = 'RegionX';
const REGIONY = 'RegionY';
const X = 'X';
const Y = 'Y';
const TABLE = 'Building';
const NBHELL = 'NbBuildingHell';
const NBHEAVEN = 'NbBuildingHeaven';
const END = 'EndForNextProduction';

$hellBuildings = BuildingUtils::getAllBuildings(1);
$heavenBuildings = BuildingUtils::getAllBuildings(-1);

$countHell = 0;
$countHeaven = 0;

for($h = 0; $h < count($hellBuildings); $h++) {
  $countHell = checkIfIsZoneHell($countHell,$hellBuildings[$h]);
}

for($h = 0; $h < count($heavenBuildings); $h++) {
  $countHeaven = checkIfIsZoneHeaven($countHeaven,$heavenBuildings[$h]);
}

$altar = BuildingUtils::getTypeBuildingWithPosition(
    Utils::getSinglePostValueInt(X),
    Utils::getSinglePostValueInt(Y),
    Utils::getSinglePostValueInt(REGIONX),
    Utils::getSinglePostValueInt(REGIONY)
);
if($countHell == 0 && $countHeaven == 0) $time = 0;
else $time = 3600/(($countHell * $altar->ProductionPerBuildingHell) + ($countHeaven*$altar->ProductionPerBuildingHeaven));

if($time <= 0) $timeToInsert = 'NULL';
else $timeToInsert =  Utils::timeStampToDateTime(time() + $time);

Utils::updateSetWhere(
  TABLE,
  [
    NBHEAVEN => $countHeaven,
    NBHELL => $countHell,
    END => $timeToInsert
  ],
  'ID = '.$altar->ID
);

echo json_encode([
    'error' => false,
    IDCLIENT => Utils::getSinglePostValueInt(IDCLIENT),
    END => $time <= 0 ? null:Utils::timeStampToJavascript(time() + $time)
  ]);

function checkIfIsZoneHell($pNbBuilding, $Building) {
  $altarRegionY = Utils::getSinglePostValueInt(REGIONY);
  if($Building->RegionY > $altarRegionY + 1 || $Building->RegionY < $altarRegionY - 1){
    return $pNbBuilding;
  }

  for($i = $Building->Y; $i < ($Building->Y + $Building->Height); $i++){
    for($j = 0; $j < 4; $j++){
      for($k = 0; $k < 4 - $j; $k++){
        $posY = Utils::getSinglePostValueInt(Y) - $k;

        $regionY = $altarRegionY;

        if($posY < -1) {
          $regionY = $altarRegionY - 1;
          $posY += 12;
        }

        if(
          (Utils::getSinglePostValueInt(REGIONX) + 1) == $Building->RegionX &&
          $regionY == $Building->RegionY &&
          $j == $Building->X &&
          $posY == $i
        ) {
          return $pNbBuilding + 1;
        }

        $posY = Utils::getSinglePostValueInt(Y) + $k;

        if($posY > 12) {
          $regionY = $altarRegionY - 1;
          $posY -= 13;
        }

        if(
          (Utils::getSinglePostValueInt(REGIONX) + 1) == $Building->RegionX &&
          $regionY == $Building->RegionY &&
          $j == $Building->X &&
          $posY == $i
        ) {
          return $pNbBuilding + 1;
        }


      }
    }
  }

  return $pNbBuilding;
}

function checkIfIsZoneHeaven($pNbBuilding, $Building) {
  $altarRegionY = Utils::getSinglePostValueInt(REGIONY);
  if($Building->RegionY > $altarRegionY + 1 || $Building->RegionY < $altarRegionY - 1){
    return $pNbBuilding;
  }

  for($i = $Building->Y; $i < ($Building->Y + $Building->Height); $i++){
    for($j = 0; $j < 4; $j++){
      for($k = 0; $k < 4 - $j; $k++){
        $posY = Utils::getSinglePostValueInt(Y) - $k;

        $regionY = $altarRegionY;

        if($posY < -1) {
          $regionY = $altarRegionY - 1;
          $posY += 12;
        }

        if(
          (Utils::getSinglePostValueInt(REGIONX) - 1) == $Building->RegionX &&
          $regionY == $Building->RegionY &&
          11 - $j == ($Building->X + $Building->Width) &&
          $posY == $i
        ) {
          return $pNbBuilding + 1;
        }

        $posY = Utils::getSinglePostValueInt(Y) + $k;

        if($posY > 12) {
          $regionY = $altarRegionY - 1;
          $posY -= 13;
        }



        if(
          (Utils::getSinglePostValueInt(REGIONX) - 1) == $Building->RegionX &&
          $regionY == $Building->RegionY &&
          11 - $j == $Building->X &&
          $posY == $i
        ) {
          return $pNbBuilding + 1;
        }


      }
    }
  }

  return $pNbBuilding;
}
?>
