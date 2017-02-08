<?php

$functionExe = str_replace("/", "", $_POST["funct"]);
$IdIntern = intval(str_replace("/", "", $_POST["idInt"]));
$progress = intval(str_replace("/", "", $_POST["prog"]));
$stepIndex = intval(str_replace("/", "", $_POST["stepIndex"]));
$steps = array(intval(str_replace("/", "", $_POST["step1"])), intval(str_replace("/", "", $_POST["step2"])), intval(str_replace("/", "", $_POST["step3"])));

Include("FacebookUtils.php");
switch ($functionExe) {
  case "ADD": addQuest($IdIntern, $progress, $stepIndex, $steps); break;
  case "REM" : removeQuest($IdIntern); break;
  case "UPDT" : updateQuestTime($IdIntern, $progress, $stepIndex); break;
  case "GET_SPE_JSON": getJson(); break;
  default: echo "No function"; break;
}

function addQuest($IdIntern, $progress, $stepIndex, $steps) {
  global $db;

  $ID = getId();
  $req = "INSERT INTO TimeQuest(IdPlayer, RefIntern, Progress, StepIndex, Step1, Step2, Step3) VALUES (:playerId, :internRef, :prog, :indexStep, :step1, :step2, :step3)";

  try {
    $reqPre = $db->prepare($req);

    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':internRef', $IdIntern);
    $reqPre->bindParam(':prog', $progress);
    $reqPre->bindParam(':indexStep', $stepIndex);
    $reqPre->bindParam(':step1', $steps[0]);
    $reqPre->bindParam(':step2', $steps[1]);
    $reqPre->bindParam(':step3', $steps[2]);

    $reqPre->execute();
  } catch (Exception $e) {
    echo $e->getMessage();
    exit;
  }
}

function removeQuest($IdIntern) {
  global $db;

  $ID = getId();
  $req = "DELETE FROM TimeQuest WHERE RefIntern = :internId AND IdPlayer = :playerId";

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

function updateQuestTime($IdIntern, $progress, $stepIndex) {
  global $db;

  $ID = getId();
  $req= "UPDATE TimeQuest SET Progress = :prog, StepIndex = :indexStep WHERE RefIntern = :internId AND IdPlayer = :playerId";

  try {
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':prog', $progress);
    $reqPre->bindParam(':indexStep', $stepIndex);
    $reqPre->bindParam(':internId', $IdIntern);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->execute();
  }
  catch (Exception $e) {
    echo $e->getMessage();
  }

}

function getJson() {
  global $db;

  $ID = getId();
  $req = "SELECT RefIntern,Progress,StepIndex,Step1,Step2,Step3 FROM TimeQuest WHERE IdPlayer = :playerId";

  try {
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->execute();
    $res = $reqPre->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($res);
  } catch (Exception $e) {
    echo $e->getMessage();
    exit;
  }
}

?>
