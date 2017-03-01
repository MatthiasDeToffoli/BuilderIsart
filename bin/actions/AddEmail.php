<?php
/**
 * User: RABIERAmbroise
 * Date: 01/03/2017
 * Time: 10:00
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Table as Table;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Table.php");

class AddEmail
{
    const EMAIL = "email";

    public static function doAction () {
        $lEmail = Utils::getSinglePostValue(static::EMAIL);

        if (filter_var($lEmail, FILTER_VALIDATE_EMAIL)) {

            Utils::updateSetWhere(
                Table::Player,
                ["Email" => $lEmail],
                // method toString not defined on FacebookUtils:getId(),
                // and parse_str returning nothing, work whit json_encode..
                "ID=".json_encode(FacebookUtils::getId()),
                false
            );
        } else {
            echo "Email is not valid";
            exit;
        }
    }

}

AddEmail::doAction();