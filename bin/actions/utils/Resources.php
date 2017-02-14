<?php

namespace actions\utils;

/**
* @author: de Toffoli Matthias
* Include this when you want to use the table Resources
*/
class Resources {

  /**
   * Create a new resources
   * @param $pId the player Id
   * @param $Type the type of resources we want to create
   * @param $startNumber the quantity we want for initialize the resources
   */
  public static function createResources($pId, $Type, $startNumber){

    global $db;

    $reqInsertion = "INSERT INTO Resources (IDPlayer, Type, Quantity) VALUES (:id,:type,:num)";
    $reqInsPre = $db->prepare($reqInsertion);
    $reqInsPre->bindParam(':id', $pId);
    $reqInsPre->bindParam(':type', $Type);
    $reqInsPre->bindParam(':num', $startNumber);
    try {
        $reqInsPre->execute();
    } catch (Exception $e) {
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
  public static function updateResources($pId, $Type, $newQuantity){
    global $db;

    $reqInsertion = "UPDATE Resources SET Quantity=:num WHERE IDPlayer = :id AND Type = :type";
    $reqInsPre = $db->prepare($reqInsertion);
    $reqInsPre->bindParam(':id', $pId);
    $reqInsPre->bindParam(':type', $Type);
    $reqInsPre->bindParam(':num', $newQuantity);
    try {
        $reqInsPre->execute();
    } catch (Exception $e) {
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
  public static function getResource($pId, $pType){
    global $db;

    $req = "SELECT Quantity FROM Resources WHERE IDPlayer = :id AND Type = :type";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':id', $pId);
    $reqPre->bindParam(':type', $pType);

    try {
        $reqPre->execute();
        return $reqPre->fetch()[0];
    } catch (Exception $e) {
        echo $e->getMessage();

        exit;
    }
  }
}
 ?>
