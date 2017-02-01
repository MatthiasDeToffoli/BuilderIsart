<?php

  $req = "SELECT * FROM Choices";
  $reqPre = $db->prepare($req);

  try {
    $reqPre->execute();
    $res = $reqPre->fetchAll();
    echo json_encode($res);
  } catch (Exception $e) {

  }

 ?>
