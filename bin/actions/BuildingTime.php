<?php

$buildID = str_replace("/", "", $_POST["buildId"]);
$crea = intval(str_replace("/", "", $_POST["creationDate"]));
$endDate = intval(str_replace("/", "", $_POST["endDate"]));
$creationSec = intval(str_replace("/", "", $_POST["creationSec"]));
$endSeconds = intval(str_replace("/", "", $_POST["endSec"]));
$functionExe = str_replace("/", "", $_POST["funct"]);

Include("FacebookUtils.php");
switch ($functionExe) {
  case "ADD": newConstructionTime($buildID, $crea, $creationSec, $endDate, $endSeconds); break;
  case "REM": removeConstructionTime($buildID); break;
  case "GET": getConstructionTime($buildID); break;
  default: echo "No function"; break;
}

  function newConstructionTime($buildID, $crea, $creationSec, $endDate, $endSeconds) {
    global $db;

    getConstructionTime($buildID);

    $req = "INSERT INTO TimeConstruction(IDPlayer, IDBuild, Creation, CreationSec, EndDate, EndSec) VALUES (:playerId,:buildId,:crea,:creaSec,:endDate,:endSec)";
    $reqPre = $db->prepare($req);
    $ID = getId();
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':buildId', $buildID);
    $reqPre->bindParam(':crea', $crea);
    $reqPre->bindParam(':creaSec', $creationSec);
    $reqPre->bindParam(':endDate', $endDate);
    $reqPre->bindParam(':endSec', $endSeconds);

    try {
      $reqPre->execute();
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  function removeConstructionTime($buildID) {
    global $db;

    $req = "DELETE FROM TimeConstruction WHERE IDPlayer = :idPlayer AND IDBuild = :idBuild";
    $reqPre = $db->prepare($req);
    $ID = getId();
    $reqPre->bindParam(':idPlayer', $ID);
    $reqPre->bindParam(':idBuild', $buildID);

    try {
      $reqPre->execute();
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  function getConstructionTime($buildID) {
    global $db;

    $req = "SELECT * FROM TimeConstruction WHERE IDPlayer = :idPlayer AND IDBuild = :idBuild";
    $reqPre = $db->prepare($req);
    $ID = getId();
    $reqPre->bindParam(':idPlayer', $ID);
    $reqPre->bindParam(':idBuild', $buildID);

    try {
      $reqPre->execute();
      $res = $reqPre->fetchAll();
      if (isset($res[0])) die();
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

 ?>
