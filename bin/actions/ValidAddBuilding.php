<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 12:32
 */

namespace actions;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("BuildingCommonCode.php");

/**
 * Class ValidBuilding
 * @package actions
 */
class ValidAddBuilding
{
    const TABLE_TYPE_BUILDING = "TypeBuilding";


    public static function validate ($pInfo) {
        $lConfig = static::getConfigForBuilding($pInfo[AddBuilding::ID_TYPE_BUILDING]);
        $pInfo = BuildingCommonCode::addDateTimes($pInfo, $lConfig);

        static::canBuild($pInfo, $lConfig); // exit if something wrong

        return $pInfo;
    }


    public static function getConfigForBuilding ($pIdTypBuilding) {
        return Utils::getTableRowByID(static::TABLE_TYPE_BUILDING, $pIdTypBuilding);
    }


    private static function canBuild ($pInfo, $pConfig) {
        if (static::isOutsideRegion($pInfo, $pConfig) ||
            static::hasCollision($pInfo, $pConfig) ||
            static::cannotBuy($pInfo, $pConfig)) {
            Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_COLLISION); // todo : will be removed
        }
    }


    private static function isOutsideRegion ($pInfo, $pConfig) {
        return false;
        //Send::refuseAddBuilding outside region
    }


    private static function hasCollision ($pInfo, $pConfig) {
        return false;
        //Send::refuseAddBuilding hasCollision
    }


    private static function cannotBuy ($pInfo, $pConfig) {
        return false;
        //Send::refuseAddBuilding cannotBuy
    }


}