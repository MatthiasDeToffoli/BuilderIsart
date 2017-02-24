<?php
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/BuildingUtils.php");
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

Utils::updateSetWhere('Player', [
  'NumberMarketigHouse' => count(BuildingUtils::getAllBuildingByName('Marketing Department'))
], 'ID = '.FacebookUtils::getId());


?>
