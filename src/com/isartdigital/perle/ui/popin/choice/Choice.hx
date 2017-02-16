package com.isartdigital.perle.ui.popin.choice;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SpriteManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice.ChoiceType;
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
enum RewardType { gold; iron; wood; karma; soul; }

typedef RewardCounter = {
	var hellNumber:Int;
	var heavenNumber:Int;
}

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
	private static inline var NB_GAIN_SPAWNER:Int = 4;
	private static inline var NB_STRESS_INDICATOR:Int = 4;
	
	// elements
	public var eChoiceDone:EventEmitter;
	private var btnClose:SmartButton;
	private var heavenChoice:TextSprite;
	private var evilChoice:TextSprite;
	private var internName:TextSprite;
	
	private var choiceCard:SmartComponent;
	private var internPortrait:UISprite;
		
	private var internStats:SmartComponent;
	private var internStress:TextSprite;
	private var internSpeed:TextSprite;
	private var internEfficiency:TextSprite;
	public var stressBar:SmartComponent;
	private var stressGaugeMask:UISprite;
	private var stressGaugeBar:UISprite;
	private var speedJauge:SmartComponent;
	private var effJauge:SmartComponent;
	
	private var currencyHellSpawner:SmartComponent;
	private var currencyHeavenSpawner:SmartComponent;
	private var stressHellIndicators:Map<Int, UISprite>;
	private var stressHeavenIndicators:Map<Int, UISprite>;
	
	private var hellSpawnerPos:Map<Int, Point>;
	private var heavenSpawnerPos:Map<Int, Point>;
	private var hellRewardSpawners:Map<Int, SmartComponent>;
	private var heavenRewardSpawners:Map<Int, SmartComponent>;
	private var activeHellReward:Array<RewardType>;
	private var activeHeavenReward:Array<RewardType>;
	
	
	public var stress:UISprite;
	

	// card slide position properties
	private var mousePos:Point;
	private var imgRot:Float;
	private var choiceType:ChoiceType;
	
	private static var isOpen:Bool;
	
	private var activeChoice:ChoiceDescription;
	private var intern:InternDescription;
	private var reward:EventRewardDesc;
	
	private var indexHellCurrency:Int;
	private var indexHeavenCurrency:Int;
	
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
		isOpen = true;
		
		addListeners();
	}
	
	/**
	 * get all intern event popin elements
	 */
	private function getComponents():Void
	{
		heavenChoice = cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_CHOICE), TextSprite);
		evilChoice = cast(getChildByName(AssetName.INTERN_EVENT_HELL_CHOICE), TextSprite);
		internName = cast(getChildByName(AssetName.INTERN_EVENT_NAME), TextSprite);
		btnClose = cast(getChildByName(AssetName.INTERN_EVENT_CLOSE), SmartButton);
		
		internStats = cast(getChildByName(AssetName.INTERN_EVENT_STATS), SmartComponent);	
		stressBar = cast(internStats.getChildByName(AssetName.INTERN_STRESS_JAUGE), SmartComponent);
		stressGaugeMask = cast(SmartCheck.getChildByName(stressBar, "jaugeStress_masque"), UISprite);
		stressGaugeBar = cast(SmartCheck.getChildByName(stressBar, "_jaugeStres"), UISprite);
		speedJauge = cast(internStats.getChildByName(AssetName.INTERN_SPEED_JAUGE), SmartComponent);
		effJauge = cast(internStats.getChildByName(AssetName.INTERN_EFF_JAUGE), SmartComponent);
		
		stress = cast(internStats.getChildByName(AssetName.INTERN_EVENT_STRESS), UISprite);
	}
	
	public function setIntern(pIntern:InternDescription):Void {
		hellRewardSpawners = new Map<Int, SmartComponent>();
		heavenRewardSpawners = new Map<Int, SmartComponent>();
		activeHellReward = new Array<RewardType>();
		activeHeavenReward = new Array<RewardType>();
		stressHellIndicators = new Map<Int, UISprite>();
		stressHeavenIndicators = new Map<Int, UISprite>();
		
		intern = pIntern;
		
		activeChoice = ChoiceManager.selectChoice(intern.idEvent);
		createChoice();
		var rewardCounter:RewardCounter = countRewards(activeChoice);
		
		for (i in 1...NB_GAIN_SPAWNER) {
			var newSpawnerHell:UISprite = cast(getChildByName(AssetName.INTERN_EVENT_HELL_CURRENCY + i), UISprite);
			var newSpawnerHeaven:UISprite = cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_CURRENCY + i), UISprite);
			
			if (i <= rewardCounter.hellNumber) hellRewardSpawners.set(i, cast(SpriteManager.spawnComponent(newSpawnerHell, AssetName.REWARD_CURRENCY_SPAWNER, this, TypeSpawn.SMART_COMPONENT), SmartComponent));
			else newSpawnerHell.visible = false;
			
			if (i <= rewardCounter.heavenNumber) heavenRewardSpawners.set(i, cast(SpriteManager.spawnComponent(newSpawnerHeaven, AssetName.REWARD_CURRENCY_SPAWNER, this, TypeSpawn.SMART_COMPONENT), SmartComponent));
			else newSpawnerHeaven.visible = false;
		}
		
		var decrement:Int = 3;
		for (i in 1...NB_STRESS_INDICATOR) {
			stressHellIndicators.set(decrement, cast(cast(getChildByName(AssetName.INTERN_EVENT_HELL_STRESS), SmartComponent).getChildByName(AssetName.INTENSITY_MARKER + i), UISprite));
			stressHeavenIndicators.set(decrement, cast(cast(getChildByName(AssetName.INTERN_EVENT_HEAVEN_STRESS), SmartComponent).getChildByName(AssetName.INTENSITY_MARKER + i), UISprite));
			decrement--;
		}
		
		initReward(activeChoice, intern);
		initStress();
	}
	
	/**
	 * Count number of reward per choiceType
	 * @param	pChoice
	 * @return
	 */
	private function countRewards(pChoice:ChoiceDescription):RewardCounter {
		var hellCounter:Int = 0;
		var heavenCounter:Int = 0;
		
		if (pChoice.goldHell > 0) hellCounter++;
		if (pChoice.ironHell > 0) hellCounter++;
		if (pChoice.karmaHell > 0) hellCounter++;
		if (pChoice.woodHell > 0) hellCounter++;
		if (pChoice.soulHell > 0) hellCounter++;
		
		if (pChoice.goldHeaven > 0) heavenCounter++;
		if (pChoice.ironHeaven> 0) heavenCounter++;
		if (pChoice.karmaHeaven > 0) heavenCounter++;
		if (pChoice.woodHeaven > 0) heavenCounter++;
		if (pChoice.soulHeaven > 0) heavenCounter++;
		
		return { hellNumber: hellCounter, heavenNumber: heavenCounter };
	}
	
	/**
	 * get new generated text
	 */
	private function createChoice():Void
	{		
		heavenChoice.text = activeChoice.heavenAnswer;
		evilChoice.text = activeChoice.hellAnswer;
		
		internName.text = intern.name;
		
		stressGaugeMask.scale.x = 0;
		stressGaugeBar.scale.x = 0;
		
		var iStress:Int = intern.stress;	
		stressGaugeBar.scale.x = Math.min(iStress / 100, 1);
		
		createCard(activeChoice);
		createPortraitCard();
		initStars();
	}
	
	private function createCard(pChoice:ChoiceDescription):Void {
		var swipCard:UISprite = cast(getChildByName(AssetName.INTERN_EVENT_CARD), UISprite);
		choiceCard = cast(SpriteManager.spawnComponent(swipCard, pChoice.card, this, TypeSpawn.SMART_COMPONENT, true));
		choiceCard.on(MouseEventType.MOUSE_DOWN, startFollow);
		imgRot = choiceCard.rotation;
		cast(choiceCard.getChildByName(AssetName.INTERN_EVENT_DESC), TextSprite).text = activeChoice.text;
	}
	
	private function createPortraitCard():Void {
		var bgName:String;
		if (intern.aligment == Std.string(Alignment.heaven)) bgName = "_eventStress_CardBG_Hell";
		else bgName = "_eventStress_CardBG_Heaven";
		
		var portrait:UISprite = cast(internStats.getChildByName("_internPortrait"), UISprite);
		var background:UISprite = cast(internStats.getChildByName("BG"), UISprite);
		
		SpriteManager.spawnComponent(background, bgName, internStats, TypeSpawn.SPRITE, 0);
		SpriteManager.spawnComponent(portrait, intern.portrait, internStats, TypeSpawn.SPRITE, 0);
	}
	
	/**
	 * show stats stars
	 */
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
	
	private function initStress():Void {
		var natIndic:Int = 1;
		var unatIndic:Int = 1;
		
		for (i in 0...NB_STRESS_INDICATOR) {
			if (activeChoice.naturalStress <= 10) natIndic = 1;
			else if (activeChoice.naturalStress > 10 && activeChoice.naturalStress <= 20) natIndic = 2;
			else natIndic = 3;
		}
			
		for (i in 0...NB_STRESS_INDICATOR) {
			if (activeChoice.unaturalStress <= 10) unatIndic = 1;
			else if (activeChoice.unaturalStress > 10 && activeChoice.unaturalStress <= 20) unatIndic = 2;
			else unatIndic = 3;
		}
		
		if (intern.aligment == Std.string(Alignment.hell)) {
			for (j in 1...NB_STRESS_INDICATOR) {
				if (j > natIndic) stressHellIndicators[j].visible = false;
				if (j > unatIndic) stressHeavenIndicators[j].visible = false;
			}
		}
		else {
			for (j in 1...NB_STRESS_INDICATOR) {
				if (j > natIndic) stressHeavenIndicators[j].visible = false;
				if (j > unatIndic) stressHellIndicators[j].visible = false;
			}
		}
	}
	
	/**
	 * Reward initialisation
	 * @param	newChoice 
	 * @param	internDesc
	 */
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
		
		showReward(ChoiceType.HELL, reward); 
		showReward(ChoiceType.HEAVEN, reward);
	}
	
	/**
	 * show all reward icone and value
	 * @param	pChoiceType
	 * @param	pReward
	 */
	private function showReward(pChoiceType:ChoiceType, pReward:EventRewardDesc):Void {
		indexHeavenCurrency = 1;
		indexHellCurrency = 1;
		if (pChoiceType == ChoiceType.HELL) {
			showSpecificReward(RewardType.gold, pChoiceType, pReward.gold, activeChoice.goldHell);
			showSpecificReward(RewardType.iron, pChoiceType, pReward.iron, activeChoice.ironHell);
			showSpecificReward(RewardType.wood, pChoiceType, pReward.wood, activeChoice.woodHell);
			showSpecificReward(RewardType.karma, pChoiceType, pReward.karma, activeChoice.karmaHell);
			showSpecificReward(RewardType.soul, pChoiceType, pReward.soul, activeChoice.soulHell);
		}
		else {
			showSpecificReward(RewardType.gold, pChoiceType, pReward.gold, activeChoice.goldHeaven);
			showSpecificReward(RewardType.iron, pChoiceType, pReward.iron, activeChoice.ironHeaven);
			showSpecificReward(RewardType.wood, pChoiceType, pReward.wood, activeChoice.woodHeaven);
			showSpecificReward(RewardType.karma, pChoiceType, pReward.karma, activeChoice.karmaHeaven);
			showSpecificReward(RewardType.soul, pChoiceType, pReward.soul, activeChoice.soulHeaven);
		}	
	}
	
	/**
	 * 
	 * @param	rewardType
	 * @param	pChoiceType
	 * @param	pReward
	 * @param	testCurrency
	 */
	private function showSpecificReward(rewardType:RewardType, pChoiceType:ChoiceType, pReward:Int, testCurrency:Int):Void {
		if (pChoiceType == ChoiceType.HELL) {
			if (!alreadyShow(rewardType, pChoiceType) && testCurrency > 0) {
				var txt:TextSprite = cast(hellRewardSpawners[indexHellCurrency].getChildByName("ressourceEvent_text"), TextSprite);
				var icon:UISprite = cast(hellRewardSpawners[indexHellCurrency].getChildByName(AssetName.PROD_ICON_GENERIC_LARGE), UISprite);
				SpriteManager.spawnComponent(icon, AssetName.getCurrencyAssetName(rewardType), hellRewardSpawners[indexHellCurrency], TypeSpawn.SPRITE);
				txt.text = cast(pReward + testCurrency);
				activeHellReward.push(rewardType);
				indexHellCurrency++;
			}
		}
		else {
			if (!alreadyShow(rewardType, pChoiceType) && testCurrency > 0) {
				var txt:TextSprite = cast(heavenRewardSpawners[indexHeavenCurrency].getChildByName("ressourceEvent_text"), TextSprite);
				var icon:UISprite = cast(heavenRewardSpawners[indexHeavenCurrency].getChildByName(AssetName.PROD_ICON_GENERIC_LARGE), UISprite);
				SpriteManager.spawnComponent(icon, AssetName.getCurrencyAssetName(rewardType), heavenRewardSpawners[indexHeavenCurrency], TypeSpawn.SPRITE);
				txt.text = cast(pReward + testCurrency);
				activeHeavenReward.push(rewardType);
				indexHeavenCurrency++;
			}
		}
	}
	
	/**
	 * Bool if the reward currency is already show
	 * @param	tReward
	 * @param	pChoiceType
	 * @return
	 */
	private function alreadyShow(tReward:RewardType, pChoiceType:ChoiceType):Bool {
		if (pChoiceType == ChoiceType.HELL) {
			for (i in 0...activeHellReward.length) { if (activeHellReward[i] == tReward) return true; }
		}
		else {
			for (i in 0...activeHeavenReward.length) { if (activeHeavenReward[i] == tReward) return true; }
		}
		return false;
	}
	
	private function addListeners ():Void {
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
		choiceCard.on(MouseEventType.MOUSE_UP_OUTSIDE, valideSwip);
		choiceCard.on(MouseEventType.MOUSE_UP, valideSwip);
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
	private function valideSwip():Void
	{	
		choiceCard.rotation = imgRot;
		choiceCard.off(MouseEventType.MOUSE_MOVE, followMouse);
		choiceCard.on(MouseEventType.MOUSE_UP_OUTSIDE, valideSwip);
		choiceCard.on(MouseEventType.MOUSE_UP, valideSwip);
		
		if (choiceType != ChoiceType.NONE) {
			ChoiceManager.applyReward(intern, reward, choiceType, activeChoice);
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
		Interactive.removeListenerClick(btnClose, onClose);
		
		choiceCard.interactive = false;
		choiceCard.off(MouseEventType.MOUSE_DOWN, startFollow);
		
		isOpen = false;
		parent.removeChild(this);
		instance = null;
		super.destroy();
	}

}