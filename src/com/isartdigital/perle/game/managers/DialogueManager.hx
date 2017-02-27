package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.DeltaDNAManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManagerLoad;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.dialogue.DialoguePoppin;
import com.isartdigital.perle.ui.hud.dialogue.FTUEStep;
import com.isartdigital.perle.ui.hud.dialogue.FingerAnim;
import com.isartdigital.perle.ui.hud.dialogue.FocusManager;
import com.isartdigital.perle.ui.hud.dialogue.GoldEffect;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;
import js.Browser;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;


/**
 * ...
 * @author Alexis
 */
class DialogueManager
{
	private static inline var ALPHA_ON:Float = 1;
	private static inline var ALPHA_OFF:Float = 0.2;
	private static inline var FTUE_SCENARIO:String = "assets/ftue2_bg.png";
	public static inline var FTUE_ACTION:String = "assets/ftue_bg.png";
	private static inline var FTUE_POS_MOVED:Float = 200;
	private static inline var FTUE_TIME_BEFORE_EVENT:Float = 200;
	private static var firstBuilding:VBuilding;
	private static var firstBatPoint:Point;
	private static var purgatoryPoint:Point;
	private static var heavenCenter:Point;
	public static var steps:Array<FTUEStep>;
	private static var finger:FingerAnim;
	private static var npc_dialogue_ftue:Array<Array<Array<String>>>;
	private static var npc_dialogue_ftue_en:Array<Array<Array<String>>>;
	
	public static var isFR:Bool;
	public static var ftueIsCreated:Bool = false;
	public static var actual_npc_dialogue_ftue:Array<Array<Array<String>>>;
	public static var dialoguePoppinPos:Point;
	public static var closeDialoguePoppin:Bool = false;
	public static var dialogueSaved:Int;
	public static var registerIsADialogue:Bool;
	public static var cameraHaveToMove:Bool;
	public static var ftueStepRecolt:Bool = false;
	public static var ftueStepClickShop:Bool = false;
	public static var ftueStepClickOnCard:Bool = false;
	public static var ftueStepPutBuilding:Bool = false;
	public static var ftueStepConstructBuilding:Bool = false;
	public static var ftueStepOpenPurgatory:Bool = false;
	public static var ftueStepSlideCard:Bool = false;
	public static var ftueStepOpenShopIntern:Bool = false;
	public static var ftueStepBuyIntern:Bool = false;
	public static var ftueStepClickOnIntern:Bool = false;
	public static var ftueStepSendIntern:Bool = false;
	public static var ftueStepResolveIntern:Bool = false;
	public static var ftueStepMakeChoice:Bool = false;
	public static var ftueStepMakeAllChoice:Bool = false;
	public static var ftueStepCloseGatcha:Bool = false;
	public static var ftueStepBlocBuildings:Bool = false;
	public static var ftueStepBlocInterns:Bool = false;
	private static var doNotGiveGold:Bool = false;
	private static var doNotGiveKarma:Bool = false;
	
	public static var ftuecreateFirstHouse:Bool = false;
	public static var ftueClosePurgatory:Bool = false;
	public static var ftueCloseUnlockedItem:Bool = false;
	
	public static var ftuePlayerCanWait:Bool = false;
	public static var boostBuilding:Bool = false;
	public static var passFree:Bool = false;
	
	private static var addedJuicy:Bool = false;
	private static var numberOfGolds:Int = 5;
	private static var numberOfGoldsCreated:Int = 0;
	
	//Var for Other Stories
	private static inline var DIALOGUE_11_SOULS:Int = 21;
	private static inline var EXPRESSION_11_SOULS:String = "_Neutral";
	private static inline var DIALOGUE_20_SOULS:Int = 17;
	private static inline var EXPRESSION_20_SOULS:String = "_Angry";
	private static inline var EXPRESSION_20_SOULS2:String = "_Neutral";
	private static inline var DIALOGUE_02_SOULS:Int = 19;
	private static inline var EXPRESSION_02_SOULS:String = "_Happy";
	private static inline var DIALOGUE_AFTER_STORIE:Int = 19;
	public static var counterForFtueHeaven:Int = 0;
	
