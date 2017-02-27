<?php

 use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Resources;
use actions\utils\Send as Send;
 
$functionExe = str_replace("/", "", $_POST["funct"]);
$IdIntern = intval(str_replace("/", "", $_POST["idInt"]));
$stepIndex = intval(str_replace("/", "", $_POST["stepIndex"]));
$steps = array(intval(str_replace("/", "", $_POST["step1"])), intval(str_replace("/", "", $_POST["step2"])), intval(str_replace("/", "", $_POST["step3"])));
$boost = intval(str_replace("/", "", $_POST["boost"]));
$price = intval(str_replace("/", "", $_POST["price"]));

include_once("utils/FacebookUtils.php");
include_once("utils/Resources.php");
include_once("utils/Send.php");
switch ($functionExe) {
  case "ADD": addQuest($IdIntern, $steps, $price); break;
  case "REM" : removeQuest($IdIntern); break;
  case "UPDT" : updateQuestTime($IdIntern, $stepIndex, $boost); break;
  case "GET_SPE_JSON": getJson(); break;
  default: echo "No function"; break;
}

function addQuest($IdIntern, $steps, $price) {
  global $db;

  $ID = FacebookUtils::getId();
  $req = "INSERT INTO TimeQuest(IDPlayer, IDIntern, StartTime, Step1, Step2, Step3, StepIndex, Boosted) VALUES (:playerId, :internRef, :creation, :step1, :step2, :step3, 0, false)";

  try {
    $reqPre = $db->prepare($req);

	$creation = new DateTime('NOW');
	$creation = $creation->format('Y-m-d\TH:i:sP');
	
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':internRef', $IdIntern);
    $reqPre->bindParam(':creation', $creation);
    $reqPre->bindParam(':step1', $steps[0]);
    $reqPre->bindParam(':step2', $steps[1]);
    $reqPre->bindParam(':step3', $steps[2]);

    $reqPre-> execute();
	
	$gold = Resources::getResources($ID);
	
	if ($price > $gold["soft"]) {
		echo json_encode(
				array (
					"errorID" => Send::INTERN_NO_GOLD_FOR_QUEST,
					"idIntern" => $idIntern
				)
			);
			exit;
	}
	
	Resources::updateResources(
        $ID,
        "soft",
        $gold["soft"] - $price
    );
	
	echo "done";
	exit;
	
  } catch (Exception $e) {
    echo $e->getMessage();
    exit;
  }
}

function removeQuest($IdIntern) {
  global $db;

  $ID = FacebookUtils::getId();
  $req = "DELETE FROM TimeQuest WHERE IDIntern = :internId AND IDPlayer = :playerId";

  try {
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':internId', $IdIntern);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->execute();
  }
  catch (Exception $e) {
    echo $e->getMessage();
  }

}

function updateQuestTime($IdIntern, $stepIndex, $boost) {
  global $db;

  $ID = FacebookUtils::getId();
  $req= "UPDATE TimeQuest SET StepIndex = :indexStep, Boosted = :isBoost WHERE IDIntern = :internId AND IDPlayer = :playerId";
  
  try {
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':indexStep', $stepIndex);
    $reqPre->bindParam(':internId', $IdIntern);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':isBoost', $boost);
    $reqPre->execute();
  }
  catch (Exception $e) {
    echo $e->getMessage();
  }

}

function getJson() {
  global $db;

  $ID = FacebookUtils::getId();
  $req = "SELECT IDIntern,StartTime,Step1,Step2,Step3,StepIndex,Boosted FROM TimeQuest WHERE IDPlayer = :playerId";

  try {
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->execute();
    $res = $reqPre-> fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($res);
  } catch (Exception $e) {
    echo $e->getMessage();
    exit;
  }
}

?>
