package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.GameConfig.TableConfig;
import com.isartdigital.perle.game.GameConfig.TableInterns;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import haxe.Json;

/**
 * Class of the interns
 * @author Emeline Berenguier
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
	
	public static function canBuy(pAlignment:Alignment, pIntern:InternDescription):Bool{
		
		if (numberInternHouses[pAlignment] > internsListAlignment[pAlignment].length) return true;	
		else return false;
	}
	
	public static function buy(pIntern:InternDescription):Void{
		var pAlignment:Alignment = null;
		internsListArray.push(pIntern);
		pIntern.aligment == "heaven" ? internsListAlignment[Alignment.heaven].push(pIntern) : internsListAlignment[Alignment.hell].push(pIntern);
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
				unlockLevel: tmpInterns[i].unlockLevel
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
		var data:Dynamic = Json.parse(object);
		
		if (data == null) return;
		var lLength:Int = Std.int(data.length);
		
		for (i in 0...lLength) {
			var newIntern:InternDescription = {
				id : Std.int(data[i].ID),
				name : data[i].Name,
				aligment :  data[i].Alignment,
				status: STATE_RESTING,
				quest : null,
				price : Std.int(data[i].Price),
				stress: Std.int(data[i].Stress),
				speed: Std.int(data[i].Speed),
				efficiency: Std.int(data[i].Efficiency),
				unlockLevel: Std.int(data[i].UnlockLevel),
				idEvent: Std.int(data[i].idEvent)
			};
			
			internsListArray.push(newIntern);
		}
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
				trace("intern" + internsListArray[i]);
				internsListArray.splice(internsListArray.indexOf(internsListArray[i]), 1);
				break;
			}
		}
	}
	
}