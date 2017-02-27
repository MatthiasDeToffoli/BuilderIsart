<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
//
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

//

$lId = FacebookUtils::getId();
Utils::updateSetWhere('Player', ['DecoMission' => Utils::getSinglePostValue("DecoMission")], 'ID = '.$lId);

?>