<?php
namespace actions\utils;

use PDO as PDO;
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("Utils.php");
include_once("FacebookUtils.php");

/**
* @author: de Toffoli Matthias
* include this if we want to use the table TypePack
*/

class PackUtils
{

  const TABLE = 'TypePack';
  const ID = 'ID';
  const NAME = 'Name';
  const KARMA = 'CostKarma';
  const GOLD = 'CostGold';

  public static function getPackById($pId) {
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

  public static function getPackByName($pName) {
    global $db;

    $req = "SELECT * FROM ".static::TABLE."  WHERE ".static::NAME." = :Name";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':Name', $pName);

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  public static function getPackByCostKarma($price) {
    global $db;

    $req = "SELECT * FROM ".static::TABLE."  WHERE ".static::KARMA." = :Price";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':Price', $price);

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }

  }

  public static function getPackByCostGold($price) {
    global $db;

    $req = "SELECT * FROM ".static::TABLE."  WHERE ".static::GOLD." = :Price";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':Price', $price);

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

}

?>
