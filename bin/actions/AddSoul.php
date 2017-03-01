<?php
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Regions as Regions;
use actions\utils\Resources as Resources;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Utils as Utils;

include_once("utils/FacebookUtils.php");
include_once("utils/Regions.php");
include_once("utils/Resources.php");
include_once("utils/BuildingUtils.php");
include_once("utils/Utils.php");

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

Utils::updateSetWhere(TABLE, [NBRESOURCES => ($typeBuilding->NbResource + 1)],'ID = '.$typeBuilding->ID);
?>
