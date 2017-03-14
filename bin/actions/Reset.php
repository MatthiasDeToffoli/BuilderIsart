<?php
/**
 * User: RABIERAmbroise
 * Date: 12/03/2017
 * Time: 13:15
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Table as Table;
use actions\utils\Utils as Utils;

include_once("utils/Utils.php");
include_once("utils/Table.php");
include_once("utils/FacebookUtils.php");

class Reset
{

    public static function doAction () {
        Utils::delete(Table::Player,"Player.ID=".FacebookUtils::getId());
    }
}

Reset::doAction();