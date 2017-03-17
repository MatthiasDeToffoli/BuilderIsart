package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.DeltaDNAManager;
import com.isartdigital.perle.game.managers.server.ServerManagerLoad;
import com.isartdigital.perle.game.managers.server.ServerManagerShop;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselBuilding;
import com.isartdigital.services.monetization.Wallet;
import com.isartdigital.utils.Debug;
import js.Browser;

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
	
	public static var currentIsartPoint(default, null):Int = 0;
	
	// todo: because asynchronous, it may come too late, to fix (don't load until callbakc)
	public static function setIPMoney (pEvent:Dynamic):Void {
		trace("Your IsartPoint money is: " + pEvent.money);
		currentIsartPoint = pEvent.money;
	}
	
	public static function buy (pBuildingName:String, pLevel:Int=1):Void {
		
		var lPrice:Map<GeneratorType, Int> = getPrice(pBuildingName);
		
		for (lGeneratorType in lPrice.keys()) {
			ResourcesManager.spendTotal(
				lGeneratorType,
				lPrice[lGeneratorType]
			);
		}
		
		var isBuilding:Bool = ShopCarousselBuilding.getNameList().indexOf(pBuildingName) != -1;
		
		DeltaDNAManager.sendTransaction(
			isBuilding ? TransactionType.boughtBuilding : TransactionType.boughtDecoration,
			GameConfig.getBuildingByName(pBuildingName, pLevel).iD,
			GeneratorType.soft,
			lPrice[GeneratorType.soft]
		);
	}
	
	
	public static function sell (pBuildingName:String,  isConstructed:Bool, pLevel:Int=1):Void { // todo : vérifier les fc qui envoit isConstructed
		
		var lSellPrice:Map<GeneratorType, Int> = getSellPrice(pBuildingName, isConstructed);
		
		for (lGeneratorType in lSellPrice.keys()) {
			ResourcesManager.gainResources(
				lGeneratorType,
				lSellPrice[lGeneratorType]
			);
		}
		
		var isBuilding:Bool = ShopCarousselBuilding.getNameList().indexOf(pBuildingName) != -1;
		
		DeltaDNAManager.sendTransaction(
			isBuilding ? TransactionType.soldBuilding : TransactionType.soldDecoration,
			GameConfig.getBuildingByName(pBuildingName, pLevel).iD,
			GeneratorType.soft,
			lSellPrice[GeneratorType.soft]
		);
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
	
	
	// todo : pas cohérent avec les autres functions :/
	// todo : répétitif
	public static function canBuyShopPack (pPrice:Map<GeneratorType, Float>):Bool {
		// ajouter alpha
		// browser alert
		// factoriser c'te classe
		
		if (ServerManagerLoad.getPlayer().email == null)
			Browser.alert("Whitout connecting to facebook and retrieving your email, you can't use IsartPoint.");
		
		// todo : hack à enlever lorsque isartPoint gérer.
		if (pPrice[GeneratorType.isartPoint] != null &&
			currentIsartPoint >= pPrice[GeneratorType.isartPoint] &&
			ServerManagerLoad.getPlayer().email != null)
			return true;
		
		for (lGeneratorType in pPrice.keys()) { 
			if (ResourcesManager.getTotalForType(lGeneratorType) < pPrice[lGeneratorType])
				return false;
		}
		
		return true;
	}
	
	/**
	 * 
	 * @param	pPrice (float cause isartPoint)
	 * @param	pGain
	 */
	public static function buyShopPack (pPrice:Map<GeneratorType, Float>, pGain:Map<GeneratorType, Int>, pConfigID:Int):Void {
		var isIsartPoint:Bool = false;
		var lHardPrice:Float = 0;
		
		
		ServerManagerShop.buyShopPack(pConfigID);
		
		for (lGeneratorType in pPrice.keys()) {
			
			
			if (lGeneratorType == GeneratorType.isartPoint) {
				DeltaDNAManager.sendTransaction(
					TransactionType.shopPackBought,
					pConfigID,
					GeneratorType.isartPoint,
					pPrice[lGeneratorType]
				);
				
				// todo : no security, but it's okay say for now Matthieu. (you can buy for less)
				Wallet.buy(
					ServerManagerLoad.getPlayer().email,
					pPrice[lGeneratorType],
					onWalletEvent
				);
				
				isIsartPoint = true;
				continue;
			}
			
			lHardPrice = pPrice[lGeneratorType];
			ResourcesManager.spendTotal(
				lGeneratorType,
				cast(pPrice[lGeneratorType], Int) // isartPoint is a float, but not karma, so no error.
			);
		}
		
		for (lGeneratorType in pGain.keys()) {
			ResourcesManager.gainResources(
				lGeneratorType,
				pGain[lGeneratorType]
			);
		}
		
		if (!isIsartPoint) {
			DeltaDNAManager.sendTransaction(
				TransactionType.shopPackBought,
				pConfigID,
				GeneratorType.hard,
				lHardPrice
			);
		}
	}
	
	public static function onWalletEvent (pEvent:Dynamic):Void {
		trace("After buying your money is:" + pEvent.money);
		currentIsartPoint = pEvent.money;
	}
	
	/*public static function getPriceShopPack (pShopPackName:String):Map<GeneratorType, Int> {
		var lConfig:TableTypeShopPack = GameConfig.getShopPackByName(pShopPackName);
		
		if (lConfig == null) {
			Debug.error("ShopPack : '" + pShopPackName + "' doesn't exist in gameconfig json !");
			return [
				GeneratorType.isartPoint => 0,
				GeneratorType.hard => 0
			]; 
		}
		
		return [
			GeneratorType.isartPoint => lConfig.priceIP,
			GeneratorType.hard => lConfig.priceKarma
		];
	}*/
	
}