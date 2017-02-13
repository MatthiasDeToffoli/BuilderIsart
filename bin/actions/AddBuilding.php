<?php
/**
 * User: RABIERAmbroise
 * Date: 01/02/2017
 * Time: 15:20
 */


namespace actions;

include_once("utils/Utils.php");
include_once("utils/Send.php");
include_once("utils/Logs.php");
include_once("ValidAddBuilding.php");
include_once("utils/FacebookUtils.php");

class AddBuilding
{
    const TABLE_BUILDING = "Building";
    const ID_CLIENT_BUILDING = "IDClientBuilding";
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
            ValidAddBuilding::validate(static::getInfo())
        );

    }

    // todo : tenter d'envoyer des valeur mindfuck poru voir si je casse ou pas ?
    private static function getInfo () {
        return [
            static::ID_CLIENT_BUILDING => static::getSinglePostValueInt(static::ID_CLIENT_BUILDING),
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