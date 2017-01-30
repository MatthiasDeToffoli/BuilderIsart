<?php

$buildID = str_replace("/", "", $_POST["buildId"]);
$crea = intval(str_replace("/", "", $_POST["creationDate"]));
$endDate = intval(str_replace("/", "", $_POST["endDate"]));
$creationSec = intval(str_replace("/", "", $_POST["creationSec"]));
$endSeconds = intval(str_replace("/", "", $_POST["endSec"]));
$boostVal = intval(str_replace("/", "", $_POST["boost"]));
$functionExe = str_replace("/", "", $_POST["funct"]);

Include("FacebookUtils.php");
switch ($functionExe) {
  case "ADD": newConstructionTime($buildID, $crea, $creationSec, $endDate, $endSeconds); break;
  case "REM": removeConstructionTime($buildID); break;
  case "UPDT": updateConstructionTime($buildID, $boostVal); break;
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

  function updateConstructionTime($buildID, $boostVal) {
    global $db;
    $boostBonus = 0;

    $req = "SELECT Boost FROM TimeConstruction WHERE IDPlayer = :idPlayer AND IDBuild = :idBuild";
    $reqPre = $db->prepare($req);
    $ID = getId();
    $reqPre->bindParam(':idPlayer', $ID);
    $reqPre->bindParam(':idBuild', $buildID);

    $reqPre->execute();
    $res = $reqPre->fetchAll();
    if ($res["Boost"] != 0) $boostBonus = $res["Boost"] + $boostVal;
    else $boostBonus = $boostVal;

    $req = "UPDATE TimeConstruction SET Boost = :boostVal WHERE IDPlayer = :idPlayer AND IDBuild = :idBuild";
    $reqPre = $db->prepare($req);
    $ID = getId();
    $reqPre->bindParam(':idPlayer', $ID);
    $reqPre->bindParam(':idBuild', $buildID);
    $reqPre->bindParam(':boostVal', $boostBonus);

    try {
      $reqPre->execute();
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

 ?>
