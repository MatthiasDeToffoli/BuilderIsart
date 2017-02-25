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
      ((60*60)/$typeBuilding->ProductionPerHour)/$typeBuilding->NbSoul,
      $typeBuilding->NbResource,
      $typeBuilding->MaxGoldContained
    );
} else if($typeBuilding->Name == 'Purgatory') {
  $calculTimePurgatory = $typeBuilding->ProductionPerHour + $Player->NumberMarketigHouse * 2;
  if($Player->IdCampaign == 0) {
    $results = calculGain(
        Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
        ((60*60)/$calculTimePurgatory),
        $typeBuilding->NbResource,
        $typeBuilding->MaxSoulsContained
      );
  } else {
    $results = calculGainWithBoost(
        Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
        ((60*60)/$calculTimePurgatory),
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
  $calculTotal = 3600/($calcul1 + $calcul2);

  if($calculTotal <= 0) $calculTotal = null;

  $results = calculGain(
      Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
      $calculTotal,
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
    if($currentTime > $pEnd) {
      if($pResource < $pMax) $newResource = $pResource + 1;

      if($pCalcul === null) {
        $end = $pCalcul;
      }
      else {
        $end = $pEnd + $pCalcul;
      }

      return calculGain($end,$pCalcul,$newResource,$pMax);
    }
  }


  return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => $pResource,"max" => $pMax, "end" => $pEnd);
}

function calculGainWithBoost($pEnd,$pCalcul,$pResource, $pMax,$pEndBoost,$pGainBoost){
    $currentTime = time();
    if($currentTime > $pEnd) {
      if($pResource < $pMax) $newResource = $pResource + 1;
        if($pEnd < $pEndBoost) $finalCalcul = $pCalcul/$pGainBoost;
        else $finalCalcul = $pCalcul;
        $end = $pEnd + $finalCalcul;

      return calculGainWithBoost($end,$pCalcul,$newResource,$pMax,$pEndBoost,$pGainBoost);
    }


  return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => $pResource,"max" => $pMax, "end" => $pEnd);
}
?>
