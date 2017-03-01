<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Resources as Resources;
use actions\utils\GeneratorType as GeneratorType;
use actions\utils\Experience as Experience;
//
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Resources.php");
include_once("utils/GeneratorType.php");
include_once("utils/Experience.php");

//

$lId = FacebookUtils::getId();
$FtueProgress = Utils::getSinglePostValue("FtueProgress");
Utils::updateSetWhere('Player', ['FtueProgress' => $FtueProgress], 'ID = '.$lId);

switch ($FtueProgress) {
	case 4:{
		echo GeneratorType::soft;
		Resources::additionResources($lId, GeneratorType::soft, 160);
		break;
	}
	case 9:
		Resources::additionResources($lId, GeneratorType::hard, 100);
		break;
	case 11:
		Experience::gaignGoodXp(100);
		break;
	case 23:
		Experience::gaignBadXp(300);
		break;
	default:
		break;
}

?>