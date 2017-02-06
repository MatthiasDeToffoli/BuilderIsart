package com.isartdigital.perle.ui.hud.dialogue;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Alexis
 */
class DialogueAction extends Dialogue
{

	public function new() 
	{
		super(AssetName.FTUE_ACTION);
		name = componentName;
	}
	
	override function setWireframe():Void 
	{
		npc_speach = cast(getChildByName(AssetName.FTUE_ACTION_SPEACH), TextSprite);	
		npc_left = AssetName.FTUE_ACTION_HEAVEN;
		npc_right = AssetName.FTUE_ACTION_HELL;
		
		super.setWireframe();
	}
	
}