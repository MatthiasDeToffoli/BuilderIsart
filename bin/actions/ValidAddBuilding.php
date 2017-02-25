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

        static::canBuild($pInfo, $pConfig, $pWallet); // exit if something wrong

        return $pInfo;
    }


    private static function canBuild ($pInfo, $pConfig, $pWallet) {
        global $db;

        static::cannotBuy($pInfo, $pConfig, $pWallet);

        if (static::isOutsideRegion($pInfo, $pConfig) ||
            static::hasCollision($pInfo, $pConfig)) {
            $db->rollBack();
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


    private static function cannotBuy ($pInfo, $pConfig, $pWallet) {
        global $db;

        $result = (
            ($pConfig[TypeBuilding::CostGold] == null || $pWallet[GeneratorType::soft] >= $pConfig[TypeBuilding::CostGold]) &&
            ($pConfig[TypeBuilding::CostKarma] == null || $pWallet[GeneratorType::hard] >= $pConfig[TypeBuilding::CostKarma]) &&
            ($pConfig[TypeBuilding::CostIron] == null || $pWallet[GeneratorType::resourcesFromHell] >= $pConfig[TypeBuilding::CostIron]) &&
            ($pConfig[TypeBuilding::CostWood] == null || $pWallet[GeneratorType::resourcesFromHeaven] >= $pConfig[TypeBuilding::CostWood])
        );

        if (!$result) {
            $db->rollBack();
            Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_NOT_ENOUGH_MONEY);
        }

        return $result;

    }


}