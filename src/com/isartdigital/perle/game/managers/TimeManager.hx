package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.ResourcesManager.Generator;
import haxe.Timer;
import eventemitter3.EventEmitter;


/*interface ZTimeBased 
{
	private function onTimeEnd ():Void;
}*/

typedef EventResoucreTick = {
	var generator:Generator;
	var tickNumber:Int;
}

/**
 * infinite repeat
 */
typedef TimeElementResource = {
	var desc:TimeDescription;
	@:optional var generator:Generator;
	// lien direct vers élément, variable en référence, ou Event ?
}


/**
 * Description of the quest
 */
typedef TimeElementQuest = {
	var desc:TimeQuestDescription;
}


/**
 * Control every TimeBased Mechanic (working constantly like a server)
 * @author ambroise rabier
 */
class TimeManager {
	
	public static inline var EVENT_RESOURCE_TICK:String = "TimeManager_Resource_Tick";
	public static inline var EVENT_QUEST_STEP:String = "TimeManager_Quest_Step_Reached";
	public static inline var EVENT_QUEST_END:String = "TimeManager_Resource_End_Reached";
	
	/**
	 * Update all timers and save every TIME_LOOP_DELAY.
	 */
	private static inline var TIME_LOOP_DELAY:Int = 5000;
	
	
	public static var eTimeGenerator:EventEmitter;
	public static var eTimeQuest:EventEmitter;
	
	public static var gameStartTime(default, null):Float;
	public static var lastKnowTime(default, null):Float;
	
	public static var listResource(default, null):Array<TimeElementResource>;
	public static var listQuest(default, null):Array<TimeElementQuest>;
	
	public static function initClass ():Void {
		eTimeGenerator = new EventEmitter();
		eTimeQuest = new EventEmitter();
		listResource = new Array<TimeElementResource>();
		listQuest = new Array<TimeElementQuest>();
	}
	
	public static function buildWhitoutSave ():Void {
		gameStartTime = Date.now().getTime();
		lastKnowTime = gameStartTime;
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:Int = pSave.timesResource.length;
		
		var lQuestArraySaved:Array<TimeQuestDescription> = pSave.timesQuest;
		var lLengthQuest:Int = pSave.timesQuest.length;
		
		trace(lLengthQuest);
		for (i in 0...lLength) {
			listResource.push({
				desc: pSave.timesResource[i]
			});
			
		}
		
		//Not working don't touch!
		
		for (i in 0...lLengthQuest){
			var lQuestDatas:TimeElementQuest = {
			desc: {
				refIntern: lQuestArraySaved[i].refIntern,
				progress: lQuestArraySaved[i].progress,
				steps: lQuestArraySaved[i].steps,
				stepIndex: lQuestArraySaved[i].stepIndex,
				end: lQuestArraySaved[i].end
			},
			};
			
			listQuest.push(lQuestDatas);
			trace("Save Id" + lQuestDatas.desc.refIntern);
		}
		
		lastKnowTime = pSave.lastKnowTime;
	}
	
	/**
	 * Create a new Time Element
	 * @param	pId : the id is the link when building from save
	 * @param	pEnd
	 * @return A new TimeElement
	 */
	public static function createTimeResource (pEnd:Float, pGenerator:Generator):TimeElementResource {

		var lTimeElement:TimeElementResource = {
			desc: {
				refTile:pGenerator.desc.id,
				progress:0,
				end:pEnd
			},
			generator:pGenerator
		};
		listResource.push(lTimeElement);
		return lTimeElement;
	}
	
	/*
	 * get the generator when we load 
	 */
	
	public static function addGenerator(pGenerator:Generator):Void{
		var lTimeElement:TimeElementResource;
		
		for (lTimeElement in listResource)
			if (lTimeElement.desc.refTile == pGenerator.desc.id){
				
				lTimeElement.generator = pGenerator;
				return;
			}
	}
	
