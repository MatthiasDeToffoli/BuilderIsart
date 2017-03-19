<?php
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Regions as Regions;

/**
* @author: de Toffoli Matthias
* load all region to current player
*/

include("utils/Regions.php");
include_once("utils/FacebookUtils.php");

echo json_encode(Regions::getAllRegion(FacebookUtils::getId()));

?>
