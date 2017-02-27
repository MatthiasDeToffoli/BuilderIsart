<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

$newDate = time();

Utils::updateSetWhere('Player', ['DateLastConnexion'=> Utils::timeStampToDateTime($newDate)], 'ID ='.FacebookUtils::getID());
?>