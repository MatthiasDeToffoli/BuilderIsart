package com.isartdigital.perle.game.managers.server;
import com.isartdigital.utils.Debug;
import haxe.Json;


typedef EventSuccessBuyShopPack = {
	@:optional var errorID:Int;
}

/**
 * ...
 * @author ambroise
 */
class ServerManagerShop {
	
	public static function buyShopPack (pConfigID:Int):Void {
		ServerManager.callPhpFile(onSuccessBuyShopPack, onErrorBuyShopPack, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.BUY_SHOP_PACK,
			"ID" => pConfigID,
		]);
	}
	
	private static function onErrorBuyShopPack (pObject:Dynamic):Void {
		Debug.error("Error php on buyShopPack : " + pObject);
	}
	
	
	private static function onSuccessBuyShopPack (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			var lEvent:EventSuccessBuyShopPack = Json.parse(pObject);

			if (Reflect.hasField(lEvent, "errorID")) {
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}
			//else 
				//SynchroManager.syncTimeOfBuilding(lEvent); // todo synchro resources et non temps
			
			
		} /*else {
			Debug.error("Success php on buyShopPack but event format is invalid ! : " + pObject);
		}*/
		
	}
	
}