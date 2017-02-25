<?php
/**
 * User: RABIERAmbroise
 * Date: 01/02/2017
 * Time: 15:20
 */


namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Send as Send;
use actions\utils\TypeBuilding;
use actions\utils\Utils as Utils;
use actions\utils\Logs as Logs;
use actions\utils\GeneratorType as GeneratorType;
use actions\utils\Resources;

include_once("ValidAddBuilding.php");
include_once("utils/Utils.php");
include_once("utils/Logs.php");
include_once("utils/Send.php");
include_once("utils/Resources.php");
include_once("utils/FacebookUtils.php");
include_once("utils/GeneratorType.php");

class AddBuilding
{
    const TABLE_TYPE_BUILDING = "TypeBuilding";
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

    /*
     * Why $db->beginTransaction(); in doAction ?
     * If another php script is running and change Resources Table,
     * before this script finish running, $newQuantity will be wrong, and may result in the user having more money.
     * But this one is not perfect too, because if another script change Resources Table, the user may not be able to buy the article anymore
     * and may result whit a negative account in database...
     * Ok the best way to resolve it is to use startTransaction.
     */

    public static function doAction () {
        global $db;
        //ValidBuilding::setConfigForBuilding(); n'arrive pas à temps ,asynchrone :/
        $lInfo = static::getInfo();
        $lConfig = Utils::getTableRowByID(static::TABLE_TYPE_BUILDING, $lInfo[static::ID_TYPE_BUILDING]);
        $db->beginTransaction();
        $lWallet = Resources::getResources($lInfo[static::ID_PLAYER]);
        // $db-rollback if something go wrong in validate().
        $lInfoWhitTime = ValidAddBuilding::validate($lInfo, $lConfig, $lWallet);

        static::updateResources($lInfo, $lConfig, $lWallet);
        $db->commit();
        Send::synchroniseBuildingTimer($lInfoWhitTime);

        unset($lInfoWhitTime[static::ID_CLIENT_BUILDING]);
        Utils::insertInto(
            static::TABLE_BUILDING,
            $lInfoWhitTime
        );

        // todo : $lInfo == lInfo unsetted ? (the more you have for log the better)
        Logs::addBuilding($lInfo[static::ID_PLAYER], Logs::STATUS_ACCEPTED, null, $lInfo);
    }

    private static function updateResources ($pInfo, $pConfig, $pWallet) {
        if ($pConfig[TypeBuilding::CostKarma] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::hard,
                $pWallet[GeneratorType::hard] - $pConfig[TypeBuilding::CostKarma]
            );
        if ($pConfig[TypeBuilding::CostGold] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::soft,
                $pWallet[GeneratorType::soft] - $pConfig[TypeBuilding::CostGold]
            );
        if ($pConfig[TypeBuilding::CostWood] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::resourcesFromHeaven,
                $pWallet[GeneratorType::resourcesFromHeaven] - $pConfig[TypeBuilding::CostWood]
            );
        if ($pConfig[TypeBuilding::CostIron] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::resourcesFromHell,
                $pWallet[GeneratorType::resourcesFromHell] - $pConfig[TypeBuilding::CostIron]
            );
    }


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
