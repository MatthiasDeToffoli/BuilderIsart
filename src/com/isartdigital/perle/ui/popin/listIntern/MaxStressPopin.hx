package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
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
	private var btnReset:SmartButton;
	private var picture:UISprite;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	public static var intern:InternDescription;
	
	private var speedIndics:Array<UISprite>;
	private var effIndics:Array<UISprite>;
	
	public static var quest:TimeQuestDescription;
	private var internDatas:SmartComponent;
	private var gaugeStress:SmartComponent;
	private var gaugeStressMask:UISprite;
	
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
	}
	
	private function getComponents():Void{
		btnClose = cast(getChildByName(AssetName.MAXSTRESS_POPIN_CLOSE_BUTTON), SmartButton);
		btnDismiss = cast(getChildByName(AssetName.MAXSTRESS_POPIN_DISMISS_BUTTON), SmartButton);
		btnReset = cast(getChildByName(AssetName.MAXSTRESS_POPIN_RESET_BUTTON), SmartButton);
		btnResetTextValue = cast(SmartCheck.getChildByName(btnReset, AssetName.MAXSTRESS_POPIN_RESET_TEXT), TextSprite);
		picture = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_PORTRAIT), UISprite);
		internName = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_NAME), TextSprite);
		aligment = cast(getChildByName(AssetName.MAXSTRESS_POPIN_INTERN_SIDE), TextSprite);
		
		internStats = cast(getChildByName(AssetName.GLOBAL_INTERN_STATS), SmartComponent);
		gaugeStress = cast(SmartCheck.getChildByName(internStats, "_jauge_stress"), SmartComponent);
		SmartCheck.traceChildrens(gaugeStress);
		gaugeStressMask = cast(SmartCheck.getChildByName(gaugeStress, "jaugeStress_masque"), UISprite);
		
		speedJauge = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
	}
	
	public function setDatas():Void{
		internName.text = Intern.getIntern(quest.refIntern).name;
		aligment.text = Intern.getIntern(quest.refIntern).aligment;
		gaugeStressMask.scale.x = 0;
		btnResetTextValue.text = RESET_VALUE + "";
		
		initStars();
	}
	
	private function initStars():Void {
		speedIndics = new Array<UISprite>();
		effIndics = new Array<UISprite>();
		
		for (i in 1...6) {
			speedIndics.push(cast(speedJauge.getChildByName("_jaugeSpeed_0" + i), UISprite));
			effIndics.push(cast(effJauge.getChildByName("_jaugeEfficiency_0" + i), UISprite));
		}		
		for (i in 0...5) { if (intern.efficiency <= i) speedIndics[i].visible = false; }
		for (i in 0...5) { if (intern.speed <= i) effIndics[i].visible = false; }
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnDismiss, onDismiss);
		Interactive.addListenerClick(btnReset, onReset);
		Interactive.addListenerRewrite(btnReset, setValuesResetBtn);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function setValuesResetBtn():Void{
		btnResetTextValue = cast(SmartCheck.getChildByName(btnReset, AssetName.MAXSTRESS_POPIN_RESET_TEXT), TextSprite);
		btnResetTextValue.text = RESET_VALUE + ""; 
	}
	
	private function onReset():Void{
		
		if (ResourcesManager.getTotalForType(GeneratorType.hard) >= RESET_VALUE){
			
			if (ChoiceManager.isInQuest(intern.idEvent)) {
				Intern.getIntern(quest.refIntern).stress = 0;
				Intern.getIntern(intern.id).status = Intern.STATE_RESTING;
				QuestsManager.chooseQuest(Intern.getIntern(intern.id).quest);
				QuestsManager.goToNextStep();
				TimeManager.nextStepQuest(QuestsManager.getQuest(intern.id));	
			}
		
		updateQuestPopin();
		ServerManager.InternAction(DbAction.UPDT, intern.id);
			//Intern.getIntern(quest.refIntern).stress = 0;
			//Intern.getIntern(quest.refIntern).status = Intern.STATE_RESTING;
			//
			//updateQuestPopin();
		}
	}
	
	private function onDismiss():Void{
		Intern.destroyIntern(intern.id);
		TimeManager.destroyTimeQuest(intern.id);
		updateQuestPopin();
	}
	
	private function onClose():Void{
		updateQuestPopin();
		Hud.getInstance().show();
	}
	
		//For the HUD Popin actualisation
	private function updateQuestPopin():Void{
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnDismiss, onDismiss);
		Interactive.removeListenerClick(btnReset, onReset);
		Interactive.removeListenerClick(btnClose, onClose);
		
		instance = null;
		Interactive.removeListenerRewrite(btnReset, setValuesResetBtn);
		Interactive.removeListenerClick(btnDismiss, onDismiss);
		Interactive.removeListenerClick(btnReset, onReset);
		Interactive.removeListenerClick(btnClose, onClose);
	}

}