<?php
/**
 * User: RABIERAmbroise
 * Date: 19/02/2017
 * Time: 14:34
 */

namespace actions\utils;

use actions\utils\Utils as Utils;
use actions\utils\Table as Table;
use actions\utils\GeneratorType as GeneratorType;
use actions\utils\TypeBuilding as TypeBuilding;

include_once("Utils.php");
include_once("Table.php");
include_once("TypeBuilding.php");
include_once("GeneratorType.php");

/**
 * private code shared between my class, that's not for anybody else use.
 * Class BuildingCommonCode
 * @package actions
 */
class BuildingCommonCode
{
    //column in table TypeBuilding
    const COLUMN_CONSTRUCTION_TIME = "ConstructionTime";

    //column in table Building
    const ID_PLAYER = "IDPlayer";
    const START_CONTRUCTION = "StartConstruction";
    const END_CONTRUCTION = "EndConstruction";
    const IS_BUILT ="IsBuilt";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";
    const WIDTH = "Width";
    const HEIGHT = "Height";

    // constant that must correspond to client code.
    const REGION_WIDTH = 12;
    const REGION_HEIGHT = 12;
    const REGION_STYX_WIDTH = 3;
    const REGION_STYX_HEIGHT = 13;
    const MAX_REGION_EXTENSION_FROM_STYX = 2;

    public static function addDateTimes ($pInfo, $pConfig) {
        $date = new \DateTime();
        $dateNow = $date->getTimestamp(); // seconds
        $pInfo[static::START_CONTRUCTION] = Utils::timeStampToDateTime($dateNow);
        $pInfo[static::END_CONTRUCTION] = Utils::timeStampToDateTime(static::getEndConstruction($dateNow, $pConfig));
        return $pInfo;
    }


    private static function getEndConstruction ($pStartConstruction, $pConfig) {
        return Utils::timeToTimeStamp($pConfig[static::COLUMN_CONSTRUCTION_TIME]) + $pStartConstruction;
    }


    public static function getBuildingWhitPosition ($pId, $pX, $pY, $pRegionX, $pRegionY) {
        return Utils::getTable(
            Table::Building,
            "Building.IDPlayer = ".$pId." AND Building.X = ".$pX." AND Building.Y = ".$pY." ".
            "AND Building.RegionX = ".$pRegionX." AND Building.RegionY = ".$pRegionY
        )[0];
    }


    public static function updateResourcesBuyBuilding ($pIDPlayer, $pTypeBuilding, $pWallet) {
        if ($pTypeBuilding[TypeBuilding::CostKarma] != null)
            Resources::updateResources(
                $pIDPlayer,
                GeneratorType::hard,
                $pWallet[GeneratorType::hard] - $pTypeBuilding[TypeBuilding::CostKarma]
            );
        if ($pTypeBuilding[TypeBuilding::CostGold] != null)
            Resources::updateResources(
                $pIDPlayer,
                GeneratorType::soft,
                $pWallet[GeneratorType::soft] - $pTypeBuilding[TypeBuilding::CostGold]
            );
        if ($pTypeBuilding[TypeBuilding::CostWood] != null)
            Resources::updateResources(
                $pIDPlayer,
                GeneratorType::resourcesFromHeaven,
                $pWallet[GeneratorType::resourcesFromHeaven] - $pTypeBuilding[TypeBuilding::CostWood]
            );
        if ($pTypeBuilding[TypeBuilding::CostIron] != null)
            Resources::updateResources(
                $pIDPlayer,
                GeneratorType::resourcesFromHell,
                $pWallet[GeneratorType::resourcesFromHell] - $pTypeBuilding[TypeBuilding::CostIron]
            );
    }

    public static function canBuy ($pConfig, $pWallet) {
        return (
            ($pConfig[TypeBuilding::CostGold] == null || $pWallet[GeneratorType::soft] >= $pConfig[TypeBuilding::CostGold]) &&
            ($pConfig[TypeBuilding::CostKarma] == null || $pWallet[GeneratorType::hard] >= $pConfig[TypeBuilding::CostKarma]) &&
            ($pConfig[TypeBuilding::CostIron] == null || $pWallet[GeneratorType::resourcesFromHell] >= $pConfig[TypeBuilding::CostIron]) &&
            ($pConfig[TypeBuilding::CostWood] == null || $pWallet[GeneratorType::resourcesFromHeaven] >= $pConfig[TypeBuilding::CostWood])
        );
    }

    public static function regionExist ($pInfo) {
        // IdPlayer whit a "d" lower case in Region table, careful.
        $lTable = Utils::getTable(Table::Region, "IdPlayer=".$pInfo[static::ID_PLAYER]." AND PositionX=".$pInfo[static::REGION_X]." AND PositionY=".$pInfo[static::REGION_Y]);
        return !empty($lTable) && isset($lTable);
    }

    /**
     * Verify that the building is inside a region.
     * @param $pInfo
     * @param $pConfig
     * @return bool
     */
    public static function isInRegion ($pInfo, $pConfig) {
        // if (region is styx, x and y inside range)
        // else (region is not styx, x and y inside range)

        $lIsStyx = $pInfo[static::REGION_X] == 0;

        $lBuildingRect =  (object) [
            "x" => $pInfo[static::X],
            "y" => $pInfo[static::Y],
            "width" => $pConfig[static::WIDTH],
            "height" => $pConfig[static::HEIGHT]
        ];

        $lRegionRect = (object) [
            "x" => 0,
            "y" => 0,
            "width" => $lIsStyx ? static::REGION_STYX_WIDTH : static::REGION_WIDTH,
            "height" => $lIsStyx ? static::REGION_STYX_HEIGHT : static::REGION_HEIGHT
        ];

        return static::rectIsInsideRect($lBuildingRect, $lRegionRect);
    }

    private static function rectIsInsideRect ($pLittleRect, $pBiggerRect) {
        return (
            $pLittleRect->x >= $pBiggerRect->x &&
            $pLittleRect->y >= $pBiggerRect->y &&
            $pLittleRect->x + $pLittleRect->width <= $pBiggerRect->x + $pBiggerRect->width &&
            $pLittleRect->y + $pLittleRect->height <= $pBiggerRect->y + $pBiggerRect->height
        );
    }

    /**
     * Check if the building collide whit another building.
     * @param $pInfo
     * @param $pConfig
     * @return bool
     */
    public static function buildingCollide ($pInfo, $pConfig) {

        return false;
    }

    public static function buildingAlignmentCorrespondToRegion ($pInfo, $pConfig) {
        
        return true;
    }

}




























