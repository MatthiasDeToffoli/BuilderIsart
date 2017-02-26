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
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
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
	private var btnGift:SmartButton;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	private var gatchaText:TextSprite;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	private var internCard:SmartComponent;
	
	public static var quest:TimeQuestDescription;
	public static var intern:InternDescription;
	
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
		btnGift = cast(getChildByName(AssetName.GATCHA_POPIN_GATCHA_BAG), SmartButton);
		internName = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_NAME), TextSprite);
		
		internCard = cast(getChildByName(AssetName.GATCHA_POPIN_INTERN_PORTRAIT), SmartComponent);
		speedJauge = cast(internCard.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(internCard.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
	}
	
	private function createPortraitCard():Void {
		var bgName:String;
		if (intern.aligment == Std.string(Alignment.heaven)) bgName = "_eventStress_CardBG_Heaven";
		else bgName = "_eventStress_CardBG_Hell";
		
		var portrait:UISprite = cast(internCard.getChildByName("_internPortrait"), UISprite);
		var background:UISprite = cast(internCard.getChildByName("BG"), UISprite);
		
		SpriteManager.spawnComponent(background, bgName, internCard, TypeSpawn.SPRITE, 0);
		SpriteManager.spawnComponent(portrait, intern.portrait, internCard, TypeSpawn.SPRITE, 0);
		
		var stressBar = cast(internCard.getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		var stressGaugeMask = cast(SmartCheck.getChildByName(stressBar, "jaugeStress_masque"), UISprite);
		var stressGaugeBar = cast(SmartCheck.getChildByName(stressBar, "_jaugeStres"), UISprite);
		var speedJauge = cast(internCard.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		var effJauge = cast(internCard.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		var speedIndics = new Array<UISprite>();
		var effIndics = new Array<UISprite>();
		
		for (i in 1...6) {
			speedIndics.push(cast(speedJauge.getChildByName("_jaugeSpeed_0" + i), UISprite));
			effIndics.push(cast(effJauge.getChildByName("_jaugeEfficiency_0" + i), UISprite));
		}
		
		for (i in 0...5) {
			if (intern.efficiency <= i) speedIndics[i].visible = false;
		}
		
		for (i in 0...5) {
			if (intern.speed <= i) effIndics[i].visible = false;
		}
		
		stressGaugeMask.scale.x = 0;
		stressGaugeBar.scale.x = 0;
		
		var iStress:Int = intern.stress;	
		stressGaugeBar.scale.x = Math.min(iStress / 100, 1);
	}
	
	public function setDatas():Void{
		intern = Intern.getIntern(quest.refIntern);
		
		gatchaText.text = Localisation.getText("LABEL_GACHA_CONGRATULATION");
		internName.text = intern.name;
		createPortraitCard();
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