<?php
/**
 * Created by PhpStorm.
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

include_once("actions/JsonCreator.php");