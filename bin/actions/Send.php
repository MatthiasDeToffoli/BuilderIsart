<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 19:30
 */

namespace actions;


class Send
{
    const BUILDING_CANNOT_BUILD = 0;

    // todo : tester , utiliser pour les erreurs de la bdd également après avoir changé error_reporting(0); ?
    public static function errorAddBuilding ($pID, $pInfo) {
        echo json_encode(array_merge(
            [
                "errorID" => $pID,
            ],
            static::getBuildingIdentifier($pInfo)
        ));

        exit;
    }

    // todo : que se passe t-il, si je refuse la ^remière requete, et que ensuite il y en a d'autre qui arrive
    // bah le building n'ayant pas été add à la bdd, il renverra une erreur comme quoi tu ne peux pas déplacer un building
    // qui n'existe pas !
    public static function validAddBuilding ($pInfo) {
        echo json_encode(array_merge(
            [
                lcfirst(AddBuilding::START_CONTRUCTION) => Utils::timeStampToJavascript(Utils::dateTimeToTimeStamp($pInfo[AddBuilding::START_CONTRUCTION])),
                lcfirst(AddBuilding::END_CONTRUCTION) => Utils::timeStampToJavascript(Utils::dateTimeToTimeStamp($pInfo[AddBuilding::END_CONTRUCTION]))
            ],
            static::getBuildingIdentifier($pInfo)
        ));
    }

    private static function getBuildingIdentifier ($pInfo) {
        return [
            lcfirst(AddBuilding::REGION_X) => $pInfo[AddBuilding::REGION_X],
            lcfirst(AddBuilding::REGION_Y) => $pInfo[AddBuilding::REGION_Y],
            lcfirst(AddBuilding::X) => $pInfo[AddBuilding::X],
            lcfirst(AddBuilding::Y) => $pInfo[AddBuilding::Y]
        ];
    }
}