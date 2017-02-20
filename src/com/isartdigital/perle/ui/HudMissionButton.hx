package com.isartdigital.perle.ui;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Rafired
 */
class HudMissionButton
{
	public static var numberOfDecorationCreated = 0;
	public static var missionIsOn = false;
	public static inline var MISSION_MAX:Int = 3;
	
	public static inline var EXP_HEAVEN:Int = 600;
	public static inline var EXP_HELL:Int = 600;
	
	
	private static function checkIfOver(?pCanLvlUp:Bool) {
		if (numberOfDecorationCreated >= MISSION_MAX) {
			Hud.getInstance().buttonMissionDeco.visible = false;
			missionIsOn = false;
			if (pCanLvlUp) {
				ResourcesManager.gainResources(GeneratorType.goodXp,EXP_HEAVEN);
				ResourcesManager.gainResources(GeneratorType.badXp,EXP_HELL);
			}
		}
	}
	
	public static function updateHud() {
		var lText:TextSprite = cast(SmartCheck.getChildByName(Hud.getInstance().buttonMissionDeco, AssetName.HUD_MISSION_DECO_TEXT), TextSprite);
		lText.text = numberOfDecorationCreated + "/" + MISSION_MAX;
	}
	
	public static function initFromLoad() {
		var lSave:Int = SaveManager.currentSave.missionDecoration;
		//check if first time
		if(SaveManager.currentSave.missionDecoration!=null)
			numberOfDecorationCreated = SaveManager.currentSave.missionDecoration;
		else 
			numberOfDecorationCreated = 0;
			
		updateHud();
		missionIsOn = true;
		checkIfOver();
	}
	
	public static function addDecoCreated() {
		numberOfDecorationCreated ++;
		updateHud();
		checkIfOver(true);
		SaveManager.save();
	}
	
	public static function getMissionOn():Bool {
		return missionIsOn;
	}
}