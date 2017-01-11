package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.levelUp.LevelUpPoppin;
import com.isartdigital.utils.loader.GameLoader;

/**
 * ...
 * @author Alexis
 */
class UnlockManager
{
	private static var itemToUnlockArray:Array<Array<Array<String>>>;
	public static var itemUnlocked:Array<Array<Array<String>>>;
	public static var itemUnlockedForPoppin:Array<Array<Array<String>>>;
	public static var isAlreadySaved:Bool = false;
	
	/**
	 * check json at the begining of the game
	 */
	public static function setUnlockItem() {
		itemToUnlockArray = [];
		itemUnlocked = [];
		itemUnlockedForPoppin = [];
		parseJsonUnlock(Main.UNLOCK_ITEM_JSON_NAME);
		checkIfFirstTime();
	}
	
	/**
	 * Check if this item is unlocked
	 * @param	pName of the item
	 * @return true or false
	 */
	public static function checkIfUnlocked(pName:String):Bool {
		for (i in 0...itemUnlocked.length) {
			if (pName == itemUnlocked[i][0][1])
				return true;
		}
		return false;
	}
	
	/**
	 * check if it's then first time of the player
	 */
	private static function checkIfFirstTime():Void {
		if (!isAlreadySaved) {
			itemUnlocked = [];
			unlockItem();
		}
		else {
			itemUnlocked = SaveManager.currentSave.itemUnlocked;
			trace(SaveManager.currentSave.itemUnlocked);
		}
	}
	
	/**
	 * Parse json in an array
	 * @param	pJsonName
	 */
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
	
	/**
	 * Unlock item at the level up
	 */
	public static function unlockItem():Void {
		
		if (itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1] == null)
			return;
			
		for (i in 0...itemToUnlockArray.length-1) {
			if (Std.parseFloat(itemToUnlockArray[i][0][0]) == Std.int(ResourcesManager.getLevel())) {
				itemUnlocked[i] = [];
				
				var lItem:Array<String> = itemToUnlockArray[i][0];
				
				if (lItem == null)
					return;
				
				itemUnlocked[i].push(lItem);
				
				if (ResourcesManager.getLevel() != 1) {
					itemUnlockedForPoppin[itemUnlockedForPoppin.length] = [];
					itemUnlockedForPoppin[itemUnlockedForPoppin.length - 1].push(lItem);
					oppenLevelUpPopin();
				}
				SaveManager.save();	
			}
		}
	}
	
	private static function oppenLevelUpPopin ():Void {
		UIManager.getInstance().openPopin(LevelUpPoppin.getInstance());
		Hud.getInstance().hide();
	}
}