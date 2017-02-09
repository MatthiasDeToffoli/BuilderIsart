<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 12:32
 */

namespace actions;

/**
 * include(Utils.php) is needed when using this class.
 * Class ValidBuilding
 * @package actions
 */
class ValidBuilding
{
    const TABLE_TYPE_BUILDING = "TypeBuilding";
    const COLUMN_CONSTRUCTION_TIME = "ConstructionTime";

    private static $config;

    public static function validate ($pInfo) {
        static::$config = static::getConfigForBuilding($pInfo[AddBuilding::ID_TYPE_BUILDING]);
        $pInfo = static::addDateTimes($pInfo);

        static::canBuild($pInfo);
        Send::validAddBuilding($pInfo);

        return $pInfo;
    }

    private static function getConfigForBuilding ($pIdTypBuilding) {
        // todo: récup que les champs nécessaire ?
        return Utils::getTableRowByID(static::TABLE_TYPE_BUILDING, $pIdTypBuilding);
    }

    private static function addDateTimes ($pInfo) {
        $date = new \DateTime();
        $dateNow = $date->getTimestamp(); // seconds
        $pInfo[AddBuilding::START_CONTRUCTION] = Utils::timeStampToDateTime($dateNow);
        $pInfo[AddBuilding::END_CONTRUCTION] = Utils::timeStampToDateTime(static::getEndConstruction($dateNow));
        return $pInfo;
    }

    private static function getEndConstruction ($pStartConstruction) {
        return Utils::timeToTimeStamp(static::$config[static::COLUMN_CONSTRUCTION_TIME]) + $pStartConstruction;
    }

    private static function canBuild ($pInfo) {
        if (!static::isInRegion($pInfo) || !static::hasNoCollision($pInfo)) {
            Send::errorAddBuilding(ErrorManager::BUILDING_CANNOT_BUILD, $pInfo);
        }
    }

    private static function isInRegion ($pInfo) {
        return true;
    }

    private static function hasNoCollision ($pInfo) {
        return true;
    }
}