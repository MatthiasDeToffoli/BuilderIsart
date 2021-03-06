package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.server.DeltaDNAManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManagerChoice;
import com.isartdigital.perle.game.managers.server.ServerManagerInterns;
import com.isartdigital.perle.game.managers.server.ServerManagerQuest;
import com.isartdigital.perle.game.managers.server.ServerManagerSpecial;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.utils.sounds.SoundManager;

import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.perle.ui.popin.listIntern.MaxStressPopin;
import haxe.Json;

typedef ChoiceDescription = {
	var iD:Int;
	var text:String;
	var hellAnswer:String;
	var heavenAnswer:String;
	var naturalStress:Int;
	var unaturalStress:Int;	
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
	var card:String;
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
 * @author victor grenu
 */
class ChoiceManager
{		
	public static var allChoices:Array<ChoiceDescription> = new Array<ChoiceDescription>();
	public static var efficiencyBalance:Array<EfficiencyStep> = new Array<EfficiencyStep>();
	public static var usedID:Array<TypeUseChoice> = new Array<TypeUseChoice>();
	
	public static var actualID:Int;
	
	public static function init():Void
	{
		actualID = 1;
		askForJson();
	}
	
	public static function askForJson():Void {
		allChoices = GameConfig.getChoices();
		efficiencyBalance = GameConfig.getChoicesConfig();
	}
	
	public static function getUsedIdJson(data:Dynamic):Void {
		if (data == null) return;
		var data:Dynamic = Json.parse(data);	
		var lLength:Int = Std.int(data.length);
			
		for (i in 0...lLength) {
			var newChoiceUsed:TypeUseChoice = {
				idChoice: Std.int(data[i].IDChoice),
				closed: Std.int(data[i].Closed)
			};
			
			usedID.push(newChoiceUsed);
		}
		
		getNewChoiceID();
		ServerManagerSpecial.loadQuests();
	}
	
	public static function newChoice(pId:Int, ?isGatcha:Bool = false):Void {
		var memId:Int = Intern.getIntern(pId).idEvent;
		ChoiceManager.getNewChoiceID();
		if (!isGatcha) ChoiceManager.newUsedChoice(memId);
		Intern.getIntern(pId).idEvent = actualID;
		var intern:InternDescription = Intern.getIntern(pId);
		if (!isGatcha) ServerManagerInterns.execute(DbAction.UPDT_EVENT, intern.id, intern.idEvent);
		else ServerManagerQuest.execute(DbAction.REM, QuestsManager.getQuest(intern.id));
	}
	
	public static function getNewChoiceID():Void {
		if (choiceAlreadyUsed(actualID)) {
			actualID++;
			getNewChoiceID();
		}
		else return;
	}
	
	public static function applyReward(pIntern:InternDescription, pReward:EventRewardDesc, pChoiceType:ChoiceType, useChoice:ChoiceDescription):Void {
		var baseReward:EventRewardDesc;
		AdsManager.playAdPictureWithCounter();
		if (pChoiceType == ChoiceType.HELL) {
			baseReward = {
				gold : (useChoice.goldHell != 0) ? useChoice.goldHell + pReward.gold : 0,
				karma : (useChoice.karmaHell != 0) ? useChoice.karmaHell + pReward.karma : 0,
				wood : (useChoice.woodHell != 0) ? useChoice.woodHell + pReward.wood : 0,
				iron : (useChoice.ironHell != 0) ? useChoice.ironHell + pReward.iron : 0,
				soul : (useChoice.soulHell != 0) ? useChoice.soulHell + pReward.soul : 0
			};
			
			SoundManager.getSound("SOUND_CHOICE_HELL").play();
		}
		else {
			baseReward = {
				gold : (useChoice.goldHeaven != 0) ? useChoice.goldHeaven + pReward.gold : 0,
				karma : (useChoice.karmaHeaven != 0) ? useChoice.karmaHeaven + pReward.karma : 0,
				wood : (useChoice.woodHeaven!= 0) ? useChoice.woodHeaven + pReward.wood : 0,
				iron : (useChoice.ironHeaven != 0) ? useChoice.ironHeaven + pReward.iron : 0,
				soul : (useChoice.soulHeaven != 0) ? useChoice.soulHeaven + pReward.soul : 0
			};
			
			SoundManager.getSound("SOUND_CHOICE_HEAVEN").play();
		}
		
		if (pIntern.stress < 100) {
			switch (pChoiceType) 
			{
				case ChoiceType.HEAVEN:
					(pIntern.aligment == "heaven") ? pIntern.stress += 10 : pIntern.stress += 30;
				
				case ChoiceType.HELL:
					(pIntern.aligment == "hell") ? pIntern.stress += 10: pIntern.stress += 30;
				
				default: return;
			}
			
			ResourcesManager.gainResources(GeneratorType.soft, baseReward.gold);
			ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, baseReward.wood);
			ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, baseReward.iron);
			ResourcesManager.gainResources(GeneratorType.hard, baseReward.karma);
			
			ResourcesManager.increaseResources(VTribunal.getInstance().myGenerator, baseReward.soul);
			
			ServerManagerChoice.applyReward(baseReward, pChoiceType);
			
			ServerManager.ChoicesAction(DbAction.CLOSE_QUEST, pIntern.idEvent);
			ServerManagerInterns.execute(DbAction.UPDT, pIntern.id);
			closeQuestStep(pIntern.idEvent);
			
			if (pIntern.quest.stepIndex < 2) ChoiceManager.newChoice(pIntern.id);
			else ChoiceManager.newChoice(pIntern.id, true);
			
			DeltaDNAManager.sendIntershipChoice(pIntern.id, useChoice.iD);
			QuestsManager.goToNextStep();
        }
        else {
			MaxStressPopin.quest = QuestsManager.getQuest(pIntern.idEvent);
            MaxStressPopin.intern = pIntern;
            UIManager.getInstance().closeCurrentPopin;
			UIManager.getInstance().openPopin(MaxStressPopin.getInstance());	
		}
	}
	
	public static function noMoreQuest():Bool {
		if (usedID.length == allChoices.length) return true; 
		return false;
	}
	
	public static function nextStep():Void {
		getNewChoiceID();
	}
	
	public static function selectChoice(pId:Int):ChoiceDescription {
		return allChoices[pId - 1];
	}
	
	public static function newUsedChoice(pIdEvent:Int):Void {
		usedID.push( { idChoice: actualID, closed: 0 } );
		ServerManager.ChoicesAction(DbAction.ADD, allChoices[actualID - 1].iD);
	}
	
	public static function closeQuestStep(pIdEvent:Int):Void {
		var lLength:Int = usedID.length;
		for (i in 0...lLength) {
			if (pIdEvent == usedID[i].idChoice) {
				usedID[i].closed = 1;
			} 
		}
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
	
	public static function isInQuest(pId:Int):Bool {
		var lLength:Int = usedID.length;
		for (i in 0...lLength) {
			if (pId == usedID[i].idChoice && usedID[i].closed == 0) {
				return true;
			} 
		}
		
		return false;
	}
	
	public static function internIsInGatcha(pId:Int):Bool {
		var llength:Int = usedID.length;
		for (i in 0...llength) {
			if (usedID[i].idChoice == pId && usedID[i].closed == 1) {
				return true;
			}
		}
		return false;
	}
	
	public static function refreshChoices():Void {
		if (usedID.length == allChoices.length) {
			actualID = 1;
			usedID = new Array<TypeUseChoice>();
			ServerManager.ChoicesAction(DbAction.VOID);		
		}
	}
}