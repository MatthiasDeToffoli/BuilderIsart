<?php

  $functionExe = str_replace("/", "", $_POST["funct"]);
  $IdIntern = intval(str_replace("/", "", $_POST["idInt"]));
  $IdEvent = intval(str_replace("/", "", $_POST["idEvent"]));
  $stress = intval(str_replace("/", "", $_POST["str"]));

  Include("FacebookUtils.php");
  switch ($functionExe) {
    case "ADD": buyIntern($IdIntern); break;
    case "REM": removeIntern($IdIntern); break;
    case "UPDT": addStress($IdIntern, $stress); break;
    case "UPDT_EVENT": updateEvent($IdEvent, $IdIntern); break;
    case "GET_SPE_JSON": getJson(); break;
    default: echo "No function"; break;
  }

  function buyIntern($IdIntern) {
    global $db;
    $ID = getId();

    if (!isset($IdIntern)) die("No valid ID");

    $req = "SELECT * FROM PlayerInterns WHERE IDIntern = :internId AND IDPlayer = :playerId";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $ID);
    $reqPre->bindParam(':internId', $IdIntern);

    try {
      $reqPre->execute();
      $res = $reqPre->fetchAll();
      if (isset($res[0])) die("Already in your intern");
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }

    $req2 = "INSERT INTO PlayerInterns(IDPlayer, IDIntern, Stress, IdEvent) VALUES (:playerId, :internId, 0, 0)";

    try {
      $reqPre = $db->prepare($req2);
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->bindParam(':internId', $IdIntern);
      $reqPre->execute();
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }
  }

  function removeIntern($IdIntern) {
    global $db;

    $ID = getId();
    $req = "DELETE FROM PlayerInterns WHERE IDPlayer = :playerId AND IDIntern = :internId";

    try {
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->bindParam(':internId', $IdIntern);
      $reqPre->execute();
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }

  }

  function updateEvent($IdEvent, $IdIntern) {
    global $db;

    $ID = getId();
    $req = "UPDATE PlayerInterns SET IdEvent = :eventId WHERE IDPlayer = :playerId AND IDIntern = :internId";

    try {
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':eventId', $IdEvent);
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->bindParam(':internId', $IdIntern);
      $reqPre->execute();
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }

  }

  function addStress($IdIntern, $stress) {
    global $db;

    $ID = getId();
    $req = "UPDATE PlayerInterns SET Stress = :stress WHERE IDPlayer = :playerId AND IDIntern = :internId";

    try {
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':stress', $stress);
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->bindParam(':internId', $IdIntern);
      $reqPre->execute();
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }
  }

  function getJson() {
    global $db;

    $i = 0;
    $ID = getId();
    $req = "SELECT * FROM Interns WHERE ID IN (SELECT IDIntern FROM PlayerInterns WHERE IDPlayer = :playerId)";
    $req2 = "SELECT IdEvent, Stress FROM PlayerInterns WHERE IDPlayer = :playerId";

    try {
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->execute();
      $res = $reqPre->fetchAll();

      $reqPre2 = $db->prepare($req2);
      $reqPre2->bindParam(':playerId', $ID);
      $reqPre2->execute();
      $res2 = $reqPre2->fetchAll();

      foreach ($res as $key => $value) {
        $retour[$i]["IdEvent"] = $res2[$i]["IdEvent"];
        $retour[$i]["Stress"] = $res2[$i]["Stress"];
        foreach ($value as $neededKey => $val) {
          $retour[$i][$neededKey] = $val;
        }
        $i++;
      }

      echo json_encode($retour);
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }

  }

?>
