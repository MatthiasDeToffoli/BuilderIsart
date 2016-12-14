package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import haxe.Timer;
import eventemitter3.EventEmitter;


/*interface ZTimeBased 
{
	private function onTimeEnd ():Void;
}*/

/**
 * infinite repeat
 */
typedef TimeElementResource = {
	var desc:TimeDescription;
	var eEndReached:EventEmitter;
	// lien direct vers élément, variable en référence, ou Event ?
}


/**
 * intermediate tick, doesn't repeat, call a method (todo)
 */
typedef TimeElementQuest = {
	var desc:TimeQuestDescription;
	var event:EventEmitter;
}


/**
 * Control every TimeBased Mechanic (working constantly like a server)
 * @author ambroise
 */
class TimeManager {
	
	public static inline var EVENT_RESOURCE_END_REACHED:String = "TimeManager_Resource_End_Reached";
	public static inline var EVENT_QUEST_STEP_REACHED:String = "TimeManager_Quest_Step_Reached";
	public static inline var EVENT_QUEST_END_REACHED:String = "TimeManager_Resource_End_Reached";
	
	/**
	 * Update all timers and save every TIME_LOOP_DELAY.
	 */
	private static inline var TIME_LOOP_DELAY:Int = 10000;
	
	
	
	public static var gameStartTime(default, null):Float;
	public static var lastKnowTime(default, null):Float;
	
	public static var listResource(default, null):Array<TimeElementResource>;
	public static var listQuest(default, null):Array<TimeElementQuest>;
	
	public static function initClass ():Void {
		listResource = new Array<TimeElementResource>();
		listQuest = new Array<TimeElementQuest>();
	}
	
	public static function buildWhitoutSave ():Void {
		gameStartTime = Date.now().getTime();
		lastKnowTime = gameStartTime;
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:Int = pSave.timesResource.length;
		for (i in 0...lLength) {
			listResource.push({
				desc: pSave.timesResource[i],
				eEndReached: new EventEmitter()
			});
			
		}
		
		lLength = pSave.timesQuest.length;
		for (i in 0...lLength) {
			listQuest.push({
				desc: pSave.timesQuest[i],
				event: new EventEmitter()
			});
		}
		
		lastKnowTime = pSave.lastKnowTime;
	}
	
	/**
	 * Create a new Time Element
	 * @param	pId : the id is the link when building from save
	 * @param	pEnd
	 * @return A new TimeElement
	 */
	public static function createResource (pId:Int, pEnd:Float):TimeElementResource {
		var lTimeElement:TimeElementResource = {
			desc: {
				refTile:pId,
				progress:0,
				end:pEnd
			},
			eEndReached: new EventEmitter(),
		};
		listResource.push(lTimeElement);
		return lTimeElement;
	}
	
	public static function createQuest (pId:Int, pSteps:Array<Float>, pEnd:Float):TimeElementQuest {
		var lTimeElement:TimeElementQuest = {
			desc: {
				refIntern:pId,
				progress:0,
				steps:pSteps,
				stepIndex:0,
				end:pEnd
			},
			event: new EventEmitter()
		};
		listQuest.push(lTimeElement);
		return lTimeElement;
	}
	
	/**
	 * Find the corresponding TimeElement whit an pId
	 * @param	pId
	 * @return
	 */
	public static function getTimeElement (pId:Int):TimeElementResource {
		var lLength:Int = listResource.length;
		
		for (i in 0...lLength) {
			if (pId == listResource[i].desc.refTile)
				return listResource[i];
		}
		
		return null;
	}
	
	/**
	 * Time is running !
	 * Call this function at the end of loading.
	 */
	public static function startTimeLoop ():Void {
		// important call timeLoop() : or the user could be cheating
		// if he build something in less
		// then TIME_LOOP_DELAY
		// because timeElapsed would be like 4 hours
		// the most bonus he can have here is TIME_LOOP_DELAY !
		// todo : i may change that ;)
		// specially if you think about connexion problem.
		// todo, i think that's important !
		//timeLoop();  // non car il veut save du coup, mais save pas encore créer si whitoutSave
		var lTime:Timer = Timer.delay(timeLoop, TIME_LOOP_DELAY);
		lTime.run = timeLoop;
	}
	
	/**
	 * When Quest is completed, go to nextStep on the TimeElement
	 * @param	pElement
	 */
	public static function nextStepQuest (pElement:TimeElementQuest):Void {
		if (pElement.desc.progress == pElement.desc.end) {
			pElement.desc.stepIndex++;
			
			if (pElement.desc.stepIndex == pElement.desc.steps.length - 1)
				pElement.event.emit(EVENT_QUEST_END_REACHED);
		}
		else
			trace("nextStepQuest not ready yet !");
	}
	
	private static function getElapsedTime (pLastKnowTime:Float, pTimeNow:Float):Float {
		return pTimeNow - pLastKnowTime;
	}
	
	private static function timeLoop ():Void {
		var lTimeNow:Float = Date.now().getTime();
		var lElapsedTime:Float = getElapsedTime(lastKnowTime, lTimeNow); // todo: moche ?
		var lLength:Int = listResource.length;
		
		lastKnowTime = lTimeNow;
		SaveManager.saveLastKnowTime(lastKnowTime);
		
		for (i in 0...lLength) {
			updateResource(listResource[i], lElapsedTime);
		}
		
		lLength = listQuest.length;
		for (i in 0...lLength) {
			updateQuest(listQuest[i], lElapsedTime);
		}
		
	}
	
	/**
	 * Add Elapsed time to TimeElementResource
	 * Emit an event whit the number of time it reached the end.
	 * @param	pElement
	 * @param	pElapsedTime
	 */
	private static function updateResource (pElement:TimeElementResource, pElapsedTime:Float):Void {
		var lNumberReached:Int = 0;
		var lFullTime:Float = pElapsedTime + pElement.desc.progress;
		
		// get the number of time you find endTime inside
		lNumberReached = cast((lFullTime - (lFullTime % pElement.desc.end)) / pElement.desc.end, Int);
		// update the progress bar.
		pElement.desc.progress = lFullTime % pElement.desc.end;
		
		
		// update resources !
		if (lNumberReached > 0)
			pElement.eEndReached.emit(EVENT_RESOURCE_END_REACHED, lNumberReached);
	}
	
	/**
	 * Stop at step until the player do the quest and go to the next step.
	 * @param	pElement
	 * @param	pElapsedTime
	 */
	private static function updateQuest (pElement:TimeElementQuest, pElapsedTime:Float):Void {
		var lPreviousProgress:Float = pElement.desc.progress;
		
		pElement.desc.progress = Math.min(
			pElement.desc.progress + pElapsedTime,
			pElement.desc.steps[pElement.desc.stepIndex]
		);
		
		// progress has reached next step && just now
		if (pElement.desc.progress == pElement.desc.steps[pElement.desc.stepIndex] &&
			pElement.desc.progress != lPreviousProgress) 
		{
			// todo: éventuellement des paramètres à rajouter.
			pElement.event.emit(EVENT_QUEST_STEP_REACHED); 
		}
	}
	
	
	
	// destroy TimeElement : à réfléchir. Que sur commande de Vtile ?

	public function new() {
		
	}
	
}