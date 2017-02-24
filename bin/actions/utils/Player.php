<?php
namespace actions\utils;

use actions\utils\Utils as Utils;
include_once("Utils.php");

/**
* @author: de Toffoli Matthias
* Include this when you want to use the table Player
*/
class Player
{

  const TABLE = 'Player';
  const ID = 'ID';
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

  public static function getPlayerById($pId) {
    global $db;

    $req = "SELECT * FROM ".static::TABLE."  WHERE ".static::ID." = :Id";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':Id', $pId);

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  public static function update($pId,$pAssocArray) {
    Utils::updateSetWhere(static::TABLE,$pAssocArray,'ID = '.$pId);
  }
}


?>
