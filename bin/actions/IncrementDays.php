<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Player as Player;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Player.php");

$ID = FacebookUtils::getID();

$player = Player::getPlayerById($ID);

$days = $player->DaysOfConnexion;
$days += 1;

if($days > 7)$days = 1;

Utils::updateSetWhere('Player', ['DaysOfConnexion'=> $days], 'ID ='.$ID);
?>