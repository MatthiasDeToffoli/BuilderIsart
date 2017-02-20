<?php
/**
 * User: RABIERAmbroise
 * Date: 19/02/2017
 * Time: 14:34
 */

namespace actions;

use actions\utils\Utils as Utils;

include_once("Utils.php");

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

}