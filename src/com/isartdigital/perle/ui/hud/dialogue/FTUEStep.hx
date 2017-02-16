package com.isartdigital.perle.ui.hud.dialogue;

import pixi.core.display.DisplayObject;

/**
 * @author Alexis
 */
typedef FTUEStep = {
	//Container
	@optional var ftueContainer:Bool;
	@optional var actionContainer:Bool;
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
	@optional var openShopIntern:Bool;
	@optional var buyIntern:Bool;
	@optional var openIntern:Bool;
	@optional var sendIntern:Bool;
	@optional var resolveIntern:Bool;
	@optional var makeChoice:Bool;
	@optional var haveToMakeAllChoice:Bool;
	@optional var closeGatcha:Bool;
	@optional var passFreeConstruct:Bool;
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
	//starts
	@optional var startOfSpecial:Bool;
	@optional var startOfCollectors:Bool;
	@optional var startOfFactory:Bool;
	@optional var startOfAltar:Bool;
	@optional var startOfMarketing:Bool;
	//In plus, out of the JSON
	@optional var item:DisplayObject;
	//To prevoid bugs
	@optional var ifPlayerCanWait:Bool;
	@optional var boostBuilding:Bool;
	@optional var ifAlreadylevel2:Bool;
	@optional var shouldBlockHud:Bool;
	
	//Juicy
	@optional var putCenterRegionHeaven:Bool;
	@optional var lightOn:Bool;
	@optional var stress:Bool;
	@optional var efficiency:Bool;
	@optional var speed:Bool;
}