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
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;

	
/**
 * Popin for the gatcha
 * @author Emeline Berenguier
 */
class GatchaPopin extends SmartPopin 
{
	
	/**
	 * instance unique de la classe GatchaPopin
	 */
	private static var instance: GatchaPopin;
	
	private var btnClose:SmartButton;
	private var btnGift:UIMovie;
	private var picture:UISprite;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	private var gatchaText:TextSprite;
	
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
		SoundManager.getSound("SOUND_GATCHA").play();
		getComponents();
		addListeners();	
		setDatas();
	}
	
	private function getComponents():Void{
		gatchaText = cast(getChildByName(AssetName.GATCHA_POPIN_TITLE), TextSprite);
		btnClose = cast(getChildByName(AssetName.GATCHA_POPIN_CLOSE_BUTTON), SmartButton);
		btnGift = cast(getChildByName(AssetName.GATCHA_POPIN_GATCHA_BAG), UIMovie);
		picture = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_PORTRAIT), UISprite);
		internName = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_NAME), TextSprite);
		aligment = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_SIDE), TextSprite);
	}
	
	public function setDatas():Void{
		gatchaText.text = Localisation.getText("LABEL_GACHA_CONGRATULATION");
		internName.text = Intern.getIntern(quest.refIntern).name;
		aligment.text = Intern.getIntern(quest.refIntern).aligment;
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnGift, onGift);
		//Interactive.addListenerClick(btnClose, onClose);
	}
	
	/**
	 * Opens the gift's popin
	 */
	private function onGift():Void{
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(RewardGatcha.getInstance());
		RewardGatcha.spawn(quest);
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClose():Void {
		if (DialogueManager.ftueStepCloseGatcha)
			return;
		UIManager.getInstance().closeCurrentPopin();
		Hud.getInstance().show();
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}