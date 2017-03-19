<?php
use actions\utils\Utils as Utils;
use actions\utils\BuildingUtils as BuildingUtils;

/**
* @author: de Toffoli Matthias
* check the zone around altar for see if it has building in his zone and send it to server.
*/

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
$deonominator = ($countHell * $altar->ProductionPerBuildingHell) + ($countHeaven*$altar->ProductionPerBuildingHeaven);
if($deonominator <= 0) $time = 0;
else $time = 3600/$deonominator;

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
  END => $time <= 0 ? null:Utils::timeStampToJavascript(time() + $time),
  NBHEAVEN => $countHeaven,
  NBHELL => $countHell
]);

/**
* check on hell regions near it (hell regions are regions on right) if a building is inside altar's zone
* @param	$pNbBuilding number building altar had in database
* @param	$Building building we check if it in altar zone
* @return numberBuilding on the region or numberBuilding on the region + 1
*/
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

/**
* check on heaven regions near it (hell regions are regions on left) if a building is inside altar's zone
* @param	$pNbBuilding number building altar had in database
* @param	$Building building we check if it in altar zone
* @return numberBuilding on the region or numberBuilding on the region + 1
*/
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
