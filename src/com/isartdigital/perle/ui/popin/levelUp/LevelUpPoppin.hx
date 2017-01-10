package com.isartdigital.perle.ui.popin.levelUp;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
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
	private var level:TextSprite;
	private var type:TextSprite;
	private var nameUnlock:TextSprite;
	private var description:TextSprite;
	private var img:UISprite;
	
	/**
	 * instance unique de la classe LevelUpPoppin
	 */
	private static var instance: LevelUpPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (pItem:String): LevelUpPoppin {
		if (instance == null) instance = new LevelUpPoppin(pItem);
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pItem:String) 
	{
		super(AssetName.LEVELUP_POPPIN);
		setWireframe();
		
		level.text = "" + ResourcesManager.getLevel();
		//type = 
		//todo : pour le type  reprendre en fonction de la classe et avec les maps
		nameUnlock.text = pItem;
		description.text = "WHAT A GDP";
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
		type = cast(getChildByName(AssetName.LEVELUP_POPPIN_TYPE), TextSprite);
		
		img = cast(SmartCheck.getChildByName(unlock, AssetName.LEVELUP_POPPIN_IMG), UISprite);
		
		btnNext = cast(getChildByName(AssetName.LEVELUP_POPPIN_BUTTON), SmartButton);
		btnNext.on(MouseEventType.CLICK, onClickNext);
	}
	
	private static function onClickNext():Void {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}
	
	/*SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> BG_SkipTimerBG
Boot.hx:62 SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> _txt_type
Boot.hx:62 SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> _txt_congratulations
Boot.hx:62 SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> _unlock
Boot.hx:62 SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> _txt_new
Boot.hx:62 SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> _bg_level
Boot.hx:62 SmartCheck.hx:41: [com,isartdigital,perle,ui,popin,levelUp,LevelUpPoppin] >=> Button_SkipTimeConfirm*/

}