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
	//dialogue
	@optional var dialogueNumber:Int;
	@optional var npcWhoTalk:String;
	//checkpoint
	var checkpoint:Bool;
	@optional var item:DisplayObject;
}