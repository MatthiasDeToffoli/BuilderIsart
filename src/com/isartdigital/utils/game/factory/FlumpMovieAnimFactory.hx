package com.isartdigital.utils.game.factory;

import pixi.core.display.Container;
import pixi.flump.Movie;

	
/**
 * ...
 * @author Mathieu Anthoine
 */
class FlumpMovieAnimFactory extends AnimFactory 
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
		anim = new Movie(pID);
		return anim;
	}
	
	override public function setFrame (?pAutoPlay:Bool=true, ?pStart:UInt = 0): Void {
		var lAnim:Movie = cast(anim, Movie);
		
		if (lAnim.totalFrames > 1) {
			if (pAutoPlay) lAnim.gotoAndPlay(pStart);
			else lAnim.gotoAndStop(pStart);
		}
		else if (!pAutoPlay) lAnim.stop();
	}

}