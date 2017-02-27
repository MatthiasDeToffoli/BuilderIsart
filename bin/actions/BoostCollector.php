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


const REGIONX = 'RegionX';
const REGIONY = 'RegionY';
const X = 'X';
const Y = 'Y';
const NAME ='Name';
const MONEYTYPE = 'hard';
const CLIENTID = 'IDClientBuilding';

$lId = FacebookUtils::getId();

$typeBuilding = BuildingUtils::getTypeBuildingWithPosition(
  Utils::getSinglePostValue(X),
  Utils::getSinglePostValue(Y),
  Utils::getSinglePostValue(REGIONX),
  Utils::getSinglePostValue(REGIONY)
);

$resource = Resources::getResource($lId,MONEYTYPE);

$endTime = Utils::dateTimeToTimeStamp($typeBuilding->EndForNextProduction);
echo $typeBuilding->EndForNextProduction;
$price = ceil(($endTime - time())/300);
$rest = $resource->Quantity - $price;

if($rest < 0) {
  echo json_encode(['error' => true, 'message' => 'not enought money for payed this']);
  exit;
}

Resources::updateResources($lId,MONEYTYPE,$rest);

Utils::updateSetWhere('Building',
  [
    'EndForNextProduction' => Utils::timeStampToDateTime(time())
  ],
  'ID = '.$typeBuilding->ID.' AND IDPlayer = '.$lId
);
?>
