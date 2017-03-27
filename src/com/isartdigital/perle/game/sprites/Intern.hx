package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.GameConfig.TableInterns;
import com.isartdigital.perle.game.managers.ChoiceManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManagerInterns;
import com.isartdigital.perle.game.managers.server.ServerManagerSpecial;
import com.isartdigital.perle.ui.popin.choice.Choice.ChoiceType;
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
	public static var internsToUnlockHeaven:Map<Int, Array<InternDescription>>;
	public static var internsToUnlockHell:Map<Int, Array<InternDescription>>;

	// UI text
	public static inline var TXT_STRESS:String = "Stress";
	public static inline var TXT_SPEED:String = "Speed";
	public static inline var TXT_EFFICIENCY:String = "Efficiency";
	
	public static inline var STATE_RESTING:String = "resting";
	public static inline var STATE_WAITING:String = "waiting";
	public static inline var STATE_MAX_STRESS:String = "stressing";
	public static inline var ALIGN = "hell";
	public static inline var MAX_STRESS:Int = 100;
	
	public static var numberInternHouses:Map<Alignment, Int> = new Map < Alignment, Int>();
	
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
		
		internsMap = new Map<Alignment, Array<InternDescription>>();
		internsMap.set(Alignment.hell, new Array<InternDescription>()); 
		internsMap.set(Alignment.heaven, new Array<InternDescription>());
		
		internsToUnlockHeaven = new Map<Int, Array<InternDescription>>();
		internsToUnlockHell = new Map<Int, Array<InternDescription>>();
		
		getJson();
		
	}
	
	/**
	 * Check if the intern can continue to work
	 * @param	pId
	 * @return
	 */
	public static function isMaxStress(pId:Int):Bool{
		if (getIntern(pId).stress < MAX_STRESS) return false;
		else return true;
	}
	
	/**
	 * Check if you have all the conditions to recruit an intern
	 * @param	pAlignment Alignment of the intern
	 * @param	pIntern Intern wanted to buy
	 * @return
	 */
	public static function canBuy(pAlignment:Alignment, pIntern:InternDescription):Bool {
		if (numberInternHouses[pAlignment] > internsListAlignment[pAlignment].length){
			return true;
		}
		else return false;
	}
	
	/**
	 * Buy an intern
	 * @param	pIntern
	 */
	public static function buy(pIntern:InternDescription):Void{
		var pAlignment:Alignment = null;
		
		if (!DialogueManager.ftueStepBuyIntern)
			if (ResourcesManager.getTotalForType(GeneratorType.soft) >= pIntern.price) ResourcesManager.spendTotal(GeneratorType.soft, pIntern.price);
			
		internsListArray.push(pIntern);
		pIntern.aligment == "heaven" ? internsListAlignment[Alignment.heaven].push(pIntern) : internsListAlignment[Alignment.hell].push(pIntern);
		ServerManagerInterns.execute(DbAction.ADD, pIntern.id);
	}
	
	/**
	 * Get the number of interns in quest
	 * @return
	 */
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
				stress: 0,
				speed: tmpInterns[i].speed,
				efficiency: tmpInterns[i].efficiency,
				unlockLevel: tmpInterns[i].unlockLevel,
				idEvent: 0,
				portrait: tmpInterns[i].portrait
			};
			if (align == Alignment.heaven){
				internsMap[Alignment.heaven].push(newIntern);
				setInternsArrayUnlockHeaven(newIntern);
			}
			else {
				internsMap[Alignment.hell].push(newIntern);
				setInternsArrayUnlockHell(newIntern);
			}
		}
		
		ServerManagerInterns.execute(DbAction.GET_SPE_JSON);
	}
	
	private static function setInternsArrayUnlockHeaven(pIntern:InternDescription):Void{
		if (internsToUnlockHeaven[pIntern.unlockLevel] == null) internsToUnlockHeaven[pIntern.unlockLevel] = new Array<InternDescription>();
		internsToUnlockHeaven[pIntern.unlockLevel].push(pIntern);
	}
	
	private static function setInternsArrayUnlockHell(pIntern:InternDescription):Void{
		if (internsToUnlockHell[pIntern.unlockLevel] == null) internsToUnlockHell[pIntern.unlockLevel] = new Array<InternDescription>();
		internsToUnlockHell[pIntern.unlockLevel].push(pIntern);
	}
	
	/**
	 * get Interns the player own
	 * @param	object
	 */
	public static function getPlayerInterns(object:Dynamic):Void {
		if (object == null) return;
		var data:Dynamic = Json.parse(object);	
		if (data == null) {
			ServerManagerSpecial.finishLoading();
			return;
		}
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
				idEvent: Std.int(data[i].IdEvent),
				portrait: Std.string(data[i].Portrait)
			};
			
			internsListArray.push(newIntern);
			(newIntern.aligment == "hell") ? internsListAlignment[Alignment.hell].push(newIntern) : internsListAlignment[Alignment.heaven].push(newIntern);
		}
		
		ServerManagerSpecial.finishLoading();
	}
	
	public static function isIntravel(pIntern:InternDescription):Bool {
		if (pIntern != null){
			var lTimeDesc:TimeQuestDescription = pIntern.quest;
			if (lTimeDesc != null){
				switch (lTimeDesc.stepIndex) {
					case 0: if (lTimeDesc.progress < lTimeDesc.steps[lTimeDesc.stepIndex] + lTimeDesc.startTime) return true; 
					case 1: if (lTimeDesc.progress < lTimeDesc.steps[lTimeDesc.stepIndex] + lTimeDesc.startTime) return true; 
					case 2: if (lTimeDesc.progress < lTimeDesc.steps[lTimeDesc.stepIndex] + lTimeDesc.startTime) return true;
					default: return false;
				}
			}

		}
		return false;
	}
	
	public static function willBeStress(pIntern:InternDescription, pChoiceType:ChoiceType, pChoice:ChoiceDescription):Bool {
		var lQuest:TimeQuestDescription = pIntern.quest;
		switch (pChoiceType) {
			case ChoiceType.HEAVEN: 
				if (pIntern.aligment == "heaven") {
					if (pIntern.stress + pChoice.unaturalStress < MAX_STRESS) return false;
					else return true;
				}
				else {
					if (pIntern.stress + pChoice.naturalStress < MAX_STRESS) return false;
					else return true;
				}
				
			case ChoiceType.HELL:
				if (pIntern.aligment == "hell") {
					if (pIntern.stress + pChoice.naturalStress < MAX_STRESS) return false;
					else return true;
				}
				else {
					if (pIntern.stress + pChoice.unaturalStress < MAX_STRESS) return false;
					else return true;
				}
				
			default: return false;
		}
		return false;
	}
	
	public static function dbMajInternEvent(pInter:InternDescription):Void {
		ServerManagerInterns.execute(DbAction.UPDT_EVENT, pInter.id);
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
			//trace(internsListArray[i]);
		}
		
		return 0;
	}
	
	public static function destroyIntern(pId:Int, ?onServerToo=true):Void{	
		var lInternArrayHeaven:Array<InternDescription> = internsListAlignment[Alignment.heaven];
		var lInternArrayHell:Array<InternDescription> = internsListAlignment[Alignment.hell];
		
		for (i in 0...internsListArray.length){
			if (pId == internsListArray[i].id){
				internsListArray.splice(internsListArray.indexOf(internsListArray[i]), 1);
				break;
			}
		}
		
		for (j in 0...internsListAlignment[Alignment.heaven].length){
			if (pId == lInternArrayHeaven[j].id){
				lInternArrayHeaven.splice(lInternArrayHeaven.indexOf(lInternArrayHeaven[j]), 1);
				break;
			}
		}
		
		for (k in 0...internsListAlignment[Alignment.hell].length){
			if (pId == lInternArrayHell[k].id){
				lInternArrayHell.splice(lInternArrayHell.indexOf(lInternArrayHell[k]), 1);
				break;
			}
		}
	}
	
}