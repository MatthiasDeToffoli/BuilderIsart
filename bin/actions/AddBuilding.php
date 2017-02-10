<?php
/**
 * User: RABIERAmbroise
 * Date: 01/02/2017
 * Time: 15:20
 */
/*$req = "SELECT * FROM Choices";
$reqPre = $db->prepare($req);
$reqPre->execute();
$res = $reqPre->fetchAll();
try {
    $req = "SELECT * FROM ";
    $reqPre = $db->prepare($req);
    //$reqPre->bindParam(':tableName', $pTableName); marche pas ici :/
    $reqPre->execute();

    //exec("START TRANSACTION");
    //exec("SELECT ... FOR UPDATE");
    //exec("COMMIT");
    //$db->beginTransaction();
    //$db->commit(); // je suis pas sûr de comprendre, c'est la meêm chose que prepare ? je crois pas
} catch (\Exception $e) {
    echo $e->getMessage();
    exit;
}

while($row = $reqPre->fetch(\PDO::FETCH_ASSOC))
{
    $result[] = $row;
}

return $result;

echo json_encode($result);*/

/*typedef TileDescription = {
    var buildingName:String; // sûr ? pose problème si on change l'assetName non ?
    var id:Int;
    var regionX:Int;
    var regionY:Int;
    var mapX:Int;
    var mapY:Int;
    var level:Int;
    @:optional var currentPopulation:Int;
	@:optional var maxPopulation:Int;
	@:optional var timeDesc:TimeDescription;
	@:optional var isTribunal:Bool;*/

namespace actions;

include_once("Utils.php");
include_once("Send.php");
include_once("Logs.php");
include_once("ValidBuilding.php");
include_once("FacebookUtils.php");

class AddBuilding
{
    const TABLE_BUILDING = "Building";
    const ID_TYPE_BUILDING = "IDTypeBuilding";
    const ID_PLAYER = "IDPlayer";
    const START_CONTRUCTION = "StartConstruction";
    const END_CONTRUCTION = "EndConstruction";
    const LEVEL = "Level";
    const NB_RESOURCE = "NbResource";
    const NB_SOUL = "NbSoul";
    const REGION_X = "RegionX";
    const REGION_Y = "RegionY";
    const X = "X";
    const Y = "Y";


    public static function add () {
        //ValidBuilding::setConfigForBuilding(); n'arrive pas à temps ,asynchrone :/
        Utils::insertInto(
            static::TABLE_BUILDING,
            ValidBuilding::validate(static::getInfo())
        );

    }

    // todo : tenter d'envoyer des valeur mindfuck poru voir si je casse ou pas ?
    private static function getInfo () {
        return [
            static::ID_TYPE_BUILDING => static::getSinglePostValueInt(static::ID_TYPE_BUILDING),
            static::ID_PLAYER => 55, //getId(), // todo : temporaire....
            static::LEVEL => 1,
            static::NB_RESOURCE => 0,
            static::NB_SOUL => 0,
            static::REGION_X => static::getSinglePostValueInt(static::REGION_X),
            static::REGION_Y => static::getSinglePostValueInt(static::REGION_Y),
            static::X => static::getSinglePostValueInt(static::X),
            static::Y => static::getSinglePostValueInt(static::Y),
        ];

    }

    private static function getSinglePostValue ($pKey) {
        if(array_key_exists($pKey, $_POST)) {
            return str_replace("/", "", $_POST[$pKey]);
        } else {
            echo "Value for key : ".$pKey." is missing in POST.";
            exit;
        }
    }

    private static function getSinglePostValueInt ($pKey) {
        return intval(static::getSinglePostValue($pKey));
    }

}

AddBuilding::add();