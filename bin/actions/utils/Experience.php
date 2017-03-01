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

class Experience {

const TABLE = 'MaxExp';

  public static function gaignGoodXp($QuantityGaign) {
    $goodXp = static::getGoodXp();
    $lId = FacebookUtils::getId();

    $exp = $goodXp->Quantity + $QuantityGaign;

    if($exp > static::getMax()) $exp = static::getMax();
    Resources::updateResources($lId,'goodXP', $exp);

    return static::testLevelUp();
  }

  public static function gaignBadXp($QuantityGaign) {

    $lId = FacebookUtils::getId();
    $badXp = static::getBadXp();
    $exp = $badXp->Quantity + $QuantityGaign;

    if($exp > static::getMax()) $exp = static::getMax();

    Resources::updateResources($lId,'badXp', $exp);

    return static::testLevelUp();
  }

public static function getGoodXp(){
  $lId = FacebookUtils::getId();
  return Resources::getResource($lId, 'goodXP');
}

public static function getBadXp() {
  $lId = FacebookUtils::getId();
  return Resources::getResource($lId, 'badXp');
}

public static function testLevelUp(){

  $lId = FacebookUtils::getId();
  $goodXp = static::getGoodXp();
  $badXp = static::getBadXp();
  $player = Player::getPlayerById($lId);

    if($goodXp->Quantity >= static::getMax() && $badXp->Quantity >=static::getMax()) {
      Resources::updateResources($lId,'badXp', 0);
      Resources::updateResources($lId,'goodXP', 0);
      Utils::updateSetWhere('Player', ['Level' => $player->Level + 1], 'ID = '.$lId);
    }

    return (object) array('badXp' => $badXp->Quantity, 'goodXp' => $goodXp->Quantity, 'level' => $player->Level);
}

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
