<?php
    /**
     * User: RABIERAmbroise
     * Date: 08/01/2017
     * Time: 10:36
     */
namespace actions;

class JsonCreator // fichier du même nom ?
{
    const TABLE = "Config,TypeBuilding,TypeIntern,TypeShopPack,TypePack,Interns,LevelReward,MaxExp,Choices,ConfigEvent,SoulName,SoulAdjective";
    const JSON_GAME_CONFIG_NAME= "./assets/json/game_config.json";

    public static function update () {
        $lTable = explode(",", static::TABLE);
        $lLength = count($lTable);
        $result = [];
        for ($i = 0; $i < $lLength; $i++) {
            $result[$lTable[$i]] = static::getTable($lTable[$i]);
        }

        static::writeJson($result);

        return $result;
    }

    private static function getTable ($pTableName) {
        global $db;
        try {
            $req = "SELECT * FROM ".$pTableName." WHERE 1";
            $reqPre = $db->prepare($req);
            //$reqPre->bindParam(':tableName', $pTableName); marche pas ici :/
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

    private static function writeJson ($pConfig) {
        $fp = fopen(static::JSON_GAME_CONFIG_NAME, 'w');
        fwrite($fp, json_encode($pConfig));
        fclose($fp);
    }
}

echo json_encode(JsonCreator::update());
