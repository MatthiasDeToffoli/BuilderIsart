<?php
/**
 * @author: de Toffoli Matthias
 * @author: Grenu Victor
 * Include this when you want to use facebook
 */
namespace actions\utils;

use Facebook;

include_once("vendor/autoload.php");

/**
 * give the token delivery by FaceBook
 * @return a string reprensenting the token
 */
class FacebookUtils
{


    public static function getToken()
    {

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
    public static function getFacebookId()
    {

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
    public static function getId()
    {
        global $db;

        $req = "SELECT ID FROM Player WHERE IDFacebook = :FbId";
        $reqPre = $db->prepare($req);
        $fbId = FacebookUtils::getFacebookId();
        $reqPre->bindParam(':FbId', $fbId);

        try {
            $reqPre->execute();
            $res = $reqPre->fetch()[0];
            if (isset($res))
                return $res;
            else
                return static::getIDNoFB();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }

    }

    private static function getIDNoFB () {
        $PWD = "com_isartdigital_perle_passwordNoFB";

        global $db;
        //echo json_encode($_COOKIE[$PWD]);
        $req = "SELECT ID FROM Player WHERE PasswordNoFB = :passwordNoFB";
        $reqPre = $db->prepare($req);
        $reqPre->bindParam(':passwordNoFB', str_replace("/", "", $_COOKIE[$PWD]));

        try {
            $reqPre->execute();
            $res = $reqPre->fetch()[0];
            return $res;
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }
//700021a1ad0bfeaa101fdf37618a4f22
//f28
}


?>
