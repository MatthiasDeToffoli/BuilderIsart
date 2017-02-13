<?php
/**
 * User: RABIERAmbroise
 * Date: 09/02/2017
 * Time: 12:33
 */

namespace actions;

include_once("./utils/Utils.php");

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
    //const STATUS_ERROR = "Error"; // todo : cela a t-il vraiment du sens ? le serveur store déjà des logs
    // et de plus ajouter un "Debug.error()" à chaque try catch est factidieux.
    // todo : Send.php envoit des codes erreurs, utiliser les mêmes message pour le client et les logs ?
    // plus facile à gérer honnêtement.

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
     * @param null $pData (limited to 1000 characters)
     */
    public static function addBuilding ($pPlayerID, $pStatus, $pData = null) {
        Utils::insertInto(static::TABLE_LOGS, [
            static::PLAYER_ID => $pPlayerID,
            static::MODULE => $_POST[KEY_POST_FILE_NAME].".php",
            static::STATUS => $pStatus,
            static::MESSAGE => "Fake Message : Building added whit success !", // todo : voir plus haut
            // accepted ::: "blabla j'accepte par mon le pouvoir qui m'est donné à la naissance.. de faire ceci et cela",
            // refused ::: "refuse car tu cheat, gros noob, tu as essayé de faire ceci, mais tu peux pas car ...",
            // error   ::: "sa craint, php renvoit une erreur ! mais le client n'a rien vu :)"
			static::DATA => substr(json_encode($pData), 0, static::MAX_CHARACTER_FOR_DATA)
        ]);
    }

}