	/**
	 * Init Ftue
	 * @param	pFTUE
	 */
	public static function init (pFTUE: Dynamic): Void {
		steps = pFTUE.steps;
		setAllExpressions();
		npc_dialogue_ftue = [];
		actual_npc_dialogue_ftue = [];
		npc_dialogue_ftue_en = [];
		GoldEffect.goldJuicy = [];
		parseJsonFtue(Main.DIALOGUE_FTUE_JSON_NAME); //json fr
		parseJsonFtue(Main.DIALOGUE_FTUE_JSON_NAME_EN, true); //json en
		DialoguePoppin.numberOfDialogue = npc_dialogue_ftue.length; //set length of the dialogue
		DialoguePoppin.firstToSpeak = npc_dialogue_ftue[0][0][0]; //Set the first NPC to talk
		
		//todo : check de dialogue via langue FB
		isFR = true;
		changeLanguage();
		
		GameStage.getInstance().getFtueContainer().addChild(DialoguePoppin.getInstance());
		dialoguePoppinPos = DialoguePoppin.getInstance().position;
		
	}
	
	/**
	 * Create Ftue
	 */
	public static function createFtue():Void {
		ftueIsCreated = true;
		var lSave:Int = SaveManager.currentSave.ftueProgress;
		//var lSave:Int = SaveManager.currentSave.ftueProgress;
		trace(lSave);
		trace(steps.length);
		//check if first time
		if (lSave != null && steps[lSave-1] !=null) {
			if (lSave > steps.length-1 || steps[lSave-1].endOfFtue || steps[lSave-1].endOfSpecial || steps[lSave-1].endOfAltar || steps[lSave-1].endOfCollectors || steps[lSave-1].endOfFactory || steps[lSave-1].endOfMarketing) {
				//DialogueUI.actualDialogue = SaveManager.currentSave.ftueProgress;
				return;
			}
			
			if (steps[lSave].gold !=null)
				doNotGiveGold = true;
			else if (steps[lSave].karma !=null)
				doNotGiveKarma = true;
			
			if (steps[lSave].haveToMakeAllChoice) {
				Hud.getInstance().hide();
				UIManager.getInstance().openPopin(ListInternPopin.getInstance());
			}
			
			else if (steps[lSave].clickOnCard) {
				Hud.getInstance().hide();
				UIManager.getInstance().openPopin(ShopPopin.getInstance());
				ShopPopin.getInstance().init(ShopTab.Building);
			}
		}
		
		GameStage.getInstance().getFtueContainer().addChild(DialoguePoppin.getInstance());
		DialoguePoppin.wasAction = true;
		dialogueSaved = 0;
		
		//check if FTUE wasn't over
		if (SaveManager.currentSave.ftueProgress != null && SaveManager.currentSave.ftueProgress != 0) {
			dialogueSaved = SaveManager.currentSave.ftueProgress;
		}
		//if(SaveManager.currentSave.ftueProgress!=null && SaveManager.currentSave.ftueProgress!=0)
		else {
			dialogueSaved = 0;
			//createFirstHouse();
		}
		
		if (lSave != null) 
			if (steps[lSave].ifAlreadylevel2) 
				dialogueSaved++;
				
			else if (steps[lSave].isInPurgatory)
				dialogueSaved = DIALOGUE_AFTER_STORIE;
			
		nextStep();
	}

	/**
	 * Function to stop recolt steps
	 */
	public static function recoltStepOver() {
		if (ftueStepRecolt) {
			ftueStepRecolt = false;
			endOfaDialogue();
		}
	}
	
