package com.isartdigital.perle.game.managers;
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
	var assets:Map<String, PriceElement> ;
	// autre element du shop, comme le taux de convertion d'une currencie en une autre, ou des objets qu'on pourrait acheter comme stagiaire ou quete, etc
	// de la meme facon faire un enum
}

/**
 * ...
 * @author ambroise
 */
class BuyManager {

	private static var buyPrice:BuyPrice;
	
	public static function initClass ():Void {		
		parseJson();
	}
	
	public static function buy (pAssetName:String):Bool {
		if (!checkAssetName(pAssetName))
			return true; // if nothing is json it is FREE \o/
		if (canBuy(pAssetName)) {
			ResourcesManager.spendTotal(
				buyPrice.assets[pAssetName].type,
				buyPrice.assets[pAssetName].price
			);
			return true;
		}
		return false;
	}
	
	// todo : refund différent si en construction
	public static function sell (pAssetName:String):Void {
		// todo : pourquoi c'est un float dans le tableau contenant les total du resourceManager ?
		ResourcesManager.spendTotal(
			buyPrice.assets[pAssetName].type,
			// todo : la fc spendTotal est prévu poru fonctionner de cette manière ?
			- Math.ceil(buyPrice.assets[pAssetName].price * buyPrice.refundRatioBuilded) 
		);
	}
	
	public static function getSellPrice(pAssetName:String):Int {
		return(Math.ceil(buyPrice.assets[pAssetName].price * buyPrice.refundRatioBuilded) );
	}
	
	public static function canBuy (pAssetName:String):Bool {
		if (!checkAssetName(pAssetName))
			return true; // if nothing is json it is FREE \o/
		
		return ResourcesManager.getTotalForType(buyPrice.assets[pAssetName].type) >= 
			   buyPrice.assets[pAssetName].price;
	}
	
	public static function checkPrice(pAssetName:String):Int {
		if (!checkAssetName(pAssetName))
			return 0; // if nothing is json it is FREE \o/
			
		return buyPrice.assets[pAssetName].price;
	}
	
	private static function checkAssetName (pAssetName:String):Bool {
		if (buyPrice.assets[pAssetName] == null) {
			Debug.error("Assetname : '" + pAssetName + "' doesn't exist in buyprice json !");
			return false;
		}
		return true;
	}
	
	private static function parseJson ():Void {
		// ### Haxe et JSON cela fait 11. Cela devrait être aussi simple que ci-dessous. ###
		//var lString:String = Json.stringify(GameLoader.getContent(Main.PRICE_JSON_NAME + ".json"));
		//untyped var lTest = Browser.window.JSON.parse(lString);
		//untyped trace(lTest.assets["House"]);
		
		var lJson:Dynamic = GameLoader.getContent(Main.PRICE_JSON_NAME);
		
		// ### get fields like refund taht don't need reflect ###
		// ### and json par, stringify to deepCopy or it will modify lJson ###
		buyPrice = Json.parse(Json.stringify(lJson));
		
		// ### create a map ###
		buyPrice.assets = new Map<String, PriceElement>();
		
		
		var fields:Array<String> = Reflect.fields(lJson.assets);
		for (i in 0...fields.length) {
			//trace(fields[i]); // ### key ###
			//trace(Reflect.field(lJson.assets, fields[i])); // ### value ###
			
			// ### refilling the Map, thx god i don't need to reflect the PriceElement ###
			buyPrice.assets[fields[i]] = Reflect.field(lJson.assets, fields[i]);
			
			// ### Haxe think it's an enum so i need to cast it to string, because that's what it is realy and then convert to enum ###
			buyPrice.assets[fields[i]].type = SaveManager.stringToEnum(cast(buyPrice.assets[fields[i]].type, String));
		}
		
		// ### would be nice if this line only could make the job ###
		//buyPrice = GameLoader.getContent(Main.PRICE_JSON_NAME + ".json");
		
		// ### here it work ! ###
		//trace(buyPrice.assets["House"].price);
		//trace(buyPrice.assets["House"].type);
		//trace(buyPrice.refundRatioBuilded);
	}
	
}