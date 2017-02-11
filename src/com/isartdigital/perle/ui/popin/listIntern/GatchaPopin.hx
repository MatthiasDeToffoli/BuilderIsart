package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author Emeline Berenguier
 */
class GatchaPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe GatchaPopin
	 */
	private static var instance: GatchaPopin;
	
	private var btnClose:SmartButton;
	private var btnGift:SmartButton;
	private var picture:UISprite;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	public static var quest:TimeQuestDescription;
	
	private static inline var GOLD_WON:Int = 1000;
	private static inline var HARD_WON:Int = 5;
	private static inline var WOOD_WON:Int = 1000;
	private static inline var STONE_WON:Int = 1000;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GatchaPopin {
		if (instance == null) instance = new GatchaPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.GATCHA_POPIN);
		getComponents();
		addListeners();	
		setDatas();
	}
	
	private function getComponents():Void{
		btnClose = cast(getChildByName(AssetName.GATCHA_POPIN_CLOSE_BUTTON), SmartButton);
		btnGift = cast(getChildByName(AssetName.GATCHA_POPIN_GATCHA_BAG), SmartButton);
		picture = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_PORTRAIT), UISprite);
		internName = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_NAME), TextSprite);
		aligment = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_SIDE), TextSprite);
	}
	
	public function setDatas():Void{
		internName.text = Intern.getIntern(quest.refIntern).name;
		aligment.text = Intern.getIntern(quest.refIntern).aligment;
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnGift, onGift);
		//Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function onGift():Void{
		ResourcesManager.gainResources(GeneratorType.soft, GOLD_WON);
		ResourcesManager.gainResources(GeneratorType.hard, HARD_WON);
		QuestsManager.finishQuest(quest);
	}
	
	private function onClose():Void {
		if (DialogueManager.ftueStepCloseGatcha)
			return;
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}