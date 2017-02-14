<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 12:33
 */

namespace actions;

include_once("Utils.php");

/**
 * Class Logs
 * @package actions
 */
class Logs
{
	//public
    const STATUS_ACCEPTED = "Accepted";
    const STATUS_PENDING = "Pending";
    const STATUS_REFUSED = "Refused";
    // accepted ::: "blabla j'accepte par mon le pouvoir qui m'est donné à la naissance.. de faire ceci et cela",
    // refused ::: "refuse car tu cheat, gros noob, tu as essayé de faire ceci, mais tu peux pas car ...",
    // error   ::: "sa craint, php renvoit une erreur ! mais le client n'a rien vu :)"

    //const STATUS_ERROR = "Error"; // todo : cela a t-il vraiment du sens ? le serveur store déjà des logs
    // et de plus ajouter un "Debug.error()" à chaque try catch est factidieux.

	// private
    const MAX_CHARACTER_FOR_DATA = 1000;
    const TABLE_LOGS = "Logs";
    const PLAYER_ID = "IDPlayer";
    const MODULE = "Module";
    const STATUS = "Status";
    const MESSAGE = "Message";
    const DATA = "Data";


    /**
     * @param $pPlayerID
     * @param $pStatus
     * @param null $pErrorCode
     * @param null $pData (limited to 1000 characters)
     */
    public static function addBuilding ($pPlayerID, $pStatus, $pErrorCode = null, $pData = null) {
        Utils::insertInto(static::TABLE_LOGS, [
            static::PLAYER_ID => $pPlayerID,
            static::MODULE => $_POST[KEY_POST_FILE_NAME].".php",
            static::STATUS => $pStatus,
            static::MESSAGE => $pErrorCode != null ? static::errorCodeToMessage($pErrorCode) : null,
			static::DATA => substr(static::jsonEncodeNoConflictSQLQuery($pData), 0, static::MAX_CHARACTER_FOR_DATA)
        ]);
    }

    public static function moveBuilding ($pPlayerID, $pStatus, $pErrorCode = null, $pData = null) {
        Utils::insertInto(static::TABLE_LOGS, [
            static::PLAYER_ID => $pPlayerID,
            static::MODULE => Utils::getSinglePostValue(KEY_POST_FILE_NAME).".php",
            static::STATUS => $pStatus,
            static::MESSAGE => $pErrorCode != null ? static::errorCodeToMessage($pErrorCode) : null,
            static::DATA => substr(static::jsonEncodeNoConflictSQLQuery($pData), 0, static::MAX_CHARACTER_FOR_DATA)
        ]);
    }

    /**
     * change the " in the text, or syntax error in sql :/
     * todo : faire champs JSON en bdd ?
     */
    private static function jsonEncodeNoConflictSQLQuery ($pData) {
        return str_replace('"', "'", json_encode($pData));
    }

    private static function errorCodeToMessage ($pErrorCode) {
        $lTranslator = [
            Send::BUILDING_CANNOT_BUILD_COLLISION => "Cannot build., there is a collision.",
            Send::BUILDING_CANNOT_MOVE_DONT_EXIST => "Cannot move, building don't exist in database.",
            Send::BUILDING_CANNOT_BUILD_OUTSIDE_REGION => "Cannot build outside région",
            Send::BUILDING_CANNOT_MOVE_COLLISION => "Cannot move, there is a collision.",
            Send::BUILDING_CANNOT_BUILD_NOT_ENOUGH_MONEY => "Cannot build, not enough money."
        ];

        if (array_key_exists($pErrorCode, $lTranslator))
            return $lTranslator[$pErrorCode];
        else
            return "ErrorCode: ".$pErrorCode;
    }

}