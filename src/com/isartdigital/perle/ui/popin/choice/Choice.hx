package com.isartdigital.perle.ui.popin.choice;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import flump.library.Point;
import pixi.interaction.EventEmitter;
import pixi.interaction.EventTarget;

enum ChoiceType { HEAVEN; HELL; NONE; }

/**
 * Choice popin
 * @author victor grenu
 */
class Choice extends SmartPopinExtended
{
	private static var instance:Choice;
	
	private static inline var DOUBLE_DOT:String = " : ";
	public static inline var EVENT_CHOICE_DONE:String = "Choice_Done";
	// max distance for the card slide
	private static inline var MOUSE_DIFF_MAX:Float = 200;
	private static inline var DIFF_MAX:Float = 80;
	
	// elements
	public var eChoiceDone:EventEmitter;
	private var btnInterns:SmartButton;
	private var btnClose:SmartButton;
	private var btnShare:SmartButton;
	private var presentationChoice:TextSprite;
	private var heavenChoice:TextSprite;
	private var evilChoice:TextSprite;
	private var internName:TextSprite;
	private var internSide:TextSprite;
	private var choiceCard:UISprite;
		
	private var internStats:SmartComponent;
	private var internStress:TextSprite;
	private var internSpeed:TextSprite;
	private var internEfficiency:TextSprite;
	private var stressBar:SmartComponent;
	private var speedIndic:SmartComponent;
	private var effIndic:SmartComponent;
	

	// card slide position properties
	private var mousePos:Point;
	private var imgPos:Point;
	private var choiceType:ChoiceType;
	
	private static var isOpen:Bool;
	
	// temporarily intern
	private var intern:InternDescription;
	private var reward:EventRewardDesc;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Choice{
		if (instance == null) instance = new Choice();
		return instance;
	}
	
	public function new(pID:String=null) 
	{
		super(AssetName.INTERN_EVENT);
		
		getComponents();
		
		choiceType = ChoiceType.NONE;
		imgPos = new Point(choiceCard.position.x, choiceCard.position.y);
		isOpen = true;
		
		addListeners();
	}
	
