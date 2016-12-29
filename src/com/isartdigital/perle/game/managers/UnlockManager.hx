package com.isartdigital.perle.game.managers;
import com.isartdigital.utils.loader.GameLoader;

/**
 * ...
 * @author Rafired
 */
class UnlockManager
{
	private static var itemToUnlockArray:Array<Array<Array<String>>>;
	public static var itemUnlocked:Array<String>;
	public static var isAlreadySaved:Bool = false;
	
	//check json at the begining
	public static function setUnlockItem() {
		itemToUnlockArray = [];
		itemUnlocked = [];
		parseJsonUnlock(Main.UNLOCK_ITEM_JSON_NAME);
		checkIfFirstTime();
	}
	
	//Check if this item is unlocked
	public static function checkIfUnlocked(pName:String):Bool {
		for (i in 0...itemUnlocked.length) {
			if (pName == itemUnlocked[i])
				return true;
		}
		return false;
	}
	
	//check if it's then first time of the player
	private static function checkIfFirstTime():Void {
		if (!isAlreadySaved) {
			itemUnlocked = [];
			unlockItem();
		}
		else {
			itemUnlocked = [];
			itemUnlocked = SaveManager.currentSave.itemUnlocked;
		}
	}
	
	private static function parseJsonUnlock(pJsonName:String):Void {
		var i:Int = 0;	
		var jsonItem:Dynamic = GameLoader.getContent(pJsonName + ".json");
		for (item in Reflect.fields(jsonItem)) {
			itemToUnlockArray[i] = [];
			var lItem = Reflect.field(jsonItem, item);
			var lArray:Array<String> = lItem;
			itemToUnlockArray[i].push(lArray);
			i++;
		}
	}
	
	//Unlock item
	public static function unlockItem():Void {
		if (itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1] == null)
			return;
		for (i in 0...itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1][0].length) {
			var lItem:String = itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1][0][i];
			if (lItem == null)
				return;
			itemUnlocked.push(lItem);
			trace("Felicitations vous avez débloqué : " + lItem);
		}
		
	}
}