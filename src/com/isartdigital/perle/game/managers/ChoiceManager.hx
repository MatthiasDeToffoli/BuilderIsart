package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.ui.popin.choice.Choice;
import haxe.Json;

typedef ChoiceDescription = {
	var id:Int;
	var text:String;
	var hellChoice:String;
	var heavenChoice:String;
}

/**
 * ...
 * @author grenu
 */
class ChoiceManager
{	
	public static var allChoices:Array<ChoiceDescription> = new Array<ChoiceDescription>();
	private static var usedID:Array<Int> = new Array<Int>();
	
	public static var actualID:Int;
	
	public static function init():Void
	{
		ServerManager.getJsonChoices();
		actualID = 0;
		actualID = getNewChoiceID();
	}
	
	public static function getJson(object:Dynamic):Void {
		var array:Dynamic = Json.parse(object);
		var lLength:Int = cast(array.length - 1, Int);
		
		for (i in 0...array.length) {
			var nChoice:ChoiceDescription = {
				id : array[i].ID,
				text : array[i].Text,
				hellChoice : array[i].HellAnswer,
				heavenChoice : array[i].HeavenAnswer
			};
			
			allChoices.push(nChoice);
		}
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
	
	public static function nextStep():Void {
		usedID.push(actualID);
		actualID = getNewChoiceID();
	}
	
	public static function selectChoice():ChoiceDescription {	
		return allChoices[actualID];
	}
}