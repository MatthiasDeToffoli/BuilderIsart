<?php
/**
 * User: RABIERAmbroise
 * Date: 17/02/2017
 * Time: 15:16
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/Utils.php");
include_once("ValidBuildingSell.php");
include_once("utils/FacebookUtils.php");

class BuildingSell
{
    const TABLE_BUILDING = "Building";

    // from facebook
    const ID_PLAYER = "IDPlayer";

    // from POST data
    const ID_CLIENT_BUILDING = "IDClientBuilding";
    const ID_TYPE_BUILDING = "IDTypeBuilding";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";


    public static function doAction () {
        $lInfo = static::getInfo();
        Utils::delete(
            static::TABLE_BUILDING,
            static::getSQLSetWherePos(ValidBuildingSell::validate($lInfo))
        );
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

    public static function getSQLSetWherePos ($pInfo) {
        $lResult = "";
        $lResult = $lResult.static::ID_PLAYER."=".$pInfo[static::ID_PLAYER]." AND ";
        $lResult = $lResult.static::REGION_X."=".$pInfo[static::REGION_X]." AND ";
        $lResult = $lResult.static::REGION_Y."=".$pInfo[static::REGION_Y]." AND ";
        $lResult = $lResult.static::X."=".$pInfo[static::X]." AND ";
        $lResult = $lResult.static::Y."=".$pInfo[static::Y];

        return $lResult;
    }
}

BuildingSell::doAction();