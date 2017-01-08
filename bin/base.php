<?php
/**
 * User: Vicktor Grenu
 */


header('Content-Type: application/json');
date_default_timezone_set("UTC");

session_start(); // todo : included in all php file ??

include("/vendor/autoload.php");
include("mdp.php");

// todo : activer lros de release
// error_reporting(0);


// database connexion
try {
  $db = new PDO("mysql:host=localhost;dbname=perle_alpha", $user, $mdp);
}
catch (Exception $e) {
  echo $e->getMessage();
  exit;
}

// app id number
$fb = new Facebook\Facebook([
    'app_id' => '1764871347166484',
    'app_secret' => '2dac14b3b3d872006edf73eccc301847',
    'default_graph_version' => 'v2.8'
]);

$helper = $fb->getJavaScriptHelper();

try {
  $accessToken = $helper->getAccessToken();
} catch (Facebook\Exceptions\FacebookResponseException $e) {
  echo 'Graph returned an error : ' . $e->getMessage();
  exit;
} catch (Facebook\Exceptions\FacebookSDKException $e) {
  echo 'Facebook SDK returned an error : ' . $e->getMessage();
  exit;
}

$fbId = $helper->getUserId();

