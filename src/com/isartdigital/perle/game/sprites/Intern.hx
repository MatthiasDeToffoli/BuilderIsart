package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.QuestsManager;
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

	public static inline var STATE_RESTING:String = "resting";
	public static inline var STATE_WAITING:String = "waiting";
	public static inline var STATE_MAX_STRESS:String = "stressing";
	public static inline var MAX_STRESS:Int = 10;
	
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
		ServerManager.getJsonInterns();		
	}
	
	public static function getJson(object:Dynamic):Void {
		var array:Dynamic = Json.parse(object);
		var lLength:Int = cast(array.length - 1, Int);
		
		for (i in 0...array.length) {
			var newIntern:InternDescription = {
				id : array[i].ID,
				name : array[i].Name,
				aligment :  array[i].Alignment,
				status: STATE_RESTING,
				quest : null,
				price : Std.int(array[i].PricePerLvl),
				stress: Std.int(array[i].Stress),
				speed: Std.int(array[i].Speed),
				efficiency: Std.int(array[i].Efficiency)
			};
			
			internsListArray.push(newIntern);
		}
	}
	
	public static function destroyIntern(pId:Int):Void{	
		trace("length" + internsListArray.length);
		for (i in 0...internsListArray.length){
			if (pId == internsListArray[i].id){
				trace("intern" + internsListArray[i]);
				internsListArray.splice(internsListArray.indexOf(internsListArray[i]), 1);
				break;
			}
		}
	}
	
}