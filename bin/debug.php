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

include_once("actions/utils/Resources.php");
echo json_encode(\actions\utils\Resources::getResources(5));