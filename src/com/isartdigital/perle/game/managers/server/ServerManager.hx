package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManagerInterns.EventErrorBuyIntern;
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
	var passwordNoFB:String; // saved in cookie
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
	@:optional var level:Int;
}

/**
 * Interface whit the server
 * @author Vicktor Grenu
 * @author Ambroise Rabier
 * @author Matthias DeTefolli
 */
class ServerManager {
	
	public static inline var KEY_POST_FILE_NAME:String = "module";
	public static inline var KEY_POST_FUNCTION_NAME:String = "action";
	private static inline var SECOND:Int = 1000;
	private static var currentButtonRegion:ButtonRegion;
	
	/**
	 * start player inscription or get his information
	 */
	public static function playerConnexion():Void {
		callPhpFile(onSuccessPlayerConnexion, onErrorPlayerConnexion, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.LOGIN]);
	}
	
	private static function onSuccessPlayerConnexion (pObject:String):Void {
		var successEvent:EventSuccessConnexion = Json.parse(pObject);
		
		if (untyped pObject.charAt(0) != "{" || Json.parse(pObject).ID == null) {
			Debug.error("Player connexion failed (go look network panel)");
			return;
		}
		ServerManagerLoad.load(); // todo : temporary (maybe)
		DeltaDNAManager.sendConnexionEvents(successEvent);
		DeltaDNAManager.listenToCloseGame();
	}
	
	private static function onErrorPlayerConnexion (object:Dynamic):Void {
		Debug.error("Error php : " + object);
	}
	
	public static function ftue():Void {
		callPhpFile(onSuccessFtue, onErrorFtue, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.FTUE, "FtueProgress"=> DialogueManager.dialogueSaved]);
	}
	
	private static function onSuccessFtue (pObject:String):Void {
		trace(pObject);
	}
	
	private static function onErrorFtue (object:Dynamic):Void {
		Debug.error("Error php : " + object);
	}
	
	private static function callDevugFille():Void {
		callPhpFile(debug, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.DEBUG]);
	}
	
	private static function debug(object:Dynamic):Void {
		trace(object);
	}

	public static function refreshConfig ():Void { // todo : remplacer par cron ?
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.TEMP_GET_JSON]);
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
	
	
	/**
	 * call php file
	 * @param	onData callBack function on success
	 * @param	onError callback function on fail
	 * @param	mFile php file to call
	 */
	public static function callPhpFile(onData:Dynamic->Void, onError:Dynamic->Void, pFileName:String, ?pParams:Map<String, Dynamic>):Void {
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
	private static function onDataRegionCallback(pObject:Dynamic):Void {
		UIManager.getInstance().closePopin(ServerConnexionPopin.getInstance());

			
			var data:EventSuccessAddRegion = Json.parse(pObject);
			
			if (data.flag) {
				if (currentButtonRegion != null) currentButtonRegion.destroy();
				RegionManager.createRegion(stringToEnum(data.type), new Point(data.ftx, data.fty), {x:Std.int(data.x), y:Std.int(data.y)});
				ResourcesManager.spendTotal(GeneratorType.soft, Std.int(data.price));
				currentButtonRegion = null;
				ResourcesManager.setLevel(Std.int(data.level));
				ResourcesManager.updateTotal(GeneratorType.goodXp, data.xpHeaven);
				ResourcesManager.updateTotal(GeneratorType.badXp, data.xpHell);
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
			case "resourcesFromHeaven" : return GeneratorType.buildResourceFromParadise;
			case "resourcesFromHell" : return GeneratorType.buildResourceFromHell;
			case "badXp" : 			return GeneratorType.badXp;
			case "goodXP" :			return GeneratorType.goodXp;
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