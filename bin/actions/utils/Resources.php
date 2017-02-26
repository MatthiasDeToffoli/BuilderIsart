<?php

namespace actions\utils;

use PDO as PDO;
use actions\utils\Utils as Utils;

include_once("Utils.php");

/**
 * @author: de Toffoli Matthias
 * Include this when you want to use the table Resources
 */
class Resources
{
    const TABLE_RESOURCES = "Resources";

    /**
     * Create a new resources
     * @param $pId the player Id
     * @param $Type the type of resources we want to create
     * @param $startNumber the quantity we want for initialize the resources
     */
    public static function createResources($pId, $Type, $startNumber)
    {

        global $db;

        $reqInsertion = "INSERT INTO Resources (IDPlayer, Type, Quantity) VALUES (:id,:type,:num)";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':id', $pId);
        $reqInsPre->bindParam(':type', $Type);
        $reqInsPre->bindParam(':num', $startNumber);
        try {
            $reqInsPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();

            exit;
        }
    }


    /**
     * update a resources value
     * @param $pId the player Id
     * @param $Type the type of resources we want update
     * @param $newQuantity the quantity that resources have to take
     */
    public static function updateResources($pId, $Type, $newQuantity)
    {
        global $db;
      
        $reqInsertion = "UPDATE Resources SET Quantity=:num WHERE IDPlayer = :id AND Type = :type";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':id', $pId);
        $reqInsPre->bindParam(':type', $Type);
        $reqInsPre->bindParam(':num', $newQuantity);
        try {
            $reqInsPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();

            exit;
        }

    }

    /**
     * addition a resources value
     * @param $pId the player Id
     * @param $Type the type of resources we want update
     * @param $newQuantity the quantity that resources have to add
     */
    public static function additionResources($pId, $Type, $newQuantity)
    {
        global $db;

        $reqInsertion = "UPDATE Resources SET Quantity= Quantity + :num WHERE IDPlayer = :id AND Type = :type";
        $reqInsPre = $db->prepare($reqInsertion);
        $reqInsPre->bindParam(':id', $pId);
        $reqInsPre->bindParam(':type', $Type);
        $reqInsPre->bindParam(':num', $newQuantity);
        try {
            $reqInsPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();

            exit;
        }

    }

    /**
     * give a resources
     * @param $pId the player Id
     * @param $pType the type of resources we want
     * @return the resources wanted
     */
    public static function getResource($pId, $pType)
    {
        global $db;

        $req = "SELECT Quantity FROM Resources WHERE IDPlayer = :id AND Type = :type";
        $reqPre = $db->prepare($req);
        $reqPre->bindParam(':id', $pId);
        $reqPre->bindParam(':type', $pType);

        try {
            $reqPre->execute();
            return $reqPre->fetch(PDO::FETCH_OBJ);
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }

    /**
     * @param $pId
     * @return array
     * @author : Ambroise
     */
    public static function getResources ($pId) {
        global $db;

        $result = [];
        $req = "SELECT Type, Quantity FROM ".static::TABLE_RESOURCES." WHERE IDPlayer=".strval($pId);
        $reqPre = $db->prepare($req);

        try {
            $reqPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }

        // [{"soft":"20000"},{"hard":"0"}] if FETCH_KEY_PAIR
        // [{"Type":"soft","Quantity":"20000"},{"Type":"hard","Quantity":"0"}] if FETCH_ASSOC
        while($row = $reqPre->fetch(\PDO::FETCH_KEY_PAIR))
        {
            $result[] = $row;
        }

        // {"soft":"20000","hard":"0"}
        $test = call_user_func_array('array_merge', $result);

        return $test;
    }

}

?>
