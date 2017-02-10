<?php

$functionExe = str_replace("/", "", $_POST["funct"]);
$IdIntern = intval(str_replace("/", "", $_POST["idInt"]));
$stepIndex = intval(str_replace("/", "", $_POST["stepIndex"]));
$steps = array(str_replace("/", "", $_POST["step1"]), str_replace("/", "", $_POST["step2"]), str_replace("/", "", $_POST["step3"]));
$endValue = str_replace("/", "", $_POST["tEnd"]);
$creation = str_replace("/", "", $_POST["tCrea"]);
$progress = str_replace("/", "", $_POST["prog"]);

Include("FacebookUtils.php");
switch ($functionExe) {
  case "ADD": addQuest($creation, $IdIntern, $steps, $endValue); break;
  case "REM" : removeQuest($IdIntern); break;
  case "UPDT" : updateQuestTime($IdIntern, $progress, $stepIndex); break;
  case "GET_SPE_JSON": getJson(); break;
  default: echo "No function"; break;
}

function addQuest($creation, $IdIntern, $steps, $endValue) {
  global $db;

  $ID = getId();
  $req = "INSERT INTO TimeQuest(IdPlayer, RefIntern, Creation, Step1, Step2, Step3, DateEnd, Progress, StepIndex) VALUES (:playerId, :internRef, :creation, :step1, :step2, :step3, :endDate, :prog, 0)";

  try {
    $reqPre = $db->prepare($req);

    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':internRef', $IdIntern);
    $reqPre->bindParam(':creation', $creation);
    $reqPre->bindParam(':step1', $steps[0]);
    $reqPre->bindParam(':step2', $steps[1]);
    $reqPre->bindParam(':step3', $steps[2]);
    $reqPre->bindParam(':endDate', $endValue);
    $reqPre->bindParam(':prog', $creation);

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
  $req = "SELECT RefIntern,Creation,Step1,Step2,Step3,DateEnd,Progress,StepIndex FROM TimeQuest WHERE IdPlayer = :playerId";

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
