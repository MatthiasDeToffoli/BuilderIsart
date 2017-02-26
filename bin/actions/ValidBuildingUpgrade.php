<?php
/**
 * User: RABIERAmbroise
 * Date: 19/02/2017
 * Time: 13:24
 */

namespace actions;

use actions\utils\BuildingCommonCode as BuildingCommonCode;

include_once("BuildingUpgrade.php");
include_once("utils/BuildingCommonCode.php");

class ValidBuildingUpgrade
{
    public static function validate ($pInfo, $pBuildingInDB, $pConfig, $pNewConfig, $pWallet) {
        // todo : levelRequirment
        static::canBuy($pConfig, $pWallet);
    }

    public static function typeBuildingExist ($pNewConfig, $pConfig) {
        global $db;
        if (!isset($pNewConfig) || empty($pNewConfig)) {
            // todo : send
            // todo : et rollback du coup
            // besoin de idClientbuilding du coup
            $db->rollBack();
            echo "Level superior than: ".$pConfig[BuildingUpgrade::COLUMN_LEVEL]." is unknow in database.";
            exit;
        }
    }

    public static function buildingExist ($pBuilding) {
        global $db;
        if (!isset($pBuilding) || empty($pBuilding)) {
            // todo : send
            // todo : rollback
            $db->rollBack();
            echo "Building don't exist in database.";
            exit;
        }
    }

    private static function canBuy ($pConfig, $pWallet) {
        global $db;

        $canBuy = BuildingCommonCode::canBuy($pConfig, $pWallet);

        if (!$canBuy) {
            $db->rollBack();
            echo "Cannot updrage building, no money";
            exit;

            //Send::refuseAddBuilding($pInfo, Send::BUILDING_CANNOT_BUILD_NOT_ENOUGH_MONEY);
        }
    }
}