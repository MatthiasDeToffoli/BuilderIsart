package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.UIManager;
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
	
	//The time's gap between two events will be vary between these constants
	private static var MIN_TIMELINE(default, null):Int = 20000;
	private static var MAX_TIMELINE(default, null):Int = 30000;
	
	//Reference of the quest in progress
	private static var questInProgress:TimeQuestDescription;
	
	private static var isFinish:Bool = false;
	
	public function new() 
	{
		
	}
	
	//Todo:Not working! Don't touch
	
	public static function initWithoutSave():Void{
		questsList = new Array<TimeQuestDescription>();
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_STEP, choice);
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_END, endQuest);
		//Choice.eChoiceDone.on(Choice.EVENT_CHOICE_DONE, goToNextStep);
	}
	
	public static function initWithSave(pDatasSaved:Save):Void{
		initWithoutSave();
		var lLength:Int = pDatasSaved.timesQuest.length;
		for (i in 0...lLength){
			questsList.push(pDatasSaved.timesQuest[i]);
		}
	}
	
	/**
	 * Creation of the quest
	 * @param	pNumberEvents Number of events contained in a quest
	 * @return	The quest's datas
	 */
	public static function createQuest(pIdIntern:Int):TimeQuestDescription{
		var lIdTimer = pIdIntern;
		var lStepsArray:Array<Int> = createRandomGapArray();
		
		var lTimeQuestDescription:TimeQuestDescription = {
			refIntern: lIdTimer,
			progress: 0,
			steps: lStepsArray,
			stepIndex: 0,
			end: createEnd(lStepsArray)
		}
		
		QuestsManager.questsList.push(lTimeQuestDescription);
	
		SaveManager.save();
		
		return lTimeQuestDescription;
	}
	
	/**
	 * Create an array of random gap values between two events
	 * @param	pLength
	 * @return A new array
	 */
	private static function createRandomGapArray():Array<Int>{
		var lListEvents:Array<Int> = new Array<Int>();
		var lGap:Int = 0;
		
		for (i in 0...NUMBER_EVENTS){
			lGap = Math.floor(Math.random() * (MAX_TIMELINE - MIN_TIMELINE + 1)) + MIN_TIMELINE + lGap;
			lListEvents.push(lGap);
		}
		
		return lListEvents;
	}
	
	/**
	 * Create the total length of the quest
	 * @param	pListEvents
	 * @return	the total value
	 */
	private static function createEnd(pListEvents:Array<Int>):Float{
		var lEnd:Int = 0;
		var lLength:Int = pListEvents.length - 1;
		
		//for (i in 0...lLength){
			//lEnd = lEnd + pListEvents[i];
		//}
		lEnd = pListEvents[lLength];
		
		return lEnd;
	}
	
	/**
	 * Callback of the choice event
	 * @param	pQuest
	 */
	private static function choice(pQuest:TimeQuestDescription):Void{
		//Todo: Possibilité ici de faire des interactions avec d'autres managers
		questInProgress = pQuest;
		Hud.getInstance().hide();
		UIManager.getInstance().closeCurrentPopin;
		GameStage.getInstance().getPopinsContainer().addChild(Choice.getInstance());
	}
	
	public static function goToNextStep():Void{
		Choice.getInstance().hide();
		TimeManager.nextStepQuest(questInProgress);
	}
	
	/**
	 * Callback of the quest's end event. Destroy the quest and its time Element
	 * @param	pQuest
	 */
	//Todo: enelver le timeElementQuest et tout remplacer par timeQuestDescription
	private static function endQuest(pQuest:TimeQuestDescription):Void{
		trace("end");
		//var lRandomEvent:Int = Math.round(Math.random() * 3 + 1);
		choice(pQuest);
		
		TimeManager.destroyTimeElement(pQuest.refIntern);
		destroyQuest(pQuest.refIntern);
		//Si stagiaire pas stressé max
		for (i in 0...Intern.internsList.length){
			if (pQuest.refIntern == Intern.internsList[i].id){
				if (Intern.internsList[i].stress < Intern.internsList[i].stressLimit){
					//Intern.internsList[i].quest = createQuest(lRandomEvent, Intern.internsList[i].id);
					Intern.internsList[i].quest = null;
				}
				
				else trace("dismiss");
			}
		}
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
	
	private static function destroyQuest(pQuestId:Int):Void{
		for (i in 0...questsList.length){
			if (questsList[i].refIntern == pQuestId){
				trace("destroy done");
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