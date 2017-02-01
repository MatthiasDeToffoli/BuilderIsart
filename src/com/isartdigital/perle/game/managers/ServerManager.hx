package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.perle.ui.hud.ButtonRegion;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.utils.Debug;
import haxe.Http;
import haxe.Json;
import pixi.core.math.Point;

	
enum ConstructionTimeAction { ADD; REM; UPDT; }

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
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.LOGIN]);
	}
	
	public static function refreshConfig ():Void { // todo : remplacer par cron ?
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.TEMP_GET_JSON]);
	}
	
	/**
	 * call server and ask him to execute a specifique fonction
	 * @param	pConstructTimeDesc TimeDescription of concerne building
	 * @param	pAction Action to execute
	 * @return 	false if GET return a construction time / else allways true
	 */
	public static function ContructionTimeAction(pConstructTimeDesc:TimeDescription, pAction:ConstructionTimeAction):Void {
		var actionCall:String = Std.string(pAction);
		switch (pAction) 
		{
			case ConstructionTimeAction.ADD:
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
				
			case ConstructionTimeAction.REM:
				callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					KEY_POST_FILE_NAME => ServerFile.TIME_BUILD,
					"buildId" => pConstructTimeDesc.refTile,
					"funct" => actionCall
				]);
			
			case ConstructionTimeAction.UPDT:
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
	 * this function help to call server for test if we can buy a region
	 * @param	typeName the type of the region we want to add
	 * @param	mapPos the position of the region in world map
	 * @param	firstTileMapPos the position of the first tile of the region
	 * @param	btnRegion the button we click for buy the region
	 */
	public static function addRegionToDataBase(typeName:String, mapPos:Index, firstTileMapPos:Index, ?btnRegion:ButtonRegion):Void {
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
		//trace(object);
		//trace(Json.parse(object)); //n'est parfois pas un objet mais un string..
	}
	
	/**
	 * call when a region is add in the database this create the region for client
	 * @param	object a object return by database can contain an error message or region information
	 */
	private static function onDataRegionCallback(object:Dynamic):Void {

		var data:Dynamic = Json.parse(object);
	
		if (data.flag) {
			if (currentButtonRegion != null) currentButtonRegion.destroy();
			RegionManager.createRegion(stringToEnum(data.type), new Point(data.ftx, data.fty), {x:Std.int(data.x), y:Std.int(data.y)});
			ResourcesManager.spendTotal(GeneratorType.soft, Std.int(data.price));
			currentButtonRegion = null;
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
	public static inline var REGIONS:String = "BuyRegions";
	public static inline var CHOICES:String = "Choices";
	public static inline var TIME_BUILD:String = "BuildingTime";
	public static inline var INTER_ACTION:String = "InternAction";
}