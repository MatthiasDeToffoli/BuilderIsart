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

	public static function doAction() {
		$infos = static::getInfo();
		
		switch ($infos[static::FUNCTION_CALL]) {
			case "ADD": static::buyIntern($infos[static::ID_INTERN]); break;
			case "REM": static::removeIntern($infos[static::ID_INTERN]); break;
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
			exit;
		}
		catch (Exception $e) {
			echo $e->getMessage();
		}
	}
	
	public static function removeIntern($idIntern) {
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
	
	public static function validIntern($ID, $idIntern) {
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
	
	public static function getInternPrice($idIntern) {
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

	public static function validIdIntern($idIntern) {
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
	
	public static function getInfo() {
		return [
			static::FUNCTION_CALL => Utils::getSinglePostValue(static::FUNCTION_CALL),
            static::ID_INTERN => Utils::getSinglePostValueInt(static::ID_INTERN)
        ];
	}
}

Interns::doAction();

?>