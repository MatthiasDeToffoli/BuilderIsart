<?php

  $functionExe = str_replace("/", "", $_POST["funct"]);
  $IdEvent = intval(str_replace("/", "", $_POST["id"]));

  Include("FacebookUtils.php");
  switch ($functionExe) {
    case "ADD": addInUsedList($IdEvent); break;
    case "USED_ID": getUsedId(); break;
    default: echo "No function"; break;
  }

  function addInUsedList($IdEvent) {
    global $db;

    if (!isset($IdEvent)) die("No valid ID");
    $ID = getId();

    $req = "INSERT INTO ChoicesUsed(IDPlayer, IDChoice, Closed) VALUES (:playerId, :choiceId, 0)";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':choiceId', $IdEvent);

    try {
      $reqPre->execute();
      $res = $reqPre->fetchAll();
      echo json_encode($res);
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  function getUsedId() {
    global $db;

    $ID = getId();

    $req = "SELECT IDChoice FROM ChoicesUsed WHERE IDPlayer = :playerId";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $ID);

    try {
      $reqPre->execute();
      $res = $reqPre->fetchAll(PDO::FETCH_NUM);

      echo json_encode($res);
    }
    catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

?>
