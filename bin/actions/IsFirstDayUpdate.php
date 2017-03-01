<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

Utils::updateSetWhere('Player', ['IsFirstDay' => 0], 'ID ='.FacebookUtils::getID());
echo "updated";
?>