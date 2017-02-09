<?php
/**
 * User: Vicktor Grenu
 * User: Ambroise Rabier
 */

header('Content-Type: application/json;');
date_default_timezone_set("UTC");

session_start(); // todo : included in all php file ??

// todo : activer lors de la release
// error_reporting(0);

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

define("KEY_POST_FILE_NAME", "module"); // fileName
define("KEY_POST_FUNCTION_NAME", "action"); // used whit a switch or associative array
define("PHP_EXTENSION", ".php");
define("PHP_DIRECTORY", "/actions/");

$action = str_replace("/", "", $_POST[KEY_POST_FILE_NAME]);

// ensuite je vérifie que le fichier existe
if(file_exists(PHP_DIRECTORY.$action.PHP_EXTENSION));
    include(PHP_DIRECTORY.$action.PHP_EXTENSION);

?>
