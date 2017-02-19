<?php
/**
 * User: RABIERAmbroise
 * Date: 19/02/2017
 * Time: 13:24
 */

namespace actions;

include_once("BuildingUpgrade.php");

class ValidBuildingUpgrade
{
    public static function validate ($pInfo, $pBuildingInDB, $pConfig, $pNewConfig) {
        // todo :  has money
        // todo : levelRequirment
    }

    public static function typeBuildingExist ($pNewConfig, $pConfig) {
        if (!isset($pNewConfig) || empty($pNewConfig)) {
            // todo : send
            // todo : et rollback du coup
            // besoin de idClientbuilding du coup
            echo "Level superior than: ".$pConfig[BuildingUpgrade::COLUMN_LEVEL]." is unknow in database.";
            exit;
        }
    }

    public static function buildingExist ($pBuilding) {
        if (!isset($pBuilding) || empty($pBuilding)) {
            // todo : send
            // todo : rollback
            echo "Building don't exist in database.";
            exit;
        }
    }
}