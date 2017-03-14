<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 12:32
 */

namespace actions;

use actions\utils\Resources;
use actions\utils\Send as Send;
use actions\utils\Utils as Utils;
use actions\utils\GeneratorType as GeneratorType;
use actions\utils\TypeBuilding as TypeBuilding;
use actions\utils\BuildingCommonCode as BuildingCommonCode;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("utils/Resources.php");
include_once("utils/BuildingCommonCode.php");
include_once("utils/GeneratorType.php");
include_once("utils/TypeBuilding.php");

/**
 * Class ValidBuilding
 * @package actions
 */
class ValidAddBuilding
{
    const COLUMN_ID_PLAYER = "IDPlayer";


    public static function validate ($pInfo, $pConfig, $pWallet) {
        $pInfo = BuildingCommonCode::addDateTimes($pInfo, $pConfig);

        // exit if something wrong
        static::canBuild($pInfo, $pConfig, $pWallet);

        return $pInfo;
    }


    private static function canBuild ($pInfo, $pConfig, $pWallet) {
        static::cannotBuy($pInfo, $pConfig, $pWallet);
        static::isOutsideRegion($pInfo, $pConfig);
        static::hasCollision($pInfo, $pConfig);
    }


    private static function isOutsideRegion ($pInfo, $pConfig) {
        global $db;
        if (!BuildingCommonCode::regionExist($pInfo)) {
            $db->rollBack();
            Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_REGION_DONT_EXIST);
        }
        if (!BuildingCommonCode::isInRegion($pInfo, $pConfig)) {
            $db->rollBack();
            Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_OUTSIDE_REGION);
        }
    }


    private static function hasCollision ($pInfo, $pConfig) {
        global $db;
        if (BuildingCommonCode::buildingCollide($pInfo, $pConfig)) {
            $db->rollBack();
            Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_COLLISION);
        }
        return false;
    }


    private static function cannotBuy ($pInfo, $pConfig, $pWallet) {
        global $db;
        $canBuy = BuildingCommonCode::canBuy($pConfig, $pWallet);
        if (!$canBuy) {
            $db->rollBack();
            Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_NOT_ENOUGH_MONEY);
        }
    }

}




























