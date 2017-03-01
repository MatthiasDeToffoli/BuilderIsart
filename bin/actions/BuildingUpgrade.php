<?php
/**
 * User: RABIERAmbroise
 * Date: 17/02/2017
 * Time: 14:28
 */

namespace actions;

use actions\utils\BuildingCommonCode as BuildingCommonCode;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Send as Send;
use actions\utils\Utils as Utils;
use actions\utils\Resources as Resources;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("utils/FacebookUtils.php");
include_once("ValidBuildingUpgrade.php");
include_once("utils/BuildingCommonCode.php");
include_once("utils/Resources.php");
//include_once("ValidAddBuilding.php"); do not use that or à doAction() for AddBuilding may be called.

class BuildingUpgrade
{
    // from database
    const TABLE_BUILDING = "Building";
    const TABLE_TYPE_BUILDING = "TypeBuilding";
    const COLUMN_ID = "ID";
    const COLUMN_NAME = "Name";
    const COLUMN_LEVEL = "Level";

    // from facebook
    const ID_PLAYER = "IDPlayer";

    // defined by server
    const ID_TYPE_BUILDING = "IDTypeBuilding";

    // from POST data
    const ID_CLIENT_BUILDING = "IDClientBuilding";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";

    public static function doAction () {
        global $db;

        $lInfo = static::getInfo();
        $lBuildingInDB = static::getBuildingInDB($lInfo);
        $lConfig = static::getConfigForBuilding($lBuildingInDB[static::ID_TYPE_BUILDING]);
        $lNewConfig = static::getNextLevelTypeBuilding($lConfig);
        $db->beginTransaction();
        $lWallet = Resources::getResources($lInfo[static::ID_PLAYER]);

        ValidBuildingUpgrade::validate($lInfo, $lBuildingInDB, $lConfig, $lNewConfig, $lWallet);
        $lInfo = BuildingCommonCode::addDateTimes($lInfo, $lNewConfig);
        Utils::updateSetWhere(
            static::TABLE_BUILDING,
            static::getFieldsToSET($lNewConfig, $lInfo),
            static::getSQLSetWherePos($lInfo)
        );
        BuildingCommonCode::updateResourcesBuyBuilding(
            $lInfo[static::ID_PLAYER],
            $lNewConfig,
            $lWallet
        );
        $db->commit();
        Send::synchroniseBuildingTimer($lInfo);
        // todo : logs
    }

    private static function getInfo () {
        return [
            static::ID_CLIENT_BUILDING => Utils::getSinglePostValueInt(static::ID_CLIENT_BUILDING),
            static::ID_PLAYER => FacebookUtils::getId(),
            static::REGION_X => Utils::getSinglePostValueInt(static::REGION_X),
            static::REGION_Y => Utils::getSinglePostValueInt(static::REGION_Y),
            static::X => Utils::getSinglePostValueInt(static::X),
            static::Y => Utils::getSinglePostValueInt(static::Y)
        ];
    }


    private static function getBuildingInDB ($pInfo) {
        $lBuilding =  Utils::getTable(
            static::TABLE_BUILDING,
            static::getSQLSetWherePos($pInfo)
        )[0];

        ValidBuildingUpgrade::buildingExist($lBuilding);

        return $lBuilding;
    }


    public static function getConfigForBuilding ($pIdTypBuilding) {
        return Utils::getTableRowByID(static::TABLE_TYPE_BUILDING, $pIdTypBuilding);
    }


    private static function getNextLevelTypeBuilding ($pConfig) {
        $lNewConfig = Utils::getTable(
            static::TABLE_TYPE_BUILDING,
            static::getSQLWhereLevelName($pConfig)
        )[0];
        ValidBuildingUpgrade::typeBuildingExist($lNewConfig, $pConfig);

        return $lNewConfig;
    }


    private static function getSQLWhereLevelName ($pConfig) {
        $lNewLevel = intval($pConfig[static::COLUMN_LEVEL]) + 1;
        $lResult = "";
        $lResult = $lResult.static::COLUMN_NAME."=\"".$pConfig[static::COLUMN_NAME]."\" AND ";
        $lResult = $lResult.static::COLUMN_LEVEL."=".$lNewLevel;

        return $lResult;
    }


    private static function getFieldsToSET ($pNewConfig, $pInfo) {
        // todo : make a common method file for building querys.
        return [
            BuildingCommonCode::START_CONTRUCTION => $pInfo[BuildingCommonCode::START_CONTRUCTION],
            BuildingCommonCode::END_CONTRUCTION => $pInfo[BuildingCommonCode::END_CONTRUCTION],
            BuildingCommonCode::IS_BUILT => true,
        ];
    }


    private static function getSQLSetWherePos ($pInfo) {
        $lResult = "";
        $lResult = $lResult.static::ID_PLAYER."=".$pInfo[static::ID_PLAYER]." AND ";
        $lResult = $lResult.static::REGION_X."=".$pInfo[static::REGION_X]." AND ";
        $lResult = $lResult.static::REGION_Y."=".$pInfo[static::REGION_Y]." AND ";
        $lResult = $lResult.static::X."=".$pInfo[static::X]." AND ";
        $lResult = $lResult.static::Y."=".$pInfo[static::Y];

        return $lResult;
    }

}
BuildingUpgrade::doAction();
