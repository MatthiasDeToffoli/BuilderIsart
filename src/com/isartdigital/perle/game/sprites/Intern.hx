package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;

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

	public function new(pInternDatas:InternDescription) 
	{
		internsListArray.push(pInternDatas);
	}
	
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
		//internsList = new Map<Int, InternDescription>();
		
		var lId:Int = IdManager.newId();
		
		var lTestInternDatas:InternDescription = {
			id : lId,
			name : "Angel A. Merkhell",
			aligment :  "angel",
			status: "resting",
			//quest : QuestsManager.createQuest(lRandomEvent, lId),
			quest : null,
			price : 2000,
			stress: 0,
			stressLimit: 10,
			speed: 1.5,
			efficiency: 0.1
		};
		
		var lTestNewIntern:Intern = new Intern(lTestInternDatas);
		
		var lTestInternDatas2:InternDescription = {
			id : IdManager.newId(),
			name : "Archanglina Jolie",
			aligment :  "demon",
			status: "resting",
			//quest : {refIntern:5, progress:0, steps: [3, 5, 1], stepIndex: 0, end: 10},
			quest : null,
			price : 2000,
			stress: 0,
			stressLimit: 10,
			speed: 1,
			efficiency: 0.1
		};
		//
		var lTestNewIntern2:Intern = new Intern(lTestInternDatas2);
		
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