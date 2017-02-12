package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
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
	public static var unlockedItem:Array<TableTypeBuilding>;
	private static inline var LEVEL_UNLOCK_SPECIAL:Float = 3;
	private static inline var LEVEL_UNLOCK_COLLECTORS:Float = 5;
	private static inline var LEVEL_UNLOCK_FACTORY:Float = 6;
	private static inline var LEVEL_UNLOCK_ALTAR:Float = 9;
	private static inline var LEVEL_UNLOCK_MARKETING:Float = 10;
	
	/**
	 * Check if this item is unlocked
	 * @param	pName of the item
	 * @return true or false
	 */
	public static function checkIfUnlocked(pName:String, ?pLevel:Int):Bool {
		if (ResourcesManager.getLevel() >= GameConfig.getBuildingByName(pName,pLevel).levelUnlocked)
			return true;
		
		return false;
	}
	
	/**
	 * Function to check what's the level to unlock this item
	 * @param	pName of the item
	 * @return level in int
	 */
	public static function checkLevelNeeded(pName:String):Int {
		return GameConfig.getBuildingByName(pName).levelUnlocked;
	}
	
	/**
	 * Unlock item at the level up
	 */
	public static function unlockItem():Void {
		unlockedItem = [];
		
		for (i in 0...GameConfig.getBuilding().length-1) {
			if (GameConfig.getBuilding()[i].levelUnlocked == ResourcesManager.getLevel())
				unlockedItem.push(GameConfig.getBuilding()[i]);
		}
		
		if(unlockedItem[0] !=null)
			oppenLevelUpPopin();
	}
	
	public static function checkIfNeedToCreateDialogue() {
		var lLevel = ResourcesManager.getLevel();
		if (lLevel == LEVEL_UNLOCK_SPECIAL || lLevel == LEVEL_UNLOCK_COLLECTORS || lLevel == LEVEL_UNLOCK_FACTORY || lLevel == LEVEL_UNLOCK_ALTAR || lLevel == LEVEL_UNLOCK_MARKETING)
			DialogueManager.nextStep();
	}
	
	private static function oppenLevelUpPopin ():Void {
		UIManager.getInstance().openPopin(LevelUpPoppin.getInstance());
		Hud.getInstance().hide();
	}
	
}