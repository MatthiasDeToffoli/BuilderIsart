package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.dialogue.DialoguePoppin;
import com.isartdigital.perle.ui.popin.levelUp.LevelUpPoppin;
import com.isartdigital.utils.game.GameStage;
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
	
	private static var UNLOCK_LEVELS:Array<Int> = [1, 11, 14, 20];
	private static var UNLOCK_PLACES:Map<Int, Int> = [1 => 2, 11 => 2, 14 => 3, 20 => 4];
	
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
		if (lLevel == LEVEL_UNLOCK_SPECIAL || lLevel == LEVEL_UNLOCK_COLLECTORS || lLevel == LEVEL_UNLOCK_FACTORY || lLevel == LEVEL_UNLOCK_ALTAR || lLevel == LEVEL_UNLOCK_MARKETING) {
			
			GameStage.getInstance().getFtueContainer().addChild(DialoguePoppin.getInstance());
			DialogueManager.nextStep();
		}
	}
	
	/**
	 * Get the correct number of empty places availables
	 * @return
	 */
	public static function getNumberPlaces():Int{
		var lNumberPlaces:Int = 0;
		
		for (i in 0...UNLOCK_LEVELS.length){
			if (UNLOCK_LEVELS[i] <= ResourcesManager.getLevel() && ResourcesManager.getLevel() < UNLOCK_LEVELS[i + 1]){
				lNumberPlaces = UNLOCK_PLACES[UNLOCK_LEVELS[i]];
				return lNumberPlaces;
			}
			if (UNLOCK_LEVELS[UNLOCK_LEVELS.length - 1] <= ResourcesManager.getLevel()){
				lNumberPlaces = UNLOCK_LEVELS[UNLOCK_LEVELS[UNLOCK_LEVELS.length - 1]];
				return lNumberPlaces; 
			}
		}
		return lNumberPlaces;
	}
	
	/**
	 * Return the level of the unlock heaven interns 
	 * @return
	 */
	public static function getLevelUnlockHeaven():Int{
		var lLevel:Int = 1;
		for (levelUnlock in Intern.internsToUnlockHeaven.keys()){
			if (levelUnlock <= ResourcesManager.getLevel()) lLevel = levelUnlock;
			if (ResourcesManager.getLevel() < levelUnlock) break;
		}
		
		return lLevel;
	}
	
	/**
	 * Return the level of the unlock hell interns 
	 * @return
	 */
	public static function getLevelUnlockHell():Int{
		var lLevel:Int = 1;
		for (levelUnlock in Intern.internsToUnlockHell.keys()){
			if (levelUnlock <= ResourcesManager.getLevel()) lLevel = levelUnlock;
			if (ResourcesManager.getLevel() < levelUnlock) break;
		}
		
		return lLevel;
	}
	
	private static function oppenLevelUpPopin ():Void {
		UIManager.getInstance().openPopin(LevelUpPoppin.getInstance());
		Hud.getInstance().hide();
	}
	
}