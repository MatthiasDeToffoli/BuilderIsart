package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.server.ErrorManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.RollBackManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.perle.ui.popin.server.ServerConnexionPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.Debug;
import haxe.Http;
import haxe.Json;
import pixi.core.math.Point;

	
enum DbAction { ADD; REM; UPDT; GET_SPE_JSON; USED_ID; UPDT_EVENT; CLOSE_QUEST; VOID; }

typedef EventSuccessConnexion = {
	var isNewPlayer:Bool;
	var ID:String;
}

typedef EventSuccessAddBuilding = {
	@:optionnal var errorID:Int;
	@:optional var startConstruction:Int;
	@:optional var endConstruction:Int;
	var iDClientBuilding:Int;
}

typedef EventSuccessMoveBuilding = {
	@:optionnal var errorID:Int;
	@:optionnal var oldX:Int;
	@:optionnal var oldY:Int;
	@:optionnal var oldRegionX:Int;
	@:optionnal var oldRegionY:Int;
	var iDClientBuilding:Int;
}

typedef EventSuccessAddRegion = {
	var flag:Bool;
	@:optional var message:String;
	@:optional var x:Int;
	@:optional var y:Int;
	@:optional var type:String;
	@:optional var ftx:Int;
	@:optional var fty:Int;
	@:optional var price:Float;
	@:optional var xpHeaven:Float;
	@:optional var xpHell:Float;
}

typedef TableRegion = {
	var Id:Int;
	var IdPlayer:Int;
	var Type:String;
	var PositionX:Int;
	var PositionY:Int;
	var FistTilePosX:Int;
	var FistTilePosY:Int;
}

/**
 * Interface whit the server
 * @author Vicktor Grenu et Ambroise Rabier
 */
class ServerManager {
	
	private static inline var SECOND:Int = 1000;
	private static inline var KEY_POST_FILE_NAME:String = "module";
	private static inline var KEY_POST_FUNCTION_NAME:String = "action";
	private static var currentButtonRegion:ButtonRegion;
	