	/**
	 * function to create a Dialogue
	 * @param	pNumber Number of dialogue
	 * @param	pNpc Npc who talk
	 * @param	pHideHud Hide Hud ?
	 * @param	pTypeOfDialogueIsAction Is dialogue an action or a scenario
	 * @param	pBlocHud Hud Stuck ?
	 */
	public static function createTextDialogue(pNumber:Int, pNpc:String, pHideHud:Bool, pTypeOfDialogueIsAction:Bool, ?pBlocHud:Bool) {
		if (!closeDialoguePoppin) {
			if (pHideHud) {
				Hud.getInstance().alpha = ALPHA_OFF;
				if(pBlocHud !=null)
					Hud.isHide = pBlocHud;
				else
					Hud.isHide = true;
			}
			else {
				Hud.getInstance().alpha = ALPHA_ON;
				Hud.isHide = false;
				//closeFtueLock();	
			}
		}
		DialoguePoppin.getInstance().createText(pNumber,pNpc,steps[dialogueSaved].npcWhoTalkPicture, steps[dialogueSaved].expression, steps[dialogueSaved].isAction, dialogueSaved);
	}
	
	/**
	 * Register items to create locked ftue
	 * @param	pTarget
	 * @param	pIsNotDialogue
	 * @param	readyForNextStep
	 * @param	pPosition
	 */
	public static function register (pTarget:DisplayObject, ?pIsNotDialogue:Bool, ?readyForNextStep:Bool, ?pPosition): Void {
		if (dialogueSaved >= steps.length ) return;
		for (i in 0...steps.length) {
			if (pTarget.name == steps[i].name) {
				steps[i].item = pTarget;
				if (readyForNextStep) nextStep();
				//cette ligne ne se fait pour les dialogues : sinon les dialogues se passent tous d'un coup car c'est la meme etape
				//if (pIsNotDialogue) cast(pTarget, SmartButton).on(MouseEventType.CLICK, endOfaDialogue); 
			}
		}
	}
	
	/**
	 * Function to create next Step of dialogue
	 * @param	pTarget
	 */
	public static function nextStep(pTarget:DisplayObject = null): Void {
		if (dialogueSaved >= steps.length) return;
		
		if (steps[dialogueSaved] == null) return;
		
		if(steps[dialogueSaved].otherStorieDialogue)
			checkForOtherStories();
		//DeltaDNA
		DeltaDNAManager.sendStepFTUE(dialogueSaved);
		
		DialoguePoppin.getInstance().position = dialoguePoppinPos;
		
		//Effects : 
		//Actions
		if (steps[dialogueSaved].isAction) {
			//Flag vars
			if (steps[dialogueSaved].clickOnShop) {
				Hud.getInstance().show();
				ftueStepClickShop = true;
			}
			if (steps[dialogueSaved].openIntern)
				ftueStepClickOnIntern = true;
			if (steps[dialogueSaved].sendIntern)
				ftueStepSendIntern = true;
			if (steps[dialogueSaved].resolveIntern)
				ftueStepResolveIntern = true;
			if (steps[dialogueSaved].makeChoice) {
				Timer.delay(createFingerAnimAfterDelay, FTUE_TIME_BEFORE_EVENT);
				ftueStepMakeChoice = true;
			}
			if (steps[dialogueSaved].haveToMakeAllChoice)
				ftueStepMakeAllChoice = true;
			if (steps[dialogueSaved].closeGatcha)
				ftueStepCloseGatcha = true;
			if (steps[dialogueSaved].openShopIntern)
				ftueStepOpenShopIntern = true;
			if (steps[dialogueSaved].ifPlayerCanWait)
				ftuePlayerCanWait = true;
			if (steps[dialogueSaved].boostBuilding)
				boostBuilding = true;
			if (steps[dialogueSaved].passFreeConstruct)
				passFree = true;
				
			//Dialogue + Arrow
			if (steps[dialogueSaved].npcWhoTalk != null && steps[dialogueSaved].arrowRotation != null) {
				createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, false, true, true);
				openFtueLock();
				FocusManager.getInstance().setFocus(steps[dialogueSaved].item, steps[dialogueSaved].arrowRotation);
			}
			
			//Dialogue + Deplacement camera
			else if (steps[dialogueSaved].npcWhoTalk != null && steps[dialogueSaved].moveCamera) {
				createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, true, true, false);
				cameraHaveToMove = true;
				createFingerAnim(AssetName.FTUE_DRAG, new Point(0,0));
				openFtueLock();
				FocusManager.getInstance().setFocus(null);
			}
			
