<?php
/**
 * User: RABIERAmbroise
 * Date: 08/02/2017
 * Time: 11:36
 */

namespace actions;


class Utils
{
    const DATETIME_FORMAT = 'Y-m-d H:i:s';

    public static function insertInto ($pTable, $pAssocArray) {
        global $db;

        $req = static::bindParamInsertInto($pTable, $pAssocArray);
        $reqPre = $db->prepare($req);
		
        try {
			$db->beginTransaction();
            $reqPre-> execute();
			$db->commit();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }

    private static function bindParamInsertInto ($pTable, $pAssocArray) {
        $lValueArray = static::addApostropheToStrings(array_values($pAssocArray));

        $lKeys = "(".implode(", ", array_keys($pAssocArray)).")";
        $lValues = "(".implode(", ", $lValueArray).")";


        $lSQLInsert = "INSERT INTO ".$pTable.$lKeys;
        $lSQLValues = " VALUES ".$lValues;
        return $lSQLInsert.$lSQLValues;
    }

    private static function addApostropheToStrings ($pArray) {
        return array_map(function ($lValue) {
            return is_string($lValue) ? "'".$lValue."'" : $lValue;
        }, $pArray);
    }

    public static function getTable ($pTableName) {
        global $db;
        try {
            $req = "SELECT * FROM ".$pTableName." WHERE 1";
            $reqPre = $db->prepare($req);
            $reqPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }

        while($row = $reqPre->fetch(\PDO::FETCH_ASSOC))
        {
            $result[] = $row;
        }

        return $result;
    }

    public static function getTableRowByID ($pTableName, $pID) {
        global $db;
        try {
            $req = "SELECT * FROM ".$pTableName." WHERE ID=".$pID;
            $reqPre = $db->prepare($req);
            $reqPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
        // todo : à quoi serventl es autres FETCH_*** ?
        while($row = $reqPre->fetch(\PDO::FETCH_ASSOC))
        {
            $result[] = $row;
        }

        return $result[0];
    }

    /**
     * Convert a timestamp in a DateTime, exemple : timestamp to "2017-02-09 17:04:21"
     * @param $pTimeStamp
     * @return string
     */
    public static function timeStampToDateTime ($pTimeStamp) {
        $date = new \DateTime();
        $date->setTimestamp($pTimeStamp);
        return $date->format(static::DATETIME_FORMAT);
    }

    /**
     * @param $pStringDate (exemple : "2017-02-09 17:04:21")
     * @return int timestamp
     */
    public static function dateTimeToTimeStamp ($pStringDate) {
        $date = new \DateTime();
        $date = $date->createFromFormat(static::DATETIME_FORMAT, $pStringDate);
        return $date->getTimestamp();
    }

    /**
     * Convert php timestamp (seconds) in js timestamp (milliseconds)
     * @param $pInt
     * @return mixed
     */
    public static function timeStampToJavascript ($pInt) {
        return $pInt * 1000;
    }

    // todo : function inveres DateTimeToTimeStamp ? voir strtotime() et \DateTime()

    /**
     * Convert for exemple value "00:30:00" in a timeStamp. (seconds)
     * @param $pTime string
     * @return int timestamp in seconds
     */
    public static function timeToTimeStamp ($pTime) {
        $lArray = explode(":",$pTime);
        $lArray[0] = intval($lArray[0]) * 3600;
        $lArray[1] = intval($lArray[1]) * 60;
        $lArray[2] = intval($lArray[2]);

        return array_sum($lArray);
    }
}

?>