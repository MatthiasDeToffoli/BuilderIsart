package com.isartdigital.perle.ui.popin.choice;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SpriteManager;
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
import pixi.core.math.Point;
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
	private var internPortrait:UISprite;
		
	private var internStats:SmartComponent;
	private var internStress:TextSprite;
	private var internSpeed:TextSprite;
	private var internEfficiency:TextSprite;
	private var stressBar:SmartComponent;
	private var stressGaugeMask:UISprite;
	private var stressGaugeBar:UISprite;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	
	private var currencyHellSpawner:SmartComponent;
	private var currencyHeavenSpawner:SmartComponent;
	private var stressHellIndicators:Array<UISprite>;
	private var stressHeavenIndicators:Array<UISprite>;
	
	private var hellSpawnerPos:Map<Int, Point>;
	private var heavenSpawnerPos:Map<Int, Point>;

	// card slide position properties
	private var mousePos:Point;
	private var imgRot:Float;
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
		imgRot = choiceCard.rotation;
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
		
		choiceCard = cast(getChildByName(AssetName.INTERN_EVENT_CARD), UISprite);
		internPortrait = cast(getChildByName(AssetName.INTERN_EVENT_PORTRAIT), UISprite);
		
		internStats = cast(getChildByName(AssetName.INTERN_EVENT_STATS), SmartComponent);	
		stressBar = cast(internStats.getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		stressGaugeMask = cast(SmartCheck.getChildByName(stressBar, "jaugeStress_masque"), UISprite);
		stressGaugeBar = cast(SmartCheck.getChildByName(stressBar, "_jaugeStres"), UISprite);
		speedJauge = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		//stressHellIndicators = new Array<UISprite>();
		//stressHeavenIndicators = new Array<UISprite>();
		hellSpawnerPos = new Map<Int, Point>();
		heavenSpawnerPos = new Map<Int, Point>();
		for (i in 1...4) {
			var newSpawnerHell:UISprite = cast(getChildByName(AssetName.INTERN_EVENT_HELL_CURRENCY + i), UISprite);
			var newSpawnerHeaven:UISprite = cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_CURRENCY + i), UISprite);
			
			hellSpawnerPos.set(i, newSpawnerHell.position);
			heavenSpawnerPos.set(i, newSpawnerHeaven.position);
			
			newSpawnerHell.visible = false;
			newSpawnerHeaven.visible = false;
			
			//stressHellIndicators.push(cast(cast(getChildByName(AssetName.INTERN_EVENT_HELL_STRESS), SmartComponent).getChildByName(AssetName.INTENSITY_MARKER + i), UISprite));
			//stressHeavenIndicators.push(cast(cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_STRESS), SmartComponent).getChildByName(AssetName.INTENSITY_MARKER + i), UISprite));
		}
	}
	
	public function setIntern(pIntern:InternDescription):Void {
		intern = pIntern;
		
		var newChoice:ChoiceDescription = ChoiceManager.selectChoice(intern.idEvent);
		createChoice(newChoice);
		initReward(newChoice, intern);
		showRewardIndicators(newChoice);
	}
	
	/**
	 * get new generated text
	 */
	private function createChoice(newChoice:ChoiceDescription):Void
	{		
		presentationChoice.text = newChoice.text;
		heavenChoice.text = newChoice.heavenAnswer;
		evilChoice.text = newChoice.hellAnswer;
		
		internName.text = intern.name;
		internSide.text = intern.aligment;
		
		stressGaugeMask.scale.x = 0;
		stressGaugeBar.scale.x = 0;
			
		var iStress:Int = intern.stress;	
		stressGaugeBar.scale.x = Math.min(iStress / 100, 1);
		
		createCard(newChoice);
		createPortrait();
		initStars();
	}
	
	private function createCard(pChoice:ChoiceDescription):Void {
		choiceCard = SpriteManager.createNewImage(choiceCard, pChoice.card, this, true);
		choiceCard.on(MouseEventType.MOUSE_DOWN, startFollow);
	}
	
	private function createPortrait():Void {
		SpriteManager.createNewImage(internPortrait, intern.portrait, this);
	}
	
	// TODO
	private function showRewardIndicators(pChoice:ChoiceDescription):Void {
		//var test:SmartComponent = new SmartComponent("RessourceIndicator");
		var index:Int = 0;
		//trace(pChoice);		
		
		if (pChoice.unaturalStress > 20) index = 3;
		else if (pChoice.unaturalStress > 11) index = 2;
		else index = 1;
	}
	
	private function initStars():Void {
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
			choiceCard.rotation = imgRot + diff / DIFF_MAX * Math.PI / 32;
			if (choiceCard.rotation > imgRot + Math.PI / 32) choiceType = ChoiceType.HELL;
			else choiceType = ChoiceType.NONE;
		}
		else if (diff < 0 && Math.abs(diff) < MOUSE_DIFF_MAX) {
			choiceCard.rotation = imgRot + diff / DIFF_MAX * Math.PI / 32;
			if (choiceCard.rotation < imgRot - Math.PI / 32) choiceType = ChoiceType.HEAVEN;
			else choiceType = ChoiceType.NONE;
		}
	}
	
	/**
	 * Replace fatecard at start pos && do answer choice if actual choice not NONE
	 */
	private function replaceCard():Void
	{	
		choiceCard.rotation = imgRot;
		choiceCard.off(MouseEventType.MOUSE_MOVE, followMouse);
		
		if (choiceType != ChoiceType.NONE) {
			ChoiceManager.applyReward(intern, reward, choiceType);
			if (DialogueManager.ftueStepMakeChoice)
				DialogueManager.endOfaDialogue();
			destroy();
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