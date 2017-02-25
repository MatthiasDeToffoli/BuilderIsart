<?php
/**
 * User: RABIERAmbroise
 * Date: 17/02/2017
 * Time: 15:30
 */

namespace actions;

use actions\utils\Send as Send;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("BuildingSell.php");

class ValidBuildingSell
{
    const TABLE_BUILDING = "Building";

    public static function validate ($pInfo) {
        $lBuildingInDB = static::getBuildingInDB($pInfo);
        static::buildingExist($pInfo, $lBuildingInDB);
        return $pInfo;
    }

    private static function buildingExist ($pInfo, $pBuildingInDB) {
        global $db;
        if (!isset($pBuildingInDB) || empty($pBuildingInDB)) {
            $db->rollBack();
            Send::refuseSellBuilding($pInfo, Send::BUILDING_CANNOT_SELL_DONT_EXIST);
        }
    }

    private static function getBuildingInDB ($pInfo) {
        return Utils::getTable(
            static::TABLE_BUILDING,
            BuildingSell::getSQLSetWherePos($pInfo)
        )[0];
    }

}