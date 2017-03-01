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
echo json_encode(Utils::getTable("LevelReward","ID = 2"));