	/**
	 * start player inscription or get his information
	 */
	public static function playerConnexion():Void {
		callPhpFile(onSuccessPlayerConnexion, onErrorPlayerConnexion, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.LOGIN]);
	}
	
	private static function onSuccessPlayerConnexion (pObject:String):Void {
		if (untyped pObject.charAt(0) != "{" || Json.parse(pObject).ID == null) {
			Debug.error("Player connexion failed");
			return;
		}
		
		DeltaDNAManager.sendConnexionEvents(Json.parse(pObject));
		DeltaDNAManager.listenToCloseGame();
	}
	
	private static function onErrorPlayerConnexion (object:Dynamic):Void {
		Debug.error("Error php : " + object);
	}
	
	
	public static function refreshConfig ():Void { // todo : remplacer par cron ?
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.TEMP_GET_JSON]);
	}
	
	/**
	 * call server and ask him to execute a specifique fonction on ConstructionTime // todo -> move var instanciation in php
	 * @param	pConstructTimeDesc TimeDescription of concerne building
	 * @param	pAction Action to execute
	 * @return 	
	 */
	public static function ContructionTimeAction(pConstructTimeDesc:TimeDescription, pAction:DbAction):Void {
		var actionCall:String = Std.string(pAction);
		switch (pAction) {
			case DbAction.ADD:
				var creaTimeFloor:Int = Math.floor(pConstructTimeDesc.creationDate / SECOND);
				var endTimeFloor:Int = Math.floor(pConstructTimeDesc.end / SECOND);
				var creaSeconds:Int = Std.int(pConstructTimeDesc.creationDate - creaTimeFloor * SECOND);
				var endSeconds:Int = Std.int(pConstructTimeDesc.end - endTimeFloor * SECOND);
		
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					KEY_POST_FILE_NAME => ServerFile.TIME_BUILD,
					"buildId" => pConstructTimeDesc.refTile,
					"creationDate" => creaTimeFloor,
					"creationSec" => creaSeconds,
					"endDate" => endTimeFloor,
					"endSec" => endSeconds,
					"funct" => actionCall
				]);
				
			case DbAction.REM:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					KEY_POST_FILE_NAME => ServerFile.TIME_BUILD,
					"buildId" => pConstructTimeDesc.refTile,
					"funct" => actionCall
				]);
			
			case DbAction.UPDT:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					KEY_POST_FILE_NAME => ServerFile.TIME_BUILD,
					"buildId" => pConstructTimeDesc.refTile,
					"boost" => pConstructTimeDesc.timeBoost,
					"funct" => actionCall
				]);
				
			default: return;
		}
	}
	
	/**
	 * call server and ask him to execute a specifique fonction on Interns
	 * @param	pAction action to call
	 * @param	pIntern sometime you need an InternDescription
	 * @return 	
	 */
	public static function InternAction(pAction:DbAction, ?internId:Int=null, ?eventId:Int=null):Void {
		var actionCall:String = Std.string(pAction);
		
		switch (pAction) {
			case DbAction.ADD:
				if (internId != null) callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall, "idInt" => internId]);
			case DbAction.REM:
				if (internId != null) callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall, "idInt" => internId]);
			case DbAction.UPDT:
				if (internId != null) callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall, "idInt" => internId, "str" => Intern.getIntern(internId).stress]);
			case DbAction.UPDT_EVENT:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall, "idInt" => internId, "idEvent" => eventId]);
			case DbAction.GET_SPE_JSON:
				callPhpFile(Intern.getPlayerInterns, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall]);			
			default: return;
		}
	}
	
	public static function ChoicesAction(pAction:DbAction, ?pId:Int=null):Void {
		var actionCall:String = Std.string(pAction);
		
		switch (pAction) {
			case DbAction.ADD:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.CHOICES, "funct" => actionCall, "idEvt" => pId]);
			case DbAction.REM:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.CHOICES, "funct" => actionCall, "idInt" => pId]);
			case DbAction.USED_ID:
				callPhpFile(ChoiceManager.getUsedIdJson, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.CHOICES, "funct" => actionCall]);
			case DbAction.CLOSE_QUEST:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.CHOICES, "funct" => actionCall, "idEvt" => pId]);
			case DbAction.VOID:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.CHOICES, "funct" => actionCall]);
			default: return;	
		}
	}
	
	public static function loadRegion():Void {
		callPhpFile(onRegionLoad, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.LOAD_REGION]);
	}
	
	private static function onRegionLoad(pObject:Dynamic):Void {
		var listRegionLoad:Array<TableRegion> = Json.parse(pObject);
		
		if (listRegionLoad.length == 0) RegionManager.buildWhitoutSave();
		else RegionManager.load(listRegionLoad);		
	}
	
	public static function TimeQuestAction(pAction:DbAction, ?pTimeQuest:TimeQuestDescription=null):Void {
		var actionCall:String = Std.string(pAction);
		
		switch (pAction) {
			case DbAction.ADD:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					KEY_POST_FILE_NAME => ServerFile.TIME_QUEST,
					"funct" => actionCall,
					"idInt" => pTimeQuest.refIntern,
					"prog" => pTimeQuest.progress,
					"stepIndex" => pTimeQuest.stepIndex,
					"step1" => pTimeQuest.steps[0],
					"step2" => pTimeQuest.steps[1],
					"step3" => pTimeQuest.steps[2],
					"tEnd" => pTimeQuest.end,
					"tCrea" => pTimeQuest.creation
				]);
			case DbAction.UPDT:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					KEY_POST_FILE_NAME => ServerFile.TIME_QUEST,
					"funct" => actionCall,
					"idInt" => pTimeQuest.refIntern,
					"prog" => pTimeQuest.progress,
					"stepIndex" => pTimeQuest.stepIndex
				]);
			case DbAction.REM:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.TIME_QUEST, "funct" => actionCall, "idInt" => pTimeQuest.refIntern]);
			case DbAction.GET_SPE_JSON:
				callPhpFile(QuestsManager.getJson, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.TIME_QUEST, "funct" => actionCall]);
			default: return;
		}
	}
	
	/**
	 * this function help to call server for test if we can buy a region
	 * @param	typeName the type of the region we want to add
	 * @param	mapPos the position of the region in world map
	 * @param	firstTileMapPos the position of the first tile of the region
	 * @param	btnRegion the button we click for buy the region
	 */
	public static function addRegionToDataBase(typeName:String, mapPos:Index, firstTileMapPos:Index, ?btnRegion:ButtonRegion):Void {
		UIManager.getInstance().openPopin(ServerConnexionPopin.getInstance());
		currentButtonRegion = btnRegion;
		callPhpFile(onDataRegionCallback, onErrorCallback, ServerFile.MAIN_PHP, [
			KEY_POST_FILE_NAME => ServerFile.REGIONS,
			"playerId" => Facebook.uid,
			"type" => typeName,
			"x" => mapPos.x,
			"y" => mapPos.y,
			"firstTileX" => firstTileMapPos.x,
			"firstTileY" => firstTileMapPos.y
			]
		);
	}
	
	// todo : rename addBuildingToDataBase to addBuilding and for addRegion too ?
	
	/**
	 * Add a building in database.
	 * IDClientBuilding is used to identify the building at server callback.
	 * StartContruction and EndScontruction are defined by the server.
	 * @param	pDescription
	 */
	public static function addBuilding (pDescription:TileDescription):Void {
		callPhpFile(onSuccessAddBuilding, onErrorAddBuilding, ServerFile.MAIN_PHP, [
			KEY_POST_FILE_NAME => ServerFile.BUILDING_ADD,
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
		callPhpFile(onSuccessMoveBuilding, onErrorMoveBuilding, ServerFile.MAIN_PHP, [
			KEY_POST_FILE_NAME => ServerFile.BUILDING_MOVE,
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
	
	/**
	 * call php file
	 * @param	onData callBack function on success
	 * @param	onError callback function on fail
	 * @param	mFile php file to call
	 */
	private static function callPhpFile(onData:Dynamic->Void, onError:Dynamic->Void, pFileName:String, ?pParams:Map<String, Dynamic>):Void {
		// create new http request
        var lCall:Http = new Http(pFileName);
        lCall.onData = onData;
        lCall.onError = onError;
		
		if (pParams != null)
			for (lKey in pParams.keys())
				lCall.setParameter(lKey, pParams[lKey]);
		
		lCall.request(true);
    }

	private static function onDataCallback(object:Dynamic):Void {
		//trace(Json.parse(object));
		//trace(Json.parse(object)); //n'est parfois pas un objet mais un string..
	}
	
	/**
	 * call when a region is add in the database this create the region for client
	 * @param	object a object return by database can contain an error message or region information
	 */
	private static function onDataRegionCallback(object:Dynamic):Void {
		UIManager.getInstance().closePopin(ServerConnexionPopin.getInstance());
		var data:EventSuccessAddRegion = Json.parse(object);

		if (data.flag) {
			if (currentButtonRegion != null) currentButtonRegion.destroy();
			RegionManager.createRegion(stringToEnum(data.type), new Point(data.ftx, data.fty), {x:Std.int(data.x), y:Std.int(data.y)});
			ResourcesManager.spendTotal(GeneratorType.soft, Std.int(data.price));
			currentButtonRegion = null;
			ResourcesManager.gainResources(GeneratorType.goodXp, data.xpHeaven);
			ResourcesManager.gainResources(GeneratorType.badXp, data.xpHell);
			return;
		}
		
		Debug.error(data.message);
	}

	private static function onErrorCallback(object:Dynamic):Void {
		Debug.error("Error php : " + object);
	}
	
	private function new() {
		
	}
	
	public static function stringToEnum(pString:String):Dynamic {

		switch (pString) {
			case "soul" : 			return GeneratorType.soul;
			case "soft" : 			return GeneratorType.soft;
			case "wood" : 			return GeneratorType.buildResourceFromParadise;
			case "stone" : 			return GeneratorType.buildResourceFromHell;
			case "hard" : 			return GeneratorType.hard;
			case "neutral" : 		return Alignment.neutral;
			case "hell" : 			return Alignment.hell;
			case "heaven" : 		return Alignment.heaven;
			case "Bundle" : 		return ShopTab.Bundle;
			case "Currencies" : 	return ShopTab.Currencies;
			case "Resources" : 		return ShopTab.Resources;
			case "Interns" : 		return ShopTab.Interns;
			case "InternsSearch" : 	return ShopTab.InternsSearch;
			case "Building" : 		return ShopTab.Building;
			case "Deco" : 			return ShopTab.Deco;
				
			default : return null;
			// default : Debug.error("No Enum found for '" + pString + "'."); 
			// not good idea since i use this function as "hasEnum()" function in GameConfig
		}
	}

}

class ServerFile {
	public static inline var MAIN_PHP:String = "actions.php";
	public static inline var LOGIN:String = "Login";
	public static inline var TEMP_GET_JSON:String = "JsonCreator";
	public static inline var REGIONS:String = "BuyRegions"; // todo : rename ADD_REGIONS ?
	public static inline var BUILDING_ADD:String = "AddBuilding";
	public static inline var BUILDING_MOVE:String = "MoveBuilding";
	public static inline var CHOICES:String = "Choices";
	public static inline var TIME_BUILD:String = "BuildingTime";
	public static inline var INTER_ACTION:String = "InternAction";
	public static inline var TIME_QUEST:String = "Quest";
	public static inline var LOAD_REGION:String = "LoadRegion";
}