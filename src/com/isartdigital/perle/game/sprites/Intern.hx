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
	public static var internsList:Map<Int,InternDescription>; //Only use when you want to get a specific intern
	//public static var numberInterns:Int;

	public function new(pInternDatas:InternDescription) 
	{
		internsList[pInternDatas.id] = pInternDatas;
		internsListArray.push(pInternDatas);
	}
	
	public static function init(){
		internsListArray = new Array<InternDescription>();
		internsList = new Map<Int, InternDescription>();
		
		var lId:Int = IdManager.newId();
		
		var lTestInternDatas:InternDescription = {
			id : lId,
			name : "Angel A. Merkhell",
			aligment :  "angel",
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
	
}