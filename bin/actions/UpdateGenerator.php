<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Player as Player;
use actions\utils\PackUtils as PackUtils;

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
if($Player->IdCampaign != 0)$BoostPack = PackUtils::getPackById($Player->IdCampaign);

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(MAPX),
  Utils::getSinglePostValue(MAPY),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

if($typeBuilding->Name == 'Hell House' || $typeBuilding->Name == 'Heaven House') {
  $results = calculGain(
      Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
      ($typeBuilding->ProductionPerHour * $typeBuilding->NbSoul)/60,
      $typeBuilding->NbResource,
      $typeBuilding->MaxGoldContained
    );
} else if($typeBuilding->Name == 'Purgatory') {
  $calculPurgatory = $typeBuilding->ProductionPerHour + $Player->NumberMarketigHouse * 2;
  if($Player->IdCampaign == 0) {
    $results = calculGain(
        Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
        $calculPurgatory/60,
        $typeBuilding->NbResource,
        $typeBuilding->MaxSoulsContained
      );
  } else {
    $results = calculGainWithBoost(
        Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
        $calculPurgatory/60,
        $typeBuilding->NbResource,
        $typeBuilding->MaxSoulsContained,
        Utils::dateTimeToTimeStamp($Player->EndOfCampaign),
        $BoostPack->GainFluxSouls
      );
  }
}
else if($typeBuilding->NbBuildingHeaven > 0 || $typeBuilding->NbBuildingHell > 0) {
  $calcul1 = $typeBuilding->NbBuildingHell * $typeBuilding->ProductionPerBuildingHell;
  $calcul2 = $typeBuilding->NbBuildingHeaven*$typeBuilding->ProductionPerBuildingHeaven;

  $results = calculGain(
      Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
      ($calcul1 + $calcul2)/60,
      $typeBuilding->NbResource,
      $typeBuilding->MaxGoldContained
    );
}
else {
  echo json_encode(["error" => true, "message"=>$typeBuilding->Name." doesn't have generator"]);
  exit;
}

Utils::updateSetWhere('Building',
  [
    'NbResource' => $results->nbResource,
    'EndForNextProduction' => Utils::timeStampToDateTime($results->end)
  ],
  'ID = '.$typeBuilding->ID.' AND IDPlayer = '.FacebookUtils::getId()
);
$results->end = Utils::timeStampToJavascript($results->end);
echo json_encode($results);

function calculGain($pEnd,$pCalcul,$pResource, $pMax){
  if($pEnd !== null){
    $currentTime = time();
    $minDiff = floor(($currentTime - $pEnd)/60) + 1;

    if($minDiff > 0) {
      if($pCalcul > 0) {
        $newResource = $pResource + ($pCalcul * $minDiff);
        if($newResource > $pMax) $newResource = $pMax;
      }

      $end = $pEnd + ($minDiff * 60);
      return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($newResource),"max" => $pMax, "end" => $end);
    }
  }


  return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($pResource),"max" => $pMax, "end" => $pEnd);
}

function calculGainWithBoost($pEnd,$pCalcul,$pResource, $pMax,$pEndBoost,$pGainBoost){
    $currentTime = time();
    $minDiff = floor(($currentTime - $pEnd)/60) + 1;
    if($minDiff > 0) {
      $newResource = $pResource + $minDiff * ($pCalcul + $pGainBoost);
      if($newResource > $pMax) $newResource = $pMax;
    $end = $pEnd + 60 * $minDiff;

      return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($newResource),"max" => $pMax, "end" => $end);
    }

  return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($pResource),"max" => $pMax, "end" => $pEnd);
}
?>
