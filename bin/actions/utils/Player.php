<?php
namespace actions\utils;
/**
* @author: de Toffoli Matthias
* Include this when you want to use the table Player
*/
class Player
{
  /**
   * give the number of a type of region the player has
   * @param $pId the player id
   * @param $Type the type of region we want
   * @return number of a type of region
   */
  public static function getRegionQuantity($pId,$Type){
    global $db;

    if($Type == "hell") $req = "SELECT NumberRegionHell FROM Player WHERE ID = :id";
    else $req = "SELECT NumberRegionHeaven FROM Player WHERE ID = :id";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':id', $pId);

    try {
      $reqPre->execute();
      return $reqPre->fetch()[0];
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  /**
   * set the number of a type of region the player has
   * @param $pId the player id
   * @param $Type the type of region we want
   * @param $quantity the quantity we want to set
   */
  public static function setRegionQuantity($pId, $Type, $quantity){
    global $db;

    if($Type == "hell") $req = "UPDATE Player SET NumberRegionHell = :num WHERE ID = :id";
    else $req = "UPDATE Player SET NumberRegionHeaven = :num WHERE ID = :id";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':id', $pId);
    $reqPre->bindParam(':num', $quantity);

    try {
      $reqPre->execute();
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }
}


?>
