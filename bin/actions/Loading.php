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
    const TABLE_TO_LOAD = "Building";
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
            for ($j = 0; $j < $lLength2; $j++) {
                unset($result[$lTable[$i]][$j][static::COLUMN_ID]);
                unset($result[static::TABLE_BUILDING][$j][static::COLUMN_ID_PLAYER]);
            }

            if ($lTable[$i] == static::TABLE_BUILDING) {
                for ($j = 0; $j < $lLength2; $j++) {
                    $result[static::TABLE_BUILDING][$j][static::COLUMN_START_CONSTRUCTION] = Utils::timeStampToJavascript(
                        Utils::dateTimeToTimeStamp(
                            $result[static::TABLE_BUILDING][$j][static::COLUMN_START_CONSTRUCTION]
                        )
                    );
                    $result[static::TABLE_BUILDING][$j][static::COLUMN_END_CONSTRUCTION] = Utils::timeStampToJavascript(
                        Utils::dateTimeToTimeStamp(
                            $result[static::TABLE_BUILDING][$j][static::COLUMN_END_CONSTRUCTION]
                        )
                    );
                }
            }

        }

        return $result;
    }
}

echo json_encode(Loading::doAction());