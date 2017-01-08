<?php
    /**
     * User: RABIERAmbroise
     * Date: 08/01/2017
     * Time: 10:36
     */

include("base.php");

class JsonCreator // fichier du même nom ?
{
    const TABLE = "TypeBuilding,TypeIntern";


    public static function update () {
        $lTable = explode(",", static::TABLE);
        $lLength = count($lTable);
        for ($i = 0; $i < $lLength; $i++) {
            static::createJson($lTable);
        }
    }

    private static function createJson ($pTableName) {
        echo $pTableName;
        // echo static::getParamTable($pTableName);
        // echo static::getParamTable($pTableName)->rowCount();
        // echo json_encode(static::getParamTable($pTableName));
        //mysqli_fetch_assoc()
    }

    private static function getParamTable ($pTableName) {
        global $db;
        $req = "SELECT * FROM :tableName";
        $reqPre = $db->prepare($req);
        $reqPre->bindParam(':tableName', $pTableName);
        $result = $reqPre->exec();
        return $result;
    }
}

JsonCreator::update();



?>
