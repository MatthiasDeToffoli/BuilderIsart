<?php
namespace actions\utils;

use PDO as PDO;
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;

include_once("Utils.php");
include_once("FacebookUtils.php");

/**
* @author: de Toffoli Matthias
* include this if we want to use the table TypeBuilding
*/

class BuildingUtils
{

  const BUILDINGTABLE = 'Building';
  const IDTYPEBUILDING = 'IDTypeBuilding';
  const IDPLAYER = 'IDPlayer';
  const NBRESOURCES = 'NbResource';
  const ENDFORNEXTPRODUCTION = 'EndForNextProduction';
  const LEVEL = 'Level';
  const REGIONX = 'RegionX';
  const REGIONY = 'RegionY';
  const X = 'X';
  const Y = 'Y';
  const NBSOUL = 'NbSoul';

  /**
  *get a typeBuilding identify with name and level
  *@param $pName the name of the building
  *@param $pLevel the level of the building
  *@return an object representing the typebuilding
  */
  public static function getTypeBuilding($pName, $pLevel) {
    global $db;

    $req = "SELECT * FROM `TypeBuilding`  WHERE Name = :Name AND Level = :Level";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':Name', $pName);
    $reqPre->bindParam(':Level', $pLevel);

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  /**
  *get a typeBuilding join a building with building id
  *@param $BuildingId id of the building to join
  *@return an object representing the typebuilding and the building
  */
  public static function getTypeBuildingWithId($BuildingId)
  {
    global $db;

    $req = "SELECT * FROM `TypeBuilding` JOIN Building ON Building.IDTypeBuilding = TypeBuilding.ID WHERE Building.ID = :ID AND Building.IDPlayer = :PID" ;
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':ID', $BuildingId);
    $reqPre->bindParam(':PID', FacebookUtils::getId());

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  /**
  *get all typeBuilding join a building with building id
  *@param $pName the name of typeBuilding
  *@return an object representing all typebuildings and buildings
  */
  public static function getAllBuildingByName($pName) {
    global $db;

    $req = "SELECT * FROM `Building` JOIN TypeBuilding ON Building.IDTypeBuilding = TypeBuilding.ID WHERE TypeBuilding.Name = :Name";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':Name', $pName);

    try {
      $reqPre->execute();
      return $reqPre->fetchAll(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  /**
  *get a typeBuilding join a building with building position
  *@param $posX position x of the building inside is region
  *@param $posY position y of the building inside is region
  *@param $regionX position x of building's region
  *@param $regionY position y of building's region
  *@return an object representing the typebuilding and the building
  */
  public static function getTypeBuildingWithPosition($posX,$posY,$regionX,$regionY)
  {
    global $db;

    $req = "SELECT * FROM `TypeBuilding` JOIN Building ON Building.IDTypeBuilding = TypeBuilding.ID WHERE Building.IDPlayer = :PID AND Building.X = :X AND Building.Y = :Y AND Building.RegionX = :RX AND Building.RegionY = :RY";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':X', $posX);
    $reqPre->bindParam(':Y', $posY);
    $reqPre->bindParam(':RX', $regionX);
    $reqPre->bindParam(':RY', $regionY);
    $reqPre->bindParam(':PID', FacebookUtils::getId());

    try {
      $reqPre->execute();
      return $reqPre->fetch(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  /**
  *get all typeBuildings join buildings with position region x
  *@param $X position x of building's region
  *@return an object representing all typebuildings and buildings had the good region x
  */
  public static function getAllBuildings($X)
  {
    global $db;

    $req = "SELECT * FROM `TypeBuilding` JOIN Building ON Building.IDTypeBuilding = TypeBuilding.ID WHERE Building.IDPlayer = :PID AND Building.RegionX = :X";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':PID', FacebookUtils::getId());
    $reqPre->bindParam(':X', $X);

    try {
      $reqPre->execute();
      return $reqPre->fetchAll(PDO::FETCH_OBJ);
    } catch (\Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  /**
  *create purgatory in database
  */
  public static function addPurgatoryToDatabase() {
    $typeTribu = static::getTypeBuilding('Purgatory',1);
    $pTime = time() +  (60*60)/$typeTribu->ProductionPerHour + 3600;

    Utils::insertInto(static::BUILDINGTABLE, [
      static::IDTYPEBUILDING => $typeTribu->ID,
      static::IDPLAYER => FacebookUtils::getId(),
      static::REGIONX => 0,
      static::REGIONY => 0,
      static::X => 0,
      static::Y => 5,
      static::NBRESOURCES => $typeTribu->MaxSoulsContained,
      static::ENDFORNEXTPRODUCTION => Utils::timeStampToDateTime($pTime)
    ]);
  }

  /**
  *create first hell building in database
  */
  public static function addFirstHellBuildingToDatabase() {
    $typeBuilding = static::getTypeBuilding('Hell House', 1);
    Utils::insertInto(static::BUILDINGTABLE, [
      static::IDTYPEBUILDING => $typeBuilding->ID,
      static::IDPLAYER => FacebookUtils::getId(),
      static::REGIONX => 1,
      static::REGIONY => 0,
      static::X => 6,
      static::Y => 6,
      static::NBRESOURCES => $typeBuilding->MaxGoldContained,
      static::NBSOUL => 3,
      static::ENDFORNEXTPRODUCTION => Utils::timeStampToDateTime(time() + ((3600/$typeBuilding->ProductionPerHour)/3))
    ]);
  }
}

?>
