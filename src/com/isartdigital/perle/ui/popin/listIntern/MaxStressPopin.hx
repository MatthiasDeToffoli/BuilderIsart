package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.server.ServerManagerInterns;
import com.isartdigital.perle.game.managers.server.ServerManagerQuest;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
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
	
	private var internStats:SmartComponent;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	
	private var btnClose:SmartButton;
	private var btnResetTextValue:TextSprite;
	private var btnDismiss:SmartButton;
	private var btnDismissTxt:TextSprite;
	private var btnReset:SmartButton;
	private var btnResetTxt:TextSprite;
	private var picture:UISprite;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	public static var intern:InternDescription;
	
	public static var quest:TimeQuestDescription;
	private var gaugeStress:SmartComponent;
	private var gaugeStressMask:UISprite;

	private var hellText:TextSprite;
	private var heavenText:TextSprite;
	private var titleText:TextSprite;
	private var internText:TextSprite;
	
	private static inline var RESET_VALUE:Int = 20;
	
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
		SoundManager.getSound("SOUND_OPEN_MENU_GENERIC").play();
	}
	
	private function getComponents():Void{
		btnClose = cast(getChildByName(AssetName.MAXSTRESS_POPIN_CLOSE_BUTTON), SmartButton);
		btnDismiss = cast(getChildByName(AssetName.MAXSTRESS_POPIN_DISMISS_BUTTON), SmartButton);
		btnDismissTxt = cast(btnDismiss.getChildByName("txt"), TextSprite);
		btnReset = cast(getChildByName(AssetName.MAXSTRESS_POPIN_RESET_BUTTON), SmartButton);
		btnResetTxt = cast(btnReset.getChildByName("Text"), TextSprite);
		btnResetTextValue = cast(SmartCheck.getChildByName(btnReset, AssetName.MAXSTRESS_POPIN_RESET_TEXT), TextSprite);
		internName = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_NAME), TextSprite);
		
		internStats = cast(getChildByName("_internPortrait"), SmartComponent);
		gaugeStress = cast(SmartCheck.getChildByName(internStats, "_jauge_stress"), SmartComponent);
		gaugeStressMask = cast(SmartCheck.getChildByName(gaugeStress, "jaugeStress_masque"), UISprite);
		
		speedJauge = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		titleText = cast(getChildByName("_maxStreesReach_txt"), TextSprite);
		titleText.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_FLAVOR");
		hellText = cast(getChildByName("_stressOut_GetOut"), TextSprite);
		hellText.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_DISMISS_TEXT");
		heavenText = cast(getChildByName("_stressOut_comeHere"), TextSprite);
		heavenText.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_RESETSTRESS_TEXT");
		internText = cast(getChildByName("_stressOut_info_text"), TextSprite);
		internText.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_TEXT");
		
		var glowStress:UISprite = cast(SmartCheck.getChildByName(internStats, "_ftue_Glow_Interns_Stress"), UISprite);
		var glowEfficiency:UISprite = cast(SmartCheck.getChildByName(internStats, "_ftue_Glow_Efficiency"), UISprite);
		var glowSpeed:UISprite = cast(SmartCheck.getChildByName(internStats, "_ftue_Glow_Speed"), UISprite);
		
		glowStress.visible = false;
		glowEfficiency.visible = false;
		glowSpeed.visible = false;
	}
	
	public function setDatas():Void{
		internName.text = intern.name;
		gaugeStressMask.scale.x = 0;
		btnResetTextValue.text = RESET_VALUE + "";
		
		btnDismissTxt.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_DISMISS");
		btnResetTxt.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_RESETSTRESS");
		
		createPortraitCard();
	}
	
	private function createPortraitCard():Void {
		var bgName:String;
		if (intern.aligment == Std.string(Alignment.heaven)) bgName = "_eventStress_CardBG_Heaven";
		else bgName = "_eventStress_CardBG_Hell";
		
		var portrait:UISprite = cast(internStats.getChildByName("_internPortrait"), UISprite);
		var background:UISprite = cast(internStats.getChildByName("BG"), UISprite);
		
		SpriteManager.spawnComponent(background, bgName, internStats, TypeSpawn.SPRITE, 0);
		SpriteManager.spawnComponent(portrait, intern.portrait, internStats, TypeSpawn.SPRITE, 0);
		
		var stressBar = cast(internStats.getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		var stressGaugeMask = cast(SmartCheck.getChildByName(stressBar, "jaugeStress_masque"), UISprite);
		var stressGaugeBar = cast(SmartCheck.getChildByName(stressBar, "_jaugeStres"), UISprite);
		var speedJauge = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		var effJauge = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		var speedIndics = new Array<UISprite>();
		var effIndics = new Array<UISprite>();
		
		for (i in 1...6) {
			speedIndics.push(cast(speedJauge.getChildByName("_jaugeSpeed_0" + i), UISprite));
			effIndics.push(cast(effJauge.getChildByName("_jaugeEfficiency_0" + i), UISprite));
		}
		
		for (i in 0...5) { if (intern.efficiency <= i) speedIndics[i].visible = false; }
		for (i in 0...5) { if (intern.speed <= i) effIndics[i].visible = false; }
		
		stressGaugeMask.scale.x = 0;
		stressGaugeBar.scale.x = 0;
		
		var iStress:Int = intern.stress;	
		stressGaugeBar.scale.x = Math.min(iStress / 100, 1);
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnDismiss, onDismiss);
		Interactive.addListenerRewrite(btnDismiss, setTextDismiss);
		Interactive.addListenerClick(btnReset, onReset);
		Interactive.addListenerRewrite(btnReset, setTextReset);
		Interactive.addListenerRewrite(btnReset, setValuesResetBtn);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function setTextDismiss():Void{
		btnDismissTxt = cast(btnDismiss.getChildByName("txt"), TextSprite);
		btnDismissTxt.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_DISMISS");
		
	}
	
	private function setTextReset():Void{
		btnResetTxt = cast(btnReset.getChildByName("txt"), TextSprite);
		btnResetTxt.text = Localisation.getText("LABEL_INTERN_STRESSEDOUT_RESETSTRESS");
	}
	
	private function setValuesResetBtn():Void{
		btnResetTextValue = cast(SmartCheck.getChildByName(btnReset, AssetName.MAXSTRESS_POPIN_RESET_TEXT), TextSprite);
		btnResetTextValue.text = RESET_VALUE + "";
	}
	
	private function onReset():Void{
		
		if (ResourcesManager.getTotalForType(GeneratorType.hard) >= RESET_VALUE) {			
			Intern.getIntern(intern.id).stress = 0;
			Intern.getIntern(intern.id).status = Intern.STATE_RESTING;
			SoundManager.getSound("SOUND_KARMA").play();
			
			if (quest != null) {
				QuestsManager.chooseQuest(Intern.getIntern(intern.id).quest);
				QuestsManager.goToNextStep();
			}
			
			updateQuestPopin();
			ServerManagerInterns.execute(DbAction.UPDT, intern.id);
		}
	}
	
	private function onDismiss():Void{
		ServerManagerInterns.execute(DbAction.REM, intern.id);
		if (intern.quest != null) ServerManagerQuest.execute(DbAction.REM, intern.quest);
		UIManager.getInstance().closePopin(this);
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClose():Void{
		UIManager.getInstance().closePopin(this);
		Hud.getInstance().show();
		SoundManager.getSound("SOUND_CLOSE_MENU").play();
	}
	
		//For the HUD Popin actualisation
	private function updateQuestPopin():Void{
		UIManager.getInstance().closePopin(this);
		UIManager.getInstance().closePopin(ListInternPopin.getInstance());
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnDismiss, onDismiss);
		Interactive.removeListenerRewrite(btnDismiss, setTextDismiss);
		Interactive.removeListenerClick(btnReset, onReset);
		Interactive.removeListenerRewrite(btnReset, setTextReset);
		Interactive.removeListenerClick(btnClose, onClose);
		
		instance = null;
		Interactive.removeListenerRewrite(btnReset, setValuesResetBtn);
		Interactive.removeListenerClick(btnDismiss, onDismiss);
		Interactive.removeListenerClick(btnReset, onReset);
		Interactive.removeListenerClick(btnClose, onClose);
	}

}