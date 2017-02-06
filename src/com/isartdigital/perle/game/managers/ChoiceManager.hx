package com.isartdigital.perle.game.managers;

import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.InternDescription;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.choice.Choice;
import haxe.Json;

typedef ChoiceDescription = {
	var id:Int;
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

/**
 * ...
 * @author grenu
 */
class ChoiceManager
{	
	public static var allChoices:Array<ChoiceDescription> = new Array<ChoiceDescription>();
	public static var efficiencyBalance:Array<EfficiencyStep> = new Array<EfficiencyStep>();
	private static var usedID:Array<Int> = new Array<Int>();
	
	public static var actualID:Int;
	
	public static function init():Void
	{
		getJsons();
		actualID = 0;
		actualID = getNewChoiceID();
	}
	
	public static function getJsons():Void {
		allChoices = GameConfig.getChoices();
		efficiencyBalance = GameConfig.getChoicesConfig();
	}
	
	public static function getNewChoiceID():Int {
		var lLength:Int = usedID.length;
		
		for (i in 0...lLength) {
			if (actualID == usedID[i]) {
				actualID++;
				return actualID;
			}
		}
		
		return actualID;
	}
	
	public static function applyReward(pIntern:InternDescription, pReward:EventRewardDesc, pChoiceType:ChoiceType):Void {
		var useChoice:ChoiceDescription = selectChoice();
		var baseReward:EventRewardDesc;
		
		if (pChoiceType == ChoiceType.HELL) {
			baseReward = {
				gold : useChoice.goldHell,
				karma : useChoice.karmaHell,
				wood : useChoice.woodHell,
				iron : useChoice.ironHell,
				soul : useChoice.soulHell
			};
		}
		else {
			baseReward = {
				gold : useChoice.goldHeaven,
				karma : useChoice.karmaHeaven,
				wood : useChoice.woodHeaven,
				iron : useChoice.ironHeaven,
				soul : useChoice.soulHeaven
			};
		}
		
		switch (pChoiceType) 
		{
			case ChoiceType.HEAVEN:
				ResourcesManager.gainResources(GeneratorType.soft, pReward.gold);
				ResourcesManager.gainResources(GeneratorType.buildResourceFromParadise, pReward.wood);
				ResourcesManager.gainResources(GeneratorType.goodXp, pReward.xp);
				ResourcesManager.takeXp(pReward.xp, GeneratorType.goodXp);
				(pIntern.aligment == "heaven") ? pIntern.stress += useChoice.heavenStress : pIntern.stress += useChoice.hellStress;
				
			case ChoiceType.HELL:
				ResourcesManager.gainResources(GeneratorType.soft, pReward.gold);
				ResourcesManager.gainResources(GeneratorType.buildResourceFromHell, pReward.iron);
				ResourcesManager.gainResources(GeneratorType.badXp, pReward.xp);
				ResourcesManager.takeXp(pReward.xp, GeneratorType.badXp);
				(pIntern.aligment == "hell") ? pIntern.stress += useChoice.hellStress: pIntern.stress += useChoice.heavenStress;
				
			default: return;
		}
	}
	
	public static function nextStep():Void {
		usedID.push(actualID);
		actualID = getNewChoiceID();
	}
	
	public static function selectChoice():ChoiceDescription {	
		return allChoices[actualID];
	}
}