<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 19:30
 */

namespace actions\utils;

use actions\utils\BuildingCommonCode as BuildingCommonCode;
use actions\utils\Logs as Logs;
use actions\AddBuilding as AddBuilding;
use actions\MoveBuilding as MoveBuilding;


include_once("Logs.php");
include_once("BuildingCommonCode.php");

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
    // constant here must be the same in ErrorManager.hx
    // update errorCodeToMessage function in Logs.php after adding
    const BUILDING_CANNOT_MOVE_COLLISION = 1;
    const BUILDING_CANNOT_MOVE_DONT_EXIST = 2;
    const BUILDING_CANNOT_BUILD_OUTSIDE_REGION = 3;
    const BUILDING_CANNOT_BUILD_COLLISION = 4;
    const BUILDING_CANNOT_BUILD_NOT_ENOUGH_MONEY = 5;
    const BUILDING_CANNOT_SELL_DONT_EXIST = 6;
	const BUILDING_NOT_ENOUGHT_HARD = 7;

	const INTERN_INVALID_ID = 21;
	const INTERN_CANNOT_BUY = 22;
	const INTERN_ALREADY_BOUGHT = 23;

    const ID_CLIENT_BUILDING = "IDClientBuilding";

    public static function refuseAddBuilding ($pInfo, $pErrorCode) {
        echo json_encode(array_merge(
            [
                "errorID" => $pErrorCode,
            ],
            static::getBuildingIdentifier($pInfo)
        ));
        // (todo) : mettre que les nécessaire ds le json_encode
        Logs::addBuilding($pInfo[AddBuilding::ID_PLAYER], Logs::STATUS_REFUSED, $pErrorCode, $pInfo);
        exit;
    }


    public static function synchroniseBuildingTimer ($pInfo) {
        echo json_encode(array_merge(
            [
                lcfirst(BuildingCommonCode::START_CONTRUCTION) => Utils::timeStampToJavascript(Utils::dateTimeToTimeStamp($pInfo[BuildingCommonCode::START_CONTRUCTION])),
                lcfirst(BuildingCommonCode::END_CONTRUCTION) => Utils::timeStampToJavascript(Utils::dateTimeToTimeStamp($pInfo[BuildingCommonCode::END_CONTRUCTION]))
            ],
            static::getBuildingIdentifier($pInfo)
        ));
    }

    public static function refuseMoveBuilding ($pInfo, $pErrorCode) {
        echo json_encode(array_merge(
            [
                "errorID" => $pErrorCode,
                lcfirst(MoveBuilding::OLD_X) => $pInfo[MoveBuilding::OLD_X],
                lcfirst(MoveBuilding::OLD_Y) => $pInfo[MoveBuilding::OLD_Y],
                lcfirst(MoveBuilding::OLD_REGION_X) => $pInfo[MoveBuilding::OLD_REGION_X],
                lcfirst(MoveBuilding::OLD_REGION_Y) => $pInfo[MoveBuilding::OLD_REGION_Y]
            ],
            static::getBuildingIdentifier($pInfo)
        ));
        // (todo) : mettre que les infos nécessaire à la place de $pInfo
        Logs::moveBuilding($pInfo[MoveBuilding::ID_PLAYER], Logs::STATUS_REFUSED, $pErrorCode, $pInfo);
        exit;
    }

    public static function refuseSellBuilding ($pInfo, $pErrorCode) {
        echo json_encode(array_merge(
            [
                "errorID" => $pErrorCode,
            ]
        ));
        // todo : logs
        // todo : synchronise ressources.
        // soit c côté client qui demande à synchroniser ses ressources, soit c'est en callback ici.
        exit;
    }


    private static function getBuildingIdentifier ($pInfo) {
        return [
            lcfirst(static::ID_CLIENT_BUILDING) => $pInfo[static::ID_CLIENT_BUILDING]
        ];
    }
}