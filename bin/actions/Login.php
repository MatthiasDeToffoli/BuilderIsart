<?php
/**
 * User: Vicktor Grenu
 */

include("vendor/autoload.php");

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

// __________________________________

// return json format
$returnSize = 5;
$retour = array();

// request to check if player is already in the database
$req = "SELECT * FROM Player WHERE IDFacebook = :playerId";
$reqPre = $db->prepare($req);
$reqPre->bindParam(':playerId', $fbId);

try {
    $reqPre->execute();
    $res = $reqPre->fetch(); // PDO::FETCH_ASSOC

    // if player is in db -> return profil info
    if (!empty($res)) {
        for ($i=0; $i < $returnSize; $i++) {
            $retour[$i] = $res[$i];
        }
    }
    // else -> put it in db
    else {
        $reqInsertion = "INSERT INTO Player(IDFacebook, DateInscription, DateLastConnexion, email) VALUES (:idFB, NOW(), NOW(), 'monmail')";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':idFB', $fbId);
        try {
            $reqInsPre->execute();
            //$res = $reqInsPre->fetch(PDO::FETCH_ASSOC); inutile ?
        } catch (Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }
} catch (Exception $e) {
    echo $e->getMessage();
    exit;
}

if (isset($accessToken)) {
    echo json_encode($retour);
}

