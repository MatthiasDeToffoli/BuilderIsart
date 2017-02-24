<?php
/**
 * User: RABIERAmbroise
 * Date: 08/02/2017
 * Time: 11:36
 */

namespace actions\utils;


class Utils
{
    const DATETIME_FORMAT = 'Y-m-d H:i:s';


    // ##############################################################
    // POST
    // ##############################################################

    public static function getSinglePostValue ($pKey) {
        if(array_key_exists($pKey, $_POST)) {
            return str_replace("/", "", $_POST[$pKey]);
        } else {
            echo "Value for key : ".$pKey." is missing in POST.";
            exit;
        }
    }

    public static function getSinglePostValueInt ($pKey) {
        return intval(static::getSinglePostValue($pKey));
    }


    // ##############################################################
    // DATABASE
    // ##############################################################

    public static function insertInto ($pTable, $pAssocArray) {
        global $db;

        $req = static::bindParamInsertInto($pTable, $pAssocArray);
        $reqPre = $db->prepare($req); // can be outside try catch, it's ok

        try {
			//$db->beginTransaction(); not usefull because only one request and SQL is mono-thread so no conflict
            $reqPre-> execute();
			//$db->commit();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }

    private static function bindParamInsertInto ($pTable, $pAssocArray) {
        $lValueArray = static::addApostropheToStringsArray(array_values($pAssocArray));

        $lKeys = "(".implode(", ", array_keys($pAssocArray)).")";
        $lValues = "(".implode(", ", $lValueArray).")";


        $lSQLInsert = "INSERT INTO ".$pTable.$lKeys;
        $lSQLValues = " VALUES ".$lValues;
        return $lSQLInsert.$lSQLValues;
    }

    // error if you put some " in string..., what is ->prepare for ??
    private static function addApostropheToStringsArray ($pArray) {
        return array_map(function ($lValue) {
            return static::addApostropheToStrings($lValue);

        }, $pArray);
    }

    private static function addApostropheToStrings ($pValue) {
        return is_string($pValue) ? '"'.$pValue.'"' : $pValue;
    }

    public static function getTable ($pTableName, $pSQLWhere = "1") {
        global $db;
        
        $req = "SELECT * FROM ".$pTableName." WHERE ".$pSQLWhere;
        $reqPre = $db->prepare($req);

        try {
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

        while($row = $reqPre->fetch(\PDO::FETCH_ASSOC))
        {
            $result[] = $row;
        }

        return $result[0];
    }

    /**
     * exemple : UPDATE `perle_gold`.`Building` SET RegionX = 54, RegionY = 6, X=8, Y = 34 WHERE `Building`.`ID` = 25
     * @param $pTable
     * @param $pAssocArray
     * @param $pSQLWhere
     */
    public static function updateSetWhere ($pTable, $pAssocArray, $pSQLWhere) {
        global $db;

        $req = static::bindParamUpdateSetWhere($pTable, $pAssocArray, $pSQLWhere);
        $reqPre = $db->prepare($req);


        try {
            $reqPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }

    private static function bindParamUpdateSetWhere ($pTable, $pAssocArray, $pSQLWhere) {
        $lSetParams = [];

        foreach ($pAssocArray as $key=>$value) {
            //exemple of push : "RegionY=6"
            array_push($lSetParams, $key."=".static::addApostropheToStrings($value));
        }

        $lSQLUpdate = "UPDATE ".$pTable;
        $lSQLSet = " SET ".implode(",",$lSetParams); // exemple : "RegionX=54, RegionY=6"
        $pSQLWhere = " WHERE ".$pSQLWhere;

        return $lSQLUpdate.$lSQLSet.$pSQLWhere;
    }

    public static function delete ($pTableName, $pSQLWhere) {
        global $db;

        $req = "DELETE FROM ".$pTableName." WHERE ".$pSQLWhere;
        $reqPre = $db->prepare($req);

        try {
            $reqPre->execute();
        } catch (\Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }


    // ##############################################################
    // TIME
    // ##############################################################

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
