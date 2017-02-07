package com.isartdigital.perle.ui.hud.dialogue;

import pixi.core.display.DisplayObject;

/**
 * @author Alexis
 */
typedef FTUEStep = {
	//Step
	@optional var name:String; 
	@optional var parentName:String;
	@optional var arrowRotation:Float;
	@optional var moveCamera:Bool;
	@optional var haveToRecolt:Bool;
	@optional var clickOnShop:Bool;
	@optional var shopCarrousselCard:String;
	@optional var whatToShowInShop:String;
	@optional var clickOnCard:Bool;
	@optional var haveToPutBuilding:Bool;
	@optional var haveToUpgradeBuilding:Bool;
	@optional var openPurgatory:Bool;
	@optional var jugeSouls:Bool;
	@optional var closePurgatory:Bool;
	@optional var nextUnlocked:Bool;
	@optional var closeUnlocked:Bool;
	//dialogue
	@optional var dialogueNumber:Int;
	@optional var npcWhoTalk:String;
	@optional var npcWhoTalkPicture:String;
	@optional var isAction:Bool;
	@optional var expression:String;
	//checkpoint
	var checkpoint:Bool;
	//Gain du Joueur
	@optional var gold:Int;
	@optional var karma:Int;
	@optional var hellEXP:Int;
	@optional var heavenEXP:Int;
	//ends
	@optional var endOfFtue:Bool;
	@optional var endOfSpecial:Bool;
	@optional var endOfCollectors:Bool;
	@optional var endOfFactory:Bool;
	@optional var endOfAltar:Bool;
	@optional var endOfMarketing:Bool;
	//In plus, out of the JSON
	@optional var item:DisplayObject;
}