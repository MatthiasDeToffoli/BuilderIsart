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

class Interns {

	const INTERN_PRICE = "Price";

	const SOFT = "soft";

	const FUNCTION_CALL = "funct";
	const ID_INTERN = "idInt";
	const STRESS = "str";
	const ID_EVENT = "idEvent";

	public static function doAction() {
		$infos = static::getInfo();
		
		switch ($infos[static::FUNCTION_CALL]) {
			case "ADD": static::buyIntern($infos[static::ID_INTERN]); break;
			case "REM": static::removeIntern($infos[static::ID_INTERN]); break;
			case "UPDT": static::addStress($infos[static::ID_INTERN], $infos[static::STRESS]); break;
			case "UPDT_EVENT": static::updateEvent($infos[static::ID_INTERN], $infos[static::ID_EVENT]); break;
			case "GET_SPE_JSON": static::getJson(); break;
			default: echo "No choosen action";
		}
	}
		
	public static function buyIntern($idIntern) {
		global $db;
		
		$ID = FacebookUtils::getId();
		
		static::validIdIntern($idIntern);
		static::validIntern($ID, $idIntern);
		
		$gold = Resources::getResources($ID);
		$price = static::getInternPrice($idIntern);
		
		if ($price[static::INTERN_PRICE] > $gold[static::SOFT]) {
			echo json_encode(
				array (
					"errorID" => Send::INTERN_CANNOT_BUY,
					"idIntern" => $idIntern
				)
			);
			exit;
		}
		
		try {
			$req2 = "INSERT INTO PlayerInterns(IDPlayer, IDIntern, Stress, IdEvent) VALUES (".$ID.", ".$idIntern.", 0, 0)";
			$reqPre = $db->prepare($req2);
			$reqPre-> execute();
			
			Resources::updateResources(
                $ID,
                static::SOFT,
                $gold[static::SOFT] - $price[static::INTERN_PRICE]
            );
			
			echo $price[static::INTERN_PRICE];
			exit;
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function removeIntern($idIntern) {
		global $db;
		
		static::validIdIntern($idIntern);
		
		$ID = FacebookUtils::getId();
		$req = "DELETE FROM PlayerInterns WHERE IDPlayer = ".$ID." AND IDIntern = ".$idIntern;
		
		try {
			$reqPre = $db->prepare($req);
			$reqPre-> execute();
			
			echo intval($idIntern);
			exit;
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function addStress($idIntern, $stress) {
		global $db;
		
		static::validIdIntern($idIntern);
		
		$ID = FacebookUtils::getId();
		$req = "UPDATE PlayerInterns SET Stress = ".$stress." WHERE IDPlayer = ".$ID." AND IDIntern = ".$idIntern;

		try {
			$reqPre = $db->prepare($req);
			$reqPre-> execute();
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function updateEvent($idIntern, $idEvent) {
		global $db;
		$ID = FacebookUtils::getId();
		
		$req = "UPDATE PlayerInterns SET IdEvent = ".$idEvent." WHERE IDPlayer = ".$ID." AND IDIntern = ".$idIntern;
		
		try {
			$reqPre = $db->prepare($req);
			$reqPre->execute();
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function validIntern($ID, $idIntern) {
		global $db;
		
		try {
			$req = "SELECT * FROM PlayerInterns WHERE IDIntern = ".$idIntern." AND IDPlayer = ".$ID;
			$reqPre = $db->prepare($req);
			$reqPre-> execute();
			
			$res = $reqPre->fetchAll();
			if (isset($res[0])) {
				echo json_encode(
					array (
						"errorID" => Send::INTERN_ALREADY_BOUGHT,
						"idIntern" => $idIntern
					)
				);
				exit;
			}
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	private static function getInternPrice($idIntern) {
		global $db;
		
		try {
			$req = "SELECT Price FROM Interns WHERE ID = ".$idIntern;
			$reqPre = $db->prepare($req);
			$reqPre->execute();
			
			return $reqPre->fetch(PDO::FETCH_ASSOC);
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}

	private static function validIdIntern($idIntern) {
		if (!isset($idIntern)) {
			echo json_encode(
				array (
					"errorID" => Send::INTERN_INVALID_ID,
					"idIntern" => $idIntern
				)
			);
			exit;
		}
	}
	
	private static function getInfo() {
		return [
			static::FUNCTION_CALL => str_replace("/", "", $_POST[static::FUNCTION_CALL]),
            static::ID_INTERN => intval($_POST[static::ID_INTERN]),
			static::STRESS => intval($_POST[static::STRESS]),
			static::ID_EVENT => intval($_POST[static::ID_EVENT])
        ];
	}
	
	private static function getJson() {
		global $db;
		
		$i = 0;
		$ID = FacebookUtils::getId();
		$req = "SELECT * FROM Interns WHERE ID IN (SELECT IDIntern FROM PlayerInterns WHERE IDPlayer = ".$ID.")";
		$req2 = "SELECT IdEvent, Stress FROM PlayerInterns WHERE IDPlayer = ".$ID;
		
		try {
			$reqPre = $db->prepare($req);
			$reqPre->execute();
			$res = $reqPre->fetchAll();
			
			$reqPre2 = $db->prepare($req2);
			$reqPre2->execute();
			$res2 = $reqPre2->fetchAll();
			
			foreach ($res as $key => $value) {
				$retour[$i]["IdEvent"] = $res2[$i]["IdEvent"];
				$retour[$i]["Stress"] = $res2[$i]["Stress"];
				foreach ($value as $neededKey => $val) {
					$retour[$i][$neededKey] = $val;
				}
				$i++;
			}
			echo json_encode($retour);
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
}

Interns::doAction();

?>