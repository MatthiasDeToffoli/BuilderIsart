package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.GameConfig.TableConfig;
import com.isartdigital.perle.game.GameConfig.TableInterns;
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
	public static inline var MAX_STRESS:Int = 100;
	
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
		ServerManager.InternAction(DbAction.GET_SPE_JSON);
	}
	
	public static function getJson(object:Dynamic):Void {
		var data:Dynamic = Json.parse(object);
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
				unlockLevel: Std.int(data[i].UnlockLevel)
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