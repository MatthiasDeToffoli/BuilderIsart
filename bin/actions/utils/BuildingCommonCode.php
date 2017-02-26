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
    const START_CONTRUCTION = "StartConstruction";
    const END_CONTRUCTION = "EndConstruction";

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

}