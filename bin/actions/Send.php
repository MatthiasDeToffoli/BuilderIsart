<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 19:30
 */

namespace actions;

include_once("Utils.php");
include_once("Logs.php");

/**
 * Class that send info back to client, in case of a valid action of the player or
 * in case of an invalid action of player (desynchronisation or cheat)
 * In any of those case, the ajax request is successfull.
 *
 * It sends data to client, so lowerCase at first char is needed.
 *
 * Class Send
 * @package actions
 */
class Send
{
    const BUILDING_CANNOT_BUILD = 0;

    // todo : tester , utiliser pour les erreurs de la bdd également après avoir changé error_reporting(0); ?
    public static function refuseAddBuilding ($pErrorID, $pInfo) {
        echo json_encode(array_merge(
            [
                "errorID" => $pErrorID,
            ],
            static::getBuildingIdentifier($pInfo)
        ));
        // todo : mettre que les nécessaire ds le json_encode
        Logs::addBuilding($pInfo[AddBuilding::ID_PLAYER], Logs::STATUS_REFUSED, $pInfo);
        exit;
    }


    public static function validAddBuilding ($pInfo) {
        echo json_encode(array_merge(
            [
                lcfirst(AddBuilding::START_CONTRUCTION) => Utils::timeStampToJavascript(Utils::dateTimeToTimeStamp($pInfo[AddBuilding::START_CONTRUCTION])),
                lcfirst(AddBuilding::END_CONTRUCTION) => Utils::timeStampToJavascript(Utils::dateTimeToTimeStamp($pInfo[AddBuilding::END_CONTRUCTION]))
            ],
            static::getBuildingIdentifier($pInfo)
        ));
        // todo : mettre que les nécessaire ds le json_encode
        Logs::addBuilding($pInfo[AddBuilding::ID_PLAYER], Logs::STATUS_ACCEPTED, $pInfo);
    }

    // voir commentaire à côté de la contatne STATuS_ERROR dans Logs
    /*public static function errorAddBuilding ($pInfo) {
        Logs::addBuilding($pInfo[AddBuilding::ID_PLAYER], Logs::STATUS_ERROR, $pInfo);
    }*/


    // todo : will change (position is not a good identifier)
    private static function getBuildingIdentifier ($pInfo) {
        return [
            lcfirst(AddBuilding::REGION_X) => $pInfo[AddBuilding::REGION_X],
            lcfirst(AddBuilding::REGION_Y) => $pInfo[AddBuilding::REGION_Y],
            lcfirst(AddBuilding::X) => $pInfo[AddBuilding::X],
            lcfirst(AddBuilding::Y) => $pInfo[AddBuilding::Y]
        ];
    }
}