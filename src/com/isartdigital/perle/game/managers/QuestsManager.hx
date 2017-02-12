package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.ServerManager.DbAction;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.popin.listIntern.GatchaPopin;
import com.isartdigital.perle.ui.popin.listIntern.InternElementInQuest;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.listIntern.MaxStressPopin;
import eventemitter3.EventEmitter;
import haxe.Json;
//import com.isartdigital.perle.game.managers.TimeManager.TimeElementQuest;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.utils.game.GameStage;

/**
 * Manager of the quests, listen emits and links actions with others managers
 * @author Emeline Berenguier
 */

class QuestsManager
{
	public static var questsList(default, null):Array<TimeQuestDescription>;
	
	private static inline var NUMBER_EVENTS:Int = 3;
	private static var FTUE_TIMELINE:Int = 2500;
	
	//The time's gap between two events will be vary between these constants
	private static var GAP_TIME_LEVELS_ARRAY:Array<Int> = [50000, 40000, 30000, 20000, 10000];
	
	//Reference of the quest in progress
	private static var questInProgress:TimeQuestDescription;
	
	private static var isFinish:Bool = false;
	
	public static inline var EVENT_CHOICE_DONE:String = "QuestsManager_Choice_Done";
		
	public function new() 
	{
		
	}
	
	public static function init():Void{
		questsList = new Array<TimeQuestDescription>();	
		ServerManager.TimeQuestAction(DbAction.GET_SPE_JSON);
		//eGoToNextStep = new EventEmitter();
	}
	
	public static function getJson(object:Dynamic):Void{
		var questArray:Array<Dynamic> = cast(Json.parse(object));
		var lLength:Int = questArray.length;
		
		for (i in 0...lLength) {
			var arraySteps:Array<Float> = [Std.parseFloat(questArray[i].Step1), Std.parseFloat(questArray[i].Step2), Std.parseFloat(questArray[i].Step3)];
			var timeQuest:TimeQuestDescription = {
				refIntern: Std.int(questArray[i].RefIntern),
				progress: Std.parseFloat(questArray[i].Progress),
				steps: arraySteps,
				stepIndex: Std.int(questArray[i].StepIndex),
				creation: Std.parseFloat(questArray[i].Creation),
				end: Std.parseFloat(questArray[i].DateEnd)
			};
			
			//ServerManager.TimeQuestAction(DbAction.UPDT, timeQuest);
			TimeManager.createTimeQuest(timeQuest);
			questsList.push(timeQuest);
		}
	}
	
	/**
	 * Creation of the quest
	 * @param	pNumberEvents Number of events contained in a quest
	 * @return	The quest's datas
	 */
	public static function createQuest(pIdIntern:Int):TimeQuestDescription{
		var lIdTimer = pIdIntern;
		var lStepsArray:Array<Float> = createRandomGapArray(Intern.getIntern(pIdIntern));
		
		var lTimeQuestDescription:TimeQuestDescription = {
			refIntern: lIdTimer,
			progress: Date.now().getTime(),
			steps: lStepsArray,
			stepIndex: 0,
			creation: Date.now().getTime(),
			end: createEnd(lStepsArray)
		}
		
		questsList.push(lTimeQuestDescription);
		ServerManager.TimeQuestAction(DbAction.ADD, lTimeQuestDescription);
		
		SaveManager.save();
		
		return lTimeQuestDescription;
	}
	
	/**
	 * Create an array of random gap values between two events
	 * @param	pLength
	 * @return A new array
	 */
	private static function createRandomGapArray(pIntern:InternDescription):Array<Float>{
		var lListEvents:Array<Float> = new Array<Float>();
		var lGap:Float = 0;
		for (i in 0...NUMBER_EVENTS){
			if (DialogueManager.ftueStepResolveIntern || DialogueManager.ftueStepMakeAllChoice || DialogueManager.ftueStepMakeChoice)
				lGap = Date.now().getTime() + FTUE_TIMELINE + lGap;
			else
				lGap = GAP_TIME_LEVELS_ARRAY[pIntern.speed - 1] + lGap;
				lListEvents.push(Date.now().getTime() + lGap);
		}
		
		return lListEvents;
	}
	
	public static function chooseQuest(pQuest:TimeQuestDescription):Void {
		questInProgress = pQuest;
	}
	
	/**
	 * Create the total length of the quest
	 * @param	pListEvents
	 * @return	the total value
	 */
	private static function createEnd(pListEvents:Array<Float>):Float{
		var lEnd:Float = 0;
		var lLength:Int = pListEvents.length - 1;
		
		lEnd = pListEvents[lLength];
		
		return lEnd;
	}
	
