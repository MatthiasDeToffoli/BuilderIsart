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

class Quests {

	const SOFT = "soft";
	const HARD = "hard";

	const FUNCTION_CALL = "funct";
	const ID_INTERN = "idInt";
	const STEP_INDEX = "stepIndex";	
	const STEP1 = "step1";
	const STEP2 = "step2";
	const STEP3 = "step3";
	const BOOST = "boost";
	const PRICE = "price";

	public static function doAction() {
		$infos = static::getInfo();
		
		switch ($infos[static::FUNCTION_CALL]) {
			case "ADD": static::addQuest($infos[static::ID_INTERN], $infos[static::STEP1], $infos[static::STEP2], $infos[static::STEP3], $infos[static::PRICE]); break;
			default: echo "No choosen action";
		}
	}
	
	private static function addQuest($idIntern, $step1, $step2, $step3, $price) {
		global $db;
		
		$ID = FacebookUtils::getId();
		$creation = new \DateTime('NOW');
		$creation = $creation->format(Utils::DATETIME_FORMAT);
		
		$gold = Resources::getResources($ID);
			
		if ($price > $gold[static::SOFT]) {
			echo json_encode(
				array (
					"errorID" => Send::INTERN_NO_GOLD_FOR_QUEST,
					"idIntern" => $idIntern
				)
			);
			exit;
		}
		
		try {
			$req = "INSERT INTO TimeQuest(IDPlayer, IDIntern, StartTime, Step1, Step2, Step3, StepIndex, Boosted) VALUES (:playerId, :internRef, :creation, :step1, :step2, :step3, 0, false)";
			$reqPre = $db->prepare($req);
			
			$reqPre->bindParam(':playerId', $ID);
			$reqPre->bindParam(':internRef', $idIntern);
			$reqPre->bindParam(':creation', $creation);
			$reqPre->bindParam(':step1', $step1);
			$reqPre->bindParam(':step2', $step2);
			$reqPre->bindParam(':step3', $step3);
			
			$reqPre-> execute();
			
			Resources::updateResources(
				$ID,
				static::SOFT,
				$gold[static::SOFT] - $price
			);
			
			echo json_encode(
				array (
					"price" => $price,
					"idIntern" => $idIntern
				)
			);
			exit;
		} catch (Exception $e) {
			echo $e->getMessage();
			exit;
		}
	}

	private static function getInfo() {
		return [
			static::FUNCTION_CALL => str_replace("/", "", $_POST[static::FUNCTION_CALL]),
            static::ID_INTERN => $_POST[static::ID_INTERN],
			static::STEP_INDEX => $_POST[static::STEP_INDEX],
			static::STEP1 => $_POST[static::STEP1],
			static::STEP2 => $_POST[static::STEP2],
			static::STEP3 => $_POST[static::STEP3],
			static::BOOST => $_POST[static::BOOST],
			static::PRICE => $_POST[static::PRICE]
        ];
	}
	
}

Quests::doAction();

?>