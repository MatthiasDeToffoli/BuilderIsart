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
    const TABLE_PLAYER = "Player";
    const TABLE_TO_LOAD = "Building,Resources,Player,Region";
    const COLUMN_ID = "ID";
    const COLUMN_ID_PLAYER = "IDPlayer";
    const COLUMN_START_CONSTRUCTION = "StartConstruction";
    const COLUMN_END_CONSTRUCTION = "EndConstruction";
    const COLUMN_END_FOR_NEXT_PRODUCTION = "EndForNextProduction";
    const COLUMN_END_OF_CAMPAIGN = "EndOfCampaign";
    const COLUMN_DATE_FOR_INVITE_SOUL = "DateForInvitedSoul";
    const COLUMN_DATE_FOR_SEE_ADD_IN_SHOP = "DateForSawAdInShop";
    const COLUMN_DATE_FOR_SEE_ADD_IN_MARKETING = "DateForSawAdInMarketing";

    public static function doAction () {
        $lTable = explode(",", static::TABLE_TO_LOAD);
        $lLength = count($lTable);
        $result = [];
        for ($i = 0; $i < $lLength; $i++) {
            if ($lTable[$i] == static::TABLE_PLAYER)
                $result[$lTable[$i]] = Utils::getTable($lTable[$i], "ID=".strval(FacebookUtils::getId()));
            else
                $result[$lTable[$i]] = Utils::getTable($lTable[$i], "IDPlayer=".strval(FacebookUtils::getId()));

            $lLength2 = count($result[$lTable[$i]]);
            $result[$lTable[$i]] = static::unsetPrivateFields($result[$lTable[$i]], $lLength2);

            $lLength2 = count($result[$lTable[$i]]);
            if ($lTable[$i] == static::TABLE_BUILDING)
                $result[static::TABLE_BUILDING] = static::convertDateTimes($result[static::TABLE_BUILDING], $lLength2);
            else if($lTable[$i] == static::TABLE_PLAYER)
              $result[static::TABLE_PLAYER][0] = static::convertDateTimesPlayer($result[static::TABLE_PLAYER][0]);
        }

        return $result;
    }

    private static function convertDateTimes ($pTable, $pLength2) {
        for ($j = 0; $j < $pLength2; $j++) {
            // todo : do another array whit the COLUMN name that need to be converted, and make the conversion more dry.
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

                if (array_key_exists(static::COLUMN_END_FOR_NEXT_PRODUCTION, $pTable[$j]))
                    if($pTable[$j][static::COLUMN_END_FOR_NEXT_PRODUCTION] != null)
                    $pTable[$j][static::COLUMN_END_FOR_NEXT_PRODUCTION] = Utils::timeStampToJavascript(
                        Utils::dateTimeToTimeStamp(
                            $pTable[$j][static::COLUMN_END_FOR_NEXT_PRODUCTION]
                        )
                    );
        }
        return $pTable;
    }

    private static function convertDateTimesPlayer ($pTable) {
            if($pTable[static::COLUMN_END_OF_CAMPAIGN] != null)
                $pTable[static::COLUMN_END_OF_CAMPAIGN] = Utils::timeStampToJavascript(
                    Utils::dateTimeToTimeStamp(
                        $pTable[static::COLUMN_END_OF_CAMPAIGN]
                    )
                );

              if($pTable[static::COLUMN_DATE_FOR_INVITE_SOUL] != null)
                  $pTable[static::COLUMN_DATE_FOR_INVITE_SOUL] = Utils::timeStampToJavascript(
                      Utils::dateTimeToTimeStamp(
                          $pTable[static::COLUMN_DATE_FOR_INVITE_SOUL]
                      )
                  );

                if($pTable[static::COLUMN_DATE_FOR_SEE_ADD_IN_SHOP] != null)
                    $pTable[static::COLUMN_DATE_FOR_SEE_ADD_IN_SHOP] = Utils::timeStampToJavascript(
                        Utils::dateTimeToTimeStamp(
                            $pTable[static::COLUMN_DATE_FOR_SEE_ADD_IN_SHOP]
                        )
                    );

                  if($pTable[static::COLUMN_DATE_FOR_SEE_ADD_IN_MARKETING] != null)
                      $pTable[static::COLUMN_DATE_FOR_SEE_ADD_IN_MARKETING] = Utils::timeStampToJavascript(
                          Utils::dateTimeToTimeStamp(
                              $pTable[static::COLUMN_DATE_FOR_SEE_ADD_IN_MARKETING]
                          )
                      );
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