	/**
	 * get all intern event popin elements
	 */
	private function getComponents():Void
	{
		presentationChoice = cast(getChildByName(AssetName.INTERN_EVENT_DESC), TextSprite);
		heavenChoice = cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_CHOICE), TextSprite);
		evilChoice = cast(getChildByName(AssetName.INTERN_EVENT_HELL_CHOICE), TextSprite);
		internName = cast(getChildByName(AssetName.INTERN_EVENT_NAME), TextSprite);
		internSide = cast(getChildByName(AssetName.INTERN_EVENT_SIDE), TextSprite);
		btnInterns = cast(getChildByName(AssetName.INTERN_EVENT_SEE_ALL), SmartButton);
		btnClose = cast(getChildByName(AssetName.INTERN_EVENT_CLOSE), SmartButton);
		//btnShare = cast(getChildByName(AssetName.INTERN_EVENT_SHARE), SmartButton);
		choiceCard = cast(getChildByName(AssetName.INTERN_EVENT_CARD), UISprite);
		
		internStats = cast(getChildByName(AssetName.INTERN_EVENT_STATS), SmartComponent);
		//internStress = cast(internStats.getChildByName(AssetName.INTERN_STRESS_TXT), TextSprite);
		//internSpeed = cast(internStats.getChildByName(AssetName.INTERN_SPEED_TXT), TextSprite);
		//internEfficiency = cast(internStats.getChildByName(AssetName.INTERN_EVENT_EFFICIENCY), TextSprite);
		
		stressBar = cast(internStats.getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		speedIndic = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effIndic = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
	}
	
	public function setIntern(pIntern:InternDescription):Void {
		intern = pIntern;
		
		var newChoice:ChoiceDescription = ChoiceManager.selectChoice(intern.idEvent);
		createChoiceText(newChoice);
		initReward(newChoice, intern);
	}
	
	/**
	 * get new generated text
	 */
	private function createChoiceText(newChoice:ChoiceDescription):Void
	{		
		presentationChoice.text = newChoice.text;
		heavenChoice.text = newChoice.heavenAnswer;
		evilChoice.text = newChoice.hellAnswer;
		
		internName.text = intern.name;
		internSide.text = intern.aligment;
		//internStress.text = Std.string(Intern.TXT_SPEED + DOUBLE_DOT + intern.stress);
		//internSpeed.text = Std.string(Intern.TXT_SPEED + DOUBLE_DOT + intern.speed);
		//internEfficiency.text = Std.string(Intern.TXT_EFFICIENCY + DOUBLE_DOT + intern.efficiency);
		
		// call matthieu !!!!!!!!
		//SmartCheck.traceChildrens(effIndic);
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
	
	private function initReward(newChoice:ChoiceDescription, internDesc:InternDescription):Void {
		var indexEff:Int = internDesc.efficiency - 1;
		
		reward = {
			gold : internDesc.efficiency * ChoiceManager.efficiencyBalance[indexEff].gold,
			karma : internDesc.efficiency * ChoiceManager.efficiencyBalance[indexEff].karma,
			wood : internDesc.efficiency * ChoiceManager.efficiencyBalance[indexEff].wood,
			iron : internDesc.efficiency * ChoiceManager.efficiencyBalance[indexEff].iron,
			soul : internDesc.efficiency, 
			xp : Std.int(internDesc.efficiency * ChoiceManager.efficiencyBalance[indexEff].xP)
		};
	}
	
	private function addListeners ():Void {
		Interactive.addListenerClick(btnInterns, onSeeAll);
		//Interactive.addListenerClick(btnShare, shareEvent);
		Interactive.addListenerClick(btnClose, onClose);
		choiceCard.interactive = true;
		choiceCard.on(MouseEventType.MOUSE_DOWN, startFollow);
	}
	
	private function showInternStats(internDesc:InternDescription):Void
	{
		
	}
	
	private function shareEvent():Void
	{
		trace("share");
	}
	
	private function onSeeAll():Void
	{
		hide();
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	/**
	 * Start sliding choice
	 * @param	mEvent
	 */
	private function startFollow(mEvent:EventTarget):Void
	{
		// update choiceType
		choiceType = ChoiceType.NONE;
		// click mouse pos
		mousePos = new Point(mEvent.data.global.x, mEvent.data.global.y);
		// add listener needed to follow mouse
		choiceCard.on(MouseEventType.MOUSE_MOVE, followMouse);
		choiceCard.on(MouseEventType.MOUSE_UP_OUTSIDE, replaceCard);
		choiceCard.on(MouseEventType.MOUSE_UP, replaceCard);
	}
	
	/**
	 * Make the fateCard follow mouse direction and get the selected answer
	 * @param	mEvent
	 */
	private function followMouse(mEvent:EventTarget):Void
	{
		// get difference with previous mouse pos
		var diff:Float = mEvent.data.global.x - mousePos.x;
		
		// move fateCard && get choiceType
		if (diff > 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
			if (Math.abs(diff) > DIFF_MAX) choiceType = ChoiceType.HELL;
			else choiceType = ChoiceType.NONE;
		}
		else if (diff < 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.position.set(imgPos.x + DIFF_MAX * (diff / MOUSE_DIFF_MAX), imgPos.y);
			if (Math.abs(diff) > DIFF_MAX) choiceType = ChoiceType.HEAVEN;
			else choiceType = ChoiceType.NONE;
		}
	}
	
	/**
	 * Replace fatecard at start pos && do answer choice if actual choice not NONE
	 */
	private function replaceCard():Void
	{	
		choiceCard.position.set(imgPos.x, imgPos.y);
		choiceCard.off(MouseEventType.MOUSE_MOVE, followMouse);
		
		if (choiceType != ChoiceType.NONE) {
			ChoiceManager.applyReward(intern, reward, choiceType);
			if (DialogueManager.ftueStepMakeChoice)
				DialogueManager.endOfaDialogue();
			onClose();
		}
	}
	
	/**
	 * onClose
	 */
	private function onClose():Void
	{
		if (DialogueManager.ftueStepMakeChoice || DialogueManager.ftueStepMakeAllChoice)
			return;
		Hud.getInstance().show();
		destroy();
	}
	
	/**
	 * hide the popin
	 */
	public function hide():Void{
		GameStage.getInstance().getHudContainer().removeChild(this);
	}
	
	/**
	 * hide the hud
	 */
	public function show():Void{
		GameStage.getInstance().getHudContainer().addChild(this);
	}
	
	/**
	 * return if is open (visible in game)
	 * @return true || false
	 */
	public static function isVisible():Bool {
		return isOpen;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnInterns, onSeeAll);
		//Interactive.removeListenerClick(btnShare, shareEvent);
		Interactive.removeListenerClick(btnClose, onClose);
		choiceCard.interactive = false;
		choiceCard.off(MouseEventType.MOUSE_DOWN, startFollow);
		
		isOpen = false;
		parent.removeChild(this);
		instance = null;
		super.destroy();
	}

}