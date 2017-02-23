<?php
/**
 * User: RABIERAmbroise
 * Date: 20/02/2017
 * Time: 12:50
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");

class Loading
{
    const TABLE_BUILDING = "Building";
    const TABLE_RESOURCES = "Resources";
    const TABLE_TO_LOAD = "Building,Resources";
    const COLUMN_ID = "ID";
    const COLUMN_ID_PLAYER = "IDPlayer";
    const COLUMN_START_CONSTRUCTION = "StartConstruction";
    const COLUMN_END_CONSTRUCTION = "EndConstruction";

    public static function doAction () {
        $lTable = explode(",", static::TABLE_TO_LOAD);
        $lLength = count($lTable);
        $result = [];
        for ($i = 0; $i < $lLength; $i++) {
            $result[$lTable[$i]] = Utils::getTable($lTable[$i], "IDPlayer=".strval(FacebookUtils::getId()));

            $lLength2 = count($result[$lTable[$i]]);
            $result[$lTable[$i]] = static::unsetPrivateFields($result[$lTable[$i]], $lLength2);

            $lLength2 = count($result[$lTable[$i]]);
            if ($lTable[$i] == static::TABLE_BUILDING)
                $result[static::TABLE_BUILDING] = static::convertDateTimes($result[static::TABLE_BUILDING], $lLength2);
        }

        return $result;
    }

    private static function convertDateTimes ($pTable, $pLength2) {
        for ($j = 0; $j < $pLength2; $j++) {
            if (array_key_exists(static::COLUMN_START_CONSTRUCTION, $pTable[$j]))
                $pTable[$j][static::COLUMN_START_CONSTRUCTION] = Utils::timeStampToJavascript(
                    Utils::dateTimeToTimeStamp(
                        $pTable[$j][static::COLUMN_START_CONSTRUCTION]
                    )
                );
            if (array_key_exists(static::COLUMN_END_CONSTRUCTION, $pTable[$j]))
                $pTable[$j][static::COLUMN_END_CONSTRUCTION] = Utils::timeStampToJavascript(
                    Utils::dateTimeToTimeStamp(
                        $pTable[$j][static::COLUMN_END_CONSTRUCTION]
                    )
                );
        }
        return $pTable;
    }

    private static function unsetPrivateFields ($pTable, $pLength2) {
        for ($j = 0; $j < $pLength2; $j++) {
            unset($pTable[$j][static::COLUMN_ID]);

            if (array_key_exists(static::COLUMN_ID_PLAYER, $pTable[$j]))
                unset($pTable[$j][static::COLUMN_ID_PLAYER]);
        }

        return $pTable;
    }
}

echo json_encode(Loading::doAction());