package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;

typedef PriceElement = {
	var type:GeneratorType;
	var price:Int;
}

typedef BuyPrice = {
	// key is assetName (may change to be less dependant from DA)
	var refundRatioBuilded:Float;
	var refundRatioConstructing:Float;
	var assets:Map<String, PriceElement>;
	// autre element du shop, comme le taux de convertion d'une currencie en une autre, ou des objets qu'on pourrait acheter comme stagiaire ou quete, etc
	// de la meme facon faire un enum
}

/**
 * ...
 * @author ambroise
 */
class BuyManager {
	
	
	public static function buy (pBuildingName:String):Void {
		
		var lPrice:Map<GeneratorType, Int> = getPrice(pBuildingName);
		
		for (lGeneratorType in lPrice.keys()) {
			ResourcesManager.spendTotal(
				lGeneratorType,
				lPrice[lGeneratorType]
			);
		}
	}
	
	
	public static function sell (pBuildingName:String,  isConstructed:Bool):Void { // todo : vérifier les fc qui envoit isConstructed
		
		var lSellPrice:Map<GeneratorType, Int> = getSellPrice(pBuildingName, isConstructed);
		
		for (lGeneratorType in lSellPrice.keys()) {
			ResourcesManager.gainResources(
				lGeneratorType,
				lSellPrice[lGeneratorType]
			);
		}
		
	}
	
	public static function getSellPrice(pBuildingName:String, isConstructed:Bool):Map<GeneratorType, Int> { // todo : vérifier les fc qui envoit isConstructed
		
		var lPrice:Map<GeneratorType, Int> = getPrice(pBuildingName);
		var lRatio:Float = isConstructed ? GameConfig.getConfig().refundRatioBuilded : GameConfig.getConfig().refundRatioConstruct;
		
		for (lGeneratorType in lPrice.keys()) {
			lPrice[lGeneratorType] = Math.ceil(lPrice[lGeneratorType] * lRatio);
		}
		
		return lPrice;
	}
	
	public static function canBuy (pBuildingName:String):Bool {
		
		var lPrice:Map<GeneratorType, Int> = getPrice(pBuildingName);
		
		for (lGeneratorType in lPrice.keys()) {
			if (ResourcesManager.getTotalForType(lGeneratorType) < lPrice[lGeneratorType])
				return false;
		}
		
		return true;
	}
	
	public static function getPrice(pBuildingName:String):Map<GeneratorType, Int> {
		
		var lBuilding:TableTypeBuilding = GameConfig.getBuildingByName(pBuildingName);
		
		if (lBuilding == null) {
			Debug.error("BuildingName : '" + pBuildingName + "' doesn't exist in gameconfig json !");
			return [
				GeneratorType.soft => 0,
				GeneratorType.buildResourceFromHell => 0,
				GeneratorType.buildResourceFromParadise => 0,
				GeneratorType.hard => 0
			]; 
		}
		
		return [
			GeneratorType.soft => lBuilding.costGold,
			GeneratorType.buildResourceFromHell => lBuilding.costIron,
			GeneratorType.buildResourceFromParadise => lBuilding.costWood,
			GeneratorType.hard => lBuilding.costKarma // todo : savoir quoi faire avec les altars...
		];
	}
	
}