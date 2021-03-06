package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.server.IdManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManagerBuilding;
import com.isartdigital.perle.game.managers.server.ServerManagerQuest;
import com.isartdigital.perle.game.managers.server.ServerManagerSpecial;
import com.isartdigital.utils.Debug;
import js.Lib;

import com.isartdigital.perle.game.managers.MarketingManager.CampaignType;
import com.isartdigital.perle.game.managers.ResourcesManager.Generator;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector.ProductionPack;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.popin.listIntern.InternElementInQuest;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselInterns;
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
	public static inline var EVENT_CHOICE_DONE:String = "TimeManager_Choice_Done";
	public static inline var EVENT_QUEST_STEP:String = "TimeManager_Quest_Step_Reached";
	public static inline var EVENT_QUEST_END:String = "TimeManager_Resource_End_Reached";
	public static inline var EVENT_CONSTRUCT_END:String = "TimeManager_Construction_End";
	public static inline var EVENT_COLLECTOR_PRODUCTION:String = "Production_Time";
	public static inline var EVENT_COLLECTOR_PRODUCTION_FINE:String = "Production_Fine";
	public static inline var EVENT_COLLECTOR_PRODUCTION_STOP:String = "Production_STOP";
	public static inline var EVENT_CAMPAIGN:String = "Campaign";
	public static inline var EVENT_CAMPAIGN_FINE:String = "Campaign fine";
	
	public static inline var TIME_DESC_REFLECT:String = "timeDesc";
	public static inline var TIME_DESC_REFLECT_BOOST:String = "timeBoost";
	
	/**
	 * Update all timers and save every TIME_LOOP_DELAY.
	 */
	private static inline var TIME_LOOP_DELAY:Int = 5 * TimesInfo.SEC;
	private static inline var TIME_LOOP_DELAY_PROGRESSION:Int = 50;
	private static inline var TIME_LOOP_SYNCHRO = TimesInfo.MIN + 30*TimesInfo.SEC; //call every 1:30 minutes
	
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
	public static var listProduction(default, null):Array <TimeDescription>;
	public static var campaignTime(default, null):Float;
	
	public static var timeLinkToVBuilding:Map<Int, VBuilding>;
	
	public static function initClass ():Void {
		eTimeGenerator = new EventEmitter();
		eTimeQuest = new EventEmitter();
		eConstruct = new EventEmitter();
		eProduction = new EventEmitter();
		eCampaign = new EventEmitter();
		listResource = new Array<TimeElementResource>();
		listQuest = new Array<TimeQuestDescription>();
		listConstruction = new Array<TimeDescription>();
		listProduction = new Array<TimeDescription>();
		timeLinkToVBuilding = new Map<Int, VBuilding>();
		campaignTime = 0;
	}
	
	public static function buildWhitoutSave ():Void {
		gameStartTime = Date.now().getTime();
		lastKnowTime = gameStartTime;
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:Int = pSave.timesResource.length;
		
		listProduction = pSave.timesProduction; // server save used now, delete if work
		campaignTime = pSave.timesCampaign.end;

		MarketingManager.setCurrentCampaign(pSave.timesCampaign.type);
		var lLengthConstruction:Int = pSave.timesConstruction.length;
		
		for (i in 0...lLength) {
			listResource.push({
				desc: pSave.timesResource[i]
			});
		}
	
		lastKnowTime = pSave.lastKnowTime;
	}
	
	public static function setCampaignTime(pTime:Float):Void {
		campaignTime = Date.now().getTime() + pTime;
	}
	
	public static function synchroCampaignTime(pTime:Float):Void {
		campaignTime = pTime;
	}
	
	private static function updateCampaignTime():Void {
		if (Date.now().getTime() >= campaignTime){
			MarketingManager.setCampaign(CampaignType.none);
			eCampaign.emit(EVENT_CAMPAIGN_FINE);
			campaignTime = 0;
			SaveManager.save();
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
				creationDate:Date.now().getTime(),
				refTile:pGenerator.desc.id,
				progress:Date.now().getTime(),
				end:pEnd == null ? pEnd : Date.now().getTime() + Date.fromTime(pEnd).getTime()
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
	public static function updateTimeResource(pEnd:Float, pId:Int,isFullTime:Bool):Void{
		var lTimeElement:TimeElementResource;

		for (lTimeElement in listResource)
			if (lTimeElement.generator.desc.id == pId){
				if (isFullTime || pEnd == null) lTimeElement.desc.end = pEnd;
				else lTimeElement.desc.end += pEnd;
			}
				
			
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
	
	public static function  createProductionTime(pack:ProductionPack, ref:Int):TimeDescription{
		var lDate:Date = Date.fromTime(Date.now().getTime() + Date.fromTime(pack.time.times).getTime());
		
		var lDesc:TimeDescription = {
			refTile: ref,
			progress: Date.now().getTime(),
			end: new Date(lDate.getFullYear(), lDate.getMonth(), Date.now().getDate() + pack.time.days, lDate.getHours(), lDate.getMinutes(), lDate.getSeconds()).getTime() ,
			creationDate: Date.now().getTime(),
			gain: pack.quantity,
			packId : pack.idDataBase
		}

		listProduction.push(lDesc);
		
		return lDesc;
	}
	
	public static function synchroProductionTime(pId:Int, pEnd:Float):Void {
		var lProduction:TimeDescription;
		
		for (lProduction in listProduction) {
			if (lProduction.refTile == pId) {
				lProduction.end = pEnd;
			}
		}
	}
	
	public static function addConstructionTimer(pBuildingTimer:TimeDescription, pBuild:VBuilding):Void {
		var dateNow:Float = Date.now().getTime();
		if (dateNow >= pBuildingTimer.end) return;
		
		timeLinkToVBuilding.set(pBuildingTimer.refTile, pBuild);
		
		pBuildingTimer.progress = dateNow - pBuildingTimer.creationDate;
		//ServerManager.ContructionTimeAction(pBuildingTimer, DbAction.ADD);
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
		
		timeLoopSynchro(); //synchro one time before game started.
		
		var lTime:Timer = Timer.delay(timeLoop, TIME_LOOP_DELAY); // todo : variable locale ? sûr ?
		lTime.run = timeLoop;
		
		var loopProgression:Timer = Timer.delay(timeLoopProgression, TIME_LOOP_DELAY_PROGRESSION);
		loopProgression.run = timeLoopProgression;
		
		var loopSynchro:Timer = Timer.delay(timeLoopSynchro, TIME_LOOP_SYNCHRO);
		loopSynchro.run = timeLoopSynchro;
	}
	
	private static function timeLoopSynchro():Void {
		var lTime:TimeElementResource;
		
		for (lTime in listResource){
			if (lTime.desc.end != null) {
				var currentVBuilding:VBuilding = IdManager.searchVBuildingById(lTime.desc.refTile);
				if (currentVBuilding != null) //I let this code for more secure but normaly it's not necessary
				ServerManagerBuilding.updateGenerator(currentVBuilding.tileDesc);
			}
		}
	}
	
	public static function timeLoopProgression():Void {
		var lTimeNow:Float = Date.now().getTime();
		var constructionEnded:Array<Int> = new Array<Int>();
		var timeQuestEnded:Array<Int> = new Array<Int>();
		var lLengthQuest:Int = listQuest.length;
		var lLengthConstruct:Int = listConstruction.length;
		var lLengthProd:Int = listProduction.length;
		var lElapsedTime:Float = getElapsedTime(lastKnowTime, lTimeNow);
		
		lastKnowTime = lTimeNow;
		
		if (campaignTime > 0) updateCampaignTime();
		
		for ( i in 0...lLengthProd)
			updateProductionTime(listProduction[i]);
			
		if (ServerManagerSpecial.specialFeatureLoadState == SpeLoadState.complete) {
			for (j in 0...lLengthQuest) {
				updateQuest(listQuest[j], lElapsedTime, timeQuestEnded);
			}
			deleteEndedQuest(timeQuestEnded);
		}
		
		for (i in 0...lLengthConstruct) {
			updateConstruction(listConstruction[i], constructionEnded);
		}		
		if (constructionEnded.length > 0) deleteEndedConstruction(constructionEnded);
		
		ChoiceManager.refreshChoices();
	}
	
	/**
	 * When Quest is completed, go to nextStep on the TimeElement, called from outside
	 * @param	pElement
	 */
	public static function nextStepQuest (pElement:TimeQuestDescription):Void {
		if (!Intern.isMaxStress(pElement.refIntern)) {
			pElement.stepIndex++;
			pElement.startTime = Date.now().getTime();
			pElement.progress = Date.now().getTime();
			Intern.getIntern(pElement.refIntern).status = Intern.STATE_RESTING;
			TimeManager.createTimeQuest(pElement);
			ServerManagerQuest.execute(DbAction.UPDT, pElement, 0);
			eTimeQuest.emit(EVENT_CHOICE_DONE, pElement);
		}
	}
	
	private static function getElapsedTime (pLastKnowTime:Float, pTimeNow:Float):Float {
		return pTimeNow - pLastKnowTime;
	}
	
	private static function timeLoop ():Void {
		var lLength:Int = listResource.length;
		
		for (i in 0...lLength) {
			updateResource(listResource[i]);
		}
		
		SaveManager.save();
	}
	
	private static function deleteEndedConstruction(pEndedList:Array<Int>):Void {
		var lLength:Int = pEndedList.length;	
		var nbSup:Int = 0;
		
		for (i in 0...lLength) {
			timeLinkToVBuilding[listConstruction.splice(pEndedList[i], 1)[0].refTile]; 
			nbSup++;
		}
		
		if (nbSup > 0) SaveManager.save();
	}
	
	private static function deleteEndedQuest(pEndedList:Array<Int>):Void {
		var lLength:Int = pEndedList.length;	
		for (i in 0...lLength) { listQuest.splice(pEndedList[i], 1); }
	}
	
	/**
	 * Add Elapsed time to TimeElementResource
	 * Emit an event whit the number of time it reached the end.
	 * @param	pElement
	 * @param	pElapsedTime
	 */
	private static function updateResource (pElement:TimeElementResource):Void {
		if (pElement.desc.end == null) return;
	
		// update resources !
		if (Date.now().getTime() > pElement.desc.end) {
			
			var currentVBuilding:VBuilding = IdManager.searchVBuildingById(pElement.desc.refTile);
			if (currentVBuilding == null) return; //@Ambroise : id 0 create and don't exist in game ? Oo
			
			eTimeGenerator.emit(
		
				EVENT_RESOURCE_TICK,
				{
					generator:pElement.generator,
					tickNumber:1
				}
			);
			
			
			var timeCalculed:Float = currentVBuilding.getTimeCalcul();
			if(timeCalculed != null)
				pElement.desc.end += currentVBuilding.getTimeCalcul();
			else pElement.desc.end = null;
		}
			
			
	}
	
	/**
	 * Stop at step until the player do the quest and go to the next step.
	 * @param	pElement
	 * @param	pElapsedTime
	 */
	private static function updateQuest (pElement:TimeQuestDescription, pElapsedTime:Float, ?pEndedList:Array<Int> = null):Void {	
		if (pElement.progress < pElement.steps[pElement.stepIndex] + pElement.startTime) {
			pElement.progress = Date.now().getTime();
		}
		
		// progress has reached next step && just now
		if (!Intern.isIntravel(Intern.getIntern(pElement.refIntern))) 
		{		
			if (Intern.getIntern(pElement.refIntern).stress < 100) {
				Intern.getIntern(pElement.refIntern).status = Intern.STATE_WAITING;
				eTimeQuest.emit(EVENT_QUEST_STEP, pElement);
				if (pElement.progress >= pElement.startTime + pElement.steps[pElement.stepIndex]) eTimeQuest.emit(EVENT_QUEST_END, pElement);
			}
			else {
				Intern.getIntern(pElement.refIntern).status = Intern.STATE_MAX_STRESS;
				eTimeQuest.emit(EVENT_QUEST_STEP, pElement);
			}
			
			var index:Int = listQuest.indexOf(pElement);
			pEndedList.push(index);
		}
	}
	
	/**
	 * Stop at step until the player do the quest and go to the next step.
	 * @param	pElement
	 * @param	pElapsedTime
	 * @param	pIndex
	 */
	private static function updateConstruction(pElement:TimeDescription, ?pEndedList:Array<Int>=null, ?forceEnd:Bool = false):Void {
		if (!forceEnd) pElement.progress = Date.now().getTime();
		else pElement.progress = pElement.end;
		
		if (pElement.progress >= pElement.end) {
			trace("construction : id => " + pElement.refTile + " terminée");
			var index:Int = listConstruction.indexOf(pElement);
			eConstruct.emit(EVENT_CONSTRUCT_END, pElement);
			pEndedList.push(index);
		}		
	}
	
	private static function updateProductionTime(pElement:TimeDescription):Void {
		pElement.progress = Date.now().getTime();
		if (pElement.progress > pElement.end){
			pElement.progress = pElement.end;
			eProduction.emit(EVENT_COLLECTOR_PRODUCTION_FINE,pElement);
		}
		eProduction.emit(EVENT_COLLECTOR_PRODUCTION, pElement);
	}
	
	public static function getProductionPackId(pRef:Int):Int {
		var lProd:TimeDescription;
		
		for (lProd in listProduction)
			if (lProd.refTile == pRef)
				return lProd.packId;
				
		return null;
	}
	
	public static function setProductionFine(pRef:Int):Void {
		var lProd:TimeDescription;
		
		for (lProd in listProduction)
			if (lProd.refTile == pRef)
				lProd.end = Date.now().getTime();
				
		SaveManager.save();
	}
	
	public static function removeProductionTIme(ref:Int){
	 	var i:Int, l:Int = listProduction.length;
		
		for (i in 0...l)
			if (listProduction[i].refTile == ref) {
				listProduction.splice(i, 1);
				eProduction.emit(EVENT_COLLECTOR_PRODUCTION_STOP, ref);
			}
			
		SaveManager.save();
	}
	
	//public static function updateGauges(pElapsedTime:Float):Void{
		//trace("here");
		//ShopCarousselInterns.startTime += pElapsedTime;
	//}
	
	/**
	 * Get actual state of construction time
	 * @param	pTileDesc
	 * @return
	 */
	public static function getBuildingStateFromTime(pTileDesc:TileDescription):VBuildingState {
		if (Reflect.hasField(pTileDesc, TIME_DESC_REFLECT)) {
			if (pTileDesc.timeDesc.progress >= pTileDesc.timeDesc.end) return VBuildingState.isBuilt;
			else if (!pTileDesc.isBuilt) return VBuildingState.isBuilding;
			else return VBuildingState.isUpgrading;
		}
		return VBuildingState.isBuilt;	
	}
	
	public static function getTextTime(pTileDesc:TileDescription):String {		
		var lLengthConstruct:Int = listConstruction.length;
		
		for (i in 0...lLengthConstruct) {
			if (listConstruction[i].refTile == pTileDesc.id) {
				var creationDate:Float = listConstruction[i].end - Date.fromString(GameConfig.getBuildingByName(pTileDesc.buildingName, pTileDesc.level).constructionTime).getTime();
				var totalTimer:Float = listConstruction[i].end - creationDate;
				var diff:Float = totalTimer - (listConstruction[i].progress - creationDate);
				return Date.fromTime(diff).toString().substr(Date.fromTime(diff).toString().length - 5, 5);
			}
		}	
		return "Finish";
	}
	
	
	/**
	 * Get time with quest format
	 * @param	pTime
	 * @return
	 */
	public static function getTextTimeQuest(pTime:Float):String {
		var txtLength:Int = Date.fromTime(pTime).toString().length;
		return Date.fromTime(pTime).toString().substr(txtLength - 8, 8);
	}
	
	/**
	 * Get time with the reroll format
	 * @param	pTime
	 * @return
	 */
	public static function getTextTimeReroll(pTime:Float):String {
		var txtLength:Int = Date.fromTime(pTime).toString().length;
		return Date.fromTime(pTime).toString().substr(txtLength - 5, 5);
	}
	
	/**
	 * Decrease a construction time
	 * @param	pVBuilding
	 * @param	pBoostValue
	 * @return
	 */
	public static function increaseConstruction(pVBuilding:VBuilding):Bool {
		var lLengthConstruct:Int = listConstruction.length;
		var constructionEnded:Array<Int> = new Array<Int>();
		
		for (i in 0...lLengthConstruct) {
			if (listConstruction[i].refTile == pVBuilding.tileDesc.id) {
				updateConstruction(listConstruction[i], constructionEnded, true);
				break;
			}
		}	
		if (constructionEnded.length > 0) deleteEndedConstruction(constructionEnded);
		
		var state:VBuildingState = getBuildingStateFromTime(pVBuilding.tileDesc);
		if (state == VBuildingState.isBuilt) return true;
		return false;
		
		SaveManager.save();
	}
	
	/**
	 * Increase the quest's progress
	 * @param	pQuest
	 * @return  possibility to continue the progress or not
	 */
	public static function increaseQuestProgress(pQuest:TimeQuestDescription):Bool{
		for (i in 0...listQuest.length) {
			if (listQuest[i].refIntern == pQuest.refIntern) {
				pQuest.progress = pQuest.steps[pQuest.stepIndex] + pQuest.startTime;
				ServerManagerQuest.execute(DbAction.UPDT, pQuest, 1);
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Get progress pourcentage of a construction timeDesc
	 * @param	pTimeDesc
	 * @return
	 */
	public static function getPourcentage(pTileDesc:TileDescription):Float {
		var timeCreation:Float = pTileDesc.timeDesc.end - Date.fromString(GameConfig.getBuildingByName(pTileDesc.buildingName, pTileDesc.level).constructionTime).getTime();
		var total:Float = pTileDesc.timeDesc.end - timeCreation;
		return (pTileDesc.timeDesc.progress - timeCreation) / total;
	}
	
	/**
	 * Get the progress's percent of anything
	 * @param	pTimeProgress
	 * @param	pTimeTotal
	 * @return the percent
	 */
	public static function getTimePourcentage(pTimeProgress:Float, pTimeTotal:Float):Float{
		return pTimeProgress / pTimeTotal;
	}
	
	public static function destroyTimeQuest(pId:Int):Void {
		var lLengthQuest:Int = listQuest.length;
		
		for (i in 0...lLengthQuest) {
			if (pId == listQuest[i].refIntern){
				var endQuest:TimeQuestDescription = listQuest.splice(i, 1)[0];
				ServerManagerQuest.execute(DbAction.REM, endQuest);
				break;
			}
		}
	}
	
	public static function destroyTimeElement (pId:Int):Void {
		var lLength:Int = listResource.length;
		var lLengthConstruction:Int = listConstruction.length;
		
		
		for (i in 0...lLength) {
			if (pId == listResource[i].desc.refTile){
				listResource.splice(i, 1);
				break;
			}
		}
		
		for (i in 0...lLengthConstruction) {
			if (pId == listConstruction[i].refTile) {
				listConstruction.splice(i, 1);
				break;
			}
		}
		
		SaveManager.save();
	}
	
	
	// destroy TimeElement : à réfléchir. Que sur commande de Vtile ?

	public function new() {
		
	}
	
}