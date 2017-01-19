package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;


typedef TableConfig = {
	var RefundRatioBuilded:Float;
	var RefundRatioConstruct:Float;
	var FactorRegionGrowth:Float;
	var PriceRegion:Float;
	var RegionXpSameSide:Float;
	var RegionXpOtherSide:Float;
	var FactorRegionNearStyx:Float;
}

typedef TableTypeBuilding = {
	var ID:Int;
	var Name:String; // constantes; voir BuildingName.hx
	var Level:Int;
	var Alignment:String; // enum; à travers le json devient string... ou le transformer en enum ?
	var Width:Int;
	var Height:Int;
	var FootPrint:Int;
	@:optional var CostGold:Int;
	@:optional var CostWood:Int;
	@:optional var CostIron:Int;
	@:optional var CostKarma:Int;
	var ConstructionTime:String; // HH:MM:SS or HHH:MM:SS
	@:optional var ProductionType:String; // enum
	@:optional var ProductionPerHour:Int;
	@:optional var ProductionResource:String; // enum
	@:optional var ProductionPerBuildingHeaven:Int;
	@:optional var ProductionPerBuildingHell:Int;
	var XPatCreationHeaven:Int;
	var XPatCreationHell:Int;
	var LevelUnlocked:Int;
	@:optional var LimitPerRegion:Int;
	@:optional var FactoryNeededToUnlock:Int;
	@:optional var MaxSoulsContained:Int;
	@:optional var MaxGoldContained:Int;
	@:optional var IDPack1:TableTypePack;
	@:optional var IDPack2:TableTypePack;
	@:optional var IDPack3:TableTypePack;
	@:optional var IDPack4:TableTypePack;
	@:optional var IDPack5:TableTypePack;
	@:optional var IDPack6:TableTypePack;
	
}

typedef TableTypePack = {
	var ID:Int;
	var Name:String; // varchar, mais pourrait être enum ?
	var CostGold:Int;
	var CostKarma:Int;
	var Time:String; // todo type Time ?
	var GainWood:Int;
	var GainIron:Int;
	var GainFluxSouls:Int;
	var ProductionResource:String; // enum
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
	public static inline var CONFIG:String = "Config";
	// todo : etc
	
	// todo : transformer les string en enum ? ou juste faire getName() sur nos enum ?
	
	
	
	public static function awake ():Void {
		config = new Map<String, Array<Dynamic>>();
		
		/*config[BUILDING] = new Array<TableTypeBuilding>();
		config[INTERN] = new Array<TableTypeIntern>();
		
		config[BUILDING][0].ID*/
		
		parseJson(config, GameLoader.getContent(Main.GAME_CONFIG));
		
		/*trace(config);
		trace(config[BUILDING]);
		trace(config[BUILDING][0]);
		trace(config[BUILDING][0].ID);*/
	}
	
	public static function getConfig ():TableTypeBuilding {
		return cast(config[CONFIG][0]);
	}
	
	public static function getBuilding ():Array<TableTypeBuilding> {
		return cast(config[BUILDING]);
	}
	
	public static function getBuildingByName (pName:String):TableTypeBuilding { // todo : enum ?
		for (i in 0...config[BUILDING].length)
			if (config[BUILDING][i].Name == pName)
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