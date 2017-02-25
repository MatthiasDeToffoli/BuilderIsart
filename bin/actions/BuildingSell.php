<?php
/**
 * User: RABIERAmbroise
 * Date: 17/02/2017
 * Time: 15:16
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Utils as Utils;
use actions\utils\GeneratorType as GeneratorType;
use actions\utils\Resources as Resources;
use actions\utils\Table as Table;
use actions\utils\TypeBuilding as TypeBuilding;
use actions\utils\BuildingCommonCode as BuildingCommonCode;
use actions\utils\Building as Building;

include_once("utils/Utils.php");
include_once("ValidBuildingSell.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Resources.php");
include_once("utils/GeneratorType.php");
include_once("utils/Table.php");
include_once("utils/TypeBuilding.php");
include_once("utils/BuildingCommonCode.php");
include_once("utils/Building.php");

class BuildingSell
{
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
        $lBuildingInDB = BuildingCommonCode::getBuildingWhitPosition(
            $lInfo[static::ID_PLAYER],
            $lInfo[static::X],
            $lInfo[static::Y],
            $lInfo[static::REGION_X],
            $lInfo[static::REGION_Y]
        );
        if ($lBuildingInDB == null) {
            echo "There is no building in database whit that position.";
            exit;
        }

        $lConfig = Utils::getTable(
            Table::TypeBuilding,
            "ID=".$lBuildingInDB[static::ID_TYPE_BUILDING]
        )[0];
        $lGlobalConfigTable = Utils::getTable(Table::Config)[0];

        $db->beginTransaction();
        $lWallet = Resources::getResources($lInfo[static::ID_PLAYER]);
        static::updateResources(
            $lConfig,
            $lWallet,
            $lGlobalConfigTable,
            $lBuildingInDB,
            $lInfo[static::ID_PLAYER]
        );
        Utils::delete(
            Table::Building,
            static::getSQLSetWherePos(ValidBuildingSell::validate($lInfo, $lConfig, $lWallet, $lGlobalConfigTable))
        );
        $db->commit();
        // todo : logs
    }

    private static function updateResources ($pConfig, $pWallet, $pGlobalConfigTable, $pBuildingInDB, $pIdPlayer) {
        $date = new \DateTime();
        $dateNow = $date->getTimestamp(); // seconds
        $isBuilded = $dateNow >= Utils::dateTimeToTimeStamp($pBuildingInDB[Building::EndConstruction]);

        // todo : use abstract class Config.
        $refundRatio = $isBuilded ?
            $pGlobalConfigTable["RefundRatioBuilded"] : $pGlobalConfigTable["RefundRatioConstruct"];

        if ($pConfig[TypeBuilding::CostKarma] != null)
            Resources::updateResources(
                $pIdPlayer,
                GeneratorType::hard,
                $pWallet[GeneratorType::hard] + ceil($pConfig[TypeBuilding::CostKarma] * $refundRatio)
            );
        if ($pConfig[TypeBuilding::CostGold] != null)
            Resources::updateResources(
                $pIdPlayer,
                GeneratorType::soft,
                $pWallet[GeneratorType::soft] + ceil($pConfig[TypeBuilding::CostGold] * $refundRatio)
            );
        if ($pConfig[TypeBuilding::CostWood] != null)
            Resources::updateResources(
                $pIdPlayer,
                GeneratorType::resourcesFromHeaven,
                $pWallet[GeneratorType::resourcesFromHeaven] + ceil($pConfig[TypeBuilding::CostWood] * $refundRatio)
            );
        if ($pConfig[TypeBuilding::CostIron] != null)
            Resources::updateResources(
                $pIdPlayer,
                GeneratorType::resourcesFromHell,
                $pWallet[GeneratorType::resourcesFromHell] + ceil($pConfig[TypeBuilding::CostIron] * $refundRatio)
            );
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