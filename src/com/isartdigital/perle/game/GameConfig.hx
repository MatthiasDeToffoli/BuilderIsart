package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;


typedef TableTypeBuilding = {
	var ID:Int;
	var Price:String;
	var Name2:String; // enum ?
}

typedef TableTypeIntern = {
	
}


/**
 * ...
 * @author ambroise
 */
class GameConfig {

	private static var config:Map<String, Array<Dynamic>>;

	public static inline var BUILDING:String = "TypeBuilding";
	public static inline var INTERN:String = "TypeIntern";
	// todo : etc
	
	// todo : transformer les string en enum ? ou juste faire getName() sur nos enum ?
	
	
	
	public static function awake ():Void {
		config = new Map<String, Array<Dynamic>>();
		
		/*config[BUILDING] = new Array<TableTypeBuilding>();
		config[INTERN] = new Array<TableTypeIntern>();
		
		config[BUILDING][0].ID*/
		
		parseJson(config, GameLoader.getContent(Main.GAME_CONFIG));
		trace(getBuilding());
		trace(getBuildingByName("tribunal"));
	}
	
	public static function getBuilding ():Array<TableTypeBuilding> {
		return cast(config[BUILDING]);
	}
	
	public static function getBuildingByName (pName:String):TableTypeBuilding { // todo : enum ?
		for (i in 0...config[BUILDING].length)
			if (config[BUILDING][i].Name2 == pName)
				return config[BUILDING][i];
				
		return null;
	}
	
	private static function tableExist (pTable:String):Bool { // todo : à utiliser, j'pe pas test mon php ingore mes changements --'
		if (config[pTable] == null) { // todo : vérif si cela marche ? parfois me semblait qu'il mettait false plutot que null
			Debug.error("table named : " + pTable + " does not exist in database.");
			return false;
		}
		
		return true;
	}
	
	private static function parseJson (pConfig:Map<String, Array<Dynamic>>, pContent:Dynamic):Void {
		
		var fields:Array<String> = Reflect.fields(pContent);
		for (i in 0...fields.length) {
			pConfig[fields[i]] = new Array<Dynamic>();
			
			var anotherFields:Array<String> = Reflect.fields(Reflect.field(pContent, fields[i]));
			for (j in 0...anotherFields.length) {
				pConfig[fields[i]][j] = Reflect.field(
					Reflect.field(pContent, fields[i]),
					anotherFields[j]
				);
			}
		}
		
	}
	
	public function new() {
		
	}
	
}