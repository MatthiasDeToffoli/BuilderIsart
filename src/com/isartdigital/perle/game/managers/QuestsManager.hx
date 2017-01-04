package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementQuest;

/**
 * Manager of the quests, listen emits and links actions with others managers
 * @author Emeline Berenguier
 */

class QuestsManager
{
	public static var questsList(default, null):Array<TimeQuestDescription>;
	
	//The time's gap between two events will be vary between these constants
	private static var MIN_TIMELINE(default, null):Int = 2000;
	private static var MAX_TIMELINE(default, null):Int = 5000;
	
	public function new() 
	{
		
	}
	
	//Todo:Not working! Don't touch
	
	public static function initWithoutSave():Void{
		questsList = new Array<TimeQuestDescription>();
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_STEP, choice);
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_END, endQuest);
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
	public static function createQuest(pNumberEvents:Int):TimeQuestDescription{
		var lIdTimer = IdManager.newId();
		var lStepsArray:Array<Float> = createRandomEventArray(pNumberEvents);
		
		var lTimeQuestDescription:TimeQuestDescription = {
			refIntern: lIdTimer,
			progress: 0,
			steps: lStepsArray,
			stepIndex: 0,
			end: createEnd(lStepsArray)
		}
		
		QuestsManager.questsList.push(lTimeQuestDescription);
		TimeManager.createTimeQuest(lTimeQuestDescription);
	
		SaveManager.save();
		
		return lTimeQuestDescription;
	}
	
	/**
	 * Create an array of random gap values between two events
	 * @param	pLength
	 * @return A new array
	 */
	private static function createRandomEventArray(pLength:Int):Array<Float>{
		var lListEvents:Array<Float> = new Array<Float>();
		for (i in 0...pLength){
			lListEvents.push(Math.floor(Math.random() * (MAX_TIMELINE - MIN_TIMELINE + 1)) + MIN_TIMELINE);
		}
		
		return lListEvents;
	}
	
	/**
	 * Create the total length of the quest
	 * @param	pListEvents
	 * @return	the total value
	 */
	private static function createEnd(pListEvents:Array<Float>):Float{
		var lEnd:Float = 0;
		var lLength:Int = pListEvents.length;
		
		for (i in 0...lLength){
			lEnd = lEnd + pListEvents[i];
		}
		
		return lEnd;
	}
	
	/**
	 * Callback of the choice event
	 * @param	pQuest
	 */
	private static function choice(pQuest:TimeElementQuest):Void{
		//Todo: Possibilité ici de faire des interactions avec d'autres managers
		TimeManager.nextStepQuest(pQuest);
	}
	
	/**
	 * Callback of the quest's end event. Destroy the quest and its time Element
	 * @param	pQuest
	 */
	//Todo: enelver le timeElementQuest et tout remplacer par timeQuestDescription
	private static function endQuest(pQuest:TimeElementQuest):Void{
		trace("end");
		trace("pQuest before" + pQuest);
		TimeManager.destroyTimeElement(pQuest.desc.refIntern);
		destroyQuest(pQuest.desc.refIntern);
		trace("pQuest after" + pQuest);
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