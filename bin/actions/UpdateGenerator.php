<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Player as Player;
use actions\utils\PackUtils as PackUtils;

/**
* @author: de Toffoli Matthias
* update the number of resources a building have and synchronis it with client
*/

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
    ($typeBuilding->ProductionPerHour * $typeBuilding->NbSoul)/3600,
    $typeBuilding->NbResource,
    $typeBuilding->MaxGoldContained
  );
} else if($typeBuilding->Name == 'Purgatory') {
  $calculPurgatory = $typeBuilding->ProductionPerHour + $Player->NumberMarketigHouse * 2;
  if($Player->IdCampaign == 0) {
    $results = calculGain(
      Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
      $calculPurgatory/3600,
      $typeBuilding->NbResource,
      $typeBuilding->MaxSoulsContained
    );
  } else {
    $results = calculGainWithBoost(
      Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
      $calculPurgatory/3600,
      $typeBuilding->NbResource,
      $typeBuilding->MaxSoulsContained,
      Utils::dateTimeToTimeStamp($Player->EndOfCampaign),
      $BoostPack->GainFluxSouls
    );
  }
}
else if($typeBuilding->Name == 'Altar Vice 1' ||
$typeBuilding->Name == 'Altar Vice 2' ||
$typeBuilding->Name == 'Altar Virtue 1' ||
$typeBuilding->Name == 'Altar Virtue 2'
) {
  $calcul1 = $typeBuilding->NbBuildingHell * $typeBuilding->ProductionPerBuildingHell;
  $calcul2 = $typeBuilding->NbBuildingHeaven*$typeBuilding->ProductionPerBuildingHeaven;

  $results = calculGain(
    Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction),
    ($calcul1 + $calcul2)/3600,
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


/**
*calcul how mutch building have product
*@param $pEnd date for increase by one
*@param $pCalcul calcul for know how mutch we increase with one update
*@param $pResource number of resource building had
*@param $pMax max of resource building can had
*@return an object contained many information to send at client for synchro
*/
function calculGain($pEnd,$pCalcul,$pResource, $pMax){
  if($pEnd !== null){
    $currentTime = time();
    $secDiff = $currentTime - $pEnd + 1;

    if($secDiff > 0) {
      if($pCalcul > 0) {
        $newResource = $pResource + ($pCalcul * $secDiff);
        if($newResource > $pMax) $newResource = $pMax;
      }

      $end = $pEnd + $secDiff;
      return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($newResource),"max" => $pMax, "end" => $end);
    }
  }


  return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($pResource),"max" => $pMax, "end" => $pEnd);
}

/**
*calcul how mutch building have product with a boost
*@param $pEnd date for increase by one
*@param $pCalcul calcul for know how mutch we increase with one update
*@param $pResource number of resource building had
*@param $pMax max of resource building can had
*@param $pEndBoost date of end of the boost
*@param $pGainBoost how much boost give resources with one update
*@return an object contained many information to send at client for synchro
*/
function calculGainWithBoost($pEnd,$pCalcul,$pResource, $pMax,$pEndBoost,$pGainBoost){
  $currentTime = time();
  $secDiff = $currentTime - $pEnd + 1;
  if($secDiff > 0) {
    $newResource = $pResource + $secDiff * ($pCalcul + $pGainBoost);
    if($newResource > $pMax) $newResource = $pMax;
    $end = $pEnd + $secDiff;

    return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($newResource),"max" => $pMax, "end" => $end);
  }

  return (object) array("error" => false,IDCLIENT => Utils::getSinglePostValue(IDCLIENT), "nbResource" => round($pResource),"max" => $pMax, "end" => $pEnd);
}
?>
