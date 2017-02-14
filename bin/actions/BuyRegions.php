

<?php

use actions\utils\Config as Config;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Player as Player;
use actions\utils\Regions as Regions;
use actions\utils\Resources as Resources;

/**
* @author: de Toffoli Matthias
* check if the player can buy a region and buy it if he can.
*/
  $TYPE_STYX = "neutral";
  $TYPE_HEAVEN = "heaven";
  $TYPE_HELL = "hell";
  $regionType = str_replace("/", "", $_POST["type"]);
  $regionX = intval(str_replace("/", "", $_POST["x"]));
  $regionY = intval(str_replace("/", "", $_POST["y"]));
  $firstTileX = intval(str_replace("/", "", $_POST["firstTileX"]));
  $firstTileY = intval(str_replace("/", "", $_POST["firstTileY"]));

  if(($regionType != $TYPE_HELL && $regionX > 0) || ($regionType != $TYPE_HEAVEN && $regionX < 0) || ($regionType != $TYPE_STYX && $regionX == 0)){
    echo json_encode(Array("flag" => false, "message" => "are you try seriously to add a region to the wrong side ? Oo don't try to hack this game -_-"));
    exit;
  }

  addToTable($regionType,$regionX,$regionY,$firstTileX,$firstTileY);

  /**
	 * test if we can add the region in the table and add this if we can
	 * @param	$Type the type of the region we want to add
	 * @param	$X the position X of the region in world map
	 * @param	$Y the position Y of the region in world map
	 * @param	$FTX the position X of the first tile of the region
	 * @param	$FTY the position Y of the first tile of the region
	 */
  function addToTable($Type, $X,$Y,$FTX,$FTY){
    include_once("utils/FacebookUtils.php");
    include_once("utils/Regions.php");
    include_once("utils/Player.php");
    include_once("utils/Config.php");
    include_once("utils/Resources.php");

    global $db;

    $Id = FacebookUtils::getId();
    $messageBack = Regions::testPosition($Id,$Type,$X,$Y);
    if(!$messageBack["flag"]){
      echo json_encode($messageBack);
      exit;
    }

    $nbRegion = Player::getRegionQuantity($Id, $Type);

    if($X == 0){
      $price = 0;
      $xpHeaven = 0;
      $xpHell = 0;
    }
    else {

      $Config = Config::getConfig();

       $price = $Config->PriceRegion * pow($Config->FactorRegionGrowth,$nbRegion);
       $xp1 = $Config->RegionXpSameSide * pow($Config->FactorRegionGrowth,$nbRegion);
       $xp2 = $Config->RegionXpOtherSide * pow($Config->FactorRegionGrowth,$nbRegion);
      if(abs($X) == 1) {
        $price *= $Config->FactorRegionNearStyx;
        $xp1 *= $Config->FactorRegionNearStyx;
        $xp2 *= $Config->FactorRegionNearStyx;
      }

      $xpHell = $X > 0 ? $xp1:$xp2;
      $xpHeaven = $X < 0 ? $xp1:$xp2;

      $nbRegion++;
    }

    $moneyRest = Resources::getResource($Id, "soft") - $price;


    if($moneyRest < 0) {
      $messageBack =  Array("flag" => false,"message" => "not enought money you must have ".abs($moneyRest)." in more");
      echo json_encode($messageBack);
      exit;
    }

    Player::setRegionQuantity($Id,$Type,$nbRegion);
    Regions::createRegion($Id,$Type,$X,$Y,$FTX,$FTY);
    Resources::updateResources($Id, "soft", $moneyRest);

    $messageBack =  Array("flag" => true,"x" => $X, "y" => $Y, "type" => $Type, "ftx" => $FTX, "fty" => $FTY, "price" => $price, "xpHeaven" => $xpHeaven, "xpHell" => $xpHell);


    echo json_encode($messageBack);
  }
?>
