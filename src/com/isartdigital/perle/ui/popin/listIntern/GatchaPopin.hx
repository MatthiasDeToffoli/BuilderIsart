package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;
import pixi.flump.Movie;

	
/**
 * Popin for the gatcha
 * @author Emeline Berenguier
 */
class GatchaPopin extends SmartPopinExtended 
{
	
	/**
	 * instance unique de la classe GatchaPopin
	 */
	private static var instance: GatchaPopin;
	
	private var btnClose:SmartButton;
	private var btnGift:SmartButton;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	private var gatchaText:TextSprite;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	private var internCard:SmartComponent;
	
	public static var quest:TimeQuestDescription;
	private var explodeTimer:Timer;
	private var currentFrame:Int;
	
	private var openingAnimation:UIMovie;
	
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
		btnClose = cast(getChildByName(AssetName.GATCHA_POPIN_CLOSE_BUTTON), SmartButton);
		btnGift = cast(getChildByName(AssetName.GATCHA_POPIN_GATCHA_BAG), SmartButton);
	}
	
	public function setDatas():Void{
		gatchaText = cast(cast(btnGift.getChildByName("CartoucheGatcha_animation"), SmartComponent).getChildByName(AssetName.GATCHA_POPIN_TITLE), TextSprite);
		gatchaText.text = Localisation.getText("LABEL_GACHA_CONGRATULATION");
		
		openingAnimation = cast(cast(btnGift.getChildByName("Cadeau_suprise"), SmartComponent).getChildByName("Cadeau_surprise_anime"), UIMovie);
		openingAnimation.goToAndStop(0);
		openingAnimation.visible = false;
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnGift, onGift);
		Interactive.addListenerRewrite(btnGift, setDatas);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	/**
	 * Opens the gift's popin
	 */
	private function onGift():Void {
		setDatas();
		Interactive.removeListenerClick(btnGift, onGift);
		Interactive.removeListenerRewrite(btnGift, setDatas);
		Interactive.removeListenerClick(btnClose, onClose);
		
		btnGift.interactive = false;	
		cast(btnGift.getChildByName("Layer1"), SmartComponent).visible = false;
		
		openingAnimation.visible = true;
		openingAnimation.resume();
		
		currentFrame = 0;
		explodeTimer = Timer.delay(loopGatcha, 100);
		explodeTimer.run = loopGatcha;
		
		QuestsManager.destroyQuest(quest.refIntern);
		
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function loopGatcha():Void {
		currentFrame++;
		if (currentFrame >= 35) endGatcha();
	}
	
	private function endGatcha():Void {
		openingAnimation.pause();
		openingAnimation.visible = false;
		explodeTimer.stop();
		RewardGatcha.spawn(quest);
		UIManager.getInstance().openPopin(RewardGatcha.getInstance());
	}
	
	private function onClose():Void {
		if (DialogueManager.ftueStepCloseGatcha)
			return;
			
		Interactive.removeListenerClick(btnGift, onGift);
		Interactive.removeListenerRewrite(btnGift, setDatas);
		Interactive.removeListenerClick(btnClose, onClose);
		
		QuestsManager.destroyQuest(quest.refIntern);
		RewardGatcha.spawn(quest);
		UIManager.getInstance().openPopin(RewardGatcha.getInstance());
		
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}