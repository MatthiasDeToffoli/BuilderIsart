<?php
/**
* @author: de Toffoli Matthias
* @author: Grenu Victor
* Include this when you want to use facebook
*/

  /**
	 * give the token delivery by FaceBook
	 * @return a string reprensenting the token
	 */
function getToken(){
  include("../../vendor/autoload.php");

  // app id number
  $fb = new Facebook\Facebook([
      'app_id' => '1764871347166484',
      'app_secret' => '2dac14b3b3d872006edf73eccc301847',
      'default_graph_version' => 'v2.8'
  ]);

  $helper = $fb->getJavaScriptHelper();

  try {
      $token = $helper->getAccessToken();
  } catch (Facebook\Exceptions\FacebookResponseException $e) {
      echo 'Graph returned an error : ' . $e->getMessage();
      exit;
  } catch (Facebook\Exceptions\FacebookSDKException $e) {
      echo 'Facebook SDK returned an error : ' . $e->getMessage();
      exit;
  }

   return $token;
}

/**
 * give the Facebook id
 * @return th e Facebook id
 */
function getFacebookId(){
  include("../../vendor/autoload.php");

  // app id number
  $fb = new Facebook\Facebook([
      'app_id' => '1764871347166484',
      'app_secret' => '2dac14b3b3d872006edf73eccc301847',
      'default_graph_version' => 'v2.8'
  ]);

  $helper = $fb->getJavaScriptHelper();

  return $helper->getUserId();
}

/**
 * give the Player Id find with facebook Id
 * @return the player Id
 */
function getId(){
  global $db;

  $req = "SELECT ID FROM Player WHERE IDFacebook = :FbId";
  $reqPre = $db->prepare($req);
  $reqPre->bindParam(':FbId', getFacebookId());

  try {
    $reqPre->execute();
    return $res = $reqPre->fetch()[0];
  } catch (Exception $e) {
    echo $e->getMessage();
    exit;
  }

}


 ?>
