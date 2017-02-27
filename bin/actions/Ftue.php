<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
//
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

//

$lId = FacebookUtils::getId();
Utils::updateSetWhere('Player', ['FtueProgress' => Utils::getSinglePostValue("FtueProgress")], 'ID = '.$lId);

?>