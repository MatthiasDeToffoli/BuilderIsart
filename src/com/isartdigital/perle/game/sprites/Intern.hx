package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;

/**
 * Class of the interns
 * @author Emeline Berenguier
 */
class Intern
{
	private var desc:InternDescription;
	public static var internsList:Array<InternDescription>;

	public function new(pInternDatas:InternDescription) 
	{
		trace(pInternDatas.gender);
		internsList.push(pInternDatas);
	}
	
	public static function init(){
		internsList = new Array<InternDescription>();
		var lTestInternDatas:InternDescription = {
			id : IdManager.newId(),
			name : "Angel A. Merkhell",
			isInQuest: false,
			gender :  "angel",
			aligment : 1,
			quest : {refIntern:5, progress:0, steps: [3, 5, 1], stepIndex: 0, end: 10},
			price : 2000,
			stress: 0,
			stressLimit: 10,
			speed: 5,
			efficiency: 0.1
		};
		
		var lTestNewIntern:Intern = new Intern(lTestInternDatas);
		
		var lTestInternDatas2:InternDescription = {
			id : IdManager.newId(),
			name : "Archanglina Jolie",
			isInQuest: false,
			gender :  "demon",
			aligment : 1,
			quest : {refIntern:5, progress:0, steps: [3, 5, 1], stepIndex: 0, end: 10},
			price : 2000,
			stress: 0,
			stressLimit: 10,
			speed: 5,
			efficiency: 0.1
		};
		
		var lTestNewIntern:Intern = new Intern(lTestInternDatas2);
		
	}
	
}