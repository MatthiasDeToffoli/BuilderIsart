package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.DeltaDNAManager;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.dialogue.Dialogue;
import com.isartdigital.perle.ui.hud.dialogue.DialogueAction;
import com.isartdigital.perle.ui.hud.dialogue.DialogueScenario;
import com.isartdigital.perle.ui.hud.dialogue.FTUEStep;
import com.isartdigital.perle.ui.hud.dialogue.FingerAnim;
import com.isartdigital.perle.ui.hud.dialogue.FocusManager;
import com.isartdigital.perle.ui.hud.dialogue.IconsFtue;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin.ShopTab;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.ui.smart.SmartButton;
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
	private static inline var FTUE_ACTION:String = "assets/ftue_bg.png";
	private static var firstBuilding:VBuilding;
	private static var firstBatPoint:Point;
	private static var purgatoryPoint:Point;
	private static var heavenCenter:Point;
	private static var steps:Array<FTUEStep>;
	private static var finger:FingerAnim;
	
	public static var closeDialoguePoppin:Bool = false;
	public static var npc_dialogue_ftue:Array<Array<Array<String>>>;
	public static var dialogueSaved:Int;
	public static var dialoguePoppin:Dialogue;
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
	
	public static var ftueClosePurgatory:Bool = false;
	public static var ftueCloseUnlockedItem:Bool = false;
	
	public static var ftuePlayerCanWait:Bool = false;
	public static var boostBuilding:Bool = false;
	public static var passFree:Bool = false;
	
	
	/**
	 * Init Ftue
	 * @param	pFTUE
	 */
	public static function init (pFTUE: Dynamic): Void {
		steps = pFTUE.steps;
		setAllExpressions();
		npc_dialogue_ftue = [];
		parseJsonFtue(Main.DIALOGUE_FTUE_JSON_NAME); //json
		Dialogue.numberOfDialogue = npc_dialogue_ftue.length; //set length of the dialogue
		Dialogue.firstToSpeak = npc_dialogue_ftue[0][0][0]; //Set the first NPC to talk
	}
	
	/**
	 * Create Ftue
	 */
	public static function createFtue():Void {
		//dialogueSaved = 21;
		//SaveManager.save();
		
		var lSave:Int = SaveManager.currentSave.ftueProgress;
		//check if first time
		if (lSave != null && steps[lSave-1] !=null) {
			if (lSave > steps.length-1 || steps[lSave-1].endOfFtue || steps[lSave-1].endOfSpecial || steps[lSave-1].endOfAltar || steps[lSave-1].endOfCollectors || steps[lSave-1].endOfFactory || steps[lSave-1].endOfMarketing || steps[lSave-1].endOfSpecial) {
				//DialogueUI.actualDialogue = SaveManager.currentSave.ftueProgress;
				return;
			}
			
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
		dialogueSaved = 0;
		
		var lIcons = new IconsFtue();
		GameStage.getInstance().getIconContainer().addChild(lIcons);
		
		//check if FTUE wasn't over
		if(SaveManager.currentSave.ftueProgress!=null)
			dialogueSaved = SaveManager.currentSave.ftueProgress;
		else {
			dialogueSaved = 0;
			createFirstHouse();
		}
		
		if (lSave != null) 
			if (steps[lSave].ifAlreadylevel2) 
				dialogueSaved++;
			
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
		GameStage.getInstance().getFtueContainer().removeChild(dialoguePoppin);	
		
		pTypeOfDialogueIsAction ? dialoguePoppin = new DialogueAction(pNpc):dialoguePoppin = new DialogueScenario(pNpc);
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
			GameStage.getInstance().getFtueContainer().addChild(dialoguePoppin);
			dialoguePoppin.open();
		}	
		dialoguePoppin.createText(pNumber,pNpc,steps[dialogueSaved].npcWhoTalkPicture, steps[dialogueSaved].expression);
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
		
		//DeltaDNA
		DeltaDNAManager.sendStepFTUE(dialogueSaved);
		
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
			if (steps[dialogueSaved].makeChoice)
				ftueStepMakeChoice = true;
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
				createFingerAnim(new Point(0,0));
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
			
			/*if (steps[dialogueSaved].putCenterRegionHeaven) {
				//CameraManager.placeCamera(heavenCenter);
				//Hud.isHide = true;
			}*/
			
			
			
			
			if (steps[dialogueSaved].clickOnCard)
				ftueStepClickOnCard = true;
			else if (steps[dialogueSaved].haveToPutBuilding) {
				Hud.getInstance().show();
				Hud.getInstance().hide();
				ftueStepPutBuilding = true;
			}
			else if (steps[dialogueSaved].jugeSouls) {
				ftueStepSlideCard = true;
				createFingerAnim(null,true);
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
			ResourcesManager.gainResources(GeneratorType.soft, steps[dialogueSaved].gold);
			Hud.getInstance().softMc.alpha = 1;
			FocusManager.getInstance().setFocus(Hud.getInstance().softMc);
			Hud.getInstance().btnSoft.interactive = false;
		}
		
		if (steps[dialogueSaved].karma != null && ResourcesManager.getTotalForType(GeneratorType.hard)==0) {
			ResourcesManager.gainResources(GeneratorType.hard, steps[dialogueSaved].karma);	
			Hud.getInstance().hardMc.alpha = 1;
			Hud.getInstance().btnHard.interactive = false;
		}
			
		if (steps[dialogueSaved].hellEXP !=null)
			ResourcesManager.gainResources(GeneratorType.badXp, steps[dialogueSaved].hellEXP);	
			
		if (steps[dialogueSaved].heavenEXP !=null)
			Timer.delay(giveHeavenExp, 200);
			
		if (steps[dialogueSaved].shouldBlockHud)
			Hud.isHide = true;
		else if (steps[dialogueSaved].doNotBockBuildings)
			ftueStepBlocBuildings = true;
		else if (steps[dialogueSaved].doNotBockInterns)
			ftueStepBlocInterns = true;
			
		/*if (steps[dialogueSaved].stress) {
			trace("te");
			//FocusManager.getInstance().setFocus(Choice.getInstance().stress);
		}*/
	}
	
	
	
	/**
	 * Function called if it's a end of a Dialogue
	 * @param	doNotNextStep bool to not pass the next step (used when we oppen poppin, like that we can call the next step when the register is over : no bug of Target=null)
	 */
	public static function endOfaDialogue(?doNotNextStep:Bool, ?pCloseHud:Bool):Void {
		if (steps[dialogueSaved + 1] != null) {
			if (steps[dialogueSaved + 1].arrowRotation != null) {
				closeDialoguePoppin = false;
				if (!pCloseHud)
					Hud.getInstance().show();
			}
			
			if (steps[dialogueSaved + 1].npcWhoTalk != null) {
				closeDialoguePoppin = false;
			}
			else {
				closeDialoguePoppin = true;
				removeDialogue();
			}
		}
		else {
			closeDialoguePoppin = true;
			removeDialogue();
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
			
		if (steps[dialogueSaved + 1] != null) 
			if (steps[dialogueSaved+1].arrowRotation != null && steps[dialogueSaved+1].npcWhoTalk != null)
				removeDialogue();
			
		if (Std.is(steps[dialogueSaved].item, SmartButton)) {
			//cast(steps[dialogueSaved].item, SmartButton).off(MouseEventType.CLICK, endOfaDialogue);
			steps[dialogueSaved].item = null;
		}
		
		if (dialogueSaved == steps.length - 1)
			Hud.getInstance().alpha = 1;
			
		else {
			trace ("fin d'etape " + dialogueSaved);
		}
		
		closeFtueLock();
		
		dialogueSaved++;
		if (steps[dialogueSaved-1].checkpoint)
			SaveManager.save();
		
		if (steps[dialogueSaved - 1].endOfFtue || steps[dialogueSaved - 1].endOfAltar || steps[dialogueSaved - 1].endOfCollectors || steps[dialogueSaved - 1].endOfFactory || steps[dialogueSaved - 1].endOfMarketing || steps[dialogueSaved - 1].endOfSpecial) {
			Hud.getInstance().alpha = 1;
			removeDialogue();
			return;
		}
		
		IconsFtue.setAllFalse();
		nextStep();
	}
	
	private static function createFingerAnim(pPos:Point, ?isCard:Bool):Void {
		finger = new FingerAnim();
		GameStage.getInstance().getActionContainer().addChild(finger);
		
		
		if (isCard) {
			var lPoint:Point = TribunalPopin.getInstance().getCardPos();
			pPos = new Point(lPoint.x, lPoint.y - finger.height / 2);
		}
		
		finger.position = pPos;
		finger.start();	
	}
	
	/**
	 * Set all expressions of NPCS
	 */
	private static function setAllExpressions():Void {
		Dialogue.allExpressionsArray = [];
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
	 * Check if this expression is already in the array
	 * @param	pExpression
	 */
	private static function checkIfAlreadyInArray(pExpression:String):Void {
		for (i in 0...Dialogue.allExpressionsArray.length) {
			if (Dialogue.allExpressionsArray[i] == pExpression)
				return;
		}
		Dialogue.allExpressionsArray.push(pExpression);
	}
	
	/**
	 * Create first House
	 */
	private static function createFirstHouse() {
		var lBuilding:VBuilding = Phantom.firstBuildForFtue();
	}
	
	/**
	 * Give EXP during FTUE
	 */
	private static function giveHeavenExp() {
		ResourcesManager.gainResources(GeneratorType.goodXp, steps[dialogueSaved].heavenEXP);
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
	private static function parseJsonFtue(pJsonName:String):Void {
		var jsonFtue:Dynamic = GameLoader.getContent(pJsonName + ".json");
		var i:Int = 0;
		for (dialogue in Reflect.fields(jsonFtue)) {
			npc_dialogue_ftue[i] = [];
			var ldialogue = Reflect.field(jsonFtue, dialogue);
			var lArray:Array<String> = ldialogue;
			npc_dialogue_ftue[i].push(lArray);
			i++;
		}
	}
	
	private static function openFtueLock():Void {
		if (steps[dialogueSaved].ftueContainer) 	
			UIManager.getInstance().openFTUEInFtue(FTUE_ACTION);
		else if(steps[dialogueSaved].actionContainer) 
			UIManager.getInstance().openFTUEInAction(FTUE_SCENARIO);
	}
	
	private static function closeFtueLock():Void {
		if (steps[dialogueSaved].ftueContainer) 	
			UIManager.getInstance().closeFTUEInFtue();
		else if(steps[dialogueSaved].actionContainer) 
			UIManager.getInstance().closeFTUEInAction();
	}
	
	/**
	 * Remove Ftue
	 */
	public static function removeDialogue():Void {
		//Hud.getInstance().show();
		GameStage.getInstance().getFtueContainer().removeChild(dialoguePoppin);	
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
	}
	
}