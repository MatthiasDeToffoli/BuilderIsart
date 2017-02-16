<?php
//use this for test your bdd call
use actions\utils\FacebookUtils as FacebookUtils;

include_once("utils/FacebookUtils.php");

echo json_encode(FacebookUtils::getId());
?>
