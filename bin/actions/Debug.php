<?php
/**
* @author: de Toffoli Matthias
* for test the call of a php fille (test error communications haxe php)
*/
//use this for test your bdd call
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/FacebookUtils.php");

echo json_encode(FacebookUtils::getId());
?>
