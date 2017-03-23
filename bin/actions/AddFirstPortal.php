<?php
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\ValidAddBuilding as ValidAddBuilding;
use actions\utils\Utils as Utils;

/**
* Add first portal for FTUE
* @author de Toffoli Matthias
*/

include_once("ValidAddBuilding.php");
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");

const ID_PLAYER = "IDPlayer";
const REGION_X = "RegionX";
const REGION_Y = "RegionY";
const X = "X";
const Y = "Y";
const ID_CLIENT_BUILDING = "IDClientBuilding";

const REGION_X = "RegionX";
const REGION_Y = "RegionY";
const X = "X";
const Y = "Y";
const PORTAL_NAME = 'Intern Building Hell';

$lInfo = getInfo();

if(count(BuildingUtils::getAllBuildingByName(PORTAL_NAME))>0) {
  echo json_encode(['error' => true, 'message' => 'a hell portal always on your game cheater', ID_CLIENT_BUILDING => $lInfo[ID_CLIENT_BUILDING]]);
  exit;
}


$lConfig = Utils::getTableRowByID('TypeBuilding', BuildingUtils::getTypeBuilding(PORTAL_NAME,1)->ID);

ValidAddBuilding::canBuildForFTUE($lInfo,$lConfig);
BuildingUtils::addToDatabase($lInfo,$lConfig['ID']);
echo json_encode(['error' => false]);

function getInfo () {
    return [
        ID_CLIENT_BUILDING => Utils::getSinglePostValueInt(ID_CLIENT_BUILDING),
        ID_PLAYER => FacebookUtils::getId(),
        REGION_X => Utils::getSinglePostValueInt(REGION_X),
        REGION_Y => Utils::getSinglePostValueInt(REGION_Y),
        X => Utils::getSinglePostValueInt(X),
        Y => Utils::getSinglePostValueInt(Y),
    ];
}
?>
