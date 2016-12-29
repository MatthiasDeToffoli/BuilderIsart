package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.loader.GameLoader;

/**
 * ...
 * @author Rafired
 */
class ExperienceManager
{
	private static var experienceToLevelUpArray:Array<Int>;
	private static var itemToUnlockArray:Array<Array<Array<String>>>;
	public static var itemUnlocked:Array<String>;
	
	//check json at the begining
	public static function setExpToLevelUp() {
		experienceToLevelUpArray = [];
		itemToUnlockArray = [];
		itemUnlocked = [];
		parseJsonLevel(Main.EXPERIENCE_JSON_NAME);
		parseJsonUnlock(Main.UNLOCK_ITEM_JSON_NAME);
		checkIfFirstTime();
	}
	
	/**
	 * get the max xp can increase depending to level
	 * @param	pLevel current player level
	 * @return the max
	 */
	public static function getMaxExp(pLevel:Int):Float{
		return experienceToLevelUpArray[pLevel - 1];
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
	private static function checkIfFirstTime():Void{
		if (SaveManager.currentSave == null) return;
		if (SaveManager.currentSave.itemUnlocked == null) {
			itemUnlocked = [];
			setUnlockItem();
		}
		else {
			itemUnlocked = SaveManager.currentSave.itemUnlocked;
		}
	}
	
	
	//Unlock item
	private static function setUnlockItem() {
		if (itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1] == null)
			return;
		for (i in 0...itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1][0].length) {
			var lItem:String = itemToUnlockArray[Std.int(ResourcesManager.getLevel()) - 1][0][i];
			//trace(lItem);
			if (lItem == null)
				return;
			itemUnlocked.push(lItem);
			trace("Felicitations vous avez débloqué : " + lItem);
		}
		SaveManager.save();
	}
	
	//Parse of the json to set an array
	private static function parseJsonLevel(pJsonName:String):Void{
		var jsonExp:Dynamic = GameLoader.getContent(pJsonName + ".json");
		for (level in Reflect.fields(jsonExp)) {
			experienceToLevelUpArray.push(Reflect.field(jsonExp, level));
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
}