package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.server.ServerFile;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding.EventSuccessAddBuilding;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding.EventSuccessMoveBuilding;
import com.isartdigital.utils.Debug;
import haxe.Json;


typedef EventSuccessAddBuilding = {
	@:optional var errorID:Int;
	@:optional var startConstruction:Int;
	@:optional var endConstruction:Int;
	var iDClientBuilding:Int;
}

typedef EventSuccessMoveBuilding = {
	@:optional var errorID:Int;
	@:optional var oldX:Int;
	@:optional var oldY:Int;
	@:optional var oldRegionX:Int;
	@:optional var oldRegionY:Int;
	var iDClientBuilding:Int;
}

typedef EventSuccessSellBuilding = {
	@:optional var errorID:Int;
}

typedef EventSuccessUpgradeBuilding = {
	@:optional var errorID:Int;
	@:optional var startConstruction:Int;
	@:optional var endConstruction:Int;
	var iDClientBuilding:Int;
}

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
		Debug.error("Error php on moveBuilding : " + pObject);
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
			Debug.error("Success php on moveBuilding but event format is invalid ! : " + pObject);
		}
		
	}
	
	public static function upgradeBuilding (pDescription:TileDescription):Void {
		trace("id:" + pDescription.id);
		ServerManager.callPhpFile(onSuccessUpgradeBuilding, onErrorUpgradeBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_UPGRADE,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	// todo : enlever tout les "building" ds les noms des fc
	private static function onErrorUpgradeBuilding (pObject:Dynamic):Void { 
		Debug.error("Error php on upgradeBuilding : " + pObject);
	}
	
	private static function onSuccessUpgradeBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessUpgradeBuilding = Json.parse(pObject);
			var lFieldError:Int;
			
			if (Reflect.hasField(lEvent, "errorID")) {
				lFieldError = Reflect.field(lEvent, "errorID");
				//if (lFieldError == ErrorManager.BUILDING_CANNOT_SELL_DONT_EXIST) // todo
					// todo : synchronisation. // soit faire ajax pr synchro, soit dans callback ici
				
				ErrorManager.openPopin(lFieldError);
			}
			else
				SynchroManager.syncTimeOfBuilding(lEvent);
			
		} 
		else
			Debug.error("Success php on sellBuilding but event format is invalid ! : " + pObject);
	}
	
	public static function sellBuilding (pDescription:TileDescription):Void {
		ServerManager.callPhpFile(onSuccessSellBuilding, onErrorSellBuilding, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUILDING_SELL,
			"IDClientBuilding" => pDescription.id,
			"RegionX" => pDescription.regionX,
			"RegionY" => pDescription.regionY,
			"X" => pDescription.mapX,
			"Y" => pDescription.mapY
		]);
	}
	
	private static function onErrorSellBuilding (pObject:Dynamic):Void {
		Debug.error("Error php on sellBuilding : " + pObject);
	}
	
	private static function onSuccessSellBuilding (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessSellBuilding = Json.parse(pObject);
			var lFieldError:Int;
			
			if (Reflect.hasField(lEvent, "errorID")) {
				lFieldError = Reflect.field(lEvent, "errorID");
				//if (lFieldError == ErrorManager.BUILDING_CANNOT_SELL_DONT_EXIST)
					// todo : synchronisation. // soit faire ajax pr synchro, soit dans callback ici
				
				ErrorManager.openPopin(lFieldError);
			}
			
		} /*else {
			Debug.error("Success php on sellBuilding but event format is invalid ! : " + pObject);
		}*/ // return nothing if success right now.
	}
	
	public static function updatePopulation(pDescription:TileDescription):Void {
		
	}
	
	public static function updateGenerator(pDescription:TileDescription):Void {
		
	}
	
}