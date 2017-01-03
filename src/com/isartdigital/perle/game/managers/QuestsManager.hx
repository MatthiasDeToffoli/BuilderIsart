package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementQuest;
import com.isartdigital.perle.game.sprites.Quest;

/**
 * Manager of the quests, listen emits and links actions with others managers
 * @author Emeline Berenguier
 */
class QuestsManager
{
	public static var questsList(default, null):Array<TimeQuestDescription>;
	
	public function new() 
	{
		
	}
	
	//Todo:Not working! Don't touch
	
	public static function initWithoutSave():Void{
		questsList = new Array<TimeQuestDescription>();
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_STEP, choice);
		TimeManager.eTimeQuest.on(TimeManager.EVENT_QUEST_END, endQuest);
	}
	
	public static function initWithSave(pDatasSaved:Save):Void{
		initWithoutSave();
		var lLength:Int = pDatasSaved.timesQuest.length;
		for (i in 0...lLength){
			questsList.push(pDatasSaved.timesQuest[i]);
		}
	}
	
	/**
	 * Callback of the choice event
	 * @param	pQuest
	 */
	private static function choice(pQuest:TimeElementQuest):Void{
		//Todo: Possibilité ici de faire des interactions avec d'autres managers
		TimeManager.nextStepQuest(pQuest);
	}
	
	/**
	 * Callback of the quest's end event. Destroy the quest and its time Element
	 * @param	pQuest
	 */
	private static function endQuest(pQuest:TimeElementQuest):Void{
		trace("end");
		trace("pQuest before" + pQuest);
		TimeManager.destroyTimeElement(pQuest.desc.refIntern);
		destroyQuest(pQuest.desc.refIntern);
		trace("pQuest after" + pQuest);
	}
	
	/**
	 * Return a specific quest from an Id
	 * @param	pId Id of the required quest
	 * @return	the required quest
	 */
	//public static function getQuest(pId:Int):Quest{
		//var lQuest:Quest = null; //Todo: obligé d'instancier car sinon impossible de retourner la valeur
		//
		//for (i in 0...questsList.length){
			//if (pId == questsList[i].idTimer){
				//lQuest = questsList[i];
			//}
		//}
		//
		//return lQuest;
	//}
	
	private static function destroyQuest(pQuestId:Int):Void{
		for (i in 0...questsList.length){
			if (questsList[i].refIntern == pQuestId){
				trace("destroy done");
				questsList.splice(i, 1);
			}
		}	
	}
	
	public static function destroyAllQuests():Void{
		var lLength:Int = questsList.length;
		for (i in 0...lLength){
			questsList.splice(i, 1);
		}
	}
	
}