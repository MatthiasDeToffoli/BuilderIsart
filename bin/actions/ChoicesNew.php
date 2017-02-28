<?php

namespace actions\utils;

use PDO as PDO;
use actions\utils\Resources;
use actions\utils\Send as Send;
use actions\utils\Utils as Utils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("utils/Resources.php");
include_once("utils/FacebookUtils.php");
include_once("utils/BuildingUtils.php");


class Choices {

	const MAX_SOUL_CONTAINED = "MaxSoulsContained";
	const FUNCTION_CALL = "funct";
	const REWARD = "reward";
	
	const REWARD_KARMA = "karma";
	const REWARD_IRON = "iron";
	const REWARD_WOOD = "wood";
	const REWARD_GOLD = "gold";
	const REWARD_BAD_XP = "badXP";
	const REWARD_GOOD_XP = "goodXP";
	const REWARD_SOUL = "soul";
	
	const SOFT = "soft";
	const HARD = "hard";
	const IRON = "resourcesFromHell";
	const WOOD = "resourcesFromHeaven";
	const BAD_XP = "badXp";
	const GOOD_XP = "goodXP";
	
	const TRIB_X = "tribuX";
	const TRIB_Y = "tribuY";
	const TRIB_REGION_X = "tribuRegionX";
	const TRIB_REGION_Y = "tribuRegionY";

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
		
		
		if ($infoReward[static::REWARD_SOUL] == 0) die("No gain souls"); 
		$tribunalType = BuildingUtils:: getTypeBuildingWithPosition($infoReward[static::TRIB_X], $infoReward[static::TRIB_Y], $infoReward[static::TRIB_REGION_X], $infoReward[static::TRIB_REGION_Y]);
		$tribunal = BuildingUtils::getAllBuildingByName($tribunalType->Name);
		
		$newNeutralSoul = $tribunal[0]->NbResource + $infoReward[static::REWARD_SOUL];
		
		if ($newNeutralSoul <= $tribunalType->MaxSoulsContained) {
			try {
				$req = "UPDATE Building SET NbResource = ".$newNeutralSoul." WHERE X = ".$infoReward[static::TRIB_X]." AND Y = ".$infoReward[static::TRIB_Y]." AND RegionX = ".$infoReward[static::TRIB_REGION_X]." AND RegionY = ".$infoReward[static::TRIB_REGION_Y];
				$reqPre = $db->prepare($req);
				$reqPre-> execute();
				exit;
			}
			catch (Exception $e) {
				echo $e->getMessage();
			}
		}
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
				static::REWARD_GOOD_XP => $_POST[static::REWARD_GOOD_XP],
				static::REWARD_SOUL => $_POST[static::REWARD_SOUL],
				static::TRIB_X => $_POST[static::TRIB_X],
				static::TRIB_Y => $_POST[static::TRIB_Y],
				static::TRIB_REGION_X => $_POST[static::TRIB_REGION_X],
				static::TRIB_REGION_Y => $_POST[static::TRIB_REGION_Y]
			]
		];
	}

}

Choices::doAction();

?>