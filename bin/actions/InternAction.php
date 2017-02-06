<?php

  $functionExe = str_replace("/", "", $_POST["funct"]);
  $IdIntern = intval(str_replace("/", "", $_POST["idInt"]));

  Include("FacebookUtils.php");
  switch ($functionExe) {
    case "ADD": buyIntern($IdIntern); break;
    case "REM": removeIntern(); break;
    case "UPDT": update(); break;
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

    $req2 = "INSERT INTO PlayerInterns(IDPlayer, IDIntern, Stress) VALUES (:playerId, :internId, 0)";

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

  function getJson() {
    global $db;

    $i = 0;
    $ID = getId();
    $req = "SELECT * FROM Interns WHERE ID IN (SELECT IDIntern FROM PlayerInterns WHERE IDPlayer = :playerId)";

    try {
      $reqPre = $db->prepare($req);
      $reqPre->bindParam(':playerId', $ID);
      $reqPre->execute();
      $res = $reqPre->fetchAll();

      foreach ($res as $key => $value) {
        foreach ($value as $neededKey => $val) {
          $retour[$i][$neededKey] = $val;
        }
        $i++;
      }

      /*$inc = $res->length;

      for ($i=0; $i < $inc; $i++) {
        $res[$i]["Stress"] += 5;
      }*/

      echo json_encode($retour);
    }
    catch (Exception $e) {
      echo $e->getMessage();
    }

  }

?>
