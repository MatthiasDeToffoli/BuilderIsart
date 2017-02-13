<?php

  $functionExe = str_replace("/", "", $_POST["funct"]);
  $IdEvent = intval(str_replace("/", "", $_POST["idEvt"]));
  $IdIntern = intval(str_replace("/", "", $_POST["idInt"]));

  include_once("utils/FacebookUtils.php");
  switch ($functionExe) {
    case "ADD": addInUsedList($IdEvent); break;
    case "REM": resetInternEvent($IdIntern); break;
    case "CLOSE_QUEST" : closeQuest($IdEvent); break;
    case "VOID" : deleteChoices(); break;
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

  function resetInternEvent($IdIntern) {
    global $db;

    $ID = getId();
    $req = "UPDATE PlayerInterns SET IdEvent = 0 WHERE IdIntern = :internId AND IDPlayer = :playerId";

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

  function closeQuest($IdEvent) {
    global $db;

    if (!isset($IdEvent)) die("No valid ID");
    $ID = getId();

    $req = "UPDATE ChoicesUsed SET Closed = 1 WHERE IDChoice = :eventId";

    try {
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':eventId', $IdEvent);
      $reqPre->execute();
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

  function deleteChoices() {
    global $db;

    $req = "DELETE FROM ChoicesUsed WHERE IDPlayer = :playerId";

    try {
      $reqPre = $db->prepare($req);
      $ID = getId();
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->execute();
    }
    catch (Exception $e) {
     echo $e->getMessage();
    }

  }

  function getUsedId() {
    global $db;

    $ID = getId();

    $req = "SELECT IDChoice, Closed FROM ChoicesUsed WHERE IDPlayer = :playerId";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $ID);

    try {
      $reqPre->execute();
      $res = $reqPre->fetchAll(PDO::FETCH_ASSOC);

      echo json_encode($res);
    }
    catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }

?>
