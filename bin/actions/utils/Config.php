<?php


namespace actions\utils;



 /**
 * @author: de Toffoli Matthias
 * include this if we want to use the table Config
 */
class Config
{

  /**
  * return the table Config
  * @return an object reprensenting the table Config
  */
  public static function getConfig(){
    global $db;

    $req = "SELECT * FROM `Config` WHERE 1";
    $reqPre = $db->prepare($req);
    $reqPre->bindParam(':playerId', $pId);

    try {
      $reqPre->execute();
      return $reqPre->fetchAll(PDO::FETCH_OBJ)[0];
    } catch (Exception $e) {
      echo $e->getMessage();
      exit;
    }
  }
}


?>
