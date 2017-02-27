<?php

namespace actions\utils;

use PDO as PDO;
use actions\utils\Resources;
use actions\utils\Send as Send;
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("utils/Resources.php");
include_once("utils/FacebookUtils.php");

class Choices {

	const FUNCTION_CALL = "funct";
	const REWARD = "reward";
	
	const REWARD_KARMA = "karma";
	const REWARD_IRON = "iron";
	const REWARD_WOOD = "wood";
	const REWARD_GOLD = "gold";
	const REWARD_BAD_XP = "badXP";
	const REWARD_GOOD_XP = "goodXP";
	
	const SOFT = "soft";
	const HARD = "hard";
	const IRON = "resourcesFromHell";
	const WOOD = "resourcesFromHeaven";
	const BAD_XP = "badXp";
	const GOOD_XP = "goodXP";

	public static function doAction() {
		$infos = static::getInfos();
		
		switch ($infos[static::FUNCTION_CALL]) {
			case "APPLY_REWARD": static::applyReward($infos[static::REWARD]); break;
			default: echo "No choosen action";
		}
	}
	
	private static function applyReward($infoReward) {
		global $db;
		
		$ID = FacebookUtils::getId();
		$wallet = Resources::getResources($ID);
		
		Resources::updateResources(
            $ID,
            static::SOFT,
            $wallet[static::SOFT] + $infoReward[static::REWARD_GOLD]
        );
		
		Resources::updateResources(
            $ID,
            static::HARD,
            $wallet[static::HARD] + $infoReward[static::REWARD_KARMA]
        );
		
		Resources::updateResources(
            $ID,
            static::IRON,
            $wallet[static::IRON] + $infoReward[static::REWARD_IRON]
        );
		
		Resources::updateResources(
            $ID,
            static::WOOD,
            $wallet[static::WOOD] + $infoReward[static::REWARD_WOOD]
        );
		
		Resources::updateResources(
            $ID,
            static::BAD_XP,
            $wallet[static::BAD_XP] + $infoReward[static::REWARD_BAD_XP]
        );
		
		Resources::updateResources(
            $ID,
            static::GOOD_XP,
            $wallet[static::GOOD_XP] + $infoReward[static::REWARD_GOOD_XP]
        );
	}
	
	private static function getInfos() {
		return [
			static::FUNCTION_CALL => str_replace("/", "", $_POST[static::FUNCTION_CALL]),
			static::REWARD => [
				static::REWARD_KARMA => $_POST[static::REWARD_KARMA],
				static::REWARD_IRON => $_POST[static::REWARD_IRON],
				static::REWARD_WOOD => $_POST[static::REWARD_WOOD],
				static::REWARD_GOLD => $_POST[static::REWARD_GOLD],
				static::REWARD_BAD_XP => $_POST[static::REWARD_BAD_XP],
				static::REWARD_GOOD_XP => $_POST[static::REWARD_GOOD_XP]
			]
		];
	}

}

Choices::doAction();

?>