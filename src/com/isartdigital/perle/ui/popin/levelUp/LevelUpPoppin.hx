package com.isartdigital.perle.ui.popin.levelUp;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author Rafired
 */
class LevelUpPoppin extends SmartPopin 
{
	
	private var btnNext:SmartButton;
	private var bgLvl:SmartComponent;
	private var unlock:SmartComponent;
	private static var level:TextSprite;
	private static var typeUnlock:TextSprite;
	private static var nameUnlock:TextSprite;
	private static var description:TextSprite;
	private static var img:UISprite;
	
	/**
	 * instance unique de la classe LevelUpPoppin
	 */
	private static var instance: LevelUpPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelUpPoppin {
		if (instance == null) instance = new LevelUpPoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.LEVELUP_POPPIN);
		setWireframe();
		setPopin();
	}
	
	private static function setPopin():Void {
		level.text = "" + ResourcesManager.getLevel();
		nameUnlock.text = UnlockManager.itemUnlockedForPoppin[0][0][2];
		typeUnlock.text = UnlockManager.itemUnlockedForPoppin[0][0][3];
		description.text = UnlockManager.itemUnlockedForPoppin[0][0][4];
		
		UnlockManager.itemUnlockedForPoppin.splice(UnlockManager.itemUnlockedForPoppin.length - 1, 1);
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		bgLvl = cast(getChildByName(AssetName.LEVELUP_POPPIN_LEVELBG), SmartComponent);
		unlock = cast(getChildByName(AssetName.LEVELUP_POPPIN_UNLOCK), SmartComponent);
		
		level = cast(SmartCheck.getChildByName(bgLvl, AssetName.LEVELUP_POPPIN_LEVEL), TextSprite);
		nameUnlock = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_NAME), TextSprite);
		description = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_DESCRIPTION), TextSprite);
		typeUnlock = cast(getChildByName(AssetName.LEVELUP_POPPIN_TYPE), TextSprite);
		
		img = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_IMG), UISprite);
		
		btnNext = cast(getChildByName(AssetName.LEVELUP_POPPIN_BUTTON), SmartButton);
		btnNext.on(MouseEventType.CLICK, onClickNext);
	}
	
	private static function onClickNext():Void {
		if (UnlockManager.itemUnlockedForPoppin.length != 0)
			setPopin();
		else {
			Hud.getInstance().show();
			UIManager.getInstance().closeCurrentPopin();
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}