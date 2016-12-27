package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.TimeManager;

/**
 * Class creating random quests
 * @author Emeline Berenguier
 */
typedef TimeLine = {
	var eventChoice:Array<Float>;
	var max:Float;
}
	
class Quest
{

	public var idTimer:Int;				//Id of the quest
	private var time:TimeElementQuest;  //Time Element of the quest
	private var end:Float = 0;			//Quest's total length
	
	//The time's gap between two events will be vary between these constants
	private static var MIN_TIMELINE(default, null):Int = 2000;
	private static var MAX_TIMELINE(default, null):Int = 5000;

	public function new(pNumberEvents:Int) 
	{
		idTimer = IdManager.newId();
		//trace(idTimer);
		var lTimeLine:TimeLine = createRandomTimeLine(pNumberEvents);
		
		var lTimeQuestDescription:TimeQuestDescription = {
			refIntern: idTimer,
			progress: 0,
			steps: lTimeLine.eventChoice,
			stepIndex: 0,
			end: lTimeLine.max
		}
		
		QuestsManager.questsList.push(lTimeQuestDescription);
		time = TimeManager.createTimeQuest(lTimeQuestDescription);
	
		SaveManager.save();
	}
	
	/**
	 * Create a random timeLine
	 * @param	pNumberEvents A random number of events
	 * @return  A new timeLine
	 */
	private function createRandomTimeLine(pNumberEvents:Int):TimeLine{
		var lTimeLine:TimeLine = {
			eventChoice:createEventArray(pNumberEvents),
			max: end	
		}
		
		return lTimeLine;
	}
	
	/**
	 * Create an array of random gap values between two events
	 * @param	pLength
	 * @return A new array
	 */
	private function createEventArray(pLength:Int):Array<Float>{
		var lListEvents:Array<Float> = new Array<Float>();
		for (i in 0...pLength){
			lListEvents.push(Math.floor(Math.random() * (MAX_TIMELINE - MIN_TIMELINE + 1)) + MIN_TIMELINE);
			end = end + lListEvents[i];
		}
		
		return lListEvents;
	}
}