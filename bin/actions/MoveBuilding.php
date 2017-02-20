<?php
/**
 * User: RABIERAmbroise
 * Date: 14/02/2017
 * Time: 10:26
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/Logs.php");
include_once("ValidMoveBuilding.php");
include_once("utils/FacebookUtils.php");

class MoveBuilding
{
    const TABLE_BUILDING = "Building";

    // from facebook
    const ID_PLAYER = "IDPlayer";

    // from POST data
    const ID_CLIENT_BUILDING = "IDClientBuilding";
    const OLD_REGION_X = "OldRegionX";
    const OLD_REGION_Y = "OldRegionY";
    const OLD_X = "OldX";
    const OLD_Y = "OldY";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";


    public static function doAction () {
        $lInfo = static::getInfo();

        Utils::updateSetWhere(
            static::TABLE_BUILDING,
            static::getFieldsToSET(ValidMoveBuilding::validate($lInfo)),
            static::getSQLWhereOldPos($lInfo)
        );
        // todo : $lInfo == lInfo unsetted ? (the more you have for log the better)
        Logs::moveBuilding($lInfo[static::ID_PLAYER], Logs::STATUS_ACCEPTED, null, $lInfo);
    }

    private static function getFieldsToSET ($pInfo) {
        return [
            static::REGION_X => $pInfo[static::REGION_X],
            static::REGION_Y => $pInfo[static::REGION_Y],
            static::X => $pInfo[static::X],
            static::Y => $pInfo[static::Y]
        ];
    }

    /**
     * return exemple : "Building.RegionX=25, Building.RegionY=44, Building.X=6, Building.Y=2"
     * @param $pInfo
     * @return string
     */
    private static function getSQLSetWhereNewPos ($pInfo) { // todo inutile ??? et casse-couille même
        $lResult = "";
        $lResult = $lResult.static::ID_PLAYER."=".$pInfo[static::ID_PLAYER]." AND ";
        $lResult = $lResult.static::REGION_X."=".$pInfo[static::REGION_X]." AND ";
        $lResult = $lResult.static::REGION_Y."=".$pInfo[static::REGION_Y]." AND ";
        $lResult = $lResult.static::X."=".$pInfo[static::X]." AND ";
        $lResult = $lResult.static::Y."=".$pInfo[static::Y];

        return $lResult;
    }

    /**
     *
     * return exemple : "Building.RegionX=25, Building.RegionY=44, Building.X=6, Building.Y=2"
     * @param $pInfo
     * @return string
     */
    public static function getSQLWhereOldPos ($pInfo) {
        $lResult = "";
        $lResult = $lResult.static::ID_PLAYER."=".$pInfo[static::ID_PLAYER]." AND ";
        $lResult = $lResult.static::REGION_X."=".$pInfo[static::OLD_REGION_X]." AND ";
        $lResult = $lResult.static::REGION_Y."=".$pInfo[static::OLD_REGION_Y]." AND ";
        $lResult = $lResult.static::X."=".$pInfo[static::OLD_X]." AND ";
        $lResult = $lResult.static::Y."=".$pInfo[static::OLD_Y];

        return $lResult;
    }

    // todo : tenter d'envoyer des valeur mindfuck poru voir si je casse ou pas ?
    private static function getInfo () {
        return [
            static::ID_CLIENT_BUILDING => Utils::getSinglePostValueInt(static::ID_CLIENT_BUILDING),
            static::ID_PLAYER => FacebookUtils::getId(),
            static::OLD_REGION_X => Utils::getSinglePostValueInt(static::OLD_REGION_X),
            static::OLD_REGION_Y => Utils::getSinglePostValueInt(static::OLD_REGION_Y),
            static::OLD_X => Utils::getSinglePostValueInt(static::OLD_X),
            static::OLD_Y => Utils::getSinglePostValueInt(static::OLD_Y),
            static::REGION_X => Utils::getSinglePostValueInt(static::REGION_X),
            static::REGION_Y => Utils::getSinglePostValueInt(static::REGION_Y),
            static::X => Utils::getSinglePostValueInt(static::X),
            static::Y => Utils::getSinglePostValueInt(static::Y)
        ];
    }
}

MoveBuilding::doAction();