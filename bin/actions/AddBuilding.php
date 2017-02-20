<?php
/**
 * User: RABIERAmbroise
 * Date: 01/02/2017
 * Time: 15:20
 */


namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Send as Send;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/Logs.php");
include_once("utils/Send.php");
include_once("ValidAddBuilding.php");
include_once("utils/FacebookUtils.php");

class AddBuilding
{
    const TABLE_BUILDING = "Building";

    // from facebook
    const ID_PLAYER = "IDPlayer";

    // defined by server
    const START_CONTRUCTION = "StartConstruction";
    const END_CONTRUCTION = "EndConstruction";
    const LEVEL = "Level";
    const NB_RESOURCE = "NbResource";
    const NB_SOUL = "NbSoul";

    // from POST data
    const ID_CLIENT_BUILDING = "IDClientBuilding";
    const ID_TYPE_BUILDING = "IDTypeBuilding";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";


    public static function doAction () {
        //ValidBuilding::setConfigForBuilding(); n'arrive pas à temps ,asynchrone :/
        $lInfo = static::getInfo();
        $lInfoWhitTime = ValidAddBuilding::validate($lInfo);
        Send::synchroniseBuildingTimer($lInfoWhitTime);
        unset($lInfoWhitTime[static::ID_CLIENT_BUILDING]);

        Utils::insertInto(
            static::TABLE_BUILDING,
            $lInfoWhitTime
        );

        // todo : $lInfo == lInfo unsetted ? (the more you have for log the better)
        Logs::addBuilding($lInfo[static::ID_PLAYER], Logs::STATUS_ACCEPTED, null, $lInfo);
    }

    // todo : tenter d'envoyer des valeur mindfuck poru voir si je casse ou pas ?
    private static function getInfo () {
        return [
            static::ID_CLIENT_BUILDING => Utils::getSinglePostValueInt(static::ID_CLIENT_BUILDING),
            static::ID_TYPE_BUILDING => Utils::getSinglePostValueInt(static::ID_TYPE_BUILDING),
            static::ID_PLAYER => FacebookUtils::getId(),
            static::REGION_X => Utils::getSinglePostValueInt(static::REGION_X),
            static::REGION_Y => Utils::getSinglePostValueInt(static::REGION_Y),
            static::X => Utils::getSinglePostValueInt(static::X),
            static::Y => Utils::getSinglePostValueInt(static::Y),
        ];
    }

}

AddBuilding::doAction();
