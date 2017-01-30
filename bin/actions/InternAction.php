<?php

  $req = "SELECT * FROM Interns";
  $reqPre = $db->prepare($req);
  $reqPre->execute();
  $res = $reqPre->fetchAll();

  echo json_encode($res);

 ?>
