package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.loader.GameLoader;

/**
 * ...
 * @author Alexis
 */
class ExperienceManager
{
	private static var experienceToLevelUpArray:Array<Int>;
	
	/**
	 * check json at the begining of the game
	 */
	public static function setExpToLevelUp() {
		experienceToLevelUpArray = [];
		//parseJsonLevel(Main.EXPERIENCE_JSON_NAME);
		getFromBDDExp();
	}
	
	/**
	 * get the max xp can increase depending to level
	 * @param	pLevel current player level
	 * @return the max
	 */
	public static function getMaxExp(pLevel:Int):Float{
		return experienceToLevelUpArray[pLevel - 1];
	}
	
	private static function getFromBDDExp():Void {
		for (i in 0...GameConfig.getMaxExpConfig().length)
			experienceToLevelUpArray.push(GameConfig.getMaxExpConfig()[i].value);
	}
	
	/**
	 * Parse of the json to set an array
	 * @param	pJsonName
	 */
	private static function parseJsonLevel(pJsonName:String):Void{
		var jsonExp:Dynamic = GameLoader.getContent(pJsonName + ".json");
		for (level in Reflect.fields(jsonExp)) {
			experienceToLevelUpArray.push(Reflect.field(jsonExp, level));
		}
		trace(experienceToLevelUpArray);
	}
}