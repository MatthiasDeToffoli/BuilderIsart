package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.QuestsManager;
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
		btnClose = cast(getChildByName("ButtonClose"), SmartButton);
		btnGift = cast(getChildByName("GatchaBag"), SmartButton);
		picture = cast(getChildByName("_internPortrait"), UISprite);
		internName = cast(getChildByName("_intern_name"), TextSprite);
		aligment = cast(getChildByName("_intern_side"), TextSprite);
	}
	
	public function setDatas():Void{
		internName.text = Intern.getIntern(quest.refIntern).name;
		aligment.text = Intern.getIntern(quest.refIntern).aligment;
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnGift, onGift);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function onGift():Void{
		trace("gift");
		QuestsManager.finishQuest(quest);
	}
	
	private function onClose():Void{
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