	public static function removeTimeResource(pId:Int):Void{
		var lTimeElement:TimeElementResource;
		
		for (lTimeElement in listResource)
			if (lTimeElement.desc.refTile == pId){
				
				listResource.splice(listResource.indexOf(lTimeElement), 1);
				return;
			}
	}
	
	/**
	 * Create a new quest time
	 * @param	pId Id of the quest
	 * @param	pTimeLine Steps and total length of the quest
	 * @param	pQuest Reference to the quest
	 * @return  The specific Time Element for the quest
	 */
	public static function createTimeQuest (pDatasQuest:TimeQuestDescription):TimeElementQuest {
		var lTimeElement:TimeElementQuest = {
			desc: {
				//todo: réfléchir à un desc
				refIntern: pDatasQuest.refIntern,
				progress: pDatasQuest.progress,
				steps: pDatasQuest.steps,
				stepIndex:pDatasQuest.stepIndex,
				end:pDatasQuest.end
			},
		};
		
		listQuest.push(lTimeElement);
		return lTimeElement;
	}
	
	/**
	 * Find the corresponding TimeElement whit an pId
	 * @param	pId
	 * @return	the required TimeElement
	 */
	private static function getTimeElement (pId:Int):TimeElementResource {
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
		var lTime:Timer = Timer.delay(timeLoop, TIME_LOOP_DELAY); // todo : variable locale ? sûr ?
		lTime.run = timeLoop;
	}
	
	/**
	 * When Quest is completed, go to nextStep on the TimeElement, called from outside
	 * @param	pElement
	 */
	public static function nextStepQuest (pElement:TimeElementQuest):Void {
		//trace("progress" + pElement.desc.progress);
		//trace("end" + pElement.desc.end);
		trace("update quest");
		if (pElement.desc.progress == pElement.desc.steps[pElement.desc.stepIndex]) {
			trace("next step");
			pElement.desc.stepIndex++;
			
			if (pElement.desc.stepIndex == pElement.desc.steps.length - 1){
				trace("end step");
				eTimeQuest.emit(EVENT_QUEST_END, pElement);
			}
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
		var lLengthQuest:Int = listQuest.length;
		
		lastKnowTime = lTimeNow;
		SaveManager.saveLastKnowTime(lastKnowTime);
		trace("length quest" + listQuest.length);
		for (i in 0...lLength) {
			updateResource(listResource[i], lElapsedTime);
		}
		
		for (i in 0...lLengthQuest) {
			//trace("length time loop " + lLengthQuest);
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
		var lNumberTick:Int = 0;
		var lFullTime:Float = pElapsedTime + pElement.desc.progress;
		
		// get the number of time you find endTime inside
		lNumberTick = cast((lFullTime - (lFullTime % pElement.desc.end)) / pElement.desc.end, Int);
		// update the progress bar.
		pElement.desc.progress = lFullTime % pElement.desc.end;

		// update resources !
		if (lNumberTick > 0)
			eTimeGenerator.emit(
				EVENT_RESOURCE_TICK,
				{
					generator:pElement.generator,
					tickNumber:lNumberTick
				}
			);
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
			trace("event!");
			eTimeQuest.emit(EVENT_QUEST_STEP, pElement); 
		}
	}
	
	public static function destroyTimeElement (pId:Int):Void {
		var lLength:Int = listResource.length;
		var lLengthQuest:Int = listQuest.length;
		
		for (i in 0...lLength) {
			if (pId == listResource[i].desc.refTile){
				listResource.splice(i, 1);
				break;
			}
		}
		
		for (j in 0...lLengthQuest) {
			if (pId == listQuest[j].desc.refIntern){
				listQuest.splice(j, 1);
				break;
			}
		}
		/*lLength = listConstruction; // va arriver
		for (i in 0...lLength) {
			if (pId == listConstruction[i].desc.refTile){
				listConstruction.splice(i, 1);
				break;
			}
		}*/
	}
	
	
	// destroy TimeElement : à réfléchir. Que sur commande de Vtile ?

	public function new() {
		
	}
	
}