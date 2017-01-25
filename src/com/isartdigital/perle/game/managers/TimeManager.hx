package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.MarketingManager.CampaignType;
import com.isartdigital.perle.game.managers.ResourcesManager.Generator;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeCollectorProduction;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector.ProductionPack;
import com.isartdigital.perle.ui.hud.Hud;
import eventemitter3.EventEmitter;
import haxe.Timer;


/*interface ZTimeBased 
{
	private function onTimeEnd ():Void;
}*/

typedef EventResoucreTick = {
	var generator:Generator;
	var tickNumber:Int;
}


typedef TimeElementResource = {
	var desc:TimeDescription;
	@:optional var generator:Generator;
	// lien direct vers élément, variable en référence, ou Event ?
}


/**
 * Description of the quest
 */
//typedef TimeElementQuest = {
	//var desc:TimeQuestDescription;
//}


/**
 * Control every TimeBased Mechanic (working constantly like a server)
 * @author Vicktor Grenu et ambroise rabier
 */
class TimeManager {
	
	public static inline var EVENT_RESOURCE_TICK:String = "TimeManager_Resource_Tick";
	public static inline var EVENT_QUEST_STEP:String = "TimeManager_Quest_Step_Reached";
	public static inline var EVENT_QUEST_END:String = "TimeManager_Resource_End_Reached";
	public static inline var EVENT_CONSTRUCT_END:String = "TimeManager_Construction_End";
	public static inline var EVENT_COLLECTOR_PRODUCTION:String = "Production_Time";
	public static inline var EVENT_COLLECTOR_PRODUCTION_FINE:String = "Production_Fine";
	public static inline var EVENT_COLLECTOR_PRODUCTION_STOP:String = "Production_STOP";
	public static inline var EVENT_CAMPAIGN:String = "Campaign";
	public static inline var EVENT_CAMPAIGN_FINE:String = "Campaign fine";
	
	public static inline var TIME_DESC_REFLECT:String = "timeDesc";
	
	/**
	 * Update all timers and save every TIME_LOOP_DELAY.
	 */
	private static inline var TIME_LOOP_DELAY:Int = 50;
	
	public static var eTimeGenerator:EventEmitter;
	public static var eTimeQuest:EventEmitter;
	public static var eConstruct:EventEmitter;
	public static var eProduction:EventEmitter;
	public static var eCampaign:EventEmitter;
	
	public static var gameStartTime(default, null):Float;
	public static var lastKnowTime(default, null):Float;
	
	public static var listResource(default, null):Array<TimeElementResource>;
	public static var listQuest(default, null):Array<TimeQuestDescription>;
	public static var listConstruction(default, null):Array<TimeDescription>;
	public static var listProduction(default, null):Array < TimeCollectorProduction>;
	public static var campaignTime(default, null):Float;
	
	public static function initClass ():Void {
		eTimeGenerator = new EventEmitter();
		eTimeQuest = new EventEmitter();
		eConstruct = new EventEmitter();
		eProduction = new EventEmitter();
		eCampaign = new EventEmitter();
		listResource = new Array<TimeElementResource>();
		listQuest = new Array<TimeQuestDescription>();
		listConstruction = new Array<TimeDescription>();
		listProduction = new Array<TimeCollectorProduction>();
		campaignTime = 0;
	}
	
	public static function buildWhitoutSave ():Void {
		gameStartTime = Date.now().getTime();
		lastKnowTime = gameStartTime;
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:Int = pSave.timesResource.length;
		
		var lQuestArraySaved:Array<TimeQuestDescription> = pSave.timesQuest;
		var lConstructionArraySaved:Array<TimeDescription> = pSave.timesConstruction;
		var lLengthConstruction:Int = pSave.timesConstruction.length;
		var lLengthQuest:Int = pSave.timesQuest.length;
		
		//trace(lLengthQuest);
		for (i in 0...lLength) {
			listResource.push({
				desc: pSave.timesResource[i]
			});
		}
		
		//Not working don't touch!
		for (i in 0...lLengthQuest){
			var lQuestDatas:TimeQuestDescription = {
				refIntern: lQuestArraySaved[i].refIntern,
				progress: lQuestArraySaved[i].progress,
				steps: lQuestArraySaved[i].steps,
				stepIndex: lQuestArraySaved[i].stepIndex,
				end: lQuestArraySaved[i].end
			};
			
			listQuest.push(lQuestDatas);
		}
		
		lastKnowTime = pSave.lastKnowTime;
	}
	
	public static function setCampaignTime(pTime:Float):Void {
		campaignTime = pTime;
	}
	
