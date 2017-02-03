<?php

  $functionExe = str_replace("/", "", $_POST["funct"]);

  Include("FacebookUtils.php");
  switch ($functionExe) {
    case "ADD": newIntern(); break;
    case "REM": removeIntern(); break;
    case "UPDT": update(); break;
    case "GET_SPE_JSON": getJson(); break;
    default: echo "No function"; break;
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
