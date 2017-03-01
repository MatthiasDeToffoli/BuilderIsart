<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Resources as Resources;
use actions\utils\GeneratorType as GeneratorType;
use actions\utils\Player as Player;
//
include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Resources.php");
include_once("utils/GeneratorType.php");
include_once("utils/Player.php");
//

$lId = FacebookUtils::getId();
$player = Player::getPlayerById($lId);
$table = Utils::getTable("LevelReward","ID = ".$player->Level);

Resources::additionResources('ID = '.$lId, GeneratorType::soft, $table["Gold"]);
Resources::additionResources('ID = '.$lId, GeneratorType::resourcesFromHell, $table["Iron"]);
Resources::additionResources('ID = '.$lId, GeneratorType::resourcesFromHeaven, $table["Wood"]);

?>