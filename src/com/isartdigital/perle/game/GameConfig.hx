package com.isartdigital.perle.game;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;


typedef TableConfig = {
	var refundRatioBuilded:Float;
	var refundRatioConstruct:Float;
	var factorRegionGrowth:Float;
	var priceRegion:Float;
	var regionXpSameSide:Float;
	var regionXpOtherSide:Float;
	var factorRegionNearStyx:Float;
}

typedef TableTypeBuilding = {
	var iD:Int;
	var name:String; // constantes; voir BuildingName.hx
	var level:Int;
	var alignment:Alignment; // enum; à travers le json devient string... ou le transformer en enum ?
	var width:Int;
	var height:Int;
	var footPrint:Int;
	@:optional var costGold:Int;
	@:optional var costWood:Int;
	@:optional var costIron:Int;
	@:optional var costKarma:Int;
	var constructionTime:String; // HH:MM:SS or HHH:MM:SS
	@:optional var productionType:String; // enum
	@:optional var productionPerHour:Int;
	@:optional var productionResource:String; // enum
	@:optional var productionPerBuildingHeaven:Int;
	@:optional var productionPerBuildingHell:Int;
	var xPatCreationHeaven:Int;
	var xPatCreationHell:Int;
	var levelUnlocked:Int;
	@:optional var limitPerRegion:Int;
	@:optional var factoryNeededToUnlock:Int;
	@:optional var maxSoulsContained:Int;
	@:optional var maxGoldContained:Int;
	@:optional var iDPack1:TableTypePack; // todo : renvoit que l'id et pas le contenu de la table
	@:optional var iDPack2:TableTypePack;
	@:optional var iDPack3:TableTypePack;
	@:optional var iDPack4:TableTypePack;
	@:optional var iDPack5:TableTypePack;
	@:optional var iDPack6:TableTypePack;
	
}

typedef TableTypePack = {
	var iD:Int;
	var name:String; // varchar, mais pourrait être enum ?
	var costGold:Int;
	var costKarma:Int;
	var time:String; // todo type Time ?
	var gainWood:Int;
	var gainIron:Int;
	var gainFluxSouls:Int;
	var productionResource:String; // enum
}

typedef TableTypeIntern = {
	
}

typedef TableTypeShopPack = {
	var iD:Int;
	var tab:ShopTab;
	var packName:String;
	var priceKarma:Int;
	var priceIP:Float;
	var giveGold:Int;
	var giveKarma:Int;
	var giveIron:Int;
	var giveWood:Int;
}


/**
 * ...
 * @author ambroise
 */
class GameConfig {

	private static var config:Map<String, Array<Dynamic>>;

	public static inline var BUILDING:String = "TypeBuilding";
	public static inline var BUILDING_PACK:String = "TypePack"; // todo : renommé TypeBuildingPack
	public static inline var INTERN:String = "TypeIntern";
	public static inline var SHOP_PACK:String = "TypeShopPack";
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
	
	public static function getConfig ():TableConfig {
		return cast(config[CONFIG][0]);
	}
	
	public static function getBuilding ():Array<TableTypeBuilding> {
		return cast(config[BUILDING]);
	}
	
	public static function getBuildingByName (pName:String):TableTypeBuilding {
		for (i in 0...config[BUILDING].length)
			if (config[BUILDING][i].name == pName)
				return config[BUILDING][i];
				
		Debug.error("BuildingName '" + pName +"' missing.");
		return null;
	}
	
	public static function getShopPack ():Array<TableTypeShopPack> {
		return cast(config[SHOP_PACK]);
	}
	
	public static function getShopPackByName (pName:String):TableTypeShopPack {
		for (i in 0...config[SHOP_PACK].length)
			if (config[SHOP_PACK][i].packName == pName)
				return config[SHOP_PACK][i];
				
		Debug.error("ShopPack name '" + pName +"' missing.");
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
				// met les propriétés en maj comme ds la bdd
				// par contre me met le bon type et pas un vulgaire string de json :/
				/*pConfig[fields[i]][j] = Reflect.field( 
					Reflect.field(pContent, fields[i]),
					anotherFields[j]
				);*/
				
				// c'est vrai cela, pourquoi en cours ils mettents des majuscule en bdd les profs ??
				var typedefFields:Array<String> = Reflect.fields(Reflect.field(
					Reflect.field(pContent, fields[i]),
					anotherFields[j]
				));
				var lowerCaseTypeDef:Dynamic = { };
				
				for (n in 0...typedefFields.length) {
					var lKey:String = typedefFields[n];
					var keyToLower:String = lKey.charAt(0).toLowerCase() + lKey.substr(1);
					var lValue:Dynamic = Reflect.field(
						Reflect.field(
							Reflect.field(pContent, fields[i]),
							anotherFields[j]
						),
						typedefFields[n]
					);
					var lNewValue:Dynamic = null;
					
					
					if (ServerManager.stringToEnum(lValue) != null)
						lNewValue = ServerManager.stringToEnum(lValue);
					else if (isInt(lValue))
						lNewValue = Std.parseInt(lValue);
					else if (isFloat(lValue))
						lNewValue = Std.parseFloat(lValue);
					else
						lNewValue = lValue;
					
					Reflect.setProperty(lowerCaseTypeDef, keyToLower, lNewValue);
				}
				
				pConfig[fields[i]][j] = lowerCaseTypeDef;
			}
		}
	}
	
	private static function isInt (pString:String):Bool {
		if (pString == null)
			return true;
		for (i in 0...pString.length) {
			if ("0123456789".indexOf(pString.charAt(i)) == -1)
				return false;
		}
		
		return true;
	}
	
	private static function isFloat (pString:String):Bool {
		if (pString == null)
			return true;
		for (i in 0...pString.length) {
			if (".0123456789".indexOf(pString.charAt(i)) == -1)
				return false;
		}
		
		return true;
	}
	
	public function new() {
		
	}
	
}