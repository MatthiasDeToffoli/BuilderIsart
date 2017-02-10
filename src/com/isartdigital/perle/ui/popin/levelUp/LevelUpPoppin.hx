package com.isartdigital.perle.ui.popin.levelUp;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author Alexis
 */
class LevelUpPoppin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe LevelUpPoppin
	 */
	private static var instance: LevelUpPoppin;
	
	private static var level:TextSprite;
	private static var typeUnlock:TextSprite;
	private static var nameUnlock:TextSprite;
	private static var description:TextSprite;
	private static var img:UISprite;
	private static var imgImage:FlumpStateGraphic;
	private var btnNext:SmartButton;
	private var btnCloseAll:SmartButton;
	private var bgLvl:SmartComponent;
	private var unlock:SmartComponent;
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelUpPoppin {
		if (instance == null) instance = new LevelUpPoppin();
		return instance;
	}
	
	private static function setPopin():Void {
		//todo : rajouter la description, level type du batiment
		level.text = "" + ResourcesManager.getLevel();
		SmartPopinExtended.setImage(img, BuildingName.getAssetName(UnlockManager.unlockedItem[0].name, UnlockManager.unlockedItem[0].level)); 
		
		nameUnlock.text = UnlockManager.unlockedItem[0].name;
		//typeUnlock.text = UnlockManager.itemUnlockedForPoppin[0][0][3];
		//description.text = UnlockManager.itemUnlockedForPoppin[0][0][4];
		
	}
	
	private static function closeAll():Void {
		UnlockManager.unlockedItem = [];
		onClickNext();
	}
	
	private static function onClickNext():Void {
		UnlockManager.unlockedItem.splice(0, 1);
		if (UnlockManager.unlockedItem.length != 0) {
			img.removeChild(imgImage);
			setPopin();
		}
		else {
			if (DialogueManager.ftueCloseUnlockedItem)
				DialogueManager.endOfaDialogue();
			Hud.getInstance().show();
			UIManager.getInstance().closeCurrentPopin();
			UnlockManager.checkIfNeedToCreateDialogue();
		}
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
		btnCloseAll = cast(getChildByName(AssetName.LEVELUP_POPPIN_PASSALL), SmartButton);
		Interactive.addListenerClick(btnNext, onClickNext);
		Interactive.addListenerClick(btnCloseAll, closeAll);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnNext, onClickNext);
		Interactive.removeListenerClick(btnCloseAll, closeAll);
		
		instance = null;
	}

}