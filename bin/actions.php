<?php
/**
 * User: Vicktor Grenu
 */

header('Content-Type: application/json');
date_default_timezone_set("UTC");

session_start(); // todo : included in all php file ??

// todo : activer lros de release
// error_reporting(0);

$db = getDataBase();

function getDataBase () {
    include("databaseInfo.php");

    // database connexion
    try {
        return new PDO("mysql:host=".$host.";dbname=".$dbName, $user, $pass);
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

//d'abord je vire les / du GET pour éviter une faille de sécurité
$action = str_replace("/", "", $_POST[KEY_POST_FILE_NAME]);

//ensuite je vérifie que le fichier existe
if(file_exists(PHP_DIRECTORY.$_POST[KEY_POST_FILE_NAME].PHP_EXTENSION));
    include(PHP_DIRECTORY.$_POST[KEY_POST_FILE_NAME].PHP_EXTENSION);

