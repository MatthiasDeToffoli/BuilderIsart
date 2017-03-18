<?php
use actions\utils\Utils as Utils;
use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Resources as Resources;
use actions\utils\PackUtils as PackUtils;
use actions\utils\Player as Player;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Player.php");
include_once("utils/PackUtils.php");
include_once("utils/Resources.php");

  const NAME = 'Name';
  const MONEYTYPE = 'hard';

  $lId = FacebookUtils::getId();

  $pack = PackUtils::getPackByName(Utils::getSinglePostValue(NAME));
  $resource = Resources::getResource($lId,MONEYTYPE);
  $lTime = 0;

if($pack->CostKarma > 0) {
    $resource->Quantity -= $pack->CostKarma;
} else {
  $player = Player::getPlayerById(FacebookUtils::getId());

  if($player->DateForSawAdInMarketing !== null) {
    $lTimeMarketing = Utils::dateTimeToTimeStamp($player->DateForSawAdInMarketing);

    if($lTimeMarketing > time()) {
      echo json_encode(['error' => true, 'message' => 'you can not saw a ad video for now', 'timeBlock' => Utils::timeStampToJavascript($lTimeMarketing)]);
      exit;
    }
  }
  $lTime = time() + 24*60*60;

  Player::update($lId,[
  'DateForSawAdInMarketing' => Utils::timeStampToDateTime($lTime)
]);

}

  if($resource->Quantity < 0) {
    echo json_encode([
      'error' => true,
      'message' => 'not have enought money',
      MONEYTYPE => $resource->Quantity + $pack->CostKarma
  ]);
  exit;
  }

  $end = Utils::timeToTimeStamp($pack->Time) + time();
  Resources::updateResources($lId,MONEYTYPE,$resource->Quantity);
  Player::update($lId,[
    'IdCampaign' => $pack->ID,
    'EndOfCampaign' => Utils::timeStampToDateTime($end)
]);

echo json_encode([
  'error' => false,
  MONEYTYPE => $resource->Quantity,
  'time' => Utils::timeStampToJavascript($end),
  'timeBlock' => Utils::timeStampToJavascript($lTime)
]);
?>
