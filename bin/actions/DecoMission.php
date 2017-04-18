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
$DecoMission = Utils::getSinglePostValue("DecoMission");
echo json_encode($lId);
echo json_encode($DecoMission);

Utils::updateSetWhere('Player', ['DecoMission' => $DecoMission], 'ID = '.$lId);

if($DecoMission == 3){
	Experience::gaignBadXp(600);
	Experience::gaignGoodXp(600);
}

?>