	/**
	 * Callback of the choice event
	 * @param	pQuest
	 */
	public static function choice(pQuest:TimeQuestDescription):Void{
		questInProgress = pQuest;
		Hud.getInstance().hide();
		//UIManager.getInstance().closeCurrentPopin;
		Choice.getInstance().setIntern(Intern.getIntern(pQuest.refIntern));
		GameStage.getInstance().getPopinsContainer().addChild(Choice.getInstance());
	}
	
	public static function goToNextStep():Void{
		Choice.getInstance().hide();
		
		if (Intern.getIntern(questInProgress.refIntern).quest.stepIndex < 2) {		
			if (!Intern.isMaxStress(questInProgress.refIntern)){
				TimeManager.nextStepQuest(questInProgress);
				Intern.getIntern(questInProgress.refIntern).status = Intern.STATE_MAX_STRESS;
				TimeManager.nextStepQuest(questInProgress);				
			}			
			else{
				MaxStressPopin.intern = Intern.getIntern(questInProgress.refIntern);
				UIManager.getInstance().closeCurrentPopin;
				UIManager.getInstance().openPopin(MaxStressPopin.getInstance());
			}
		}	
		else {
			endQuest(questInProgress);
		}
	}	
	/**
	 * Callback of the quest's end event. Destroy the quest and its time Element
	 * @param	pQuest
	 */
	//Todo: enelver le timeElementQuest et tout remplacer par timeQuestDescription
	private static function endQuest(pQuest:TimeQuestDescription):Void{
		trace("end");
		if (DialogueManager.ftueStepMakeAllChoice)
			DialogueManager.endOfaDialogue();
			
		UIManager.getInstance().closeCurrentPopin();
		GatchaPopin.quest = pQuest;
		UIManager.getInstance().openPopin(GatchaPopin.getInstance());
		GameStage.getInstance().getPopinsContainer().addChild(GatchaPopin.getInstance());
		
		for (i in 0...Intern.internsListArray.length){
			if (pQuest.refIntern == Intern.internsListArray[i].id) {
				ServerManager.TimeQuestAction(DbAction.REM, Intern.internsListArray[i].quest);
				Intern.getIntern(pQuest.refIntern).quest = null;
			}
		}
	}
	
	public static function finishQuest(pQuest:TimeQuestDescription):Void {
		if (DialogueManager.ftueStepCloseGatcha)
			DialogueManager.endOfaDialogue();
		ServerManager.ChoicesAction(DbAction.REM, pQuest.refIntern);
		

		if (Intern.isMaxStress(questInProgress.refIntern)){
			MaxStressPopin.quest = pQuest;
			//trace(MaxStressPopin.quest);
			UIManager.getInstance().closeCurrentPopin();
			UIManager.getInstance().openPopin(MaxStressPopin.getInstance());
		}		
		else {
			Intern.getIntern(pQuest.refIntern).status = Intern.STATE_RESTING;
			UIManager.getInstance().closeCurrentPopin();
			InternElementInQuest.canPushNewScreen = true;
			UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		}
		
		destroyQuest(pQuest.refIntern);
	}
	
	/**
	 * Return a specific quest from an Id
	 * @param	pId Id of the required quest
	 * @return	the required quest
	 */
	public static function getQuest(pId:Int):TimeQuestDescription{
		var lQuest:TimeQuestDescription = null; //Todo: obligé d'instancier car sinon impossible de retourner la valeur
		
		for (i in 0...questsList.length){
			if (pId == questsList[i].refIntern){
				lQuest = questsList[i];
			}
		}
		
		return lQuest;
	}
	
	public static function getCursorPosition(pId:Int):Array<Float> {
		var quest:TimeQuestDescription = getQuest(pId); 
		var positions:Array<Float> = new Array<Float>();
		
		var globalLength = quest.end - quest.creation;
		for (i in 0...3) {
			var rLength:Float = quest.steps[i] - quest.creation;
			positions.push((rLength / globalLength));
		}
		
		return positions;
	}
	
	public static function getPrctAvancment(pId:Int):Float {
		var quest:TimeQuestDescription = getQuest(pId);
		var globalLength = quest.end - quest.creation;
		return (quest.progress - quest.creation) / globalLength;
	}
	
	//private static function isMaxStress(pId:Int):Bool{
		//if (Intern.getIntern(pId).stress < Intern.MAX_STRESS) return false;
		//else return true;
	//}
	
	public static function destroyQuest(pQuestId:Int):Void{
		for (i in 0...questsList.length){
			if (questsList[i].refIntern == pQuestId){
				questsList.splice(i, 1);
			}
		}	
	}
	
	public static function destroyAllQuests():Void{
		var lLength:Int = questsList.length;
		for (i in 0...lLength){
			questsList.splice(i, 1);
		}
	}
	
}