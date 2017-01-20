<?php
  $TYPE_STYX = "neutral";
  $TYPE_HEAVEN = "heaven";
  $TYPE_HELL = "hell";
 $regionType = str_replace("/", "", $_POST["type"]);
 $regionX = intval(str_replace("/", "", $_POST["x"]));
 $regionY = intval(str_replace("/", "", $_POST["y"]));
 $firstTileX = intval(str_replace("/", "", $_POST["firstTileX"]));
 $firstTileY = intval(str_replace("/", "", $_POST["firstTileY"]));

 if(($regionX != $TYPE_HELL && $regionX > 0) || ($regionX != $TYPE_HEAVEN && $regionX < 0) || ($regionX != $TYPE_STYX && $regionX == 0)){
   echo false;
   exit;
 }

 addToTable($regionType,$regionX,$regionY,$firstTileX,$firstTileY);

 function addToTable($Type, $X,$Y,$FTX,$FTY){
   include("FacebookUtils.php");
   include("vendor/autoload.php");
   global $db;


   $id = getId();

   $req = "INSERT INTO Region(IdPlayer, Type, PositionX, PositionY, FistTilePosX, FistTilePosY) VALUES (:playerId,:Type,:X,:Y,:FTX,:FTY)";
   $reqPre = $db->prepare($req);
   $reqPre->bindParam(':playerId', $id);
   $reqPre->bindParam(':Type', $Type);
   $reqPre->bindParam(':X', $X);
   $reqPre->bindParam(':Y', $Y);
   $reqPre->bindParam(':FTX', $FTX);
   $reqPre->bindParam(':FTY', $FTY);

   try {
     $reqPre->execute();
     echo true;
   } catch (Exception $e) {
     echo $e->getMessage();
     exit;
   }
 }
?>
