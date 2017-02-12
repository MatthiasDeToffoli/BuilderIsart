package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.GameConfig.TableConfig;
import com.isartdigital.perle.game.GameConfig.TableInterns;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.perle.ui.popin.choice.Choice.ChoiceType;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import haxe.Json;

/**
 * Class of the interns
 * @author victor grenu && Emeline Berenguier
 */
class Intern
{
	private var desc:InternDescription;
	public static var internsListArray:Array<InternDescription>;
	public static var internsListAlignment:Map<Alignment, Array<InternDescription>>;
	public static var internsMap:Map<Alignment, Array<InternDescription>>;

	// UI text
	public static inline var TXT_STRESS:String = "Stress";
	public static inline var TXT_SPEED:String = "Speed";
	public static inline var TXT_EFFICIENCY:String = "Efficiency";
	
	public static inline var STATE_RESTING:String = "resting";
	public static inline var STATE_WAITING:String = "waiting";
	public static inline var STATE_MAX_STRESS:String = "stressing";
	public static inline var ALIGN = "hell";
	public static inline var MAX_STRESS:Int = 100;
	
	public static var numberInternHouses:Map<Alignment, Int>;
	
	public static function getIntern(pId:Int):InternDescription{
		var lIntern:InternDescription = null;
		
		for (i in 0...Intern.internsListArray.length){
			if (pId == internsListArray[i].id){
				lIntern = internsListArray[i];
			}
		}
		return lIntern;
	}
	
	public static function init(){
		internsListArray = new Array<InternDescription>();
		internsListAlignment = new Map<Alignment, Array<InternDescription>>();
		internsListAlignment[Alignment.hell] = new Array<InternDescription>();
		internsListAlignment[Alignment.heaven] = new Array<InternDescription>();

		numberInternHouses = new Map < Alignment, Int>();
		
		internsMap = new Map<Alignment, Array<InternDescription>>();
		internsMap.set(Alignment.hell, new Array<InternDescription>()); 
		internsMap.set(Alignment.heaven, new Array<InternDescription>());
		
		getJson();
	}
	
	public static function isMaxStress(pId:Int):Bool{
		if (getIntern(pId).stress < MAX_STRESS) return false;
		else return true;
	}
	
	public static function canBuy(pAlignment:Alignment, pIntern:InternDescription):Bool{
		
		if (numberInternHouses[pAlignment] > internsListAlignment[pAlignment].length){
			if (ResourcesManager.getTotalForType(GeneratorType.soft) >= pIntern.price) return true;	
			else return false;
		}
		else return false;
	}
	
	public static function buy(pIntern:InternDescription):Void{
		var pAlignment:Alignment = null;
		
		if (!DialogueManager.ftueStepBuyIntern)	
			ResourcesManager.spendTotal(GeneratorType.soft, pIntern.price);
		internsListArray.push(pIntern);
		pIntern.aligment == "heaven" ? internsListAlignment[Alignment.heaven].push(pIntern) : internsListAlignment[Alignment.hell].push(pIntern);
		ServerManager.InternAction(DbAction.ADD, pIntern.id);
	}
	
	public static function numberInternsInQuest():Int{
		var lNumber:Int = 0;
		
		for (i in 0...Intern.internsListArray.length){
			if (internsListArray[i].quest != null){
				lNumber++;
			}
		}
		
		return lNumber;
	}
	
	/**
	 * get all the interns in Interns table
	 */
	public static function getJson():Void {		
		var tmpInterns:Array<TableInterns> = GameConfig.getInterns();
		var lLength:Int = tmpInterns.length;
		
		for (i in 0...lLength) {
			var align:Alignment = (tmpInterns[i].alignment == ALIGN) ? Alignment.hell : Alignment.heaven;
			
			var newIntern:InternDescription = {
				id : tmpInterns[i].iD,
				name : tmpInterns[i].name,
				aligment :  tmpInterns[i].alignment,
				status: STATE_RESTING,
				quest : null,
				price : tmpInterns[i].price,
				stress: tmpInterns[i].stress,
				speed: tmpInterns[i].speed,
				efficiency: tmpInterns[i].efficiency,
				unlockLevel: tmpInterns[i].unlockLevel,
				idEvent: 0
			};
			
			if (align == Alignment.heaven) internsMap[Alignment.heaven].push(newIntern);
			else internsMap[Alignment.hell].push(newIntern);
		}
		
		ServerManager.InternAction(DbAction.GET_SPE_JSON);
	}
	
