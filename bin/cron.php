<?php
/**
 * User: RABIERAmbroise
 * Date: 24/02/2017
 * Time: 19:58
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

function updateSetWhere () {
    global $db;

    $req = "INSERT INTO `perle_gold`.`Logs` (`ID`, `IDPlayer`, `Date`, `Module`, `Status`, `Message`, `Data`) VALUES (NULL, '666', CURRENT_TIMESTAMP, '666 cron.php', 'Error', '666', '666')";
    $reqPre = $db->prepare($req);


    try {
        $reqPre->execute();
    } catch (\Exception $e) {
        echo $e->getMessage();
        exit;
    }
}
updateSetWhere();

include_once("actions/JsonCreator2.php");