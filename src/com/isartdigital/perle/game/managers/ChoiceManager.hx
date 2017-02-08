package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.ServerManager.DbAction;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import haxe.Json;

typedef ChoiceDescription = {
	var iD:Int;
	var text:String;
	var hellAnswer:String;
	var heavenAnswer:String;
	var hellStress:Int;
	var heavenStress:Int;	
	var goldIndicatorHeaven:Int;
	var goldHeaven:Int;
	var karmaIndicatorHeaven:Int;
	var karmaHeaven:Int;
	var woodIndicatorHeaven:Int;
	var woodHeaven:Int;
	var ironIndicatorHeaven:Int;
	var ironHeaven:Int;
	var soulIndicatorHeaven:Int;
	var soulHeaven:Int;	
	var goldIndicatorHell:Int;
	var goldHell:Int;
	var karmaIndicatorHell:Int;
	var karmaHell:Int;
	var woodIndicatorHell:Int;
	var woodHell:Int;
	var ironIndicatorHell:Int;
	var ironHell:Int;
	var soulIndicatorHell:Int;
	var soulHell:Int;
}

typedef EfficiencyStep = {
	var level:Int;
	var gold:Int;
	var karma:Int;
	var wood:Int;
	var iron:Int;
	var soul:Int;
	var xP:Int;
}

typedef EventRewardDesc = {
	var gold:Int;
	var karma:Int;
	var wood:Int;
	var iron:Int;
	var soul:Int;
	@:optional var xp:Int;
}

typedef TypeUseChoice = {
	var idChoice:Int;
	var closed:Int;
}

/**
 * ...
 * @author grenu
 */
class ChoiceManager
{		
	public static var allChoices:Array<ChoiceDescription> = new Array<ChoiceDescription>();
	public static var efficiencyBalance:Array<EfficiencyStep> = new Array<EfficiencyStep>();
	private static var usedID:Array<TypeUseChoice> = new Array<TypeUseChoice>();
	
	public static var actualID:Int;
	
	public static function init():Void
	{
		actualID = 1;
		askForJson();
	}
	
	public static function askForJson():Void {
		allChoices = GameConfig.getChoices();
		ServerManager.EventAction(DbAction.USED_ID);
		efficiencyBalance = GameConfig.getChoicesConfig();
	}
	
	public static function getUsedIdJson(object:Dynamic):Void {
		usedID = cast(Json.parse(object));
		getNewChoiceID();
	}
	
	public static function newChoice(pId:Int, ?isGatcha:Bool = false):Void {
		var memId:Int = actualID;
		ChoiceManager.getNewChoiceID();
		if (!isGatcha) ChoiceManager.newUsedChoice();
		Intern.getIntern(pId).idEvent = actualID;
		var intern:InternDescription = Intern.getIntern(pId);
		if (!isGatcha) ServerManager.InternAction(DbAction.UPDT_EVENT, intern.id, intern.idEvent);
		else {
			Intern.getIntern(pId).quest = null; 
			ServerManager.TimeQuestAction(DbAction.REM, QuestsManager.getQuest(intern.id));
			ServerManager.EventAction(DbAction.CLOSE_QUEST, memId);
		}
	}
	
	public static function getNewChoiceID():Void {
		if (choiceAlreadyUsed(actualID)) {
			actualID++;
			getNewChoiceID();
		}
		else return;
	}
	
	public static function applyReward(pIntern:InternDescription, pReward:EventRewardDesc, pChoiceType:ChoiceType):Void {
		var useChoice:ChoiceDescription = selectChoice(actualID);
		var baseReward:EventRewardDesc;
		
		if (pIntern.quest.stepIndex != 2) ChoiceManager.newChoice(pIntern.id);
		else ChoiceManager.newChoice(pIntern.id, true);
		
		if (pChoiceType == ChoiceType.HELL) {
			baseReward = {
				gold : useChoice.goldHell + pReward.gold,
				karma : useChoice.karmaHell + pReward.karma,
				wood : useChoice.woodHell + pReward.wood,
				iron : useChoice.ironHell + pReward.iron,
				soul : useChoice.soulHell + pReward.soul
			};
		}
		else {
			baseReward = {
				gold : useChoice.goldHeaven + pReward.gold,
				karma : useChoice.karmaHeaven + pReward.karma,
				wood : useChoice.woodHeaven + pReward.wood,
				iron : useChoice.ironHeaven + pReward.iron,
				soul : useChoice.soulHeaven + pReward.soul
			};
		}
		
		switch (pChoiceType) 
		{
			case ChoiceType.HEAVEN:
				ResourcesManager.gainResources(GeneratorType.soft, baseReward.gold);
				ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, baseReward.wood);
				ResourcesManager.gainResources(GeneratorType.goodXp, baseReward.xp);
				ResourcesManager.gainResources(GeneratorType.hard, baseReward.karma);
				ResourcesManager.takeXp(baseReward.xp, GeneratorType.goodXp);
				(pIntern.aligment == "heaven") ? pIntern.stress += useChoice.heavenStress : pIntern.stress += useChoice.hellStress;
				
			case ChoiceType.HELL:
				ResourcesManager.gainResources(GeneratorType.soft, baseReward.gold);
				ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, baseReward.iron);
				ResourcesManager.gainResources(GeneratorType.badXp, baseReward.xp);
				ResourcesManager.gainResources(GeneratorType.hard, baseReward.karma);
				ResourcesManager.takeXp(baseReward.xp, GeneratorType.badXp);
				(pIntern.aligment == "hell") ? pIntern.stress += useChoice.hellStress: pIntern.stress += useChoice.heavenStress;
				
			default: return;
		}
		
		ServerManager.EventAction(DbAction.CLOSE_QUEST, useChoice.iD);
	}
	
	public static function nextStep():Void {
		getNewChoiceID();
	}
	
	public static function selectChoice(pId:Int):ChoiceDescription {
		return allChoices[pId - 1];
	}
	
	public static function newUsedChoice():Void {
		usedID.push( { idChoice: actualID, closed: 0 } );
		ServerManager.EventAction(DbAction.ADD, allChoices[actualID - 1].iD);
	}
	
	public static function choiceAlreadyUsed(pId:Int):Bool {
		var lLength:Int = usedID.length;
		for (i in 0...lLength) {
			if (pId == usedID[i].idChoice) {
				return true;
			}
		}
		
		return false;
	}
	
	public static function refreshChoices():Void {
		if (usedID.length == allChoices.length) {
			actualID = 1;
			usedID = new Array<TypeUseChoice>();
			ServerManager.EventAction(DbAction.REFRESH);
			
		}
	}
}