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
	public static var playerExperience:Array<Float>;
	public static var playerLevel:Int;
	
	//check json at the begining
	public static function setExpToLevelUp() {
		experienceToLevelUpArray = [];
		itemToUnlockArray = [];
		itemUnlocked = [];
		playerExperience = [];
		parseJsonLevel(Main.EXPERIENCE_JSON_NAME);
		parseJsonUnlock(Main.UNLOCK_ITEM_JSON_NAME);
		checkIfFirstTime();
		setOnHud();
	}
	
	//add exp
	//0 Heaven, 1 hell, 2 all
	public static function addExp(pSide:String, pExp:Float):Void {
		var lNum:Int = 0;
		switch(pSide) {
			case "Heaven" : lNum = 0; 
			case "Hell" : lNum = 1; 
			case "All" : lNum = 2; 
		}
		
		if (lNum != 2) {
			addExpInArray(pExp, lNum);
		}
		else
			for (i in 0...2) {
				addExpInArray(pExp, i);
			}
		
		checkIfLevelUp();
		SaveManager.save();
		setOnHud();
	}
	
	//Check if this item is unlocked
	public static function checkIfUnlocked(pName:String):Bool {
		for (i in 0...itemUnlocked.length) {
			if (pName == itemUnlocked[i])
				return true;
		}
		return false;
	}
	
	private static function addExpInArray(pExp:Float, ?lNum:Int):Void {
		if (playerExperience[lNum] < experienceToLevelUpArray[playerLevel - 1]) {
				if (playerExperience[lNum] + pExp >= experienceToLevelUpArray[playerLevel - 1]) // check to not surpass the limit
					playerExperience[lNum] = experienceToLevelUpArray[playerLevel - 1];
				else
					playerExperience[lNum] += pExp;
		}
	}
	
	
	//check if the player lvl up
	private static function checkIfLevelUp():Void{
		if (playerExperience[0] == experienceToLevelUpArray[playerLevel - 1] && playerExperience[1] == experienceToLevelUpArray[playerLevel - 1]) {
			playerLevel ++;
			setUnlockItem();
		}
	}
	
	//check if it's then first time of the player
	private static function checkIfFirstTime():Void{
		if (SaveManager.currentSave.playerExp == null) {
			playerLevel = 1;
			playerExperience = [0, 0];
			itemUnlocked = [];
			setUnlockItem();
		}
		else {
			playerLevel = SaveManager.currentSave.playerLevel;
			playerExperience = SaveManager.currentSave.playerExp;
			itemUnlocked = SaveManager.currentSave.itemUnlocked;
		}
	}
	
	//add on HUD
	private static function setOnHud() {
		Hud.getInstance().setAllTextValues(playerLevel,true);
		Hud.getInstance().setAllTextValues(playerExperience[0], false, GeneratorType.goodXp);
		Hud.getInstance().setAllTextValues(playerExperience[1], false, GeneratorType.badXp);	
	}
	
	
	//Unlock item
	private static function setUnlockItem() {
		if (itemToUnlockArray[playerLevel - 1] == null)
			return;
		for (i in 0...itemToUnlockArray[playerLevel - 1][0].length) {
			var lItem:String = itemToUnlockArray[playerLevel - 1][0][i];
			trace(lItem);
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