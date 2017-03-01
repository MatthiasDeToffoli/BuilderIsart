<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Experience as Experience;
//
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Experience.php");
//

$lId = FacebookUtils::getId();


Experience::gaignGoodXp(Utils::getSinglePostValue("goodXp"));
Experience::gaignBadXp(Utils::getSinglePostValue("badXp"));

?>