	/**
	 * get Interns the player own
	 * @param	object
	 */
	public static function getPlayerInterns(object:Dynamic):Void {
		if (object == null) return;
		var data:Dynamic = Json.parse(object);	
		if (data == null) return;
		var lLength:Int = Std.int(data.length);
		
		for (i in 0...lLength) {
			var newIntern:InternDescription = {
				id : Std.int(data[i].ID),
				name : data[i].Name,
				aligment :  data[i].Alignment,
				status: (Std.int(data[i].Stress) >= MAX_STRESS) ? STATE_MAX_STRESS : STATE_WAITING,
				quest : QuestsManager.getQuest(data[i].ID),
				price : Std.int(data[i].Price),
				stress: Std.int(data[i].Stress),
				speed: Std.int(data[i].Speed),
				efficiency: Std.int(data[i].Efficiency),
				unlockLevel: Std.int(data[i].UnlockLevel),
				idEvent: Std.int(data[i].IdEvent)
			};
			
			if (newIntern.quest != null && ChoiceManager.isInQuest(newIntern.idEvent)) {
				var tmpProgress:Float = Date.now().getTime();
				if (tmpProgress >= newIntern.quest.steps[0] && newIntern.quest.stepIndex == 0) tmpProgress = newIntern.quest.steps[0];
				else if (tmpProgress>= newIntern.quest.steps[1] && newIntern.quest.stepIndex == 1) tmpProgress = newIntern.quest.steps[1];
				else if (tmpProgress >= newIntern.quest.steps[2] && newIntern.quest.stepIndex == 2) tmpProgress = newIntern.quest.steps[2];
				else newIntern.quest.progress = tmpProgress;
			}
			
			internsListArray.push(newIntern);
		}
	}
	
	public static function isIntravel(pIntern:InternDescription):Bool {
		var lTimeDesc:TimeQuestDescription = pIntern.quest;
		switch (lTimeDesc.stepIndex) {
			case 0: if (lTimeDesc.progress < lTimeDesc.steps[lTimeDesc.stepIndex]) return true; 
			case 1: if (lTimeDesc.progress < lTimeDesc.steps[lTimeDesc.stepIndex]) return true; 
			case 2: if (lTimeDesc.progress < lTimeDesc.steps[lTimeDesc.stepIndex]) return true;
			default: return false;
		}
		return false;
	}
	
	public static function willBeStress(pIntern:InternDescription, pChoiceType:ChoiceType, pChoice:ChoiceDescription):Bool {
		var lQuest:TimeQuestDescription = pIntern.quest;
		switch (pChoiceType) {
			case ChoiceType.HEAVEN: 
				if (pIntern.aligment == "heaven") {
					if (pIntern.stress + pChoice.heavenStress < MAX_STRESS) return false;
					else return true;
				}
				else {
					if (pIntern.stress + pChoice.hellStress < MAX_STRESS) return false;
					else return true;
				}
				
			case ChoiceType.HELL:
				if (pIntern.aligment == "hell") {
					if (pIntern.stress + pChoice.hellStress < MAX_STRESS) return false;
					else return true;
				}
				else {
					if (pIntern.stress + pChoice.heavenStress < MAX_STRESS) return false;
					else return true;
				}
				
			default: return false;
		}
		return false;
	}
	
	public static function dbMajInternEvent(pInter:InternDescription):Void {
		ServerManager.InternAction(DbAction.UPDT_EVENT, pInter.id);
	}
	
	/**
	 * Incremente the number of intern houses avalaibles
	 * @param	pAlignment
	 */
	public static function incrementeInternHouses(pAlignment:Alignment):Void{
		numberInternHouses[pAlignment] += 1;
	}
	
	/**
	 * Decremente the number of intern houses avalaibles 
	 * @param	pAlignment
	 */
	public static function decrementeInternHouses(pAlignment:Alignment):Void{
		numberInternHouses[pAlignment] -= 1;
	}
	
	public static function countInternInQuest():Int {
		var nb:Int = internsListArray.length - 1;
		for (i in 0...nb) {
			trace(internsListArray[i]);
		}
		
		return 0;
	}
	
	public static function destroyIntern(pId:Int):Void{	
		for (i in 0...internsListArray.length){
			if (pId == internsListArray[i].id){
				internsListArray.splice(internsListArray.indexOf(internsListArray[i]), 1);
				ServerManager.InternAction(DbAction.REM, pId);
				break;
			}
		}
	}
	
}