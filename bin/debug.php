<?php
/**
 * User: RABIERAmbroise
 * Date: 25/02/2017
 * Time: 11:15
 */

$db = getDataBase();

function getDataBase () {
    include("databaseInfo.php");

    // database connexion
    try {
        return new PDO(
            "mysql:host=".$host.";dbname=".$dbName,
            $user,
            $pass,
            array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8")
        );
    }
    catch (Exception $e) {
        echo $e->getMessage();
        exit;
    }
}

// put here what you want to test :)
// then in cmd or git bash use php -a <fileName>
// enjoy

use actions\utils\Utils as Utils;
include_once("actions/utils/Utils.php");
//echo json_encode(\actions\utils\Resources::getResources(4));
//include_once("actions/utils/BuildingCommonCode.php");
//echo json_encode(\actions\BuildingCommonCode::getBuildingWhitPosition(4,3,8,1,0));
//echo json_encode(Utils::getTable("LevelReward","ID = 2"));
/*
function getTypeBuildingWithId($BuildingId, $pPlayerID)
{
    global $db;

    $req = "SELECT * FROM Building JOIN TypeBuilding ON TypeBuilding.id = Building.IDTypeBuilding WHERE IDPlayer= :PID AND IDTypeBuilding = :ID";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':ID', $BuildingId);
    $reqPre->bindParam(':PID', $pPlayerID);

    try {
        $reqPre->execute();
        //return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
        echo $e->getMessage();
        exit;
    }

    while($row = $reqPre->fetch(\PDO::FETCH_OBJ))
    {
        $result[] = $row;
    }
    return $result;
}
echo count(getTypeBuildingWithId(9,114));
echo json_encode(getTypeBuildingWithId(9,114));*/

function getTypeBuildingWithPosition($posX,$posY,$regionX,$regionY)
{
    global $db;
    $player = 114;
    $req = "SELECT * FROM `TypeBuilding` JOIN Building ON Building.IDTypeBuilding = TypeBuilding.ID WHERE Building.IDPlayer = :PID AND Building.X = :X AND Building.Y = :Y AND Building.RegionX = :RX AND Building.RegionY = :RY";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':X', $posX);
    $reqPre->bindParam(':Y', $posY);
    $reqPre->bindParam(':RX', $regionX);
    $reqPre->bindParam(':RY', $regionY);
    $reqPre->bindParam(':PID', $player);

    try {
        $reqPre->execute();
        return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
        echo $e->getMessage();
        exit;
    }
}
$test = getTypeBuildingWithPosition(0,5,0,0);
var_dump($test->ID);
var_dump($test->NbSoul);
var_dump($test->LevelUnlocked);
var_dump($test->IDTypeBuilding);
//echo json_encode(getTypeBuildingWithPosition(0,5,0,0));