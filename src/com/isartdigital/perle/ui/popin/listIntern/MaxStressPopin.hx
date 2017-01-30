package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * ...
 * @author Emeline Berenguier
 */
class MaxStressPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe MaxStress
	 */
	private static var instance: MaxStressPopin;
	
	private var btnClose:SmartButton;
	private var btnResetTextValue:TextSprite;
	private var btnDismiss:SmartButton;
	private var btnReset:SmartButton;
	private var picture:UISprite;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	public static var quest:TimeQuestDescription;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MaxStressPopin {
		if (instance == null) instance = new MaxStressPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(AssetName.INTERN_EVENT_MAX_STRESS);
		getComponents();
		setDatas();
		addListeners();
	}
	
	private function getComponents():Void{
		btnClose = cast(getChildByName(AssetName.MAXSTRESS_POPIN_CLOSE_BUTTON), SmartButton);
		btnDismiss = cast(getChildByName(AssetName.MAXSTRESS_POPIN_DISMISS_BUTTON), SmartButton);
		btnReset = cast(getChildByName(AssetName.MAXSTRESS_POPIN_RESET_BUTTON), SmartButton);
		btnResetTextValue = cast(SmartCheck.getChildByName(btnReset, AssetName.MAXSTRESS_POPIN_RESET_TEXT), TextSprite);
		picture = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_PORTRAIT), UISprite);
		internName = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_NAME), TextSprite);
		aligment = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_SIDE), TextSprite);
	}
	
	public function setDatas():Void{
		internName.text = Intern.getIntern(quest.refIntern).name;
		aligment.text = Intern.getIntern(quest.refIntern).aligment;
		btnResetTextValue.text = "20"; //Todo, en attendant le balancing
		
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnDismiss, onDismiss);
		Interactive.addListenerClick(btnReset, onReset);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function onReset():Void{
		Intern.getIntern(quest.refIntern).stress = 0;
		Intern.getIntern(quest.refIntern).status = Intern.STATE_RESTING;
		
		updateQuestPopin();
	}
	
	private function onDismiss():Void{
		Intern.destroyIntern(quest.refIntern);
		updateQuestPopin();
		//QuestsManager.destroyQuest(quest.refIntern);
		//TimeManager.destroyTimeElement(quest.refIntern);
	}
	
	private function onClose():Void{
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
	}
	
		//For the HUD Popin actualisation
	private function updateQuestPopin():Void{
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}