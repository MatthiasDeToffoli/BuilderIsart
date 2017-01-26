<?php

  $req = "SELECT * FROM Choices";
  $reqPre = $db->prepare($req);
  $reqPre->execute();
  $res = $reqPre->fetchAll();

  echo json_encode($res);

 ?>
