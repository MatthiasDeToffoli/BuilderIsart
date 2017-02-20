<?php
/**
 * User: RABIERAmbroise
 * Date: 14/02/2017
 * Time: 11:41
 */

namespace actions;

use actions\utils\Send as Send;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/Send.php");

class ValidMoveBuilding
{
    const TABLE_BUILDING = "Building";
    const TABLE_BUILDING_ID_TYPE_BUILDING = "IDTypeBuilding";
    const TABLE_TYPE_BUILDING = "TypeBuilding";
    const COLUMN_CONSTRUCTION_TIME = "ConstructionTime";

    private static $config;

    /**
     * @param $pInfo
     * @return mixed
     */
    public static function validate ($pInfo) {
        $lBuildingInDB = static::getBuildingInDB($pInfo);

        static::buildingExist($pInfo, $lBuildingInDB);
        static::$config = static::getConfigForBuilding($lBuildingInDB[static::TABLE_BUILDING_ID_TYPE_BUILDING]); // Call from MoveBuilding
        static::canMove($pInfo); // exit if something wrong

        return $pInfo;
    }

    private static function getBuildingInDB ($pInfo) {
        return Utils::getTable(
            static::TABLE_BUILDING,
            MoveBuilding::getSQLWhereOldPos($pInfo)
        );
    }

    private static function buildingExist ($pInfo, $pBuildingInDB) {
        if (!isset($pBuildingInDB) || empty($pBuildingInDB))
            Send::refuseMoveBuilding($pInfo, Send::BUILDING_CANNOT_MOVE_DONT_EXIST);
    }

    private static function getConfigForBuilding ($pIdTypBuilding) {
        // todo: opti -> récup que les champs nécessaire ?
        return Utils::getTableRowByID(static::TABLE_TYPE_BUILDING, $pIdTypBuilding);
    }

    private static function canMove ($pInfo) {
        if (static::isOutsideRegion($pInfo) || static::hasCollision($pInfo)) {
            Send::refuseMoveBuilding($pInfo, Send::BUILDING_CANNOT_MOVE_COLLISION);
        }
    }

    private static function isOutsideRegion ($pInfo) {
        return false;
        //Send::refuseAddBuilding outside region
    }

    private static function hasCollision ($pInfo) {
        return false;
        //Send::refuseAddBuilding hasCollision
    }
}