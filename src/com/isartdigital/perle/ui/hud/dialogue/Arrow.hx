package com.isartdigital.perle.ui.hud.dialogue;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;


/**
 * ...
 * @author Mathieu Anthoine
 */
class Arrow extends FlumpStateGraphic
{

	public function new(pAsset:String=null) 
	{
		super("FTUE_arrow");
		
	}
	
	override public function start():Void 
	{
		super.start();
		if (factory == null)
			factory = new FlumpMovieAnimFactory();
		boxType = BoxType.SELF;
		setState(DEFAULT_STATE,true);
	}
	
}