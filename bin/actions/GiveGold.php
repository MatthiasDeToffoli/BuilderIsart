<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Resources as Resources;
use actions\utils\GeneratorType as GeneratorType;
//
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Resources.php");
include_once("utils/GeneratorType.php");
//

$lId = FacebookUtils::getId();
Resources::additionResources('ID = '.$lId, GeneratorType::soft, ['DecoMission' => Utils::getSinglePostValue("DecoMission")], 'ID = '.$lId);

?>