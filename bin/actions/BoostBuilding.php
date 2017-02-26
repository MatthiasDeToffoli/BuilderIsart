<?php

namespace actions\utils;

use PDO as PDO;
use DateTime as DateTime;
use actions\utils\Resources;
use actions\utils\Send as Send;
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("utils/Resources.php");
include_once("utils/FacebookUtils.php");

class BoostBuilding {

	const VALID_BOOST = "done";
	const HARD = "hard";
	const START_CONSTRUCTION = "StartConstruction";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";
	
	const PROGRESS = "progress";
	const END_TIME = "endTime";

	public static function doAction() {
		$infos = static::getInfo();
		static::boostBuilding($infos);
	}
	
	private static function boostBuilding($infos) {
		global $db;
		
		$ID = FacebookUtils::getId();
		
		$price = static::getHardPrice($infos, $ID);
		
		$hard = $gold = Resources::getResources($ID);
		
		if ($price > $hard[static::HARD]) {
			echo json_encode(
				array (
					"errorID" => Send::BUILDING_NOT_ENOUGHT_HARD
				)
			);
			exit;
		}
		
		try {
			$req = "SELECT StartConstruction FROM Building WHERE IDPlayer = ".$ID." AND RegionX = ".$infos[static::REGION_X]." AND RegionY = ".$infos[static::REGION_Y]." AND X = ".$infos[static::X]." AND Y = ".$infos[static::Y];
			$reqPre = $db->prepare($req);
			$reqPre-> execute();
			$res = $reqPre->fetch(PDO::FETCH_ASSOC);
			
			$req2 = "UPDATE Building SET EndConstruction = '".$res[static::START_CONSTRUCTION]."' WHERE IDPlayer = ".$ID." AND RegionX = ".$infos[static::REGION_X]." AND RegionY = ".$infos[static::REGION_Y]." AND X = ".$infos[static::X]." AND Y = ".$infos[static::Y];
			$reqPre2 = $db->prepare($req2);
			$reqPre2-> execute();
			
			Resources::updateResources(
                $ID,
                static::HARD,
                $hard[static::HARD] - $price
            );
			
			echo static::VALID_BOOST;
			exit;
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function getHardprice($infos, $ID) {
		global $db;
	
		try {
			$hardPrice = ceil(($infos[static::END_TIME] - $infos[static::PROGRESS]) / 300000);
			return $hardPrice;
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function getInfo() {
		return [
            static::REGION_X => Utils::getSinglePostValueInt(static::REGION_X),
            static::REGION_Y => Utils::getSinglePostValueInt(static::REGION_Y),
            static::X => Utils::getSinglePostValueInt(static::X),
            static::Y => Utils::getSinglePostValueInt(static::Y),
            static::PROGRESS => Utils::getSinglePostValue(static::PROGRESS),
            static::END_TIME => Utils::getSinglePostValue(static::END_TIME)
        ];
	}

}

BoostBuilding::doAction();

?>