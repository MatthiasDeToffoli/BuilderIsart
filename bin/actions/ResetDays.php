<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

Utils::updateSetWhere('Player', ['DaysOfConnexion'=> 1], 'ID ='.FacebookUtils::getID());
?>