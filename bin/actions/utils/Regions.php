<?php

namespace actions\utils;
/**
* @author: de Toffoli Matthias
* Include this when you want to use the table Region
*/
/**
 *
 */
class Regions
{

  /**
   * add a region to the table
   * @param	$Id the player Id
   * @param	$Type the type of the region we want to add
   * @param	$X the position X of the region in world map
   * @param	$Y the position Y of the region in world map
   * @param	$FTX the position X of the first tile of the region
   * @param	$FTY the position Y of the first tile of the region
   */
    public static function createRegion($Id,$Type, $X,$Y,$FTX,$FTY){
      global $db;

      $req = "INSERT INTO Region(IdPlayer, Type, PositionX, PositionY, FistTilePosX, FistTilePosY) VALUES (:playerId,:Type,:X,:Y,:FTX,:FTY)";
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':playerId', $Id);
      $reqPre->bindParam(':Type', $Type);
      $reqPre->bindParam(':X', $X);
      $reqPre->bindParam(':Y', $Y);
      $reqPre->bindParam(':FTX', $FTX);
      $reqPre->bindParam(':FTY', $FTY);

      try {
        $reqPre->execute();

      } catch (Exception $e) {
        echo $e->getMessage();
        exit;
      }

    }

    /**
     * test if the position of the region to add is valid
     * @param $playerId the player id
     * @param $Type the type of region we want
     * @param $X the position X of the region in world map
     * @param $X the position Y of the region in world map
     * @return a boolean said if we can create the region or not
     */
    public static function testPosition($playerId,$Type, $X,$Y) {
      global $db;
      if(Regions::testIfAnotherRegionInThisPosition($X,$Y)) return Array("flag" => false,"message" => "Always a region in this position. You try to Hack this  game ? Oo");
      if($Type == "neutral" && $X == 0 && $Y == 0) return Array("flag" => true);


      $req = "SELECT PositionX,PositionY FROM Region WHERE IdPlayer = :pId";
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':pId', $playerId);

      try {
        $reqPre->execute();
        $res = $reqPre->fetchAll(PDO::FETCH_OBJ);
        if(empty($res)) return Array("flag" => false, "message" => "no region in database");

        $length = count($res);

        for($i = 0; $i < $length; $i++){
          if($X - 1 == $res[$i]->PositionX || $X + 1 == $res[$i]->PositionX) return Array("flag" => true);
          if($Y - 1 == $res[$i]->PositionY || $Y + 1 == $res[$i]->PositionY) return Array("flag" => true);
        }

        return Array("flag" => false, "message" => "no region near the region to add. You try to Hack this game ? Oo");


      } catch (Exception $e) {
        echo $e->getMessage();
        exit;
      }

    }

    /**
    *get all region to this player
    *@param $pId id of the player
    *@return all region of this player
    */

    public static function getAllRegion($pId){
      global $db;

      $req = "SELECT * FROM `Region` WHERE IdPlayer = :id";
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':id', $pId);

      try {
        $reqPre->execute();
        return $reqPre->fetchAll(PDO::FETCH_OBJ);
      } catch (Exception $e) {
        echo $e->getMessage();
        exit;
      }
    }

    /**
     * test if the client want to add a region on another region
     * @param $X the position X of the region in world map
     * @param $X the position Y of the region in world map
     * @return a boolean said if a region is in the position want or not
     */
    public static function testIfAnotherRegionInThisPosition($X,$Y){
      global $db;

      $req = "SELECT * FROM `Region` WHERE PositionX = :X AND PositionY = :Y";
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':X', $X);
      $reqPre->bindParam(':Y', $Y);

      try {
        $reqPre->execute();
        $res = $reqPre->fetch();
        if(!empty($res)) return true;
        return false;

      } catch (Exception $e) {
        echo $e->getMessage();
        exit;
      }
    }
}


?>
