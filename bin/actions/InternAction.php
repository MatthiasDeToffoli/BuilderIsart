<?php

  $req = "SELECT * FROM Interns";
  $reqPre = $db->prepare($req);

  try {
    $reqPre->execute();
    $res = $reqPre->fetchAll();
    echo json_encode($res);
  } catch (Exception $e) {

  }

 ?>
