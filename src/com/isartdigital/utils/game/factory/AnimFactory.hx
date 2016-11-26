package com.isartdigital.utils.game.factory;

import pixi.core.display.Container;

/**
 * ...
 * @author Mathieu Anthoine
 */
class AnimFactory
{

	private var anim:Container;
	
	private function new() 
	{
		
	}
	
	public function getAnim ():Container {
		return anim;
	}
	
	public function create (pID:String):Container {
		return null;
	}
	
	public function update (pId:String):Void {
		
	}
	
	public function setFrame (?pAutoPlay:Bool=true, ?pStart:UInt = 0): Void {

	}
	
}