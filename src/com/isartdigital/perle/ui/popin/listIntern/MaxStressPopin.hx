package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.ServerManager;
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
	private var internStress:TextSprite;
	private var internSpeed:TextSprite;
	private var internEfficiency:TextSprite;
	private var stressBar:SmartComponent;
	private var speedIndic:SmartComponent;
	private var effIndic:SmartComponent;
	
	private var btnClose:SmartButton;
	private var btnResetTextValue:TextSprite;
	private var btnDismiss:SmartButton;
	private var btnReset:SmartButton;
	private var picture:UISprite;
	private var internName:TextSprite;
	private var aligment:TextSprite;
	public static var intern:InternDescription;
	
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
		stressBar = cast(internStats.getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		speedIndic = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effIndic = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		internStress = cast(internStats.getChildByName(AssetName.INTERN_STRESS_TXT), TextSprite);
		internSpeed = cast(internStats.getChildByName(AssetName.INTERN_SPEED_TXT), TextSprite);
		internEfficiency = cast(internStats.getChildByName(AssetName.INTERN_EVENT_EFFICIENCY), TextSprite);
	}
	
	public function setDatas():Void{
		internName.text = intern.name;
		aligment.text = intern.aligment;		
		
		btnResetTextValue.text = "20"; //Todo, en attendant le balancin
		
		var iEff:Int =  6 - intern.efficiency;
		for (i in 1...iEff)
			cast(effIndic.getChildAt(i), UISprite).visible = false;
			
		var iSpeed:Int = 6 - intern.speed;
		for (i in 1...iSpeed)
			cast(speedIndic.getChildAt(i), UISprite).visible = false;
			
		//var iStress:Int = 6 - Math.round(intern.stress / 20);
		//for (i in 1...iStress)
			//cast(stressBar.getChildAt(i), UISprite).visible = false;
	}
	
	private function addListeners():Void{
		Interactive.addListenerClick(btnDismiss, onDismiss);
		Interactive.addListenerClick(btnReset, onReset);
		Interactive.addListenerClick(btnClose, onClose);
	}
	
	private function onReset():Void{
		Intern.getIntern(intern.id).stress = 0;
		
		if (ChoiceManager.isInQuest(intern.idEvent)) {
			Intern.getIntern(intern.id).status = Intern.STATE_RESTING;
			QuestsManager.chooseQuest(Intern.getIntern(intern.id).quest);
			QuestsManager.goToNextStep();
			TimeManager.nextStepQuest(QuestsManager.getQuest(intern.id));	
		}
		
		updateQuestPopin();
		ServerManager.InternAction(DbAction.UPDT, intern.id);
	}
	
	private function onDismiss():Void{
		Intern.destroyIntern(intern.id);
		TimeManager.destroyTimeQuest(intern.id);
		updateQuestPopin();
	}
	
	private function onClose():Void{
		updateQuestPopin();
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
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
	}

}