			//Dialogue + recolt
			else if (steps[dialogueSaved].haveToRecolt != null) {
				createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, true, true, false);
				ftueStepRecolt = true;
				//CameraManager.placeCamera(firstBatPoint);
				Hud.getInstance().hide();
				Hud.getInstance().show();
				//Hud.isHide = true;
			}
			
			//Dialogue + construc
			else if (steps[dialogueSaved].npcWhoTalk != null && steps[dialogueSaved].haveToUpgradeBuilding) {
				createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, true, true, false);
				ftueStepConstructBuilding = true;
				Hud.getInstance().hide();
				Hud.getInstance().show();
			}
			
			//Dialogue + open Purgatory
			else if (steps[dialogueSaved].npcWhoTalk != null && steps[dialogueSaved].openPurgatory) {
				createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, true, true, false);
				ftueStepOpenPurgatory = true;
				//CameraManager.placeCamera(purgatoryPoint);
				Hud.getInstance().hide();
				Hud.getInstance().show();
				//Hud.isHide = true;
			}
			
			//Dialogue + click on card
			else if (steps[dialogueSaved].npcWhoTalk != null) {
				ftueStepClickOnCard = true;
				createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, false, true, true);
			}
			
			if (steps[dialogueSaved].clickOnCard)
				ftueStepClickOnCard = true;
			else if (steps[dialogueSaved].haveToPutBuilding) {
				Hud.getInstance().show();
				Hud.getInstance().hide();
				ftueStepPutBuilding = true;
			}
			else if (steps[dialogueSaved].jugeSouls) {
				ftueStepSlideCard = true;
				createFingerAnim(AssetName.FTUE_DRAG_MOVE, null,true);
			}
			else if (steps[dialogueSaved].closePurgatory)
				ftueClosePurgatory = true;
			else if (steps[dialogueSaved].closeUnlocked)
				ftueCloseUnlockedItem = true;
				
			if (steps[dialogueSaved].buyIntern)
				ftueStepBuyIntern = true;
		}
		
		//Dialogue
		else if (dialogueSaved == 0 || steps[dialogueSaved].npcWhoTalk != null) {
			if (pTarget != null) return;
			createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk, true, false);
			openFtueLock();
			FocusManager.getInstance().setFocus(steps[dialogueSaved].item);
		}
		
		//ARROW
		else if (steps[dialogueSaved].arrowRotation != null) FocusManager.getInstance().setFocus(steps[dialogueSaved].item, steps[dialogueSaved].arrowRotation);
		
		//GAINS : 
		if (steps[dialogueSaved].gold != null) {
			if (!doNotGiveGold) {
				createGoldEffectJuicy();
				ResourcesManager.gainResources(GeneratorType.soft, steps[dialogueSaved].gold);
			}
			Hud.getInstance().softMc.alpha = 1;
			FocusManager.getInstance().setFocus(Hud.getInstance().softMc);
			Hud.getInstance().btnSoft.interactive = false;
		}
		
		if (steps[dialogueSaved].karma != null) {
			if (!doNotGiveKarma) 
				ResourcesManager.gainResources(GeneratorType.hard, steps[dialogueSaved].karma);	
			Hud.getInstance().hardMc.alpha = 1;
			Hud.getInstance().btnHard.interactive = false;
		}
			
		if (steps[dialogueSaved].hellEXP != null) {
			Hud.getInstance().setGlowTrue(Hud.getInstance().lBarHell);
			Timer.delay(giveHellExp, FTUE_TIME_BEFORE_EVENT);
		}
			
		if (steps[dialogueSaved].heavenEXP != null) {
			Hud.getInstance().setGlowTrue(Hud.getInstance().lBarHeaven);
			ResourcesManager.gainResources(GeneratorType.goodXp, steps[dialogueSaved].heavenEXP);	
			Hud.getInstance().heavenXPBar.alpha = 1;
			FocusManager.getInstance().setFocus(Hud.getInstance().heavenXPBar);
		}
		if (steps[dialogueSaved].hidHud) {
			Hud.isHide = false;
			Hud.getInstance().hide();
		}
			
		if (steps[dialogueSaved].shouldBlockHud)
			Hud.isHide = true;
		else if (steps[dialogueSaved].doNotBockBuildings)
			ftueStepBlocBuildings = true;
		else if (steps[dialogueSaved].doNotBockInterns)
			ftueStepBlocInterns = true;
		
		if (steps[dialogueSaved].speed || steps[dialogueSaved].efficiency) {
			DialoguePoppin.getInstance().position.y -= FTUE_POS_MOVED;
			Choice.getInstance().setGlowVisible();
		}
			
		if (steps[dialogueSaved].removeGlowIntern)
			Choice.getInstance().setGlowFalse();
			
		if (steps[dialogueSaved].changeDialoguePos)
			DialoguePoppin.getInstance().position.y += FTUE_POS_MOVED;
	}
	
	
	
	/**
	 * Function called if it's a end of a Dialogue
	 * @param	doNotNextStep bool to not pass the next step (used when we oppen poppin, like that we can call the next step when the register is over : no bug of Target=null)
	 */
	public static function endOfaDialogue(?doNotNextStep:Bool, ?pCloseHud:Bool):Void {
		DialoguePoppin.getInstance().position = dialoguePoppinPos;
		if (steps[dialogueSaved + 1] != null) {
			if (steps[dialogueSaved + 1].arrowRotation != null) {
				//closeDialoguePoppin = false;
				if (!pCloseHud)
					Hud.getInstance().show();
			}
			
			if (steps[dialogueSaved + 1].npcWhoTalk != null) {
				closeDialoguePoppin = false;
			}
			else {
				//closeDialoguePoppin = true;
				DialoguePoppin.getInstance().setAllFalse();
			}
		}
		else {
			//closeDialoguePoppin = true;
			DialoguePoppin.getInstance().setAllFalse();
		}
			
		endOfStep(doNotNextStep);
	}
	
	/**
	 * Card to show in the shop for a step in Shop
	 * @param	ShopTab
	 * @return  array string
	 */
	public static function getCardToShow(ShopTab):Array<String> {
		var lCard:String = steps[dialogueSaved].shopCarrousselCard;
		var arrayBuilding:Array<String> = [lCard];
		return arrayBuilding;
	}
	
	/**
	 * Function called at the end of a Step
	 * @param	doNotNextStep bool to not pass the next step (used when we oppen poppin, like that we can call the next step when the register is over : no bug of Target=null)
	 */
	private static function endOfStep (?doNotNextStep:Bool):Void {
		if (finger != null) 
			GameStage.getInstance().getActionContainer().removeChild(finger);
		
		setAllFalse();
		
		if (dialogueSaved >= steps.length)
			return;
			
		if (Std.is(steps[dialogueSaved].item, SmartButton)) {
			//cast(steps[dialogueSaved].item, SmartButton).off(MouseEventType.CLICK, endOfaDialogue);
			steps[dialogueSaved].item = null;
		}
		
		if (dialogueSaved == steps.length - 1)
			Hud.getInstance().alpha = 1;
		
		closeFtueLock();
		
		dialogueSaved++;
		if (steps[dialogueSaved - 1].checkpoint) {
			ServerManager.ftue();
			//SaveManager.save();
		}
		
		if (steps[dialogueSaved - 1].endOfFtue || steps[dialogueSaved - 1].endOfAltar || steps[dialogueSaved - 1].endOfCollectors || steps[dialogueSaved - 1].endOfFactory || steps[dialogueSaved - 1].endOfMarketing || steps[dialogueSaved - 1].endOfSpecial) {
			Hud.getInstance().alpha = 1;
			Hud.isHide = true;
			Hud.getInstance().show();
			removeDialogue();
			return;
		}
		
		if (steps[dialogueSaved-1].endOfOtherStories)
			dialogueSaved = DIALOGUE_AFTER_STORIE;
		
		nextStep();
	}
	
	/**
	 * Create Finger Anim after delay
	 */
	private static function createFingerAnimAfterDelay():Void {
		createFingerAnim(AssetName.FTUE_DRAG_MOVE,Choice.getInstance().getCardPos());
	}
	
	/**
	 * Create Finger Anim
	 * @param	pAsset different asset
	 * @param	pPos position
	 * @param	isCard
	 */
	private static function createFingerAnim(pAsset:String, pPos:Point, ?isCard:Bool):Void {
		finger = new FingerAnim(pAsset);
		GameStage.getInstance().getActionContainer().addChild(finger);
		
		
		if (isCard) {
			var lPoint:Point = TribunalPopin.getInstance().getCardPos();
			pPos = new Point(lPoint.x, lPoint.y);
		}
		
		finger.position = pPos;
		finger.start();	
	}
	
	/**
	 * Set all expressions of NPCS
	 */
	private static function setAllExpressions():Void {
		DialoguePoppin.allExpressionsArray = [];
		changeSpriteForExpression();
	}
	
	/**
	 * Change Sprite of Npc with the expression
	 */
	private static function changeSpriteForExpression():Void {
		for (i in 0...steps.length) {
			if (steps[i].expression != null)
				checkIfAlreadyInArray(steps[i].expression);
		}
	}
	
	/**
	 * Create effect when we give gold to player
	 */
	private static function createGoldEffectJuicy():Void {
		addedJuicy = true;
		if (numberOfGoldsCreated >= numberOfGolds)
			return;
		
		numberOfGoldsCreated++;
		var lGold:GoldEffect = new GoldEffect(AssetName.PROD_ICON_SOFT,GameStage.getInstance().getActionContainer().toGlobal(DialoguePoppin.getInstance().getNpcHeavenPos()), Hud.getInstance().getGoldIconPos());
		//lGold.effect();
		Timer.delay(createGoldEffectJuicy, 200);
	}
	
	/**
	 * Check if this expression is already in the array
	 * @param	pExpression
	 */
	private static function checkIfAlreadyInArray(pExpression:String):Void {
		for (i in 0...DialoguePoppin.allExpressionsArray.length) {
			if (DialoguePoppin.allExpressionsArray[i] == pExpression)
				return;
		}
		DialoguePoppin.allExpressionsArray.push(pExpression);
	}
	
	/**
	 * Create first House
	 */
	private static function createFirstHouse() {
		ftuecreateFirstHouse = true;
		var lBuilding:VBuilding = Phantom.firstBuildForFtue();
	}
	
	/**
	 * Give EXP during FTUE
	 */
	private static function giveHellExp() {
		ResourcesManager.gainResources(GeneratorType.badXp, steps[dialogueSaved].hellEXP);
	}
	
	/**
	 * Function to wait so time for special steps
	 * @param	pTime in milliseconds
	 */
	public static function waitTime(pTime:Int) {
		Timer.delay(waitTimeEndOfDialgue, pTime);
	}
	
	/**
	 * Time waited
	 */
	private static function waitTimeEndOfDialgue() {
		endOfaDialogue();
	}
	
	/**
	 * Parse of the json to set an array
	 * @param	pJsonName
	 */
	private static function parseJsonFtue(pJsonName:String,?pEn:Bool):Void {
		var jsonFtue:Dynamic = GameLoader.getContent(pJsonName + ".json");
		var i:Int = 0;
		for (dialogue in Reflect.fields(jsonFtue)) {
			if (pEn)
				npc_dialogue_ftue_en[i] = [];
			else
				npc_dialogue_ftue[i] = [];
				
			var ldialogue = Reflect.field(jsonFtue, dialogue);
			var lArray:Array<String> = ldialogue;
			if (pEn)
				npc_dialogue_ftue_en[i].push(lArray);
			else
				npc_dialogue_ftue[i].push(lArray);
				
			i++;
		}
	}
	
	/**
	 * Open black on normal screen
	 */
	private static function openFtueLock():Void {
		if (steps[dialogueSaved].ftueContainer) 	
			UIManager.getInstance().openFTUEInFtue(FTUE_ACTION);
		else if (steps[dialogueSaved].actionContainer) {
			if (steps[dialogueSaved].efficiency || steps[dialogueSaved].stress || steps[dialogueSaved].speed)
				UIManager.getInstance().openFTUEInAction(FTUE_ACTION);
			else
				UIManager.getInstance().openFTUEInAction(FTUE_SCENARIO);
		}
	}
	
	/**
	 * close ftue screen
	 */
	private static function closeFtueLock():Void {
		if (steps[dialogueSaved].ftueContainer) 	
			UIManager.getInstance().closeFTUEInFtue();
		else if(steps[dialogueSaved].actionContainer) 
			UIManager.getInstance().closeFTUEInAction();
	}
	
	/**
	 * Check if this dialogue can be an another story
	 */
	private static function checkForOtherStories():Void {
		var lDialogue:Int = 0;
		var lExpression:String = "null";
		var lExpression2:String = "null";
	
		switch(counterForFtueHeaven) {
			case 0: {
				lDialogue = DIALOGUE_02_SOULS;
				lExpression = EXPRESSION_02_SOULS;
			}
			case 1: {
				lDialogue = DIALOGUE_11_SOULS;
				lExpression = EXPRESSION_11_SOULS;
			}
			case 2: {
				lDialogue = DIALOGUE_20_SOULS;
				lExpression = EXPRESSION_20_SOULS;	
				lExpression2 = EXPRESSION_20_SOULS2;	
			}
		}
		
		steps[dialogueSaved].dialogueNumber = lDialogue;
		steps[dialogueSaved+1].dialogueNumber = lDialogue+1;
		steps[dialogueSaved].expression = lExpression;
		steps[dialogueSaved + 1].expression = lExpression;
		
		if(lExpression2 !="null")
			steps[dialogueSaved+1].expression = lExpression2;
		
		counterForFtueHeaven = 0;
	}
	
	/**
	 * Remove Ftue
	 */
	public static function removeDialogue():Void {
		//Hud.getInstance().show();
		GameStage.getInstance().getFtueContainer().removeChild(DialoguePoppin.getInstance());	
	}
	
	/**
	 * Set all the flag var at false
	 */
	private static function setAllFalse():Void {
		ftueStepClickShop = false;
		ftueStepClickOnCard = false;
		ftueStepPutBuilding = false;
		ftueStepConstructBuilding = false;
		ftueStepOpenPurgatory = false;
		ftueStepSlideCard = false;
		ftueStepBuyIntern = false;	
		ftueStepClickOnIntern = false;	
		ftueStepSendIntern = false;	
		ftueStepResolveIntern = false;	
		ftueStepMakeChoice = false;	
		ftueStepMakeAllChoice = false;	
		ftueStepCloseGatcha = false;	
		ftueStepOpenShopIntern = false;	
		ftueClosePurgatory = false;
		ftueCloseUnlockedItem = false;	
		ftuePlayerCanWait = false;	
		boostBuilding = false;	
		passFree = false;	
		ftueStepBlocBuildings = false;	
		ftueStepBlocInterns = false;
		doNotGiveGold = false;
		doNotGiveKarma = false;
		ftuecreateFirstHouse = false;
		
		Hud.getInstance().setGlowFalse();
	}
	
	/**
	 * Change language dialogue
	 */
	public static function changeLanguage() {
		actual_npc_dialogue_ftue = [];
		
		if (isFR)
			actual_npc_dialogue_ftue = npc_dialogue_ftue;
		else
			actual_npc_dialogue_ftue = npc_dialogue_ftue_en;
	}
	
	/**
	 * Remove gold after their effect
	 */
	private static function removeGolds() {
		if (GoldEffect.goldJuicy.length != 0)
		for (i in 0...GoldEffect.goldJuicy.length) {
			var lGold:UISprite = GoldEffect.goldJuicy[i];
			GoldEffect.goldJuicy.splice(i, 1);
			GameStage.getInstance().getIconContainer().removeChild(lGold);
			lGold.destroy();
		}
		addedJuicy = false;
	}
	
}