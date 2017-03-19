<?php

namespace actions\utils;

use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\BuildingUtils as BuildingUtils;
use actions\utils\PackUtils as PackUtils;
use actions\utils\Resources as Resources;
use actions\utils\Player as Player;
use PDO as PDO;

include_once("Utils.php");
include_once("FacebookUtils.php");
include_once("BuildingUtils.php");
include_once("PackUtils.php");
include_once("Resources.php");
include_once("Player.php");

/**
* @author: de Toffoli Matthias
* include this for gestion of level up and experience
*/
class Experience {

  const TABLE = 'MaxExp';

  /**
  *increase good xp
  *@param $QuantityGaign quantity to increase
  *@return an object with level good xp and bad xp
  */
  public static function gaignGoodXp($QuantityGaign) {
    $goodXp = static::getGoodXp();
    $lId = FacebookUtils::getId();

    $exp = $goodXp->Quantity + $QuantityGaign;

    if($exp > static::getMax()) $exp = static::getMax();
    Resources::updateResources($lId,'goodXP', $exp);

    return static::testLevelUp();
  }

  /**
  *increase bad xp
  *@param $QuantityGaign quantity to increase
  *@return an object with level good xp and bad xp
  */
  public static function gaignBadXp($QuantityGaign) {

    $lId = FacebookUtils::getId();
    $badXp = static::getBadXp();
    $exp = $badXp->Quantity + $QuantityGaign;

    if($exp > static::getMax()) $exp = static::getMax();

    Resources::updateResources($lId,'badXp', $exp);

    return static::testLevelUp();
  }

  /**
  *get current player good xp
  *@return an object represanting good xp
  */
  public static function getGoodXp(){
    $lId = FacebookUtils::getId();
    return Resources::getResource($lId, 'goodXP');
  }

  /**
  *get current player bad xp
  *@return an object represanting bad xp
  */
  public static function getBadXp() {
    $lId = FacebookUtils::getId();
    return Resources::getResource($lId, 'badXp');
  }

  /**
  *test if the player level up
  *@return an object with level good xp and bad xp
  */
  public static function testLevelUp(){

    $lId = FacebookUtils::getId();
    $goodXp = static::getGoodXp();
    $badXp = static::getBadXp();
    $player = Player::getPlayerById($lId);

    if($goodXp->Quantity >= static::getMax() && $badXp->Quantity >=static::getMax()) {
      Resources::updateResources($lId,'badXp', 0);
      Resources::updateResources($lId,'goodXP', 0);
      Utils::updateSetWhere('Player', ['Level' => $player->Level + 1], 'ID = '.$lId);
      $badXp->Quantity = 0;
      $goodXp->Quantity = 0;
      $player->Level++;
    }

    return (object) array('badXp' => $badXp->Quantity, 'goodXp' => $goodXp->Quantity, 'level' => $player->Level);
  }

  /**
  *get max xp player can have
  *@return the max xp player can have
  */
  public static function getMax() {
    $lId = FacebookUtils::getId();
    $player = Player::getPlayerById($lId);

    if($player->Level > 19) {
      $level = 20;
    } else $level = $player->Level + 1;

    global $db;

    $req = "SELECT * FROM ".static::TABLE."  WHERE Level = :level";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':level', $level);

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ)->Value;
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }
}
?>
