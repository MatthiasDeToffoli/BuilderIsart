package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.ServerManager.EventSuccessAddBuilding;
import com.isartdigital.perle.game.managers.server.ServerManager.EventSuccessMoveBuilding;
import com.isartdigital.perle.game.managers.server.ServerFile;
import com.isartdigital.utils.Debug;
import haxe.Json;

/**
 * ...
 * @author ambroise
 */
class ServerManagerBuilding{

	/**
	 * Add a building in database.
	 * IDClientBuilding is used to identify the building at server callback.
	 * StartContruction and EndScontruction are defined by the server.
	 * @param	pDescription
	 */
	public static function addBuilding (pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessAddBuilding, onErrorAddBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_ADD,
			"IDClientBuilding" => pDescription.id,
			"IDTypeBuilding" => GameConfig.getBuildingByName(pDescription.buildingName).iD,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorAddBuilding (pObject:Dynamic):Void {
		Debug.error("Error php on addBuilding : " + pObject);
	}
	
	
	private static function onSuccessAddBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessAddBuilding = Json.parse(pObject);
			
			if (Reflect.hasField(lEvent, "errorID")) {
				RollBackManager.deleteBuilding(lEvent.iDClientBuilding);
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}
			else
				SynchroManager.syncTimeOfBuilding(lEvent);
			
		} else {
			Debug.error("Success php on addBuilding but event format is invalid ! : " + pObject);
		}
		
	}
	
	public static function moveBuilding (pOldDescription:TileDescription, pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessMoveBuilding, onErrorMoveBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_MOVE,
			"IDClientBuilding" => pDescription.id,
			"OldRegionX" => pOldDescription.regionX,
			"OldRegionY" => pOldDescription.regionY,
			"OldX" => pOldDescription.mapX,
			"OldY" => pOldDescription.mapY,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorMoveBuilding (pObject:Dynamic):Void {
		Debug.error("Error php on addBuilding : " + pObject);
	}
	
	private static function onSuccessMoveBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessMoveBuilding = Json.parse(pObject);
			var lFieldError:Int;
			
			if (Reflect.hasField(lEvent, "errorID")) {
				lFieldError = Reflect.field(lEvent, "errorID");
				if (lFieldError == ErrorManager.BUILDING_CANNOT_MOVE_DONT_EXIST)
					RollBackManager.deleteBuilding(lEvent.iDClientBuilding);
				else	
					RollBackManager.cancelMoveBuilding(lEvent);
				
				ErrorManager.openPopin(lFieldError);
			}
			
		} else {
			Debug.error("Success php on addBuilding but event format is invalid ! : " + pObject);
		}
		
	}
	
	public static function upgradeBuilding (pDescription:TileDescription):Void {
		
	}
	
	public static function sellBuilding (pDescription:TileDescription):Void {
		
	}
	
}