	private static function updateCampaignTime(ElapsedTime:Float):Void {
		campaignTime = Math.max(campaignTime - ElapsedTime, 0);
		
		if (campaignTime == 0){
			MarketingManager.setCampaign(CampaignType.none);
			eCampaign.emit(EVENT_CAMPAIGN_FINE);
		} else {
			eCampaign.emit(EVENT_CAMPAIGN, campaignTime);
		}
		
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
	
	/**
	 * update the time speed
	 * @param	pEnd the new time for increase resources
	 * @param	pGenerator the generator link to the timeManager
	 */
	public static function updateTimeResource(pEnd:Float, pGenerator:Generator):Void{
		var lTimeElement:TimeElementResource;
		
		for (lTimeElement in listResource)
			if (lTimeElement.generator == pGenerator)
				lTimeElement.desc.end = pEnd;
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
	
	public static function  createProductionTime(pack:ProductionPack, ref:Int):TimeCollectorProduction{
		var myTime:TimeCollectorProduction = {
			buildingRef: ref,
			gain: pack.quantity,
			progress: pack.time
		}
		
		listProduction.push(myTime);
		
		return myTime;
	}
	
	public static function addConstructionTimer(pBuildingTimer:TimeDescription):Void {
		var dateNow:Float = Date.now().getTime();		
		if (dateNow >= pBuildingTimer.end) return;	
		
		pBuildingTimer.progress = dateNow - pBuildingTimer.creationDate;		
		listConstruction.push(pBuildingTimer);
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
	public static function createTimeQuest (pDatasQuest:TimeQuestDescription):TimeQuestDescription { // todo : un peu inutile comme function ?
		var lTimeElement:TimeQuestDescription = pDatasQuest;
		
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
	 * Find the corresponding construction time description whit an pId
	 * @param	pId
	 * @return	the required TimeDescription
	 */
	public static function getTimeDescription (pid:Int):TimeDescription {
		var llength:Int = listConstruction.length;
		
		for (i in 0...llength) 
		{
			if (pid == listConstruction[i].refTile)
				return listConstruction[i];
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
	public static function nextStepQuest (pElement:TimeQuestDescription):Void {
		//trace("progress" + pElement.desc.progress);
		//trace("end" + pElement.desc.end);
		if (pElement.progress == pElement.steps[pElement.stepIndex]) {
			
			if (pElement.stepIndex == pElement.steps.length - 1){
				eTimeQuest.emit(EVENT_QUEST_END, pElement);
			}
			
			pElement.stepIndex++;
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
		var lLengthConstruct:Int = listConstruction.length;
		var lLenghtProd:Int = listProduction.length;
		var constructionEnded:Array<Int> = new Array<Int>();
		
		lastKnowTime = lTimeNow;
		SaveManager.saveLastKnowTime(lastKnowTime);
		//trace("length quest" + listQuest.length);
		
		if (campaignTime > 0) updateCampaignTime(lElapsedTime);
		
		for (i in 0...lLength) {
			updateResource(listResource[i], lElapsedTime);
		}
		
		for (j in 0...lLengthQuest) {
			//trace("length time loop " + lLengthQuest);
			updateQuest(listQuest[j], lElapsedTime);
		}
		
		for ( i in 0...lLenghtProd)
			updateProductionTime(listProduction[i], lElapsedTime);
		
		for (i in 0...lLengthConstruct) {
			updateConstruction(listConstruction[i], lElapsedTime, constructionEnded);
		}		
		deleteEndedConstruction(constructionEnded);
	}
	
	private static function deleteEndedConstruction(pEndedList:Array<Int>):Void {
		var lLength:Int = pEndedList.length;	
		for (i in 0...lLength) { listConstruction.splice(pEndedList[i], 1); }
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
	private static function updateQuest (pElement:TimeQuestDescription, pElapsedTime:Float):Void {
		var lPreviousProgress:Float = pElement.progress;
		//trace(Intern.internsList[pElement.refIntern]);
		
		pElement.progress = Math.min(
			pElement.progress + (pElapsedTime * Intern.internsList[pElement.refIntern].speed),
			//pElement.progress + pElapsedTime,
			pElement.steps[pElement.stepIndex]
		);
		
		// progress has reached next step && just now
		if (pElement.progress == pElement.steps[pElement.stepIndex] &&
			pElement.progress != lPreviousProgress) 
		{
			// todo: éventuellement des paramètres à rajouter.
			eTimeQuest.emit(EVENT_QUEST_STEP, pElement); 
		}
	}
	
	/**
	 * Stop at step until the player do the quest and go to the next step.
	 * @param	pElement
	 * @param	pElapsedTime
	 * @param	pIndex
	 */
	private static function updateConstruction(pElement:TimeDescription, pElapsedTime:Float, pEndedList:Array<Int>):Void {
		pElement.progress += pElapsedTime;
		var diff:Float = pElement.end - pElement.creationDate;
		trace("update : id => " + pElement.refTile);
		
		if (pElement.progress >= diff) {
			trace("construction : id => " + pElement.refTile + " terminée");
			var index:Int = listConstruction.indexOf(pElement);
			eConstruct.emit(EVENT_CONSTRUCT_END, pElement);
			pEndedList.push(index);
		}
	}
	
	private static function updateProductionTime(pElement:TimeCollectorProduction, pEllapsedTime:Float):Void {
		pElement.progress -= pEllapsedTime;
		if (pElement.progress < 0){
			pElement.progress = 0;
			eProduction.emit(EVENT_COLLECTOR_PRODUCTION_FINE,pElement);
		}
		eProduction.emit(EVENT_COLLECTOR_PRODUCTION, pElement);
	}
	
	public static function removeProductionTIme(ref:Int){
	 	var i:Int, l:Int = listProduction.length;
		
		for (i in 0...l)
			if (listProduction[i].buildingRef == ref) {
				listProduction.splice(i, 1);
				eProduction.emit(EVENT_COLLECTOR_PRODUCTION_STOP, ref);
			}
	}
	
	public static function getBuildingStateFromTime(pTileDesc:TileDescription):VBuildingState {
		if (Reflect.hasField(pTileDesc, TIME_DESC_REFLECT)) {
			var diff:Float = pTileDesc.timeDesc.end - pTileDesc.timeDesc.creationDate;
			if (pTileDesc.timeDesc.progress >= diff) return VBuildingState.isBuilt;
			else return VBuildingState.isBuilding;
		}
		return VBuildingState.isBuilt;	
	}
	
	public static function getTextTime(pTileDesc:TileDescription):String {		
		var lLengthConstruct:Int = listConstruction.length;
		
		for (i in 0...lLengthConstruct) {
			if (listConstruction[i].refTile == pTileDesc.id) {
				var txtLength:Int = Date.fromTime(listConstruction[i].progress).toString().length;
				var totalTimer:Float = listConstruction[i].end - listConstruction[i].creationDate;
				var diff:Float = totalTimer - listConstruction[i].progress;
				return Date.fromTime(diff).toString().substr(txtLength - 5, 5);
			}
		}	
		return "Finish";
	}
	
	public static function getTextTimeQuest(pTime:Float):String {
		var txtLength:Int = Date.fromTime(pTime).toString().length;
		return Date.fromTime(pTime).toString().substr(txtLength - 5, 5);
	}
	
	public static function increaseProgress(pVBuilding:VBuilding, pBoostValue:Float):Bool {
		var lLengthConstruct:Int = listConstruction.length;
		
		for (i in 0...lLengthConstruct) {
			if (listConstruction[i].refTile == pVBuilding.tileDesc.id) {
				listConstruction[i].progress += pBoostValue;
				break;
			}
		}	
		
		var state:VBuildingState = getBuildingStateFromTime(pVBuilding.tileDesc);
		if (state == VBuildingState.isBuilt) return true;
		return false;
	}
	
	public static function increaseQuestProgress(pQuest:TimeQuestDescription):Bool{
		//if(pQuest.progress != pQuest.end)
		if (pQuest.stepIndex < 3){
			//pQuest.stepIndex++;
			pQuest.progress = pQuest.steps[pQuest.stepIndex];
			QuestsManager.choice(pQuest);
			return true;
		}
		
		else return false;
	}
	
	public static function getPourcentage(pTimeDesc:TimeDescription):Float {
		var total = pTimeDesc.end - pTimeDesc.creationDate;
		return pTimeDesc.progress / total;
	}
	
	public static function destroyTimeElement (pId:Int):Void {
		var lLength:Int = listResource.length;
		var lLengthQuest:Int = listQuest.length;
		var lLengthConstruction:Int = listConstruction.length;
		
		for (i in 0...lLength) {
			if (pId == listResource[i].desc.refTile){
				listResource.splice(i, 1);
				break;
			}
		}
		
		for (i in 0...lLengthQuest) {
			if (pId == listQuest[i].refIntern){
				listQuest.splice(i, 1);
				break;
			}
		}
		
		for (i in 0...lLengthConstruction) {
			if (pId == listConstruction[i].refTile) {
				listConstruction.splice(i, 1);
				break;
			}
		}
	}
	
	
	// destroy TimeElement : à réfléchir. Que sur commande de Vtile ?

	public function new() {
		
	}
	
}