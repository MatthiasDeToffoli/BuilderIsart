package com.isartdigital.perle.game;
import com.isartdigital.perle.game.GameConfig.TableTypePack;
import com.isartdigital.perle.game.managers.ChoiceManager.ChoiceDescription;
import com.isartdigital.perle.game.managers.ChoiceManager.EfficiencyStep;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.loader.GameLoader;


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
	@:optional var productionType:String; // enum : Real Time ou je sais plus quoi, voir bdd
	@:optional var productionPerHour:Int;
	@:optional var productionResource:GeneratorType; // enum
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
	var time:String;
	var gainWood:Int;
	var gainIron:Int;
	var gainFluxSouls:Int;
	var productionResource:GeneratorType; // enum
}

typedef TableTypeIntern = {
	
}

typedef TableTypeShopPack = {
	var iD:Int;
	var tab:ShopTab;
	var packName:String;
	var iconLevel:Int;
	@:optional var priceKarma:Int;
	@:optional var priceIP:Float;
	@:optional var giveGold:Int;
	@:optional var giveKarma:Int;
	@:optional var giveIron:Int;
	@:optional var giveWood:Int;
	@:optional var oneTimeOffer:Bool;
}

typedef TableInterns = {
	var iD:Int;
	var name:String;
	var	alignment:String;
	var price:Int;
	var stress:Int;
	var speed:Int;
	var efficiency:Int;
	var unlockLevel:Int;
	var idEvent:Int;
	var portrait:String;
}

typedef TableSoulText = {
	var fr:String;
	var en:String;
	var id:Int;
}

typedef TableLevelRewards = {
	var iD:Int;
	var gold:Int;
	@:optional var wood:Int;
	@:optional var iron:Int;
}

/**
 * ...
 * @author ambroise
 * @author autre
 */
class GameConfig {

	private static var config:Map<String, Array<Dynamic>>;

	public static inline var BUILDING:String = "TypeBuilding";
	public static inline var BUILDING_PACK:String = "TypePack"; // todo : renommé TypeBuildingPack
	public static inline var INTERN:String = "TypeIntern";
	public static inline var SHOP_PACK:String = "TypeShopPack";
	public static inline var CONFIG:String = "Config";
	public static inline var INTERNS:String = "Interns";
	public static inline var LEVELREWARD:String = "LevelReward";
	public static inline var CHOICES:String = "Choices";
	public static inline var CONFIG_EVENT:String = "ConfigEvent";
	public static inline var USED_CHOICES:String = "ChoicesUsed";
	public static inline var SOUL_NAME:String = "SoulName";
	public static inline var SOUL_ADJ:String = "SoulAdjective";
	
	
	public static function awake ():Void {
		config = new Map<String, Array<Dynamic>>();
		parseJson(config, GameLoader.getContent(Main.GAME_CONFIG));
		/*trace(config);
		trace(config[LEVELREWARD]);
		trace(config[LEVELREWARD][0]);
		trace(config[LEVELREWARD][0].gold);*/
	}
	
	public static function getConfig ():TableConfig {
		return cast(config[CONFIG][0]);
	}
	
	public static function getBuilding ():Array<TableTypeBuilding> {
		return cast(config[BUILDING]);
	}
	
	public static function getInterns():Array<TableInterns> {
		return cast(config[INTERNS]);
	}
	
	public static function getChoices():Array<ChoiceDescription> {
		return cast(config[CHOICES]);
	}
	
	public static function getChoicesConfig():Array<EfficiencyStep> {
		return cast(config[CONFIG_EVENT]);
	}
	
	public static function getLevelRewardsConfig():Array<TableLevelRewards> {
		return cast(config[LEVELREWARD]);
	}
	
	public static function getBuildingPack(pType:GeneratorType):Array<TableTypePack> {
		
		var lArray:Array<TableTypePack> = new Array<TableTypePack>();
		var lTypePack:TableTypePack;
		
		for (lTypePack in config[BUILDING_PACK])
			if (pType == lTypePack.productionResource) lArray.push(lTypePack);
		lArray.sort(sortpackArrayById);
		return lArray;
	}
	
	public static function getBuildingPackById(pId:Int):TableTypePack {
		
		var lTypePack:TableTypePack;
		
		for (lTypePack in config[BUILDING_PACK])
			if (pId == lTypePack.iD) return lTypePack;
			
		return null;
	}
	
	private static function sortpackArrayById(pack1:TableTypePack, pack2:TableTypePack):Int {
		if (pack1.iD < pack2.iD) return -1;
		if (pack1.iD > pack2.iD) return 1;
		return 0;
	}
	
	public static function getBuildingByName (pName:String, ?pLevel:Int):TableTypeBuilding {
		for (i in 0...config[BUILDING].length)
			if (config[BUILDING][i].name == pName)
				if (pLevel == null || config[BUILDING][i].level == pLevel) 
					return config[BUILDING][i];
				
		Debug.error("BuildingName '" + pName +"' missing.");
		return null;
	}
	
	public static function getBuildingByID (pID:Int):TableTypeBuilding {
		for (i in 0...config[BUILDING].length)
			if (config[BUILDING][i].iD == pID)
				return config[BUILDING][i];
				
		Debug.error("BuildingID '" + pID +"' missing.");
		return null;
	}
	
	public static function countSoulName():Int {
		return config[SOUL_NAME].length;
	}
	
	public static function countSoulAdj():Int {
		return config[SOUL_ADJ].length;
	}
	
	public static function getSoulName(i:Int):TableSoulText {
		return config[SOUL_NAME][i];
	}
	
	public static function getSoulAdjective(i:Int):TableSoulText {
		return config[SOUL_ADJ][i];
	}
	
	public static function getShopPack ():Array<TableTypeShopPack> {
		return cast(config[SHOP_PACK]);
	}
	
	public static function getShopPackOneTimeOffer ():Array<TableTypeShopPack> {
		var lArray:Array<TableTypeShopPack> = cast(config[SHOP_PACK]);
		return lArray.filter(function (p:TableTypeShopPack) {
			return p.oneTimeOffer;
		});
	}
	
	public static function getShopPackByName (pName:String):TableTypeShopPack {
		for (i in 0...config[SHOP_PACK].length)
			if (config[SHOP_PACK][i].packName == pName)
				return config[SHOP_PACK][i];
				
		Debug.error("ShopPack name '" + pName +"' missing.");
		return null;
	}
	
	public static function parseJson (pConfig:Map<String, Array<Dynamic>>, pContent:Dynamic):Void {
		
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
				
				// j'aurais très pu utiliser lcFirst() côté server je pense.
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
					else if (Type.typeof(lValue).getName() == "TInt") // is already an init whitout ""
						lNewValue = lValue;
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