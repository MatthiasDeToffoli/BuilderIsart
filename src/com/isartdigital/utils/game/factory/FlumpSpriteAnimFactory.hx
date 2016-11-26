package com.isartdigital.utils.game.factory;

import pixi.core.display.Container;
import pixi.flump.Sprite;

	
/**
 * ...
 * @author Mathieu Anthoine
 */
class FlumpSpriteAnimFactory extends AnimFactory 
{
	

	public function new() 
	{
		super();
	}
	
	override public function getAnim ():Container {
		if (anim !=null) {
			anim.parent.removeChild(anim);
			anim.destroy();
			anim = null;
		}
		return super.getAnim();
	}
	
	override public function create (pID:String):Container {
		anim = new Sprite(pID);
		return anim;
	}
	
	override public function setFrame (?pAutoPlay:Bool=true, ?pStart:UInt = 0): Void {
	}

}